package abe.com.ponents.tools
{
    import abe.com.edia.camera.Camera;
    import abe.com.mon.colors.Color;
    import abe.com.mon.geom.Rectangle2;
    import abe.com.mon.utils.AllocatorInstance;
    import abe.com.mon.utils.arrays.lastIn;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.monitors.AbstractRuler;
    import abe.com.ponents.utils.Orientations;

    import flash.display.BlendMode;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.text.TextField;

    /**
     * @author cedric
     */
    public class CanvasRuler extends AbstractRuler
    {
        static public const ZOOM_STEPS : Array = [
        	0.1,
            0.25,
            0.5,
            1,
            2,
            5,
            10
        ];
        static public const MARKERS_RANGES : Array = [
        	[1000,500,100],
        	[500,100,50],
        	[200,100,10],
            [100,50,10],
            [50,10,5],
            [10,5,1],
            [10,5,1]
        ];

        protected var _canvas : CameraCanvas;
        protected var _rulerShape:Shape;
        protected var _mouseShape:Shape;
        protected var _textfields : Array;
        
        public function CanvasRuler ( canvas : CameraCanvas, direction : uint = 0 )
        {
            _canvas = canvas;
            _canvas.camera.cameraChanged.add( cameraChanged );
            _textfields = [];
            super ( canvas, direction );

            _canvas.mouseMoved.add(canvasMouseMoved);
            mouseMoved.add(canvasMouseMoved);
            
            _rulerShape = new Shape();
            _mouseShape = new Shape();
            _mouseShape.blendMode = BlendMode.INVERT;
            addChild(_rulerShape);
            addChild(_mouseShape);
        }

        private function canvasMouseMoved ( c : Component ) : void
        {
            var g : Graphics = _mouseShape.graphics;
            g.clear();
            
        	g.lineStyle(0,0xffffff);
            switch( _direction )
            {
                case Orientations.HORIZONTAL:
                	g.moveTo( c.mouseX, 0 );
                	g.lineTo( c.mouseX, height );
                	break;
                case Orientations.VERTICAL:
                	g.moveTo( 0, c.mouseY );
                	g.lineTo( width, c.mouseY );
                	break;
                
            }
        }

        override public function repaint () : void
        {
            super.repaint ();
            drawMarkers();
        }
        
        private function cameraChanged ( c : Camera ) : void
        {
            drawMarkers();
        }
        
        private function drawMarkers():void
        {
            var z : Number = _canvas.camera.zoom;
            var g : Graphics = _rulerShape.graphics;
            var ranges : Array = getRange();
            var step:Number = lastIn( ranges );
            var c : Color = _style.textColor;
            var min : Number;
            var max : Number;
            var size : int = 0;
            var r : Rectangle2 = _canvas.topLayer.getLocalCameraScreen(_canvas.camera);
            g.clear();
            g.lineStyle(0, c.hexa, c.alpha/255);
            var a : Array = [];
            var tCount : int = 0;
            var txt : TextField;
            switch( _direction )
            {
                case Orientations.HORIZONTAL :
                	min = r.x % step == 0 ? r.x : r.x - ( r.x % step );
                	max = r.right;
                    for( var i:int = min; i<=max; i+=step)
                    {
                        if( i % ranges[0] == 0 )
                        {
                           	if( tCount < _textfields.length )
                           		txt = _textfields[tCount];
                            else
                            {
                           		txt = AllocatorInstance.get(TextField, {
                                    'autoSize':"left",
                                    'defaultTextFormat':_style.format,
                                    'textColor':c.hexa,
                                    'selectable':false
                                });
                                addChild( txt );
                            }
                            
                            txt.text = String(i);
                            txt.x = (i - r.x )*z - txt.width/2;
                            txt.y = 0;
                            a.push( txt );
                            tCount++;
                           	size = 11; 
                        }
                        else if( i % ranges[1] == 0 )
                            size = 8; 
                        else
                        	size = 5;
                        
                        g.moveTo( ( i - r.x ) * z , height - size );
                        g.lineTo( ( i - r.x ) * z, height );
                    }
                	break; 
                    
                case Orientations.VERTICAL : 
                	min = r.y % step == 0 ? r.y : r.y - ( r.y % step );
                	max = r.bottom;
                    
                    for( i = min; i<=max; i+=step)
                    {
                        if( i % ranges[0] == 0 )
                        {
                           	if( tCount < _textfields.length )
                           		txt = _textfields[tCount];
                            else
                            {
                           		txt = AllocatorInstance.get( TextField, {
                                    'autoSize':"left",
                                    'defaultTextFormat':_style.format,
                                    'textColor':c.hexa,
                                    'selectable':false
                                });
                                addChild( txt );
                            }
                            
                            txt.text = String(i);
                            txt.x = 0;
                            txt.y = (i  - r.y )*z -1;
                            a.push( txt );
                            tCount++;
                           	size = 11; 
                        }
                        else if( i % ranges[1] == 0 )
                            size = 8; 
                        else
                            size = 5;
                        
                        g.moveTo( width-size, ( i - r.y ) * z );
                        g.lineTo( width, ( i - r.y ) * z );
                    }
                	break;
            }
           	if( tCount < _textfields.length )
            {
                for(tCount;tCount < _textfields.length;tCount++)
                {
                    txt = _textfields[tCount];
                    removeChild( txt );
                    AllocatorInstance.release(txt); 
                }
            }
            _textfields = a;
        }
        private function getRange():Array
        {
            var l : uint = ZOOM_STEPS.length;
            var z : Number = _canvas.camera.zoom;
            for(var i:uint =0;i<l;i++)
            {
                if( z < ZOOM_STEPS[i] )
                	return MARKERS_RANGES[i];
            }
            return null;
        }
        
    }
}

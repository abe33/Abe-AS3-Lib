package abe.com.ponents.tools
{
    import abe.com.mon.colors.*;
    import abe.com.mon.geom.*;
    import abe.com.mon.utils.*;
    import abe.com.ponents.core.SimpleDOContainer;
    import abe.com.ponents.layouts.display.*;

    import org.osflash.signals.Signal;

    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    [Skinable(skin="ColorWheel")]
    [Skin(define="ColorWheel",
          inherit="EmptyComponent",
          state__all__background="color(0xff666666)"
    )]
    public class ColorWheel extends SimpleDOContainer
    {
        static public var COLOR_RAMP : Gradient = new Gradient( [ Color.Red,  Color.Yellow,  Color.Green, Color.Cyan, 
                                                                  Color.Blue, Color.Fuchsia, Color.Red ],
                                                                [ 0, 1/6, 2/6, 3/6, 4/6, 5/6, 1 ] );

        protected var _color : Color;
        protected var _colorHSV : Array;
        protected var _colorCursor : Sprite;
        
        protected var _wheel : Sprite;
        protected var _wheelOuterCircle : Circle;
        protected var _wheelInnerCircle : Circle;
        protected var _triangle : Triangle;
        protected var _triangleStatic : Triangle;
        protected var _triangleBase : Sprite;
        protected var _triangleBlack : Sprite;
        protected var _triangleWhite : Sprite;
        
        protected var _draggingHue : Boolean;
        protected var _draggingSatVal : Boolean;
        
        public var dataChanged : Signal;
        
        public function ColorWheel( color : Color = null )
        {
            _childrenLayout = new DONoLayout();
            super();
            dataChanged = new Signal();
            _wheel = new Sprite();
            _colorCursor = new Sprite();
            _triangleBase = new Sprite();
            _triangleBlack = new Sprite();
            _triangleWhite = new Sprite();
            
            addComponentChild( _wheel );
            addComponentChild( _triangleBase );
            addComponentChild( _triangleWhite );
            addComponentChild( _triangleBlack );
            addComponentChild( _colorCursor );
            _colorCursor.blendMode = "invert";
            
            initGeometries();
            drawWheel();
            invalidatePreferredSizeCache();
            this.color = color ? color : Color.Black.clone();
        }
        public function get target () : Color { return _color; }
        public function set target (target : Color) : void { color = target; } 
        
        public function get color() : Color { return _color; }
        public function set color( c : Color ):void
        {
            if (!c) return;
            
            _color = c;
            _colorHSV = _color.hsv;
            
            update();
        }
        override public function invalidatePreferredSizeCache():void
        {
            _preferredSizeCache = dm(200,200);
            invalidate();
        }
        public function initGeometries():void
        {
            var x : Number = _preferredSizeCache.width / 2;
            var y : Number = _preferredSizeCache.height / 2;
            
            var s : Number = 15;
            var d : Number = 60;
            var d2 : Number = d + s;
            var a1 : Number = 0;
            var a2 : Number = a1 + Math.PI*2/3;
            var a3 : Number = a1 - Math.PI*2/3;
            
            var x1 : Number = Math.cos( a1 ) * d;
            var y1 : Number = Math.sin( a1 ) * d;
            
            var x2 : Number = Math.cos( a2 ) * d;
            var y2 : Number = Math.sin( a2 ) * d;
            
            var x3 : Number = Math.cos( a3 ) * d;
            var y3 : Number = Math.sin( a3 ) * d;
            
            _triangle = new Triangle( pt( x+x1, y+y1 ),
                                      pt( x+x2, y+y2 ),
                                      pt( x+x3, y+y3 ) );
            
            _triangleStatic = new Triangle( pt( x1, y1 ),
                                            pt( x2, y2 ),
                                            pt( x3, y3 ) );
            
            _wheelInnerCircle = new Circle( x, y, d );
            _wheelOuterCircle = new Circle( x, y,d2 );
        }
        public function update():void
        {
            updateGeometries( _colorHSV[0] );
            
            clearCursors();
            drawTriangles();        
            drawWheelCursor();
            drawTriangleCursor();
        }
        public function updateGeometries( h : Number ):void
        {
            _triangle.rotation = MathUtils.deg2rad( h );
        }
        public function getHueWithAngle( a : Number ) : Number
        {
            return ( ( a + Math.PI ) / Math.PI * 180 ) % 360;
        }
        public function hsvToPos ( h : Number, s : Number, v : Number ) : Point
        {
            var m : Matrix;
            var xmids : Number;
            var ymids : Number;
            var xdifs : Number;
            var ydifs : Number;
            
            var xmidv : Number;
            var ymidv : Number;
            var xdifv : Number;
            var ydifv : Number;
            
            var x1 : Number = _triangle.a.x;
            var y1 : Number = _triangle.a.y;
            
            var x2 : Number = _triangle.b.x;
            var y2 : Number = _triangle.b.y;
            
            var x3 : Number = _triangle.c.x;
            var y3 : Number = _triangle.c.y;
                
            xdifs = x1 - x2;
            ydifs = y1 - y2;
            var rs : Number = s/100;
            
            xmidv = x2 + xdifs * rs;
            ymidv = y2 + ydifs * rs;
            xdifv = xmidv - x3;
            ydifv = ymidv - y3;
            var rv : Number = v/100;
            
            return pt ( x3 + ( xdifv * rv ),
                        y3 + ( ydifv * rv ) );
        }
        public function clearCursors():void
        {
            _colorCursor.graphics.clear();
        }
        public function drawTriangleCursor():void
        {
            var h : Number = _colorHSV[0];       
            var s : Number = _colorHSV[1];
            var v : Number = _colorHSV[2];
            
            var p : Point = hsvToPos( h, s, v );
            
            _colorCursor.graphics.lineStyle( 0 );
            _colorCursor.graphics.drawCircle(p.x,p.y,3);
        }
        public function drawWheelCursor():void
        {        
            var h : Number = _colorHSV[0];       
            
            var a : Number = MathUtils.deg2rad( h );
            var p1 : Point = _wheelInnerCircle.getPointAtAngle( MathUtils.deg2rad( h ) )
            var x1 : Number = p1.x;
            var y1 : Number = p1.y;
            
            var p2 : Point = _wheelOuterCircle.getPointAtAngle( MathUtils.deg2rad( h ) )
            var x2 : Number = p2.x;
            var y2 : Number = p2.y;
            
            _colorCursor.graphics.lineStyle( 0 );
            _colorCursor.graphics.moveTo(x1,y1);
            _colorCursor.graphics.lineTo(x2,y2);
        }
        public function drawTriangles():void
        {
            var c : Color = new Color();
            
            c.hsv = [_colorHSV[0],100,100];
            
            _triangleBase.x = _triangleBlack.x = _triangleWhite.x = _wheelInnerCircle.x;
            _triangleBase.y = _triangleBlack.y = _triangleWhite.y = _wheelInnerCircle.y;
            
            drawTriangle( _triangleBase, c.hexa );
            drawTriangle( _triangleBlack, 0x000000 );
            drawTriangle( _triangleWhite, 0xffffff );
            
            _triangleBase.rotation = _colorHSV[0];
            _triangleBlack.rotation = _colorHSV[0]-120;
            _triangleWhite.rotation = _colorHSV[0]+120;
        }
        public function drawTriangle( triangle : Sprite, color : uint ) : void
        {  
            var xmid : Number;
            var ymid : Number;
            var xdif : Number;
            var ydif : Number;
            var m : Matrix;
            var a : Number;
            var x1 : Number = _triangleStatic.a.x;
            var y1 : Number = _triangleStatic.a.y;
            
            var x2 : Number = _triangleStatic.b.x;
            var y2 : Number = _triangleStatic.b.y;
            
            var x3 : Number = _triangleStatic.c.x;
            var y3 : Number = _triangleStatic.c.y;
            
            var xmin : Number = MathUtils.min(x1, x2, x3);
            var ymin : Number = MathUtils.min(y1, y2, y3);
            
            var l : Number = _triangleStatic.ab.length;
            
            triangle.graphics.clear();
           
            m = new Matrix(); 
            xmid = ( x2 + x3 ) / 2;
            ymid = ( y2 + y3 ) / 2;
            xdif = xmid - x1;
            ydif = ymid - y1; 
            a = Math.atan2( ydif, xdif );
            m.createGradientBox( l, 
                                 l,
                                 a,
                                 xmin,
                                 ymin
                                );       
             
            triangle.graphics.beginGradientFill( "linear", [ color, color ], [1,0],[0,255],m,"pad", "linearRGB" );
            triangle.graphics.moveTo(x1,y1);   
            triangle.graphics.lineTo(x2,y2);   
            triangle.graphics.lineTo(x3,y3); 
            triangle.graphics.endFill();    
        }
        public function drawWheel ():void
        {
            var a : int;
             _wheel.graphics.clear();
            for( a = 0; a < 360; a ++ )
            {
                drawWheelSegment( MathUtils.deg2rad( a ), 
                                  MathUtils.deg2rad( a + 1 ), 
                                  COLOR_RAMP.getColor( a / 360 ).hexa );
            }
        }
        public function drawWheelSegment( a1 : Number, a2 : Number, c : Number ) : void
        {
            
            var p1 : Point = _wheelInnerCircle.getPointAtAngle( a1 );
            var p2 : Point = _wheelOuterCircle.getPointAtAngle( a1 );
            var p3 : Point = _wheelInnerCircle.getPointAtAngle( a2 );
            var p4 : Point = _wheelOuterCircle.getPointAtAngle( a2 );
            
            var x1 : Number = p1.x;
            var y1 : Number = p1.y;
            
            var x2 : Number = p2.x;
            var y2 : Number = p2.y;
            
            var x3 : Number = p3.x;
            var y3 : Number = p3.y;
            
            var x4 : Number = p4.x;
            var y4 : Number = p4.y;

            _wheel.graphics.beginFill( c );
            _wheel.graphics.moveTo(x1,y1);
            _wheel.graphics.lineTo(x2,y2);
            _wheel.graphics.lineTo(x4,y4);
            _wheel.graphics.lineTo(x3,y3);
            _wheel.graphics.lineTo(x1,y1);
            _wheel.graphics.endFill();
        }
        
        override public function mouseDown( e : MouseEvent ) : void
        {
            stage.addEventListener( MouseEvent.MOUSE_MOVE, stageMouseMove );
            stage.addEventListener( MouseEvent.MOUSE_UP, stageMouseUp );
            
            var p : Point = pt( mouseX, mouseY );
            if( _wheelOuterCircle.containsPoint( p ) && 
               !_wheelInnerCircle.containsPoint( p ) )
            {
                _draggingHue = true;
            }
            else if( _wheelInnerCircle.containsPoint( p ) )
            {
                if( _triangle.containsPoint( p ) )
                {
                    _draggingSatVal = true;
                }
            }
        }
        public function stageMouseUp( e : MouseEvent ): void
        {
            _draggingHue = false;
            _draggingSatVal = false;
            
            stage.removeEventListener( MouseEvent.MOUSE_MOVE, stageMouseMove );
            stage.removeEventListener( MouseEvent.MOUSE_UP, stageMouseUp );
        }
        public function stageMouseMove ( e : MouseEvent) : void
        {
            var h : Number = _colorHSV[0];
            var s : Number = _colorHSV[1];
            var v : Number = _colorHSV[2];
            var p : Point = pt( mouseX, mouseY );
            var d : Point;
            if( _draggingHue )
            {
                d = _wheelInnerCircle.center.subtract( p );
                h = getHueWithAngle( Math.atan2( d.y, d.x ) );
                _color.hsv = [ h, s, v ];
                _colorHSV = [ h, s, v ];
                
                fireDataChangedSignal();
                update();
            }
            else if( _draggingSatVal && _triangle.containsPoint( p ) )
            {
                d = p.subtract( _triangle.c );
                d.normalize( 100 );
                var i : Point = GeometryUtils.perCrossing( _triangle.c, d, _triangle.a, _triangle.ab );
                var l1 : Number = Point.distance( _triangle.c, i );
                var l2 : Number = Point.distance( _triangle.b, i );
                var l3 : Number = Point.distance( _triangle.c, p );
                
                s = ( l2 / _triangle.ab.length ) * 100;
                v = ( l3 / l1 ) * 100;
                
                _color.hsv = [ h, s, v ];
                _colorHSV = [ h, s, v ];
                
                fireDataChangedSignal();
                update();
            }
        }
        public function fireDataChangedSignal () : void
        {
            dataChanged.dispatch( this, _color );
        }
    }

}

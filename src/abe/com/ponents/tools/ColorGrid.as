package abe.com.ponents.tools
{
    import abe.com.mon.colors.Color;
    import abe.com.mon.utils.MathUtils;
    import abe.com.mon.geom.*;
    import abe.com.ponents.core.*;
    import abe.com.ponents.events.*;
    import abe.com.ponents.layouts.display.*;
    import abe.com.ponents.skinning.*;

    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.*;
    import flash.geom.Matrix;
    
    import org.osflash.signals.Signal;
    
    [Skinable(skin="EmptyComponent")]
    public class ColorGrid extends SimpleDOContainer
    {
        static public const MODE_R : uint = 0;
        static public const MODE_G : uint = 1;
        static public const MODE_B : uint = 2;
        static public const MODE_H : uint = 3;
        static public const MODE_V : uint = 5;
        static public const MODE_S : uint = 4;
        
        static protected const HSV_RAMP : Array = [0xff0000,0xffff00,0x00ff00,0x00ffff,0x0000ff,0xff00ff,0xff0000];
        static protected const HSV_RAMP_RATIOS : Array = [ 0, 
                                                           1/6 * 255, 
                                                           2/6 * 255, 
                                                           3/6 * 255, 
                                                           4/6 * 255, 
                                                           5/6 * 255, 
                                                           255 ];
        

        protected var _mode : uint;
        protected var _color : Color;
        
        private var _colorBase : Shape;
        private var _colorMod1 : Shape;
        private var _colorMod2 : Shape;
        private var _colorCursor : Shape;
        private var _colorBlend : Shape;
        private var _colorBorders : Shape;
        
        public var dataChanged : Signal;
        
        public function ColorGrid ( color : Color, mode : uint = 0 )
        {
            dataChanged = new Signal();
            _childrenLayout = new DONoLayout();
            super();
            
            _mode = mode;
            _color = color; 
            _colorBase = new Shape();
            _colorMod1 = new Shape();
            _colorMod2 = new Shape();
            _colorCursor = new Shape();
            _colorBlend = new Shape();
            _colorBorders = new Shape();
            _colorCursor.blendMode = "invert";
            
            addComponentChild( _colorBase );
            addComponentChild( _colorMod1 );
            addComponentChild( _colorMod2 );
            addComponentChild( _colorBlend );
            addComponentChild( _colorCursor );
            addComponentChild( _colorBorders );
            
            invalidatePreferredSizeCache();
        }
        public function get value () : Color { return _color; }
        public function set value ( c : Color ) : void
        {
            _color = c;
            draw();
        }
        public function get mode () : uint { return _mode; }
        public function set mode ( m: uint ) : void
        {
            _mode = m;
            draw();
        }
        
        override public function repaint():void
        {
            draw();
            super.repaint();
        }
        override public function invalidatePreferredSizeCache() : void
        {
            _preferredSizeCache = dm(100,100);
            invalidate();
        }
        override public function mouseDown( e : MouseEvent ) : void
        {
            stage.addEventListener( "mouseMove", stageMouseMove );
            stage.addEventListener( "mouseUp", stageMouseUp );
        }
        public function stageMouseUp( e : MouseEvent ) : void
        {
            stage.removeEventListener( "mouseMove", stageMouseMove );
            stage.removeEventListener( "mouseUp", stageMouseUp );
        }
        public function stageMouseMove( e : MouseEvent ) : void
        {
            var bwidth : Number = 16;
            var padding : Number = 4;
            var gwidth : Number = width - padding - bwidth;
            
            var hsv : Array = _color.hsv;
            var x : Number = MathUtils.restrict(mouseX,0,gwidth+1);
            var y : Number = MathUtils.restrict(mouseY,0,height);
            var h : Number = hsv[0];
            var s : Number = hsv[1];
            var v : Number = hsv[2];
            
            var onLeft : Boolean = x <= gwidth;
            
            switch ( _mode )
            {
                case MODE_R : 
                    if( onLeft )
                    {
                        _color.green = Math.floor( ( height - y ) / height * 255 );
                        _color.blue = Math.floor( x / gwidth * 255 );
                    }
                    else
                        _color.red = Math.floor( ( height - y ) / height * 255 );
                    
                    fireDataChangedSignal();
                    break;
                 case MODE_G : 
                    if( onLeft )
                    {
                        _color.red = Math.floor( ( height - y ) / height * 255 );
                        _color.blue = Math.floor( x / gwidth * 255 );
                    }
                    else
                        _color.green = Math.floor( ( height - y ) / height * 255 );
                    
                    fireDataChangedSignal();   
                    break;
                 case MODE_B : 
                    if( onLeft )
                    {
                        _color.red = Math.floor( ( height - y ) / height * 255 );
                        _color.green = Math.floor( x / gwidth * 255 );
                    }
                    else
                        _color.blue = Math.floor( ( height - y ) / height * 255 );
                   
                    fireDataChangedSignal();     
                    break;
                 case MODE_H : 
                    if( onLeft )
                    {
                        s = Math.floor( ( height - y ) / height * 100 );
                        v = Math.floor( x / gwidth * 100 );
                    }
                    else
                        h = Math.floor( ( height - y ) / height * 360 );
                    
                    _color.hsv = [h,s,v];
                    fireDataChangedSignal();     
                    break;
                case MODE_S : 
                    if( onLeft )
                    {
                        h = Math.floor( ( height - y ) / height * 360 );
                        v = Math.floor( x / gwidth * 100 );
                    }
                    else
                        s = Math.floor( ( height - y ) / height * 100 );
                    
                    _color.hsv = [h,s,v];
                    fireDataChangedSignal();     
                    break;   
                case MODE_V : 
                    if( onLeft )
                    {
                        h = Math.floor( ( height - y ) / height * 360 );
                        s = Math.floor( x / gwidth * 100 );
                    }
                    else
                        v = Math.floor( ( height - y ) / height * 100 );
                    
                    _color.hsv = [h,s,v];
                    fireDataChangedSignal();     
                    break;   
                default :
                    break;
            }
        }
        public function fireDataChangedSignal():void
        {
           dataChanged.dispatch( this, value );
        }
        
        public function draw() : void
        {
            _colorBase.graphics.clear();
            _colorMod1.graphics.clear();
            _colorMod2.graphics.clear();
            _colorCursor.graphics.clear();
            _colorBlend.graphics.clear();
            _colorBorders.graphics.clear();
            
            _colorBase.blendMode = "normal";
            _colorMod1.blendMode = "normal";
            _colorMod2.blendMode = "normal";
            
            var bwidth : Number = 16;
            var padding : Number = 4;
            var gwidth : Number = width - padding - bwidth;
            
            _colorBorders.graphics.beginFill( DefaultSkin.borderColor.hexa );
            _colorBorders.graphics.drawRect( 0,0,gwidth,height );
            _colorBorders.graphics.drawRect( 1,1,gwidth-2,height-2 );
            _colorBorders.graphics.drawRect( gwidth + padding,0,bwidth,height );
            _colorBorders.graphics.drawRect( gwidth + padding+1,1,bwidth-2,height-2 );
            _colorBorders.graphics.endFill();
            
            var m : Matrix;
            var r : Number;
            var g : Number;
            var b : Number;
            var hsv : Array;
            var h : Number;
            var s : Number;
            var v : Number;
            var c : Color;
            var a : Number;
            
            switch( _mode )
            {
                case MODE_R : 
                    _colorBase.graphics.beginFill( _color.red << 16, 1 );
                    _colorBase.graphics.drawRect( 0,0,gwidth,height );
                    _colorBase.graphics.endFill();
                    
                    m = new Matrix();
                    m.createGradientBox( bwidth,height,-Math.PI/2,bwidth,0);
                    _colorBlend.graphics.beginGradientFill("linear",[0x000000,0xff0000],[1,1],[0,255],m,"repeat");
                    _colorBlend.graphics.drawRect( gwidth + padding, 0, bwidth, height );
                    _colorBlend.graphics.endFill();
                    
                    m = new Matrix();
                    m.createGradientBox(gwidth,height,0,0,0);
                    _colorMod1.graphics.beginGradientFill("linear",[0x000000,0x0000ff],[1,1],[0,255],m,"repeat");
                    _colorMod1.graphics.drawRect( 0,0,gwidth,height );
                    _colorMod1.graphics.endFill();
                    _colorMod1.blendMode = "add";
                    
                    m = new Matrix();
                    m.createGradientBox(gwidth,height,-Math.PI/2,0,0);
                    _colorMod2.graphics.beginGradientFill("linear",[0x000000,0x00ff00],[1,1],[0,255],m,"repeat");
                    _colorMod2.graphics.drawRect( 0,0,gwidth,height );
                    _colorMod2.graphics.endFill();
                    _colorMod2.blendMode = "add";
                    
                    r = _color.red / 255;
                    g = _color.green / 255;
                    b = _color.blue / 255;
                    
                    _colorCursor.graphics.beginFill(0xffffff);
                    _colorCursor.graphics.drawRect( Math.floor( b * gwidth ), 0, 1, height );
                    _colorCursor.graphics.endFill();
                    
                    _colorCursor.graphics.beginFill(0xffffff);
                    _colorCursor.graphics.drawRect( 0, Math.floor( height - g * height ), gwidth, 1 );
                    _colorCursor.graphics.endFill();
                    
                    _colorCursor.graphics.beginFill(0xffffff);
                    _colorCursor.graphics.drawRect( gwidth + padding, Math.floor( height - r * height ), bwidth, 1 );
                    _colorCursor.graphics.endFill();
                    break;
                
                case MODE_G : 
                    _colorBase.graphics.beginFill( _color.green << 8, 1 );
                    _colorBase.graphics.drawRect( 0,0,gwidth,height );
                    _colorBase.graphics.endFill();
                    
                    m = new Matrix();
                    m.createGradientBox( bwidth,height,-Math.PI/2,bwidth,0);
                    _colorBlend.graphics.beginGradientFill("linear",[0x000000,0x00ff00],[1,1],[0,255],m,"repeat");
                    _colorBlend.graphics.drawRect( gwidth + padding, 0, bwidth, height );
                    _colorBlend.graphics.endFill();
                    
                    m = new Matrix();
                    m.createGradientBox(gwidth,height,0,0,0);
                    _colorMod1.graphics.beginGradientFill("linear",[0x000000,0x0000ff],[1,1],[0,255],m,"repeat");
                    _colorMod1.graphics.drawRect( 0,0,gwidth,height );
                    _colorMod1.graphics.endFill();
                    _colorMod1.blendMode = "add";
                    
                    m = new Matrix();
                    m.createGradientBox(gwidth,height,-Math.PI/2,0,0);
                    _colorMod2.graphics.beginGradientFill("linear",[0x000000,0xff0000],[1,1],[0,255],m,"repeat");
                    _colorMod2.graphics.drawRect( 0,0,gwidth,height );
                    _colorMod2.graphics.endFill();
                    _colorMod2.blendMode = "add";
                    
                    r = _color.red / 255;
                    g = _color.green / 255;
                    b = _color.blue / 255;
                    
                    _colorCursor.graphics.beginFill(0xffffff);
                    _colorCursor.graphics.drawRect( Math.floor( b * gwidth ), 0, 1, height );
                    _colorCursor.graphics.endFill();
                    
                    _colorCursor.graphics.beginFill(0xffffff);
                    _colorCursor.graphics.drawRect( 0, Math.floor( height - r * height ), gwidth, 1 );
                    _colorCursor.graphics.endFill();
                    
                    _colorCursor.graphics.beginFill(0xffffff);
                    _colorCursor.graphics.drawRect( gwidth + padding, Math.floor( height - g * height ), bwidth, 1 );
                    _colorCursor.graphics.endFill();
                    break;
                                    
                case MODE_B : 
                    _colorBase.graphics.beginFill( _color.blue, 1 );
                    _colorBase.graphics.drawRect( 0,0,gwidth,height );
                    _colorBase.graphics.endFill();
                    
                    m = new Matrix();
                    m.createGradientBox( bwidth,height,-Math.PI/2,bwidth,0);
                    _colorBlend.graphics.beginGradientFill("linear",[0x000000,0x0000ff],[1,1],[0,255],m,"repeat");
                    _colorBlend.graphics.drawRect( gwidth + padding, 0, bwidth, height );
                    _colorBlend.graphics.endFill();
                    
                    m = new Matrix();
                    m.createGradientBox(gwidth,height,0,0,0);
                    _colorMod1.graphics.beginGradientFill("linear",[0x000000,0x00ff00],[1,1],[0,255],m,"repeat");
                    _colorMod1.graphics.drawRect( 0,0,gwidth,height );
                    _colorMod1.graphics.endFill();
                    _colorMod1.blendMode = "add";
                    
                    m = new Matrix();
                    m.createGradientBox(gwidth,height,-Math.PI/2,0,0);
                    _colorMod2.graphics.beginGradientFill("linear",[0x000000,0xff0000],[1,1],[0,255],m,"repeat");
                    _colorMod2.graphics.drawRect( 0,0,gwidth,height );
                    _colorMod2.graphics.endFill();
                    _colorMod2.blendMode = "add";
                    
                    r = _color.red / 255;
                    g = _color.green / 255;
                    b = _color.blue / 255;
                    
                    _colorCursor.graphics.beginFill(0xffffff);
                    _colorCursor.graphics.drawRect( Math.floor( g * gwidth ), 0, 1, height );
                    _colorCursor.graphics.endFill();
                    
                    _colorCursor.graphics.beginFill(0xffffff);
                    _colorCursor.graphics.drawRect( 0, Math.floor( height - r * height ), gwidth, 1 );
                    _colorCursor.graphics.endFill();
                    
                    _colorCursor.graphics.beginFill(0xffffff);
                    _colorCursor.graphics.drawRect( gwidth + padding, Math.floor( height - b * height ), bwidth, 1 );
                    _colorCursor.graphics.endFill();
                    break;
                
                case MODE_H : 
                    hsv = _color.hsv;

                    h = hsv[0] / 360;
                    s = hsv[1] / 100;
                    v = hsv[2] / 100;
                    
                    c = new Color();
                    c.hsv = [ hsv[0], 100, 100 ];
                    _colorBase.graphics.beginFill( c.hexa, 1 );
                    _colorBase.graphics.drawRect( 0,0,gwidth,height );
                    _colorBase.graphics.endFill();
                    
                    m = new Matrix();
                    m.createGradientBox( bwidth,height,-Math.PI/2,bwidth,0);
                    _colorBlend.graphics.beginGradientFill("linear",HSV_RAMP,[1,1,1,1,1,1,1],HSV_RAMP_RATIOS,m,"repeat");
                    _colorBlend.graphics.drawRect( gwidth + padding, 0, bwidth, height );
                    _colorBlend.graphics.endFill();

                    m = new Matrix();
                    m.createGradientBox(gwidth,height,-Math.PI/2,0,0);
                    _colorMod1.graphics.beginGradientFill("linear",[0xffffff,0xffffff],[1,0],[0,255],m,"repeat");
                    _colorMod1.graphics.drawRect( 0,0,gwidth,height );
                    _colorMod1.graphics.endFill();

                    m = new Matrix();
                    m.createGradientBox(gwidth,height,0,0,0);
                    _colorMod2.graphics.beginGradientFill("linear",[0x000000,0x000000],[1,0],[0,255],m,"repeat");
                    _colorMod2.graphics.drawRect( 0,0,gwidth,height );
                    _colorMod2.graphics.endFill();
                    
                    _colorCursor.graphics.beginFill(0xffffff);
                    _colorCursor.graphics.drawRect( Math.floor( v * gwidth ), 0, 1, height );
                    _colorCursor.graphics.endFill();
                    
                    _colorCursor.graphics.beginFill(0xffffff);
                    _colorCursor.graphics.drawRect( 0, Math.floor( height - s * height ), gwidth, 1 );
                    _colorCursor.graphics.endFill();
                    
                    _colorCursor.graphics.beginFill(0xffffff);
                    _colorCursor.graphics.drawRect( gwidth + padding, Math.floor( height - h * height ), bwidth, 1 );
                    _colorCursor.graphics.endFill();
                    break;
                
                case MODE_S : 
                
                    hsv = _color.hsv;

                    h = hsv[0] / 360;
                    s = hsv[1] / 100;
                    v = hsv[2] / 100;
                    
                    c = new Color();
                    _colorBase.graphics.beginFill( 0xffffff, 1 );
                    _colorBase.graphics.drawRect( 0,0,gwidth,height );
                    _colorBase.graphics.endFill();
                    
                    m = new Matrix();
                    m.createGradientBox( bwidth,height,-Math.PI/2,bwidth,0);
                    _colorBlend.graphics.beginGradientFill("linear",[0x000000,0xffffff],[1,1],[0,255],m,"repeat");
                    _colorBlend.graphics.drawRect( gwidth + padding, 0, bwidth, height );
                    _colorBlend.graphics.endFill();

                    m = new Matrix();
                    m.createGradientBox(gwidth,height,-Math.PI/2,0,0);
                    _colorMod1.graphics.beginGradientFill("linear",HSV_RAMP,[s,s,s,s,s,s,s],HSV_RAMP_RATIOS,m,"repeat");
                    _colorMod1.graphics.drawRect( 0,0,gwidth,height );
                    _colorMod1.graphics.endFill();

                    m = new Matrix();
                    m.createGradientBox(gwidth,height,0,0,0);
                    _colorMod2.graphics.beginGradientFill("linear",[0x000000,0x000000],[1,0],[0,255],m,"repeat");
                    _colorMod2.graphics.drawRect( 0,0,gwidth,height );
                    _colorMod2.graphics.endFill();
                    
                    _colorCursor.graphics.beginFill(0xffffff);
                    _colorCursor.graphics.drawRect( Math.floor( v * gwidth ), 0, 1, height );
                    _colorCursor.graphics.endFill();
                    
                    _colorCursor.graphics.beginFill(0xffffff);
                    _colorCursor.graphics.drawRect( 0, Math.floor(  height - h * height ), gwidth, 1 );
                    _colorCursor.graphics.endFill();
                    
                    _colorCursor.graphics.beginFill(0xffffff);
                    _colorCursor.graphics.drawRect( gwidth + padding, Math.floor( height - s * height ), bwidth, 1 );
                    _colorCursor.graphics.endFill();
                    break;       
                    
                 case MODE_V : 
                
                    hsv = _color.hsv;

                    h = hsv[0] / 360;
                    s = hsv[1] / 100;
                    v = hsv[2] / 100;
                    
                    c = new Color();
                    _colorBase.graphics.beginFill( 0x000000, 1 );
                    _colorBase.graphics.drawRect( 0,0,gwidth,height );
                    _colorBase.graphics.endFill();
                    
                    m = new Matrix();
                    m.createGradientBox( bwidth,height,-Math.PI/2,bwidth,0);
                    _colorBlend.graphics.beginGradientFill("linear",[0x000000,0xffffff],[1,1],[0,255],m,"repeat");
                    _colorBlend.graphics.drawRect( gwidth + padding, 0, bwidth, height );
                    _colorBlend.graphics.endFill();

                    m = new Matrix();
                    m.createGradientBox(gwidth,height,-Math.PI/2,0,0);
                    _colorMod1.graphics.beginGradientFill("linear",HSV_RAMP,[v,v,v,v,v,v,v],HSV_RAMP_RATIOS,m,"repeat");
                    _colorMod1.graphics.drawRect( 0,0,gwidth,height );
                    _colorMod1.graphics.endFill();
                    _colorMod1.blendMode = "add";

                    m = new Matrix();
                    m.createGradientBox(gwidth,height,0,0,0);
                    _colorMod2.graphics.beginGradientFill("linear",[0xffffff,0xffffff],[v,0],[0,255],m,"repeat");
                    _colorMod2.graphics.drawRect( 0,0,gwidth,height );
                    _colorMod2.graphics.endFill();
                    
                    _colorCursor.graphics.beginFill(0xffffff);
                    _colorCursor.graphics.drawRect( Math.floor( s * gwidth ), 0, 1, height );
                    _colorCursor.graphics.endFill();
                    
                    _colorCursor.graphics.beginFill(0xffffff);
                    _colorCursor.graphics.drawRect( 0, Math.floor(  height - h * height ), gwidth, 1 );
                    _colorCursor.graphics.endFill();
                    
                    _colorCursor.graphics.beginFill(0xffffff);
                    _colorCursor.graphics.drawRect( gwidth + padding, Math.floor( height - v * height ), bwidth, 1 );
                    _colorCursor.graphics.endFill();
                    break;      
                default : 
                    break;                           
            }
        }
    }
}

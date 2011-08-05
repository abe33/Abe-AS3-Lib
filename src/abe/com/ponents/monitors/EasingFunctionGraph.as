package abe.com.ponents.monitors
{
    import abe.com.mon.colors.Color;
    import abe.com.mon.geom.Dimension;
    import abe.com.ponents.core.AbstractComponent;

    import flash.display.Graphics;
    import flash.display.Shape;

    /**
     * @author cedric
     */
    public class EasingFunctionGraph extends AbstractComponent
    {
		static public const PAD : uint = 10;

        protected var _easingFunction : Function;
        protected var _graph : Shape;
        
        public function EasingFunctionGraph ( f : Function = null )
        {
            super ();
            
            _allowOver = _allowPressed = _allowFocus = false;
            
            _easingFunction = f;
            _preferredSizeCache = new Dimension(100, 100);
            
            _graph = new Shape();
            addComponentChild( _graph );
            
            renderGraph();
        }

        public function get easingFunction () : Function { return _easingFunction; }
        public function set easingFunction ( f : Function ) : void { _easingFunction = f; renderGraph(); }
        
        override public function repaint () : void
        {
            super.repaint ();
            renderGraph();
        }
        
        protected function renderGraph():void
        {
            var g : Graphics = _graph.graphics;
            g.clear();
            
            
            var x : Number = 0;
            
            var p2 : uint = PAD*2;
            
            g.lineStyle(0, 0x666666 );
            g.moveTo(PAD, PAD);
            g.lineTo(PAD, height-PAD);
            g.lineTo(width-PAD, height-PAD);

            if( _easingFunction == null )
            	return;
            
            g.lineStyle(0, Color.FireBrick.hexa );
            g.moveTo( x+PAD, _easingFunction( x, height-PAD, -height+p2, width-p2 ) );
            
            for(x;x<=width-p2;x+=2)
            	g.lineTo(x+PAD, _easingFunction( x, height-PAD, -height+p2, width-p2 ) );
            
        }
    }
}

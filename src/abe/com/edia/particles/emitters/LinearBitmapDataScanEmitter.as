package abe.com.edia.particles.emitters
{
    import abe.com.mon.geom.pt;
    import abe.com.mon.utils.BitmapUtils;
    import abe.com.mon.utils.getReflectionSource;
    import abe.com.mon.utils.getSource;
    import abe.com.patibility.lang._$;

    import flash.display.BitmapData;
    import flash.geom.Point;

    /**
     * @author cedric
     */
    public class LinearBitmapDataScanEmitter extends AbstractBitmapDataEmitter implements FixedCoordsEmitter
    {
        protected var _from: Point;
        protected var _to: Point;
        protected var _pixelLookup : Function;
        protected var _coords : Array;
        protected var _iterator : int;
        
        public function LinearBitmapDataScanEmitter ( bmp : BitmapData, 
        											  from : Point, 
                                                      to : Point,
                                                      pixelLookup : Function = null )
        {
            super ( bmp );
            _from = from;
            _to = to;
            _pixelLookup = pixelLookup;
            updateCoordinates();
        }
        public function get coords () : Array { return _coords; }
        
        public function get from () : Point { return _from; }
        public function set from ( from : Point ) : void { _from = from; updateCoordinates(); }

        public function get to () : Point { return _to; }
        public function set to ( to : Point ) : void { _to = to; updateCoordinates(); }
        
        public function get pixelLookup () : Function { return _pixelLookup;}
        public function set pixelLookup ( pixelLookup : Function ) : void 
        { 
            _pixelLookup = pixelLookup;
            updateCoordinates();
        }

        public function updateCoordinates () : void
        {
            _iterator = 0;
            _coords = BitmapUtils.linearBitmapScan( _bitmapData, _from, _to, _pixelLookup);
        }
        
        override public function get ( n : Number = NaN ) : Point
        {
            if( _coords.length == 0 )
            	return pt();
            
            if( _iterator >= _coords.length )
            	_iterator %= _coords.length;
            
            return _coords[ _iterator++ ];
        }
        
        override protected function getSourceArguments () : String
        {
            return [ getSource( _bitmapData ), 
            		 _$("new flash.geom.Point($0,$1)", _from.x, _from.y),
            		 _$("new flash.geom.Point($0,$1)", _to.x, _to.y),
                     getSource( _pixelLookup ) ].join(", ");
        }
        override protected function getReflectionSourceArguments () : String
        {
            return [ getReflectionSource( _bitmapData ), 
            		 _$("new flash.geom::Point($0,$1)", _from.x, _from.y), 
            		 _$("new flash.geom::Point($0,$1)", _to.x, _to.y), 
                     getReflectionSource ( _pixelLookup ) ].join ( ", " );
        }
    }
}

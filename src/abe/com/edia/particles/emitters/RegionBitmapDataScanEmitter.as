package abe.com.edia.particles.emitters
{
    import abe.com.mon.geom.pt;
    import abe.com.mon.utils.getReflectionSource;
    import abe.com.mon.utils.getSource;
    import abe.com.patibility.lang._$;

    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * @author cedric
     */
    public class RegionBitmapDataScanEmitter extends AbstractBitmapDataEmitter implements FixedCoordsEmitter
    {
        protected var _pixelLookup : Function;
        protected var _coords : Array;
        protected var _iterator : int;
        protected var _region : Rectangle;
        
        public function RegionBitmapDataScanEmitter ( bmp : BitmapData, 
        											  region : Rectangle, 
                                                      pixelLookup : Function )
        {
            super ( bmp );
            _region = region;
            _pixelLookup = pixelLookup;
            
            updateCoordinates();
        }

        public function get coords () : Array { return _coords; }
        
        public function get pixelLookup () : Function { return _pixelLookup;}
        public function set pixelLookup ( pixelLookup : Function ) : void 
        { 
            _pixelLookup = pixelLookup;
            updateCoordinates();
        }
        
        public function get region () : Rectangle { return _region; }
        public function set region ( region : Rectangle ) : void { _region = region; updateCoordinates(); }

        public function updateCoordinates () : void
        {
            _iterator = 0;
            var a : Array = [];
            for( var y : int = _region.y; y < _region.bottom; y++ )
            	for( var x : int = _region.x; x < _region.right; x++ )
                {
                    if( _pixelLookup( _bitmapData, x, y ) )
                    	a.push( pt(x,y) );
                }
            
            _coords = a;
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
            		 _$("new flash.geom.Rectangle($0,$1,$2,$3)", _region.x, _region.y, _region.width, _region.height ),
                     getSource( _pixelLookup ) ].join(", ");
        }
        override protected function getReflectionSourceArguments () : String
        {
            return [ getReflectionSource( _bitmapData ), 
            		 _$("new flash.geom::Rectangle($0,$1,$2,$3)", _region.x, _region.y, _region.width, _region.height ),
                     getReflectionSource ( _pixelLookup ) ].join ( ", " );
        }
    }
}
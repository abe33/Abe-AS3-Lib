package abe.com.edia.particles.emitters
{
    import abe.com.mon.geom.pt;
    import abe.com.mon.utils.BitmapUtils;

    import flash.display.BitmapData;
    import flash.geom.Point;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="bitmapData,center,angle,pixelLookup")]
    public class RadialBitmapDataScanEmitter extends AbstractBitmapDataEmitter implements FixedCoordsEmitter
    {
        protected var _center: Point;
        protected var _pixelLookup : Function;
        protected var _angle : Number;
        protected var _coords : Array;
        protected var _iterator : int;
        
        public function RadialBitmapDataScanEmitter ( bmp : BitmapData, 
        											  center : Point, 
                                                      angle : Number = 0,
                                                      pixelLookup : Function = null )
        {
            super ( bmp );
            _center = center;
            _pixelLookup = pixelLookup;
            _angle = angle;
            updateCoordinates();
        }
        public function get coords () : Array { return _coords; }
        
        public function get angle () : Number { return _angle; }
        public function set angle ( angle : Number ) : void { _angle = angle; updateCoordinates(); }

		public function get center () : Point { return _center; }
        public function set center ( center : Point ) : void { _center = center; updateCoordinates(); }

        public function get pixelLookup () : Function { return _pixelLookup;}
        public function set pixelLookup ( pixelLookup : Function ) : void 
        { 
            _pixelLookup = pixelLookup;
            updateCoordinates();
        }

        public function updateCoordinates () : void
        {
            _iterator = 0;
            _coords = BitmapUtils.radialBitmapScan( _bitmapData, _center, _angle, _pixelLookup);
        }

        override public function get ( n : Number = NaN ) : Point
        {
            if( _coords.length == 0 )
            	return pt();
                
            if( _iterator >= _coords.length )
            	_iterator %= _coords.length;
            
            return _coords[ _iterator++ ];
        }
        
    }
}

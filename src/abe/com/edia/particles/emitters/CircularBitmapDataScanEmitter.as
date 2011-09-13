package abe.com.edia.particles.emitters
{
    import abe.com.mon.geom.pt;
    import abe.com.mon.utils.BitmapUtils;

    import flash.display.BitmapData;
    import flash.geom.Point;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="bitmapData,center,radius,pixelLookup")]
    public class CircularBitmapDataScanEmitter extends AbstractBitmapDataEmitter implements FixedCoordsEmitter
    {
        protected var _pixelLookup : Function;
        protected var _coords : Array;
        protected var _iterator : int;
        protected var _center : Point;
        protected var _radius : Number;
        
        public function CircularBitmapDataScanEmitter ( bmp : BitmapData, 
        												center : Point, 
                                                        radius : Number, 
                                                        pixelLookup : Function )
        {
            super ( bmp );
            _center = center;
            _radius = radius;
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
        
        public function get center () : Point { return _center; }
        public function set center ( center : Point ) : void { _center = center; updateCoordinates(); }
        
        public function get radius () : Number { return _radius; }
        public function set radius ( radius : Number ) : void { _radius = radius; updateCoordinates(); }

        public function updateCoordinates () : void
        {
            _iterator = 0;
            _coords = BitmapUtils.circularBitmapScan( _bitmapData, _center, _radius, _pixelLookup);
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
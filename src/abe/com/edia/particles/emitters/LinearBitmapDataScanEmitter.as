package abe.com.edia.particles.emitters
{
    import abe.com.mon.geom.pt;
    import abe.com.mon.randoms.Random;
    import abe.com.mon.utils.BitmapUtils;
    import abe.com.mon.utils.RandomUtils;

    import flash.display.BitmapData;
    import flash.geom.Point;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="bitmapData,from,to,pixelLookup")]
    public class LinearBitmapDataScanEmitter extends AbstractBitmapDataEmitter implements FixedCoordsEmitter
    {
        protected var _from: Point;
        protected var _to: Point;
        protected var _pixelLookup : Function;
        protected var _coords : Array;
        protected var _iterator : int;
        protected var _randomized : Boolean;
        protected var _random : Random;
        
        public function LinearBitmapDataScanEmitter ( bmp : BitmapData, 
        											  from : Point, 
                                                      to : Point,
                                                      pixelLookup : Function = null,
                                                      randomized : Boolean = true,
                                                      random : Random = null )
        {
            super ( bmp );
            _from = from;
            _to = to;
            _pixelLookup = pixelLookup;
            _randomized = randomized;
            _random = random ? random : RandomUtils;
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
                
            if( _randomized )
                return _random.inArray(_coords);
            else
            {
	            if( _iterator >= _coords.length )
	            	_iterator %= _coords.length;
	            
	            return _coords[ _iterator++ ];
            }
        }
    }
}

package abe.com.mon.geom
{
    import abe.com.mon.core.Cloneable;
    import abe.com.mon.core.FormMetaProvider;
    import abe.com.mon.core.Randomizable;
    import abe.com.mon.randoms.Random;
    import abe.com.mon.utils.RandomUtils;

    import flash.display.BitmapData;
    import flash.geom.Point;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="bitmapData,minWeight")]
    public class BitmapDataSurface implements Surface, 
    										  Randomizable, 
                                              Cloneable, 
                                              FormMetaProvider
    {
        protected var _bitmapData : BitmapData;
        protected var _positions : Array;
        protected var _weights : Array;
        protected var _cumulatedWeights : Array;
        protected var _totalWeight : Number;
        protected var _minWeight : Number;
        protected var _randomSource : Random;
        
        public function BitmapDataSurface ( bitmapData : BitmapData, minWeight : Number = 0 )
        {
            _bitmapData = bitmapData;
            _minWeight = minWeight;
            _randomSource = RandomUtils;
            updateData();
        }

        public function get acreage () : Number { return _totalWeight; }
        
        public function get bitmapData () : BitmapData { return _bitmapData; }
        public function set bitmapData ( bitmapData : BitmapData ) : void 
        { 
            _bitmapData = bitmapData;
            updateData();
        }
        public function get randomSource () : Random { return _randomSource; }
        public function set randomSource ( randomSource : Random ) : void { _randomSource = randomSource; }
        
        public function getRandomPointInSurface () : Point
        {
            return _randomSource.inArrayWithRatios( _positions, _cumulatedWeights, true, _totalWeight );
        }

        public function containsPoint ( p : Point ) : Boolean { return contains(p.x, p.y); }
        public function contains ( x : Number, y : Number ) : Boolean
        {
            var r : Number = ( ( _bitmapData.getPixel32( x, y ) >> 24 ) & 0xff ) / 255;
			return r >= _minWeight;
        }
        
        public function updateData() : void
        {
            _totalWeight = 0;
            _positions = [];
            _cumulatedWeights = [];
            _weights = [];
            
            if( _bitmapData )
            {
            	var w : int = _bitmapData.width;
            	var h : int = _bitmapData.height;
                var x : int;
                var y : int;
				var r : Number;
                
                for(y=0;y<h;y++)
                {
                	for(x=0;x<w;x++)
                    {
                        r = ( ( _bitmapData.getPixel32( x, y ) >> 24 ) & 0xff ) / 255;
                        if( r >= _minWeight )
                        {
                        	_weights.push( r );
                            _positions.push( pt( x, y ) );
                            _totalWeight += r;
                            _cumulatedWeights.push(_totalWeight);
                        }
                    }
                }
            }
        }

        public function containsGeometry ( geom : Geometry ) : Boolean
        {
            throw new Error ("Unsupported method");
            return false;
        }
        
        public function clone () : * { return new BitmapDataSurface( _bitmapData, _minWeight ); }
        

        public function get minWeight () : Number {
            return _minWeight;
        }

        public function set minWeight ( minWeight : Number ) : void {
            _minWeight = minWeight;
        }

    }
}

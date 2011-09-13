package abe.com.edia.particles.emitters
{
    import abe.com.mon.core.Randomizable;
    import abe.com.mon.randoms.Random;
    import abe.com.mon.utils.RandomUtils;

    import flash.display.BitmapData;
    import flash.geom.Point;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="bitmapData")]
    public class AbstractBitmapDataEmitter implements Emitter, Randomizable
    {
        protected var _bitmapData : BitmapData;
        protected var _randomSource : Random;
        
        public function AbstractBitmapDataEmitter ( bmp : BitmapData )
        {
            _bitmapData = bmp;
            _randomSource = RandomUtils;
        }
        
        public function get bitmapData () : BitmapData { return _bitmapData; }
        public function set bitmapData ( bitmapData : BitmapData ) : void { _bitmapData = bitmapData; }

        public function get randomSource () : Random { return _randomSource; }
        public function set randomSource ( randomSource : Random ) : void { _randomSource = randomSource; }

        public function get ( n : Number = NaN ) : Point { return null; }
        public function clone () : * { return null; }

    }
}

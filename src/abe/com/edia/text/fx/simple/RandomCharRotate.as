package abe.com.edia.text.fx.simple
{
    import abe.com.mon.utils.RandomUtils;
    import abe.com.mon.randoms.Random;
    import abe.com.mon.core.Randomizable;
    import abe.com.mon.geom.Range;

    /**
     * @author cedric
     */
    public class RandomCharRotate extends CharRotate implements Randomizable
    {
        protected var _randomSource : Random;
        
        protected var _range : Range;
        
        
        public function RandomCharRotate ( angleRange : Range, ref : String = "topLeft", randomSource : Random = null )
        {
            _range = angleRange;
            _randomSource = randomSource ? randomSource : RandomUtils;
            super ( 0, ref );
        }

        override protected function getAngle () : Number
        {
            return _randomSource.range(_range);
        }

        public function get randomSource () : Random { return _randomSource; }
        public function set randomSource ( randomSource : Random ) : void { _randomSource = randomSource; }

        public function get range () : Range { return _range; }
        public function set range ( range : Range ) : void { _range = range; }
    }
}

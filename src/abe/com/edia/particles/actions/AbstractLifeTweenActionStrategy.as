package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.motion.AbstractTween;
	
    [Serialize(constructorArgs="easing,startValue,endValue")]
    public class AbstractLifeTweenActionStrategy extends AbstractActionStrategy
	{
		protected var _easing : Function;
		protected var _startValue : Number;
		protected var _endValue : Number;

        public function AbstractLifeTweenActionStrategy ( 	easing : Function = null,
        											   		startValue : Number = 1, 
                                                       		endValue : Number = 0 )
		{
			_startValue = startValue;
			_endValue = endValue;
			_easing = ( easing != null ) ? easing : AbstractTween.noEasing;
		}
		
		override public function process( particle : Particle ) : void
		{
			var n : Number = _easing( particle.life, _startValue, _endValue - _startValue, particle.maxLife );
			_process( particle, n );
		}

        protected function _process ( particle : Particle, value : Number ) : void
        {
        }

        public function get easing () : Function {
            return _easing;
        }

        public function set easing ( easing : Function ) : void {
            _easing = easing;
        }

        public function get startValue () : Number {
            return _startValue;
        }
        public function set startValue ( startValue : Number ) : void {
            _startValue = startValue;
        }

        public function get endValue () : Number {
            return _endValue;
        }

        public function set endValue ( endValue : Number ) : void {
            _endValue = endValue;
        }

	}
}
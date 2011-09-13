package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.DisplayObjectParticle;
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.utils.getReflectionSource;
    import abe.com.mon.utils.getSource;
    import abe.com.patibility.lang._$;

    import flash.geom.Point;

	[Serialize(constructorArgs="startScale,endScale,easing")]
    public class ScaleLifeTweenActionStrategy extends AbstractLifeTweenActionStrategy
	{
		protected var _startScale : Point;
		protected var _endScale : Point;

        public function ScaleLifeTweenActionStrategy ( startScale : Point, endScale : Point, easing : Function = null )
		{
			super( easing, 0, 1 );
			_startScale = startScale;
			_endScale = endScale;
		}
		override protected function _process( particle : Particle, value : Number ) : void
		{
			var p : DisplayObjectParticle = particle as DisplayObjectParticle;
			
			p.scale.x = _startScale.x + ( _endScale.x - _startScale.x ) * value; 
            p.scale.y = _startScale.y + ( _endScale.y - _startScale.y ) * value;
        }

        public function get startScale () : Point {
            return _startScale;
        }

        public function set startScale ( startScale : Point ) : void {
            _startScale = startScale;
        }

        public function get endScale () : Point {
            return _endScale;
        }

        public function set endScale ( endScale : Point ) : void {
            _endScale = endScale;
        }	

	}
}
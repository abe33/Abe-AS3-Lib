package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.DisplayObjectParticle;
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.utils.getReflectionSource;
    import abe.com.mon.utils.getSource;
    import abe.com.patibility.lang._$;

    import flash.geom.Point;

    public class ScaleLifeTweenActionStrategy extends AbstractLifeTweenActionStrategy
	{
		protected var _pStartScale : Point;
		protected var _pEndScale : Point;

        public function ScaleLifeTweenActionStrategy ( startScale : Point, endScale : Point, easing : Function = null )
		{
			super( easing, 0, 1 );
			_pStartScale = startScale;
			_pEndScale = endScale;
		}
		override protected function _process( particle : Particle, value : Number ) : void
		{
			var p : DisplayObjectParticle = particle as DisplayObjectParticle;
			
			p.scale.x = _pStartScale.x + ( _pEndScale.x - _pStartScale.x ) * value; 
			p.scale.y = _pStartScale.y + ( _pEndScale.y - _pStartScale.y ) * value; 
        }	
        
        override protected function getSourceArguments () : String
        {
            return [ _$("new flash.geom.Point($0,$1)", _pStartScale.x, _pStartScale.y ),
            		 _$("new flash.geom.Point($0,$1)", _pEndScale.x, _pEndScale.y ), 
                     getSource(_fEasing, "${easingFunction}" ) ].join(", ");
        }

        override protected function getReflectionSourceArguments () : String
        {
            return [ _$("new flash.geom::Point($0,$1)", _pStartScale.x, _pStartScale.y ),
            		 _$("new flash.geom::Point($0,$1)", _pEndScale.x, _pEndScale.y ), 
                     getReflectionSource(_fEasing, "${easingFunction}" ) ].join(", ");
        }

	}
}
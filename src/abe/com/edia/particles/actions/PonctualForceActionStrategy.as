package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.utils.getReflectionSource;
    import abe.com.mon.utils.getSource;
    import abe.com.mon.utils.reflectionSourcesDictionary;
    import abe.com.mon.utils.sourcesDictionary;
    import abe.com.patibility.lang._$;
    import flash.geom.Point;


	public class PonctualForceActionStrategy extends AbstractActionStrategy implements ActionStrategy
	{
        static public function noDecay ( n : Number ) : Number {
            return 1;
        }
        sourcesDictionary[ noDecay ] = "abe.com.edia.particles.strategy.actions.PonctualForceActionStrategy.noDecay";
        reflectionSourcesDictionary[ noDecay ] = "abe.com.edia.particles.strategy.actions::PonctualForceActionStrategy.noDecay";
        
        static public function linearDecay ( n : Number ) : Number {
            return 1-n;
        }
        sourcesDictionary[ linearDecay ] = "abe.com.edia.particles.strategy.actions.PonctualForceActionStrategy.linearDecay";
        reflectionSourcesDictionary[ linearDecay ] = "abe.com.edia.particles.strategy.actions::PonctualForceActionStrategy.linearDecay";
       
        static public function expDecay ( n : Number ) : Number {
            return 1-n*n;
        }
        sourcesDictionary[ expDecay ] = "abe.com.edia.particles.strategy.actions.PonctualForceActionStrategy.expDecay";
        reflectionSourcesDictionary[ expDecay ] = "abe.com.edia.particles.strategy.actions::PonctualForceActionStrategy.expDecay";
        
		protected var _forcePosition : Point;
		protected var _forceStrength : Number;
		protected var _forceRadius : Number;
        protected var _forceDecay : Function;
		
		public function PonctualForceActionStrategy( forcePosition : Point = null, 
        											 forceRadius : Number = 100, 
                                                     forceStrength : Number = 10,
                                                     forceDecay : Function = null )
		{
			_forcePosition = forcePosition;
			_forceRadius = forceRadius;
			_forceStrength = forceStrength;
            _forceDecay = forceDecay != null ? forceDecay : noDecay;
        }
		public function get forcePosition () : Point { return _forcePosition; }
		public function set forcePosition ( forcePosition : Point ) : void { _forcePosition = forcePosition ? forcePosition : new Point(); } 
		
		public function get forceRadius () : Number { return _forceRadius; }
		public function set forceRadius ( forceRadius : Number ) : void	{ _forceRadius = isNaN( forceRadius ) ? 0 : forceRadius; }
		
		public function set forceStrength ( forceStrength : Number ) : void	{ _forceStrength = isNaN( forceStrength ) ? 0 : forceStrength;	}
        public function get forceStrength () : Number { return _forceStrength;	}
        
		public override  function process( particle : Particle ) : void
		{
			processForce(particle, _forcePosition, _forceRadius, _forceStrength, _forceDecay );
		}
        protected function processForce( particle : Particle, pos : Point, radius : Number, strength : Number, decay : Function ):void
        {
            var pForce : Point = particle.position.subtract( pos );
			var distLength : Number = pForce.length;
			
			if( distLength > radius ) return;
			
			var l : Number = strength * decay( distLength / radius ) * _nTimeStep;
			
			pForce.normalize( l );			
			particle.velocity = particle.velocity.add( pForce );
        }
        
        override protected function getSourceArguments () : String
        {
            return [ _$("new flash.geom.Point($0,$1)", _forcePosition.x, _forcePosition.y),
            		 _forceRadius,
                     _forceStrength, 
                     getSource( _forceDecay, "${decayFunction}" ) ].join(", ");
        }
        override protected function getReflectionSourceArguments () : String
        {
            return [ _$("new flash.geom::Point($0,$1)", _forcePosition.x, _forcePosition.y),
            		 _forceRadius,
                     _forceStrength, 
                     getReflectionSource( _forceDecay, "${decayFunction}" ) ].join(", ");
        }
	}
}
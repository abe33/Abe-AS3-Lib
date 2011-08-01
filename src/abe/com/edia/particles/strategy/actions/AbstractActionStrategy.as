package abe.com.edia.particles.strategy.actions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.ParticleSystem;
    import abe.com.edia.particles.strategy.ActionStrategy;
    import abe.com.patibility.lang._$;

    import flash.utils.getQualifiedClassName;

    public class AbstractActionStrategy implements ActionStrategy
	{
        protected var _nTimeStep : Number;
        protected var _system : ParticleSystem;
		
		public function prepareAction( bias : Number, biasInSecond : Number, currentTime : Number ) : void
		{
			_nTimeStep = biasInSecond;
		}
        public function get system () : ParticleSystem { return _system; }
        public function set system ( s : ParticleSystem ):void {  _system = s; }
        
		public function process( particle : Particle ) : void
		{
		}
        public function toSource () : String
        {
            return _$ ( "new $0($1)", getQualifiedClassName ( this ).replace("::","."), getSourceArguments () );
        }
        
        public function toReflectionSource () : String { 
            return _$ ( "new $0($1)", getQualifiedClassName ( this ), getReflectionSourceArguments () ); 
        }
       
        protected function getSourceArguments () : String
        {
            return "";
        }
        protected function getReflectionSourceArguments () : String
        {
            return "";
        }
	}
}
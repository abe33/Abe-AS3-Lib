package abe.com.edia.particles.strategy.actions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.ParticleSystem;
    import abe.com.edia.particles.strategy.ActionStrategy;
    import abe.com.patibility.lang._$;

    import flash.utils.getQualifiedClassName;

    /**
     * @author cedric
     */
    public class MacroActionStrategy implements ActionStrategy
    {
        protected var _actions : Array;
        protected var _system : ParticleSystem;

        public function MacroActionStrategy ( ... args )
        {
            _actions = args;
        }
        public function get actions () : Array { return _actions; }
        public function set actions ( actions : Array ) : void { _actions = actions; }
        
        public function get system () : ParticleSystem { return _system; }
        public function set system ( s : ParticleSystem ):void 
        {
        	_system = s; 
            for each( var a : ActionStrategy in _actions )
            	a.system = s;
        }

        public function prepareAction ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void
        {
            for each( var a : ActionStrategy in _actions )
            	a.prepareAction(bias, biasInSeconds, currentTime);
        }

        public function process ( particle : Particle ) : void
        {
            for each( var a : ActionStrategy in _actions )
            	a.process(particle);
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
            return "\n\t" + _actions.map( function(o:ActionStrategy,... args):String{ return o.toSource().replace(/\n/g,"\n\t"); } ).join(",\n\t");
        }
        protected function getReflectionSourceArguments () : String
        {
            return "\n\t" + _actions.map( function(o:ActionStrategy,... args):String{ return o.toReflectionSource().replace(/\n/g,"\n\t"); } ).join(",\n\t");
        }
    }
}

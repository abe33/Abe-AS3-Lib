package abe.com.edia.particles.emissions
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.core.ParticleSystem;
    import abe.com.edia.particles.emitters.Emitter;
    import abe.com.edia.particles.emitters.PointEmitter;
    import abe.com.mon.geom.pt;
    import abe.com.mon.utils.AllocatorInstance;
    import abe.com.mon.utils.StringUtils;
    import abe.com.patibility.lang._;
    import abe.com.patibility.lang._$;
    import flash.utils.getQualifiedClassName;


    public class AbstractEmission implements ParticleEmission
	{
		protected var _particleType : Class;
        protected var _emitter : Emitter;
        protected var _system : ParticleSystem;
        
		/**
		 * 
		 * @param type
		 * @param position
		 * @throws com.bourre.error.ClassCastException
		 * @throws com.bourre.error.NullPointerException
		 * @throws com.bourre.error.UnimplementedVirtualMethodException
         */
        public function AbstractEmission ( type : Class, emitter : Emitter = null )
		{
			this._particleType = type;
            this._emitter = emitter ? emitter : new PointEmitter(pt());
		}
        
		public function get emitter() : Emitter { return _emitter; }
		public function set emitter( e : Emitter ) : void { _emitter = e; }
		
		public function get particleType() : Class { return _particleType; }
		public function set particleType( type : Class ) : void { 
            _checkParticleType( type );
            _particleType = type;
		}
        public function get system () : ParticleSystem { return _system; }
        public function set system ( s : ParticleSystem ):void { _system = s; }
        
		public function isFinish():Boolean { return true; }
		
		public function prepare( bias : Number, biasInSeconds : Number, time : Number ) : void {}
		public function reset () : void {}
		public function hasNext() : Boolean { return false; }
		public function nextTime():Number { return 0; }
		public function remove():void {}
		
		public function next() : *
		{
			var p : Particle = AllocatorInstance.get(  _particleType ) as Particle; 
			p.position = _emitter.get();
			return p;
		}
		
		public function toString () : String
		{
			return StringUtils.stringify( this );
		}
		
		/*-----------------------------------------------------------------------
			PROTECTED METHODS
		------------------------------------------------------------------------*/
		
		protected function _checkParticleType ( c : Class ) : void
		{
			if( c == null )
				throw new Error( _$(_("Particle's class passed to $0 is null"),this) );
			else if( ( new c () as Particle ) == null )
            	throw new Error(_$(_("Particle's class passed to $0 is not a subclass of the Particle class : $1"),this,c) );
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
        public function clone () : *
        {
            return null;
        }
	}
}
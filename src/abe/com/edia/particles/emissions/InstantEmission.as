package abe.com.edia.particles.emissions
{
    import flash.utils.getQualifiedClassName;
    import abe.com.edia.particles.emitters.Emitter;

	public class InstantEmission extends AbstractEmission
	{
		protected var _nCount : Number;
		
		public function InstantEmission( type : Class, emitter : Emitter = null, count : Number = 0 )
		{
			super( type, emitter );
			_nCount = count;
		}
		public override function hasNext() : Boolean
		{
			return _nCount > 0;
		}
		public override function next() : *
		{
			_nCount--;
			return super.next();			
        }
        override public function clone () : *
        {
            return new InstantEmission( _particleType, _emitter, _nCount );
        }
        override protected function getSourceArguments () : String
        {
            return [ getQualifiedClassName(_particleType).replace("::", "."), _emitter.toSource(), _nCount ].join(", ");
        }
        override protected function getReflectionSourceArguments () : String
        {
            return [ getQualifiedClassName(_particleType), _emitter.toReflectionSource(), _nCount ].join(", ");
        }
	}
}
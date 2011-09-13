package abe.com.edia.particles.emissions
{
    import flash.utils.getQualifiedClassName;
    import abe.com.edia.particles.emitters.Emitter;

	[Serialize(constructorArgs="particleType,emitter,count")]
	public class InstantEmission extends AbstractEmission
	{
		protected var _count : Number;
		
		public function InstantEmission( type : Class, emitter : Emitter = null, count : Number = 0 )
		{
			super( type, emitter );
			_count = count;
		}
		public override function hasNext() : Boolean
		{
			return _count > 0;
		}
		public override function next() : *
		{
			_count--;
			return super.next();			
        }
        override public function clone () : *
        {
            return new InstantEmission ( _particleType, _emitter, _count );
        }

        public function get count () : Number {
            return _count;
        }

        public function set count ( count : Number ) : void {
            _count = count;
        }
	}
}
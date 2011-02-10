package aesia.com.patibility.accessors 
{
	/**
	 * @author cedric
	 */
	public class PropertyAccessor implements Accessor 
	{
		protected var _target : Object;
		protected var _propertyName : String;

		public function PropertyAccessor ( target : Object, propertyName : String ) 
		{
			_target = target;
			_propertyName = propertyName;
		}
		public function get () : *
		{
			if( propertyExist() )
				return _target[ _propertyName ];
			else 
				return undefined;
		}
		public function set (v : *) : void
		{
			if( propertyExist() )
				_target[ _propertyName ] = v;
		}
		
		public function get value () : * { return get(); }
		public function set value (v : *) : void { set( v ); }
		
		public function propertyExist() : Boolean 
		{
			return _target.hasOwnProperty( _propertyName );
		}
	}
}

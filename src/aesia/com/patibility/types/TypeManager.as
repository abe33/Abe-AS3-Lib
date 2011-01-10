package aesia.com.patibility.types 
{
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;
	/**
	 * @author cedric
	 */
	public class TypeManager 
	{
		static private var _types : Object = {};
		
		static public function registerType( type : Type ) : void
		{
			if( !hasType(type.type) )
				_types[type.type] = type;
			else 
				throw new ReferenceError( _$(_("The type $0 can't be registered since another type exist with the same name."), type ) );
		}
		
		static public function getType( type : String ) : Type { return hasType( type ) ? _types[ type ] : null; }
		static public function hasType( type : String ) : Boolean { return _types.hasOwnProperty( type ); }
	}
}

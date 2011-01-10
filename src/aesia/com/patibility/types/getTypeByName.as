package aesia.com.patibility.types
{
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;

	import flash.utils.getDefinitionByName;
	/**
	 * @author cedric
	 */
	public function getTypeByName ( name : String ) : * 
	{
		try
		{
			var cls : Class = getDefinitionByName( name ) as Class;
			if( cls )
				return cls;
			else 
				throw new TypeError(_$(_("The definition for '$0' isn't a Class."), name ));
		}
		catch( e : ReferenceError )
		{
			var type : Type = TypeManager.getType( name );
			if( type )
				return type;
			else 
				throw new TypeError( _$(_("There's no type registered with the name '$0'"), name ) );
		}
	}
}

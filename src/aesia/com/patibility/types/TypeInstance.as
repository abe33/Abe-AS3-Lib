package aesia.com.patibility.types 
{
	import aesia.com.mon.core.Copyable;
	import aesia.com.mon.core.Cloneable;
	import aesia.com.mon.utils.Reflection;
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;

	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	/**
	 * @author cedric
	 */
	dynamic public class TypeInstance extends Proxy implements Cloneable, Copyable
	{
		protected var _type : Type;
		protected var _id : String;
		protected var _data : Object;

		public function TypeInstance ( kwargs : Object = null ) 
		{
			if( !kwargs )
				throw new ReferenceError( _( "The kwargs argument of the TypeInstance constructor is mandatory" ) );
			else if( !kwargs.hasOwnProperty( "type" ))
				throw new ReferenceError( _( "The kwargs argument of the TypeInstance constructor require that a 'type' property is defined" ) );
			else
			{
				var typeName : String = kwargs["type"];
				
				_type = TypeManager.getType( typeName );
				_data = {};
				
				if(!_type)
					throw new TypeError( _$( _( "The type '$0' can't be found in the TypeManager" ), typeName ) );
				
				delete kwargs["type"];
				
				for( var i : String in kwargs )
				{
					if( hasOwnProperty( i ) )
					{
						if( _type.isValidValueForMember( i, kwargs[i] ) )
							_data[i] = kwargs[i];
						else
							throw new TypeError( _$( _( "The type $0 define its member '$1' with the type $2, got $3" ), _type, i, _type.getMemberType( i ), Reflection.getClassName( kwargs[i]) ) );
					}
					else
						throw new ReferenceError( _$( _( "The type $0 don't define a member named '$1'" ), _type, i ) );
				}
				
				for each( var n : String in _type.members )
					if( !_data.hasOwnProperty( n ) )
						_data[n] = null;
			}
		}
		public function get id () : String { return _id; }
		public function set id (id : String) : void { _id = id; }
		
		public function get type () : Type { return _type; }
		public function get data () : Object { return _data; }
		
		public function clone () : * { return new TypeInstance( toVo() ); }
		public function toString () : String { return _$( "[instance $0$1]", _type.type, _id ? "(id="+_id+")" : "" ); }		public function toVo () : Object 
		{ 
			var o : Object = { 'type':_type.type };
			for( var i : String in _data )
			{
				var r : * = _data[i];
				
				if( r is Object )
					o[i] = r.hasOwnProperty("toVo") ? r.toVo() : r;
				else
					o[i] = r;
			}
			
			return o; 
		}
		public function copyTo (o : Object) : void
		{
			for( var i : String in this )
				o[i] = this[i];
		}
		public function copyFrom (o : Object) : void
		{
			for( var i : String in o )
				this[i] = o[i];
		}
		
		override AS3 function hasOwnProperty ( name : * = undefined ) : Boolean { return _type.hasMember( name );  }
		override flash_proxy function hasProperty (name : *) : Boolean { return _type.hasMember( name ); }
		
		override flash_proxy function getProperty (name : *) : * { return hasOwnProperty( name ) ? _data[name] : undefined;	}
		override flash_proxy function setProperty (name : *, value : *) : void 
		{
			if( hasOwnProperty( name ) )
				if( _type.isValidValueForMember( name, value ) )
					_data[name] = value;
				else
					throw new TypeError( _$(_("The value '$0' don't match the type $1 for member '$2'."), value, _type.getMemberType(name), name ) );
		}
		override flash_proxy function nextNameIndex (index : int) : int 
		{
			if (index < _type.members.length) 
             	return index + 1;
         	else 
             	return 0;
		}
		override flash_proxy function nextName (index : int) : String { return _type.members[index - 1]; }
		override flash_proxy function nextValue (index : int) : * {	return _data[ _type.members[ index - 1 ] ]; }
		
	}
}

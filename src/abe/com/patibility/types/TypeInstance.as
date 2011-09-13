package abe.com.patibility.types 
{
    import abe.com.mon.core.Cloneable;
    import abe.com.mon.core.Copyable;
    import abe.com.mon.core.Equatable;
    import abe.com.mon.logs.Log;
    import abe.com.mon.utils.Reflection;
    import abe.com.mon.utils.magicClone;
    import abe.com.mon.utils.magicEquals;
    import abe.com.patibility.lang._;
    import abe.com.patibility.lang._$;

    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    import flash.utils.IExternalizable;
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;
	/**
	 * @author cedric
	 */
	dynamic public class TypeInstance extends Proxy implements Cloneable, Copyable, Equatable, IExternalizable
	{
		protected var _type : Type;
		protected var _id : String;
		protected var _data : Object;

		public function TypeInstance ( kwargs : Object = null ) 
		{
			if( kwargs )
			{
				if( !kwargs.hasOwnProperty( "type" ))
					throw new ReferenceError( _( "The kwargs argument of the TypeInstance constructor require that a 'type' property is defined" ) );
				else
				{
					var typeName : String = kwargs["type"];
					
					var type : Type = TypeManager.getType( typeName );
					var id : String;
					
					if(!type)
						throw new TypeError( _$( _( "The type '$0' can't be found in the TypeManager" ), typeName ) );
					
					delete kwargs["type"];
					
					if( kwargs.hasOwnProperty("id") )
					{
						id = kwargs["id"];
						delete kwargs["id"];
					}
					
					setupInstance( type, id, kwargs );
				}
			}
		}
		public function get id () : String { return _id; }
		public function set id (id : String) : void { _id = id != null ? id : ""; }
		
		public function get type () : Type { return _type; }
		
		public function get typeName () : String { return _type.type; }		public function set typeName ( type : String ) : void { _type = TypeManager.getType( type );}
		
		public function get data () : Object { return _data; }
		public function set data (data : Object) : void { _data = data; }
		
		protected function setupInstance( type : Type, id : String, data : Object ) : void
		{
			_type = type;
			_id = id;
			_data = {};
			
			for( var i : String in data )
			{
				if( hasOwnProperty( i ) )
				{
					if( _type.isValidValueForMember( i, data[i] ) )
						_data[i] = data[i];
					else
						//throw new TypeError( _$( _( "The type $0 define its member '$1' with the type $2, got $3" ), 						Log.error( _$( _( "The type $0 define its member '$1' with the type $2, got $3" ), 
											 _type, 
											 i, 
											 _type.getMemberType( i ), 
											 Reflection.getClassName( data[i] ) ) );
				}
				else
					//throw new ReferenceError( _$( _( "The type $0 don't define a member named '$1'" ), 					Log.error( _$( _( "The type $0 don't define a member named '$1'" ), 
													_type, i ) );
			}
			
			for each( var n : String in _type.members )
				if( !_data.hasOwnProperty( n ) )
					_data[n] = null;
			
		}
		public function writeExternal (output : IDataOutput) : void	
		{
			output.writeUTF( _id ? _id : "" );
			output.writeObject( _type );			output.writeObject( _data );
		}
		public function readExternal (input : IDataInput) : void 
		{
			_id = input.readUTF();
			
			var t : Type = input.readObject();
			
			_type = TypeManager.getType( t.type );
			_data = input.readObject();
		}
		
		public function clone () : * 
		{ 
			var o : Object = { 'type':typeName };
			
			for( var i : String in _data )
			{
				var r : * = _data[i];
				
				if( r )
					o[i] = magicClone(r);
				else
					o[i] = null;
			}
			var t : TypeInstance = new TypeInstance( o );
			t.id = id;
			return t;
		}
		
		public function toString () : String { return _$( "[instance $0$1]", typeName, _id ? "(id="+_id+")" : "" ); }		public function toVo () : Object 
		{ 
			var o : Object = { 'type':_type.type };
			for( var i : String in _data )
			{
				var r : * = _data[i];
				
				if( r is Array )
					o[i] = r.concat();
				else if( r is Object )
					o[i] = r.hasOwnProperty("toVo") ? r.toVo() : r;
				else
					o[i] = r;
			}
			return o; 
		}
		public function copyTo (o : Object) : void
		{
			for( var i : String in this )
				o[i] = this[i] is Array ? this[i].concat() : this[i];
		}
		public function copyFrom (o : Object) : void
		{
			for( var i : String in o )
				this[i] = o[i] is Array ? o[i].concat() : o[i];
		}
		public function equals (o : *) : Boolean
		{
			if( o is TypeInstance && o.typeName == typeName )
			{
				for( var i : String in this )
					if( !magicEquals( this[i], o[i] ) )
						return false;
				
				return true;
			}
			else return false;
		}
		
		override AS3 function hasOwnProperty ( name : * = undefined ) : Boolean { return _type.hasMember( name );  }
		override flash_proxy function hasProperty (name : *) : Boolean { return _type.hasMember( name ); }
		override flash_proxy function callProperty (name : *, ...args) : * 
		{ 
			if( _type.hasMember( name ) ) 
				return ( _data[name] as Function ).apply( this, args );
			else 
				return null; 
		}
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

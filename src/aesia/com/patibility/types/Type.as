package aesia.com.patibility.types 
{
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.StringUtils;
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;

	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	/**
	 * @author cedric
	 */
	public class Type implements IExternalizable
	{
		protected var _type : String;
		protected var _parentType : String;
		protected var _help : String;
				protected var _struct : Object;
		protected var _structDatas : Object;
				protected var _formStruct : Object;
		protected var _formStructDatas : Object;
		
		protected var _members : Array;
		
		private var _sealed : Boolean;

		public function Type ( kwargs : Object = null ) 
		{
			if( kwargs )
			{
				if( !kwargs.hasOwnProperty("type"))
					throw new ReferenceError(_("The kwargs argument of the Type constructor require that a 'type' property is defined"));
				else
				{
					var type : String;
					var help : String;
					var parentType : String;
					var struct : Object;				
					
					type = kwargs["type"];
					delete kwargs["type"];
					
					if( kwargs.hasOwnProperty( "help" ) )
					{
						help = kwargs["help"];
						delete kwargs["help"];
					}
					else help = "";
					
					if( kwargs.hasOwnProperty( "extends" ) )
					{
						parentType = kwargs["extends"];
						delete kwargs["extends"];
					}
					else parentType = "object";
						
					
					struct = kwargs;
					
					setupType(type, parentType, struct, struct, help );
				}
			}
		}
		public function get type () : String { return _type; }
		public function get parentType () : String { return _parentType; }
		public function get parentTypeInstance () : Type { return TypeManager.getType( _parentType ); }
		public function get struct () : Object { return _struct; }
		public function get structDatas () : Object { return _structDatas; }
		public function get members () : Array { return _members; }
		public function get help () : String { return _help; }
				public function get formStruct () : Object { return _formStruct; }
		public function set formStruct ( o : Object ) : void { _formStruct = o; }
		
		public function get formStructDatas () : Object	{ return _formStructDatas; }		public function set formStructDatas ( o : Object ) : void { _formStructDatas = o; }
		
		public function writeExternal (output : IDataOutput) : void
		{
			output.writeUTF( _type );			output.writeUTF( _parentType );			output.writeObject( _struct );			output.writeObject( _formStruct );
			Log.debug( _help );
			output.writeUTF( _help ? _help : "help" );
		}
		public function readExternal (input : IDataInput) : void
		{
			var type : String = input.readUTF();			var parentType : String = input.readUTF();			var struct : Object = input.readObject();			var formStruct : Object = input.readObject();
			var help : String = input.readUTF();
			
			setupType(type, parentType, struct, formStruct, help );
		}
		
		protected function setupType( name : String, parent : String, struct : Object, form : Object, help : String ) : void
		{
			_type = name;
			_parentType = parent;
			_struct = struct;
			_formStruct = form;
			_help = help;
			_structDatas = {};			_formStructDatas = {};
			_members = [];
				
			var i : String;
			var d : String;
			var v : String;
			var ind : int;
			
			for( i in _struct )
			{
				if( _members.indexOf( i ) != -1 )
					continue;
				
				v = _struct[i];
				ind = v.indexOf("<");
				
				if( ind != -1 )
				{
					d = v.substring( ind+1, StringUtils.findClosingIndex( v, ind+1, "<", ">") );
					v = v.substr(0, ind);					_structDatas[i] = d.replace(">", "").replace("<", "");
				}
				else
					_structDatas[i] = null;
				
				_struct[i] = v;
				_members.push(i);
			}
			
			for( i in _formStruct )
			{
				v = _formStruct[i];
				ind = v.indexOf("(");
				if( ind != -1 )
				{
					d = v.substring( ind+1, StringUtils.findClosingIndex( v, ind+1, "(", ")") );
					v = v.substr(0, ind);
					if( d.indexOf(",") != -1 )
						_formStructDatas[i] = d.split(",");
					else
						_formStructDatas[i] = [d];
				}
				else
					_formStructDatas[i] = null;
						
				_formStruct[i] = v;
			}
			_members.sort();				
			if( !TypeManager.hasType( type ) )
				TypeManager.registerType( this );
			
			_sealed = true;
		}
		public function create( kwargs : Object = null ) : TypeInstance	
		{ 
			if( kwargs )
			{
				if( kwargs.hasOwnProperty("type") )
					if( !delete kwargs["type"] )
						throw new ArgumentError(_("The kwargs argument of the Type.create method don't accept any property named 'type', moreover the 'type' property of the kwargs argument can't be deleted."));
				
				var o : Object = {'type':_type};
				for(var i : String in kwargs)
					o[i] = kwargs[i];
				
				return new TypeInstance( o );
			}
			else
				return new TypeInstance({'type':_type}); 
		}
		
		public function hasMember( member : String ) : Boolean { return _struct.hasOwnProperty( member ); }
		
		public function getMemberData (member : String) : * 
		{
			if( hasMember(member) )
				return _structDatas[member];
			else
				throw new ReferenceError(_$(_("The member '$0' don't exist in this type $1."), member, this ));
			
			return null;
		}
		public function getMemberType( member : String ) : *
		{
			if( hasMember( member ) )
				return getTypeByName( _struct[ member ] );
			else 
				throw new ReferenceError(_$(_("The member '$0' don't exist in this type $1."), member, this ));
			
			return null;
		}
		public function isValidValueForMember ( member : String, v : * ) : Boolean
		{
			if( hasMember( member ) )
			{
				if( v === null )
					return true;
				
				var type : * = getMemberType( member );
				var datas : * = getMemberData( member );
				
				var b : Boolean;
				var val : *;

				if( type is Class )
				{
					if( datas != null )
					{
						if( type == Array )
						{
							b = valueMatchType( v, type );
													
							if(!b)
								return b;
							
							var t : * = getTypeByName( datas );
							for each( val in v )
								b &&= valueMatchType( val, t );
							
							if(!b)
								throw new TypeError(_$(_("Value for the member '$0' should be an Array containing only elements of type $1, instead the value was [$2]"),
													member, t, v ) );
							else
								return b;
						}
						else
							return valueMatchType( v, type );
					}
					else
						return valueMatchType( v, type );
					
				}
				else if( type is Type )
					return valueMatchType( v, type );

				else throw new TypeError(_$(_("The type of the member '$0' in the type $1 must be either a Class object or a Type object : $2"), member, this, type ) );
				
			}
			else throw new ReferenceError(_$(_("The member '$0' don't exist in this type $1."), member, this ));
			
			return false;
		}
		public function valueMatchType ( v : *, t : * ) : Boolean
		{
			if( t is Class )
				return v is t;
			else if( t is Type )
			{
				if( v is TypeInstance )
					return (v as TypeInstance).type.isSubType( t );
				else
					return false;
			}
			else
				return false;
		}
		public function isSubType (type : Type ) : Boolean 
		{
			if( this == type )
				return true;
			else
			{
				var t : Type = parentTypeInstance;
				while( t )
				{
					if( t == type )
						return true;
					
					t = t.parentTypeInstance;
				}
			}
			return false;
		}
		public function toString() : String { return _$("[type $0]", _type ); }
		
	}
}

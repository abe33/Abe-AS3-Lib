package aesia.com.patibility.types 
{
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.StringUtils;
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;
	/**
	 * @author cedric
	 */
	public class Type 
	{
		protected var _type : String;
		protected var _parentType : String;
		
		protected var _struct : Object;
		protected var _membersAdditionnalDatas : Object;
		protected var _members : Array;
		
		protected var _help : String;
		
		public function Type ( kwargs : Object ) 
		{
			if( !kwargs )
				throw new ReferenceError(_("The kwargs argument of the Type constructor is mandatory"));
			else if( !kwargs.hasOwnProperty("type"))
				throw new ReferenceError(_("The kwargs argument of the Type constructor require that a 'type' property is defined"));
			else
			{
				_type = kwargs["type"];
				delete kwargs["type"];				
				if( kwargs.hasOwnProperty( "help" ) )
				{
					_help = kwargs["help"];
					delete kwargs["help"];
				}
				if( kwargs.hasOwnProperty( "extends" ) )
				{
					_parentType = kwargs["extends"];					delete kwargs["extends"];
				}
				
				_struct = {};
				_membersAdditionnalDatas = {};
				_members = [];
				
				for( var i : String in kwargs )
				{
					var d : String;
					var v : String = kwargs[i];
					var ind : int;
					
					if( ( ind = v.indexOf("(") ) != -1 )
					{
						d = v.substring( ind+1, StringUtils.findClosingIndex( v, ind+1, "(", ")") );
						v = v.substr(0, ind);
						
						if( d.indexOf(",") != -1 )
							_membersAdditionnalDatas[i] = d.split(",");
						else
							_membersAdditionnalDatas[i] = d;
					}
					else
						_membersAdditionnalDatas[i] = null;
					
					_struct[i] = v;
					_members.push(i);
				}
				_members.sort();
			}
		}
		
		public function get type () : String { return _type; }
		public function get parentType () : Type { return TypeManager.getType( _parentType ); }
		public function get struct () : Object { return _struct; }
		public function get members () : Array { return _members; }
		public function get membersAdditionnalDatas () : Object { return _membersAdditionnalDatas; }
		
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
				return _membersAdditionnalDatas[member];
			else
				throw new ReferenceError(_$(_("The member '$0' don't exist in this type $1."), member, this ));
			
			return null;
		}
		public function getMemberType( member : String ) : *
		{
			if( hasMember( member ) )
			{
				var t : String = _struct[ member ];
				return getTypeByName( t );
			}
			else throw new ReferenceError(_$(_("The member '$0' don't exist in this type $1."), member, this ));
			
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
						if( datas is Array )
						{
							b = false;
							for each( val in datas )
								b ||= v == val;
							
							if(!b)
								throw new ArgumentError(_$(_("The value '$0' for the member '$1' of the type $2 should be one of the following possible values : $3"),
															v, member, type, datas ) );
							else return true;
						}
						else
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
				var t : Type = parentType;
				while( t )
				{
					if( t == type )
						return true;
					
					t = t.parentType;
				}
			}
			return false;
		}
		public function toString() : String { return _$("[type $0]", _type ); }
		
	}
}

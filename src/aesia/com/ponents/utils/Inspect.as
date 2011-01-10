package aesia.com.ponents.utils 
{
	import aesia.com.mon.utils.Reflection;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.mon.utils.StringUtils;
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.core.Container;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	/**
	 * @author cedric
	 */
	public class Inspect 
	{
		static protected const PATH_RE : RegExp = /^[a-zA-Z0-9_\[\].]+$/;
		static public function isValidPath( path : String ) : Boolean
		{
			return PATH_RE.test(path);
		}
		static public function listDisplay( root : DisplayObjectContainer = null, 
											recursiveLevel : int = -1, 
											onlyComponents : Boolean = false ) : String
		{
			root = root ? root : StageUtils.root;
			return printChild( root, 
							   recursiveLevel, 
							   0, 
							   "", 
							   onlyComponents );
		}
		static public function locate( name : String, o : DisplayObjectContainer = null ) : DisplayObject
		{
			if( !o )
				o = StageUtils.root;

			var d : DisplayObject;
			var l : uint = o.numChildren;
			while(l--)
			{
				d = o.getChildAt(l);
				if( d.name == name )
					return d;
				else if( d.hasOwnProperty("id") && d["id"] == name )
					return d;
				else if( d is DisplayObjectContainer )
				{
					d = locate(name, d as DisplayObjectContainer );
					if( d )
						return d;
				}
			}			
			return null;
		}
		static public function pathTo ( o : DisplayObject ) : String
		{
			if( !o )
				return "";
			
			var s : String = o.name;
			var p : DisplayObjectContainer;
			var pe : Boolean;
			do
			{
				p = o.parent;
				pe = p != null;
				if( pe )
				{
					if( p == StageUtils.root )
						return "root." + s;
					
					s = p.name + "." + s;
					o = p;
				}
			}
			while( pe );

			return s;
		}
		static private function printChild( o : DisplayObjectContainer, 
											recursiveLevel : int = 0, 
											currentLevel : uint = 0, 
											indent : String = "", 
											onlyComponents : Boolean = false ) : String
		{
			var s : String;
			var i : uint;
			var l : uint;
			var char : String;
			var indAdd : String;
			var inner : String;
			if( !( onlyComponents && o is Component ) )
			{
				l = o.numChildren;
				s = getDisplay(o);
				for( i = 0 ; i < l ; i++ )
				{
					// ├│└
					var c : DisplayObject = o.getChildAt(i);
					char = i == l-1 ? "└─■" : "├─■";
					indAdd = i == l-1 ? "  " : "│ ";
					inner = recursiveLevel == 0 || 
										( recursiveLevel != -1 && 
										  currentLevel < recursiveLevel ) ? 
											c is DisplayObjectContainer ? 
												printChild( c as DisplayObjectContainer, 
															recursiveLevel, 
															currentLevel+1, 
															indent + indAdd, 
															onlyComponents ) : 
												getDisplay(c) :
											getDisplay(c);
					s += _$("\n$0$1$2$3", indent, char , "["+i+"]", inner );
				}
			}
			else
			{
				s = getDisplay(o);
				
				if( o is Container )
				{
					var ct : Container = (o as Container);
					
					/*FDT_IGNORE*/
					TARGET::FLASH_9 { var children : Array = ct.children; }
					TARGET::FLASH_10 { var children : Vector.<Component> = ct.children; }
					TARGET::FLASH_10_1 { /*FDT_IGNORE*/
					var children : Vector.<Component> = ct.children; /*FDT_IGNORE*/ } /*FDT_IGNORE*/
					
					l = children.length;
					for( i = 0 ; i < l ; i++ )
					{
						var cp : Component = children[i];
						char = i == l-1 ? "└─■" : "├─■";
						indAdd = i == l-1 ? "  " : "│ ";
						inner = recursiveLevel == 0 || 
											( recursiveLevel != -1 && 
											  currentLevel < recursiveLevel ) ? 
												( onlyComponents ? cp is Container : cp is DisplayObjectContainer ) ? 
													printChild( cp as DisplayObjectContainer, 
																recursiveLevel, currentLevel+1, 
																indent + indAdd, 
																onlyComponents ) : 
													getDisplay(cp) :
												getDisplay(cp);
						s += _$("\n$0$1$2$3", indent, char , "["+i+"]", inner );
					}
				}
			}
			return s;
		}
		protected static function getDisplay ( o : Object) : String 
		{
			var s : String = StringUtils.stringify( o );
			switch( true )
			{
				case o is Container : 
					return _$("<font color='#333388'>$0</font>",s);				case o is Component : 
					return _$("<font color='#883388'>$0</font>",s);
				case o is DisplayObjectContainer : 
					return _$("<font color='#008800'>$0</font>",s);
				case !(o is InteractiveObject ):
					return _$("<font color='#666666'>$0</font>",s);
				default : 
					return s;
			}
		}
		static public function resolvePath( path : String, root : DisplayObjectContainer = null ) : DisplayObject
		{
			var p : Array = path.split(/[\[\].]+/g);
			root = root ? root : StageUtils.root;
			var r : DisplayObjectContainer = root;
			var o : DisplayObject;
			var l : uint = p.length;
			var s : String;
			for( var i:uint=0 ; i<l ; i++ )
			{
				s = StringUtils.trim(p[i]);
				if(s.length == 0)
					continue;
				if( i == 0 )
				{
					switch( s )
					{
						case "root":
							o = r = StageUtils.root;
							break;
						case "stage" : 
							o = r = StageUtils.stage;
							break;
						default : 
							o = r.getChildByName(s);
							if( o is DisplayObjectContainer )
								r = o as DisplayObjectContainer;
							break;
					}
				}
				else
				{
					if( (/^\d+$/g).test(s) )
					{
						o = r.getChildAt( parseInt(s) );
						if( o is DisplayObjectContainer )
							r = o as DisplayObjectContainer;
					}
					else
					{
						o = r.getChildByName(s);
						if( o is DisplayObjectContainer )
							r = o as DisplayObjectContainer;
					}
				}
				if( o == null )
					throw new Error(_$(_("Can't find the child named '$0' from '$1' in resolvePath('$2',$3)."), 
											s, r, path, root ));
			}
			return o;
		}
		static public function inspect( o : * ):String
		{
			if( typeof o != "object" )
			{
				if( o is String )
					return "'"+escape(o)+"'";
				else
					return String( o );
			}
			else
			{
				var s : String = "";
				var s2 : String = "";
				var i:String;
				if( o is Array )
				{
					s = "[";
					s2 = "";
					for( i in o )
						s2 += "  " + StringUtils.stringify(o[i]) + ",\n";

					if( s2 != "" )
						s += "\n" + s2;
					s += "]";
					return s;
				}
				else
				{
					s ="";
					if( Reflection.getClass(o)!= Object )
					{
						s += StringUtils.stringify(o);
						o = Reflection.asAnonymousObject(o);
					}
					s += "{";
					s2 = "";
					for( i in o )
					{
						s2 += "  '" + escape(i) + "' : " + StringUtils.stringify(o[i]) + ",\n";
					}
					if( s2 != "" )
						s += "\n"+s2;
					s += "}";
					return s;
				}
			}
		}
	}
}

package abe.com.ponents.tools 
{

	import abe.com.ponents.tools.canvas.Tool;
	/**
	 * @author cedric
	 */
	public class ToolsList 
	{
		static protected var _toolsList : Object = {};
		
		static public function registerTool ( name : String, tool : Tool ) : void
		{
			_toolsList[name] = tool;
		}
		static public function containsToolKey ( name : String ) : Boolean
		{
			return _toolsList.hasOwnProperty( name );
		}
		static public function containsTool ( tool : Tool ) : Boolean
		{
			return getToolKey(tool) != null;
		}
		static public function getToolKey( tool : Tool ):String
		{
			for(var i:String in _toolsList)
				if( _toolsList[i]==tool )
					return i;
					
			return null;
		}
		static public function getTool( name : String ) : Tool
		{
			if( ToolsList.containsToolKey(name) )
				return _toolsList[name];
				
			return null;
		}

		static public function unregisterTool( t : * ) : void
		{
			if( t is String )
			{
				if( containsToolKey( t ) )
					delete _toolsList[t];
			}
			else if( t is Tool )
			{
				if( containsTool(t) )
					delete _toolsList[getToolKey(t)];
			}
		}
	}
}

/**
 * @license
 */
package  abe.com.munication.host 
{
	import flash.external.ExternalInterface;

	public class HTMLSniffer 
	{
		static protected const HEADER_SOLE_NODES : Array = ["link","style","meta"];		static protected const BODY_SOLE_NODES : Array = ["br","img","embed","object","input"];
		
		static public function getElementById ( id : String ) : XML
		{
			if( ExternalInterface.available )
			{
				var v : String = ExternalInterface.call( "_getElementById", id ) as String;
				v = closeHTMLTags( v, HEADER_SOLE_NODES.concat( BODY_SOLE_NODES ) );
								
				return new XML( v );
			}
			return null;
		}
		
		static public function getHead () : XML
		{
			if( ExternalInterface.available )
			{
				var a : Array = ExternalInterface.call( "_getElementsByTagName", "head" ) as Array;
				
				// on ferme les balises <link> et <meta> non fermées 
				// firefox les fournies comme ça meme si elles étaient bien formées a la base
				var s : String  = a.join("");
				s = closeHTMLTags( s, HEADER_SOLE_NODES );
								
				return new XML( "<head>" + s + "</head>"  );
			}
			return null;
		}
		
		static public function getBody () : XML
		{
			if( ExternalInterface.available )
			{
				var a : Array = ExternalInterface.call( "_getElementsByTagName", "body" ) as Array;
				
				var s : String = a.join("");
				s = closeHTMLTags( s, BODY_SOLE_NODES );
				
				return new XML( "<body>" + s + "</body>"  );
			}
			return null;
		}
		
		static private function closeHTMLTags ( s : String, tags : Array ) : String
		{
			// var reg : RegExp = new RegExp ( "<([A-Z][A-Z0-9]*)\b[^>]*>(.*?)</\1>", "gi" );
			for( var i : String in tags )
			{
				s = s.replace( new RegExp( "<"+ tags[i] +"([^>]*)>", "gi" ), "<"+ tags[i] +"$1/>");
			}
			return s;
		}
	}
}

/**
 * @license
 */
package abe.com.edia.text.builds 
{
	import abe.com.edia.text.core.Char;

	import flash.text.TextFormat;
	/**
	 * @author Cédric Néhémie
	 */
	public class StyleContext 
	{
		static private const FORMAT_PROPERTIES : Array = [ "font", "size","color","bold","italic","underline","letterSpacing" ];
		
		public var format : TextFormat;
		public var chars : Vector.<Char>;
		public var subContexts : Vector.<StyleContext>;

		public function StyleContext () 
		{
			chars = new Vector.<Char>( );
			subContexts = new Vector.<StyleContext>( );
		}

		public function applyStyle( tf : TextFormat = null ) : void
		{
			var f : TextFormat = new TextFormat();
			
			//Log.debug( this + " has " + chars.length + " chars" );
			
			for(var i : String in FORMAT_PROPERTIES )
			{
				var p : String = FORMAT_PROPERTIES[i];
				
				//Log.debug( p + " : " + format[ p ] );
				
				if( tf && tf[ p ] != null && format[ p ] == null )
					f[ p ] = tf[ p ];
				else if ( format[ p ] != null )
					f[ p ] = format[ p ];
			}
			for each( var c : Char in chars )
				c.format = f;
			
			for each( var sc : StyleContext in subContexts )
				sc.applyStyle( f );
		}
	
	}
}

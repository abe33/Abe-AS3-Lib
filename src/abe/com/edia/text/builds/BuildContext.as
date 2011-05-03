/**
 * @license
 */
package abe.com.edia.text.builds 
{
	import abe.com.edia.text.core.Char;
	import abe.com.edia.text.core.TextFieldChar;
	import abe.com.edia.text.fx.CharEffect;
	import abe.com.mon.logs.Log;

	import flash.display.DisplayObject;
	public class BuildContext
	{
		//public var format : TextFormat;
		public var build : BasicBuild;
		public var char : Char;
		public var effects : Vector.<CharEffect>;
		public var filters : Array;
		public var link : String;
		public var align : String;		public var embedFonts : Boolean;		public var cacheAsBitmap : Boolean;
		public var backgroundColor : Number;
		public var i : int;
		
		public function BuildContext ()
		{
			effects = new Vector.<CharEffect> ();
			filters = new Array();
			align = "left";
			i = 0;
		}	
		public function notAChar() : void
		{
			i--;
		}
		public function setChar( char : Char ) : void
		{
			if( build.chars.indexOf( this.char ) == i )
				build.checkCharRelease ( this.char );
			
			this.char = char;
			if( char is DisplayObject )
			{
				build.created[i] = char;
				char.filters = filters;				
				if( !isNaN(backgroundColor) )
					build.owner.backgroundChars[ char ] = backgroundColor;

				for each ( var q : CharEffect in effects )
					q.addChar( char );	
				
				if( char is TextFieldChar )
					build.setDefaults( char as TextFieldChar, this );
			}		
			build.setChar(i, char);
				
		}
		public function appendChar( char : Char ) : void
		{
			i++;
			setChar(char);
		}
	}
}

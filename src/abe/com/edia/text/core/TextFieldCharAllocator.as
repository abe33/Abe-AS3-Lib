/**
 * @license
 */
package abe.com.edia.text.core 
{
	public class TextFieldCharAllocator
	{
		private var unusedChars : Vector.<TextFieldChar>;
		private var usedChars : Vector.<TextFieldChar>;
		
		public function TextFieldCharAllocator ()
		{
			unusedChars = new Vector.<TextFieldChar> ();
			usedChars = new Vector.<TextFieldChar> ();
		}
		public function getChar () : TextFieldChar
		{
			var l : TextFieldChar;
			if ( unusedChars.length != 0 )
			{
				l = unusedChars.pop();			
			}
			else
			{
				l = new TextFieldChar();
			}
			usedChars.push(l);
			
			return l;
		}
		public function releaseChar ( l : TextFieldChar ) : void
		{
			usedChars.splice( usedChars.indexOf( l ), 1 );
			unusedChars.push( l );
		}
	}
}

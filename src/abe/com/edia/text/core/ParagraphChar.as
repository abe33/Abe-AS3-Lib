/**
 * @license
 */
package abe.com.edia.text.core 
{

	/**
	 * @author Cédric Néhémie
	 */
	public class ParagraphChar extends NewLineChar 
	{
		public var align : String;
		
		public function ParagraphChar ( align : String = "left" )
		{
			this.align = align;
		}

		override public function toString () : String
		{
			return "";
		}
	}
}

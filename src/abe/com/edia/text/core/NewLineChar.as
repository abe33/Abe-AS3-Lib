/**
 * @license
 */
package abe.com.edia.text.core 
{

	/**
	 * @author Cédric Néhémie
	 */
	public class NewLineChar extends NullChar 
	{
		static public const DEFAULT_LINE_HEIGHT : Number = 16;
		
		public var ignoredAfterParagraph : Boolean;
		public var lineHeight : Number;

		public function NewLineChar ( ignoredAfterParagraph : Boolean = false, lineHeight : Number = DEFAULT_LINE_HEIGHT ) 
		{
			this.ignoredAfterParagraph = ignoredAfterParagraph;
			this.lineHeight = lineHeight;
		}
		override public function get text () : String {	return "\n"; }
	}
}

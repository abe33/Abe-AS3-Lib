/**
 * @license
 */
package abe.com.edia.text.core 
{
    import abe.com.mon.utils.StringUtils;
	/**
	 * @author Cédric Néhémie
	 */
	public class ParagraphChar extends NewLineChar 
	{
		public var align : String;
		
		public function ParagraphChar ( align : String = "left" )
		{
			super( true );
			this.align = align;
		}
		override public function get text () : String { return StringUtils.tokenReplace( "\n", align ); }
	}
}

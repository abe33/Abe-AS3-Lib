package abe.com.edia.text.core 
{
	/**
	 * @author cedric
	 */
	public class NonBreakingSpaceChar extends TextFieldChar 
	{
		override public function get text () : String {	return "&nbsp;"; }
	}
}

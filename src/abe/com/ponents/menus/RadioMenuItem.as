package abe.com.ponents.menus 
{
	import abe.com.ponents.core.*;
	import abe.com.ponents.skinning.icons.RadioCheckedIcon;
	import abe.com.ponents.skinning.icons.RadioUncheckedIcon;


	/**
	 * @author Cédric Néhémie
	 */
	
	[Skinable(skin="RadioMenuItem")]
	[Skin(define="RadioMenuItem",
		  inherit="MenuItem",
		  
		  custom_checkedIcon="icon(abe.com.ponents.skinning.icons::RadioCheckedIcon)",
		  custom_uncheckedIcon="icon(abe.com.ponents.skinning.icons::RadioUncheckedIcon)"
	)]
	public class RadioMenuItem extends CheckBoxMenuItem 
	{
		static private const DEPENDENCIES : Array = [ RadioCheckedIcon, RadioUncheckedIcon ];
		
		public function RadioMenuItem (label : String, checked : Boolean = false)
		{
			super( label, checked );
		}
		
		override public function click ( context : UserActionContext ) : void
		{
			swapSelect(true);
		}
	}
}

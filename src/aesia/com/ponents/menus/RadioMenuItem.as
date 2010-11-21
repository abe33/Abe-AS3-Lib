package aesia.com.ponents.menus 
{
	import aesia.com.ponents.skinning.icons.RadioCheckedIcon;
	import aesia.com.ponents.skinning.icons.RadioUncheckedIcon;

	import flash.events.Event;

	/**
	 * @author Cédric Néhémie
	 */
	
	[Skinable(skin="RadioMenuItem")]
	[Skin(define="RadioMenuItem",
		  inherit="MenuItem",
		  
		  custom_checkedIcon="icon(aesia.com.ponents.skinning.icons::RadioCheckedIcon)",
		  custom_uncheckedIcon="icon(aesia.com.ponents.skinning.icons::RadioUncheckedIcon)"
	)]
	public class RadioMenuItem extends CheckBoxMenuItem 
	{
		static private const DEPENDENCIES : Array = [ RadioCheckedIcon, RadioUncheckedIcon ];
		
		public function RadioMenuItem (label : String, checked : Boolean = false)
		{
			super( label, checked );
		}
		
		override public function click (e : Event = null) : void
		{
			swapSelect(true);
		}
	}
}

package abe.com.ponents.menus 
{
	import abe.com.ponents.skinning.decorations.SeparatorDecoration;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="MenuSeparator")]
	[Skin(define="MenuSeparator",
		  inherit="MenuItem",
		  state__all__background="new deco::SeparatorDecoration(skin.lightColor,skin.shadowColor,0)"
	)]
	public class MenuSeparator extends MenuItem 
	{
		static private const SKIN_DEPENDENCIES : Array = [SeparatorDecoration];
		public function MenuSeparator ()
		{
			super();
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			allowDrag = false;
			gesture = null;				
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			allowSelected = false;
			_enabled = false;
			label = "";
		}

		override public function set enabled (b : Boolean) : void
		{
		}

		override public function get columnsSizes () : Array { return [0,0,0,0]; }
		override public function set columnsSizes (a : Array) : void {}
	}
}

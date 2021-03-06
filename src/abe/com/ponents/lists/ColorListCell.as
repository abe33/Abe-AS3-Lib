package abe.com.ponents.lists 
{
	import abe.com.mon.colors.Color;
	import abe.com.ponents.layouts.display.DOInlineLayout;
	import abe.com.ponents.skinning.icons.ColorIcon;
	import abe.com.ponents.utils.Directions;

	/**
	 * @author cedric
	 */
	[Skinable(skin="ColorListCell")]
	[Skin(define="ColorListCell",
			  inherit="ListCell",
			  preview="abe.com.ponents.lists::ColorListCell.defaultColorListCellPreview",
		   	  previewAcceptStyleSetup="false",
		   
			  state__all__insets="new cutils::Insets(2)"
	)]
	public class ColorListCell extends DefaultListCell
	{
		
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		static public function defaultColorListCellPreview () : List
		{
			var l : List = new List( Color.YellowGreen, Color.OliveDrab, Color.Olive );
			l.listCellClass = ColorListCell;
			l.selectedIndex = 1;
			
			return l;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		public function ColorListCell ()
		{
			super();
			//buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			icon = new ColorIcon( Color.Black );
			icon.width = 40;
			icon.height = 18;
			
			( childrenLayout as DOInlineLayout ).direction = Directions.RIGHT_TO_LEFT;
		}

		override public function set value (val : *) : void
		{
			super.value = val;
			( icon as ColorIcon ).color = val;
		}

		override protected function formatLabel (value : *) : String
		{
			var c : Color = value as Color;
			return _owner && _owner.hasFormatingFunction ? _owner.itemFormatingFunction.call( _owner, value ) : 
				( c.name != "" ? c.name + " (0x" + c.rgba + ")" : "(0x" + c.rgba + ")" );
		}
	}
}

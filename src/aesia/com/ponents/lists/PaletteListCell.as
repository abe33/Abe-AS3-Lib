package aesia.com.ponents.lists 
{
	import aesia.com.mon.utils.Color;
	import aesia.com.mon.utils.Palette;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.layouts.display.DOInlineLayout;
	import aesia.com.ponents.skinning.icons.PaletteIcon;
	import aesia.com.ponents.utils.Directions;

	/**
	 * @author cedric
	 */
	[Skinable(skin="PaletteListCell")]
	[Skin(define="PaletteListCell",
			  inherit="ListCell",
			  preview="aesia.com.ponents.lists::PaletteListCell.defaultPaletteListCellPreview",
		   	  previewAcceptStyleSetup="false",
		   	  
			  state__all__insets="new aesia.com.ponents.utils::Insets(2)"
	)]
	public class PaletteListCell extends DefaultListCell
	{
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		static public function defaultPaletteListCellPreview () : List
		{
			var l : List = new List( Color.PALETTE_SVG, new Palette( _("A custom palette") , Color.YellowGreen , Color.OliveDrab , Color.OliveDrab ) );
			l.listCellClass = PaletteListCell;
			l.selectedIndex = 1;
			
			return l;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		public function PaletteListCell ()
		{
			super();
			//buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			icon = new PaletteIcon( new Palette(_("Unnamed Palette"), Color.Black ) );
			( childrenLayout as DOInlineLayout ).direction = Directions.RIGHT_TO_LEFT;
		}

		override public function set value (val : *) : void
		{
			super.value = val;
			( icon as PaletteIcon ).palette = val;
		}

		override protected function formatLabel (value : *) : String
		{
			return _owner && _owner.hasFormatingFunction ? _owner.itemFormatingFunction.call( _owner, value ) : (_value as Palette).name;
		}

		override protected function valueChanged (old : *, nevv : *, id : Number) : void
		{
			(_value as Palette).name = nevv;
		}
	}
}

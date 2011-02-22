package abe.com.ponents.lists 
{
	import abe.com.mon.utils.Color;
	import abe.com.mon.utils.Gradient;
	import abe.com.patibility.lang._;
	import abe.com.ponents.layouts.display.DOInlineLayout;
	import abe.com.ponents.skinning.icons.GradientIcon;
	import abe.com.ponents.utils.Directions;

	/**
	 * @author cedric
	 */
	[Skinable(skin="GradientListCell")]
	[Skin(define="GradientListCell",
			  inherit="ListCell",
			  preview="abe.com.ponents.lists::GradientListCell.defaultGradientListCellPreview",
		   	  previewAcceptStyleSetup="false",
		   	  
			  state__all__insets="new cutils::Insets(2)"
	)]
	public class GradientListCell extends DefaultListCell
	{
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		static public function defaultGradientListCellPreview () : List
		{
			var l : List = new List( new Gradient( [ Color.Black, Color.White ], [0,1], _("Black And White" )),
									 new Gradient( [ Color.Red, Color.Orange, Color.Yellow ], [0,.5,1], _("Fire"))	 );
			l.listCellClass = GradientListCell;
			l.selectedIndex = 1;
			
			return l;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		public function GradientListCell ()
		{
			super();
			//buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			icon = new GradientIcon( new Gradient([Color.Black,Color.White], [0,1]) );
			icon.width = 40;
			icon.height = 18;
			
			( childrenLayout as DOInlineLayout ).direction = Directions.RIGHT_TO_LEFT;
		}
		override public function set value (val : *) : void
		{
			super.value = val;
			( icon as GradientIcon ).gradient = val;
		}
		override protected function formatLabel (value : *) : String
		{
			return _owner && _owner.hasFormatingFunction ? _owner.itemFormatingFunction.call( _owner, value ) : (_value as Gradient).name;
		}
		override protected function valueChanged (old : *, nevv : *, id : Number) : void
		{
			(_value as Gradient).name = nevv;
		}
	}
}

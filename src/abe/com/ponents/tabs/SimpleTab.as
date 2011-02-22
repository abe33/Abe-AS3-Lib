package abe.com.ponents.tabs
{
	import abe.com.ponents.buttons.DraggableButton;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.layouts.display.DOInlineLayout;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.transfer.Transferable;
	import abe.com.ponents.utils.Alignments;
	import abe.com.ponents.utils.CardinalPoints;
	import abe.com.ponents.utils.Directions;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="Tab")]
	[Skin(define="Tab_North",
		  inherit="Tab",
		  preview="abe.com.ponents.tabs::TabbedPane.northTabbedPanePreview",
		  previewAcceptStyleSetup="false",

		  state__all__borders="new cutils::Borders(1,1,1,0)",
		  state__all__corners="new cutils::Corners(6,6,0,0)"
	)]
	[Skin(define="Tab_South",
		  inherit="Tab",
		  preview="abe.com.ponents.tabs::TabbedPane.southTabbedPanePreview",
		  previewAcceptStyleSetup="false",

		  state__all__borders="new cutils::Borders(1,0,1,1)",
		  state__all__corners="new cutils::Corners(0,0,6,6)"
	)]
	[Skin(define="Tab_East",
		  inherit="Tab",
		  preview="abe.com.ponents.tabs::TabbedPane.eastTabbedPanePreview",
		  previewAcceptStyleSetup="false",

		  state__all__borders="new cutils::Borders(0,1,1,1)",
		  state__all__corners="new cutils::Corners(0,6,0,6)"
	)]
	[Skin(define="Tab_West",
		  inherit="Tab",
		  preview="abe.com.ponents.tabs::TabbedPane.westTabbedPanePreview",
		  previewAcceptStyleSetup="false",

		  state__all__borders="new cutils::Borders(1,1,0,1)",
		  state__all__corners="new cutils::Corners(6,0,6,0)"
	)]
	[Skin(define="Tab",
		  inherit="DefaultGradientComponent",
		  preview="abe.com.ponents.tabs::TabbedPane.defaultTabbedPanePreview",
		  previewAcceptStyleSetup="false",

		  state__all__insets="new cutils::Insets(4)"
	)]
	public class SimpleTab extends DraggableButton implements Tab
	{
		protected var _content : Component;
		protected var _placement : String;
		protected var _parentTabbedPane : TabbedPane;
		protected var _styleNamePrefix : String = "Tab";

		public function SimpleTab ( name : String, content : Component = null, icon : Icon = null )
		{
			super();

			this.label = name;
			this.icon = icon;

			_content = content;
		}

		public function get content () : Component { return _content; }
		public function set content (content : Component) : void
		{
			_content = content;
		}

		public function get parentTabbedPane () : TabbedPane { return _parentTabbedPane; }
		public function set parentTabbedPane (parentTabbedPane : TabbedPane) : void
		{
			_parentTabbedPane = parentTabbedPane;
		}

		public function get styleNamePrefix () : String { return _styleNamePrefix; }
		public function set styleNamePrefix (styleNamePrefix : String) : void
		{
			_styleNamePrefix = styleNamePrefix;
			placement = placement;
		}

		public function get placement () : String { return _placement; }
		public function set placement (placement : String) : void
		{
			_placement = placement;
			var ilayout : DOInlineLayout = childrenLayout as DOInlineLayout;
			switch( _placement )
			{
				case CardinalPoints.NORTH :
					styleKey = _styleNamePrefix + "_North";
					ilayout.horizontalAlign = Alignments.CENTER;
					ilayout.direction = Directions.RIGHT_TO_LEFT;					break;
				case CardinalPoints.SOUTH :
					styleKey = _styleNamePrefix + "_South";
					ilayout.horizontalAlign = Alignments.CENTER;
					ilayout.direction = Directions.RIGHT_TO_LEFT;
					break;
				case CardinalPoints.EAST :
					styleKey = _styleNamePrefix + "_East";
					ilayout.horizontalAlign = Alignments.LEFT;
					ilayout.direction = Directions.LEFT_TO_RIGHT;
					break;
				case CardinalPoints.WEST :
					styleKey = _styleNamePrefix + "_West";
					ilayout.horizontalAlign = Alignments.RIGHT;					ilayout.direction = Directions.RIGHT_TO_LEFT;
					break;
			}
		}
		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		override public function get allowDrag () : Boolean { return super.allowDrag && _enabled; }
		override public function get transferData () : Transferable
		{
			return new TabTransferable( this, _parentTabbedPane );
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}

package aesia.com.ponents.tabs 
{
	import aesia.com.mon.geom.dm;
	import aesia.com.mon.logs.Log;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.actions.ProxyAction;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.buttons.ButtonDisplayModes;
	import aesia.com.ponents.containers.DraggablePanel;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.dnd.DragSource;
	import aesia.com.ponents.events.ActionEvent;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.events.PropertyEvent;
	import aesia.com.ponents.layouts.components.BoxSettings;
	import aesia.com.ponents.layouts.components.HBoxLayout;
	import aesia.com.ponents.layouts.display.DOInlineLayout;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.transfer.Transferable;
	import aesia.com.ponents.utils.Alignments;
	import aesia.com.ponents.utils.CardinalPoints;
	import aesia.com.ponents.utils.Directions;

	import flash.events.Event;

	/**
	 * @author Cédric Néhémie
	 */
	[Style(name="closeIcon", type="aesia.com.ponents.skinning.icons.Icon")]
	[Skinable(skin="ClosableTab")]
	[Skin(define="ClosableTab_North",
		  inherit="Tab_North",
		  preview="aesia.com.ponents.tabs::ClosableTab.northTabbedPanePreview",
		  previewAcceptStyleSetup="false",
		  
		  state__all__borders="new cutils::Borders(1,1,1,0)",
		  state__all__corners="new cutils::Corners(6,6,0,0)"
	)]
	[Skin(define="ClosableTab_South",
		  inherit="Tab_South",
		  preview="aesia.com.ponents.tabs::ClosableTab.southTabbedPanePreview",
		  previewAcceptStyleSetup="false",
		  
		  state__all__borders="new cutils::Borders(1,0,1,1)",
		  state__all__corners="new cutils::Corners(0,0,6,6)"
	)]
	[Skin(define="ClosableTab_East",
		  inherit="Tab_East",
		  preview="aesia.com.ponents.tabs::ClosableTab.eastTabbedPanePreview",
		  previewAcceptStyleSetup="false",
		  
		  state__all__borders="new cutils::Borders(0,1,1,1)",
		  state__all__corners="new cutils::Corners(0,6,0,6)"
	)]
	[Skin(define="ClosableTab_West",
		  inherit="Tab_West",
		  preview="aesia.com.ponents.tabs::ClosableTab.westTabbedPanePreview",
		  previewAcceptStyleSetup="false",
		  
		  state__all__borders="new cutils::Borders(1,1,0,1)",
		  state__all__corners="new cutils::Corners(6,0,6,0)"
	)]
	[Skin(define="ClosableTab",
		  inherit="DefaultGradientComponent",
		  preview="aesia.com.ponents.tabs::ClosableTab.defaultTabbedPanePreview",
		  previewAcceptStyleSetup="false",
		  
		  state__all__insets="new cutils::Insets(4)",
		 
		  custom_closeIcon="icon(aesia.com.ponents.tabs::ClosableTab.CROSS)"
	)]
	[Skin(define="ClosableTab_CloseButton",
		  inherit="DefaultComponent",
		  
		  state__0_1_4_5_8_9_12_13__background="skin.emptyDecoration",		  state__0_1_4_5_8_9_12_13__foreground="skin.noDecoration",
		  state__all__corners="new cutils::Corners(4)",		  state__all__insets="new cutils::Insets(0)"
	)]
	public class ClosableTab extends DraggablePanel implements Tab, DragSource
	{
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		static public function defaultTabbedPanePreview () : TabbedPane
		{
			var tp : TabbedPane = new TabbedPane();
			tp.addTab( new ClosableTab("Tab 1", new Panel() ) ); 		
			tp.addTab( new ClosableTab("Tab 2", new Panel() ) ); 
			tp.preferredSize = dm(100,100);
			return tp;		
		}
		static public function northTabbedPanePreview () : TabbedPane
		{
			var tp : TabbedPane = defaultTabbedPanePreview();
			tp.tabsPosition = CardinalPoints.NORTH;
			return tp;		
		}
		static public function southTabbedPanePreview () : TabbedPane
		{
			var tp : TabbedPane = defaultTabbedPanePreview();
			tp.tabsPosition = CardinalPoints.SOUTH;
			return tp;		
		}
		static public function eastTabbedPanePreview () : TabbedPane
		{
			var tp : TabbedPane = defaultTabbedPanePreview();
			tp.tabsPosition = CardinalPoints.EAST;
			return tp;		
		}
		static public function westTabbedPanePreview () : TabbedPane
		{
			var tp : TabbedPane = defaultTabbedPanePreview();
			tp.tabsPosition = CardinalPoints.WEST;
			return tp;		
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		[Embed(source="../skinning/icons/control_close_blue.png")]
		static public var CROSS : Class;	
		
		protected var _closeButton : Button;		protected var _mainButton : Button;
		protected var _content : Component;
		protected var _placement : String;
		protected var _parentTabbedPane : TabbedPane;
		
		public function ClosableTab ( name : String, content : Component = null, icon : Icon = null )
		{
			super();
			_allowOver = true;			_allowPressed = true;
			
			var layout : HBoxLayout = new HBoxLayout( this, 3, 
							new BoxSettings(0), 
							new BoxSettings(0, "right", "center", null, false, false, true ) );
			_childrenLayout = layout;
			_content = content;
			
			_mainButton = new Button( new AbstractAction( name ) );
			_mainButton.mouseEnabled = false;
			_mainButton.styleKey = "EmptyComponent";
			_mainButton.isComponentIndependent = false;
			
			if( icon )
				_mainButton.icon = icon;
			
			_closeButton =  new Button( new ProxyAction( onClose, _("Close this tab"), _style.closeIcon.clone() ) );
			_closeButton.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			_closeButton.styleKey = "ClosableTab_CloseButton";
			_closeButton.isComponentIndependent = false;
			
			layout.setObjectForBox( _mainButton, 0 );			layout.setObjectForBox( _closeButton, 1 );
			
			addComponent( _mainButton );			addComponent( _closeButton );
		}
		protected function onClose () : void 
		{
			fireComponentEvent( ComponentEvent.CLOSE );
		}
		public function get buttonDisplayMode () : uint { return _mainButton.buttonDisplayMode; }
		public function set buttonDisplayMode (m : uint) : void
		{
			_mainButton.buttonDisplayMode = m;
			_size = null;
			invalidatePreferredSizeCache();
		}
		public function get label () : * { return _mainButton.label;}
		public function set label (s : *) : void
		{
			_mainButton.label = s;
		}
		public function get icon () : Icon { return _mainButton.icon; }
		public function set icon (icon : Icon) : void
		{
			_mainButton.icon = icon;
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
		
		public function get placement () : String { return _placement; }		
		public function set placement (placement : String) : void
		{
			_placement = placement;
			var ilayout : DOInlineLayout = _mainButton.childrenLayout as DOInlineLayout;
			var layout : HBoxLayout = childrenLayout as HBoxLayout;
			switch( _placement )
			{
				case CardinalPoints.NORTH : 
					styleKey = "ClosableTab_North";
					ilayout.horizontalAlign = Alignments.CENTER;
					ilayout.direction = Directions.RIGHT_TO_LEFT;
					
					layout.setObjectForBox( _mainButton, 0 );
					layout.boxes[0].stretch = false;
					
					layout.setObjectForBox( _closeButton, 1 );
					layout.boxes[1].stretch = true;
					break;
				case CardinalPoints.SOUTH : 
					styleKey = "ClosableTab_South";
					ilayout.horizontalAlign = Alignments.CENTER;
					ilayout.direction = Directions.RIGHT_TO_LEFT;
					
					layout.setObjectForBox( _mainButton, 0 );
					layout.boxes[0].stretch = false;
					
					layout.setObjectForBox( _closeButton, 1 );
					layout.boxes[1].stretch = true;
					break;
				case CardinalPoints.EAST : 
					styleKey = "ClosableTab_East";
					ilayout.horizontalAlign = Alignments.LEFT;
					ilayout.direction = Directions.LEFT_TO_RIGHT;
					
					layout.setObjectForBox( _mainButton, 0 );
					layout.boxes[0].stretch = false;
					
					layout.setObjectForBox( _closeButton, 1 );
					layout.boxes[1].stretch = true;
					break;
				case CardinalPoints.WEST : 
					styleKey = "ClosableTab_West";
					ilayout.horizontalAlign = Alignments.RIGHT;
					ilayout.direction = Directions.RIGHT_TO_LEFT;
					
					layout.setObjectForBox( _mainButton, 1 );
					layout.boxes[1].stretch = false;
					
					layout.setObjectForBox( _closeButton, 0 );
					layout.boxes[0].stretch = true;
					break;
			}
			invalidatePreferredSizeCache();
		}
		override public function removeFromParent () : void 
		{
			parentTabbedPane.removeTab(this);
		}
		public function get selected () : Boolean { return _selected;}
		public function set selected (b : Boolean) : void
		{
			_selected = b;
			invalidate(true);
		}

		override public function click (e : Event = null) : void
		{
			Log.debug( e.target);
			
			if( e.target != _closeButton )
				dispatchEvent( new ActionEvent( ActionEvent.ACTION, true ) );			else
				fireComponentEvent( ComponentEvent.CLOSE );
				
		}
		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		override public function get transferData () : Transferable
		{
			return new TabTransferable( this, _parentTabbedPane );
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		override protected function stylePropertyChanged ( e : PropertyEvent ) : void
		{
			switch( e.propertyName )
			{
				case "closeIcon" : 
					_closeButton.icon = e.propertyValue.clone();
					break;
				default : 
					super.stylePropertyChanged( e );
					break;
			}
		}
	}
}

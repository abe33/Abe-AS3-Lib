package aesia.com.ponents.tabs 
{
	import aesia.com.ponents.events.TabEvent;
	import aesia.com.mon.geom.dm;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.containers.SlidePane;
	import aesia.com.ponents.core.AbstractContainer;
	import aesia.com.ponents.dnd.DragSource;
	import aesia.com.ponents.events.ActionEvent;
	import aesia.com.ponents.layouts.components.BorderLayout;
	import aesia.com.ponents.utils.CardinalPoints;

	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="TabbedPane")]
	[Skin(define="TabbedPane",
		  inherit="DefaultComponent",
		  preview="aesia.com.ponents.tabs::TabbedPane.defaultTabbedPanePreview",
		  
		  state__all__foreground="new aesia.com.ponents.skinning.decorations::NoDecoration()"	)]
	[Skin(define="TabBarViewport",
		  inherit="DefaultComponent",
		  preview="aesia.com.ponents.tabs::TabbedPane.defaultTabbedPanePreview",
		  acceptStyleSetting="false",
		  
		  state__all__foreground="new aesia.com.ponents.skinning.decorations::NoDecoration()"
	)]
	public class TabbedPane extends AbstractContainer 
	{
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		static public function defaultTabbedPanePreview () : TabbedPane
		{
			var tp : TabbedPane = new TabbedPane();
			tp.addTab( new SimpleTab("Tab 1", new Panel() ) ); 		
			tp.addTab( new SimpleTab("Tab 2", new Panel() ) ); 
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
		
		protected var _tabBar : TabBar;
		protected var _tabScroller : SlidePane;
		protected var _tabsPlacement : String;
		
		protected var _selectedTab : Tab;
		
		public function TabbedPane ( tabsPosition : String = "north" )
		{
			_childrenLayout = new BorderLayout( this );
			super();
			_allowFocus = false;

			_tabBar = new TabBar();
			_tabBar.tabbedPane = this;
			_tabScroller = new SlidePane ();	
			_tabScroller.styleKey = "EmptyComponent";			_tabScroller.viewport.styleKey = "TabBarViewport";
			_tabScroller.view = _tabBar;
			addComponent( _tabScroller );
			this.tabsPosition = tabsPosition;
		}
		public function get tabScroller () : SlidePane { return _tabScroller; }	
		public function get tabBar () : TabBar { return _tabBar; }
		
		public function get tabsPosition () : String { return _tabsPlacement; }	
		public function set tabsPosition (tabsPosition : String) : void
		{
			var layout : BorderLayout = _childrenLayout as BorderLayout;
			layout.removeComponentAt( _tabsPlacement );
			
			_tabsPlacement = tabsPosition;
			
			layout.addComponent( _tabScroller, _tabsPlacement );
			_tabBar.placement = _tabsPlacement;
		}
		public function get allowSelectTabOnDnD () : Boolean { return _tabBar.allowSelectTabOnDnD; }		
		public function set allowSelectTabOnDnD (allowSelectTabOnDnD : Boolean) : void
		{
			_tabBar.allowSelectTabOnDnD = allowSelectTabOnDnD;
		}
		public function get selectedTab () : Tab { return _selectedTab; }		
		public function set selectedTab (selectedTab : Tab) : void
		{
			var layout : BorderLayout = _childrenLayout as BorderLayout;
			if( _selectedTab )
			{
				_selectedTab.selected = false;
				removeComponent( _selectedTab.content );
				layout.removeComponentAt( CardinalPoints.CENTER );
			}
			
			_selectedTab = selectedTab;	
			
			if( _selectedTab )
			{
				_selectedTab.selected = true;
				_tabScroller.ensureRectIsVisible( new Rectangle( _selectedTab.x, _selectedTab.y, _selectedTab.width, _selectedTab.height ) );
				addComponent( _selectedTab.content );
				layout.addComponent( _selectedTab.content, CardinalPoints.CENTER );
			}
			fireTabChangeEvent();		
		}
		
		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		public function set dndEnabled ( b : Boolean ) : void
		{
			_tabBar.dndEnabled = b;
		}
		public function get dropEnabled () : Boolean { return _tabBar.dropEnabled; }
		public function set dropEnabled ( b : Boolean ) : void
		{
			_tabBar.dropEnabled = b;
		}
		public function get dragEnabled () : Boolean { return _tabBar.dragEnabled; }
		public function set dragEnabled ( b : Boolean ) : void
		{
			_tabBar.dragEnabled = b;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		public function addTab ( tab : Tab ) : void
		{
			_tabBar.addComponent( tab );
			setUpTab ( tab );
		}
		public function removeTab ( tab : Tab ) : void
		{
			_tabBar.removeComponent( tab );
			tearDownTab(tab);
		}
		public function setUpTab ( tab : Tab ) : void
		{
			tab.parentTabbedPane = this;
			tab.addWeakEventListener( ActionEvent.ACTION, tabClick );
			tab.placement = _tabsPlacement;	
			
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			if( tab is DragSource )
			  ( tab as DragSource ).allowDrag = dragEnabled;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			//_tabScroller.checkScroll();
				
			if( !_selectedTab )
				selectedTab = tab;
		}
		
		public function tearDownTab ( tab : Tab ) : void
		{
			tab.parentTabbedPane = null;
			tab.selected = false;
			tab.removeEventListener( ActionEvent.ACTION, tabClick );
			tab.size = null;
			
			//_tabScroller.checkScroll();
			
			if( _selectedTab == tab )
			{
				if(  _tabBar.hasChildren )
					selectedTab = _tabBar.children[0] as Tab;
				else 
					selectedTab = null;
			}
		}
			
		override public function isValidateRoot () : Boolean
		{
			return true;
		}

		public function tabClick ( e : ActionEvent ) : void
		{
			var t : Tab = e.target as Tab;
			
			if( t )
				selectedTab = t;
		}
		protected function fireTabChangeEvent () : void
		{
			dispatchEvent( new TabEvent(TabEvent.TAB_CHANGE));
		}
	}
}

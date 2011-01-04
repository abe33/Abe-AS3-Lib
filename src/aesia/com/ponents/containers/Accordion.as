package aesia.com.ponents.containers
{
	import aesia.com.mands.events.CommandEvent;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.motion.SingleTween;
	import aesia.com.ponents.core.AbstractContainer;
	import aesia.com.ponents.core.Container;
	import aesia.com.ponents.events.ActionEvent;
	import aesia.com.ponents.layouts.components.AccordionLayout;
	import aesia.com.ponents.scrollbars.Scrollable;
	import aesia.com.ponents.utils.ScrollUtils;

	import flash.geom.Rectangle;

	[Skinable(skin="Accordion")]
	[Skin(define="Accordion",
			  inherit="DefaultComponent"
	)]
	[Skin(define="AccordionContentContainer",
			  inherit="DefaultComponent",
			  state__all__borders="new cutils::Borders(0,0,0,1)",
			  state__all__background="skin.emptyDecoration"
	)]
	/**
	 * @author cedric
	 */
	public class Accordion extends AbstractContainer implements Scrollable
	{
		protected var _tabs : Array;
		protected var _selectedTab : AccordionTab;
		protected var _tabContentContainer1 : ScrollPane;		protected var _tabContentContainer2 : ScrollPane;

		protected var _animation : SingleTween;
		protected var _transition : Number;

		public function Accordion ( ... tabs )
		{
			_childrenLayout = new AccordionLayout(this);
			super ();

			_allowFocus = false;

			_tabContentContainer1 = new ScrollPane();
			_tabContentContainer1.styleKey = "EmptyComponent";
			_tabContentContainer1.viewport.styleKey = "AccordionContentContainer";
			_tabContentContainer1.allowFocus = false;

			_tabContentContainer2 = new ScrollPane();
			_tabContentContainer2.styleKey = "EmptyComponent";
			_tabContentContainer2.viewport.styleKey = "AccordionContentContainer";
			_tabContentContainer2.allowFocus = false;

			_animation = new SingleTween ( this, "transition", 1, 500, 0 );
			_animation.addEventListener(CommandEvent.COMMAND_END, tweenEnd );

			_tabs = [];
			for each( var tab : AccordionTab in tabs )
				if( tab )
					addTab( tab );
		}

		public function get tabs () : Array { return _tabs; }
		public function get tabContentContainer1 () : ScrollPane { return _tabContentContainer1; }		public function get tabContentContainer2 () : ScrollPane { return _tabContentContainer2; }

		public function get transition () : Number { return _transition; }
		public function set transition ( transition : Number ) : void
		{
			_transition = transition;
			invalidatePreferredSizeCache();
			var p : Container = parentContainer;
			if( p )
			{
				p = p.parentContainer;
				if( p && p is AbstractScrollContainer )
					( p as AbstractScrollContainer ).invalidate();
			}
			fireResizeEvent();
		}

		public function get selectedTab () : AccordionTab { return _selectedTab; }
		public function set selectedTab ( selectedTab : AccordionTab ) : void
		{
			if( _selectedTab )
			{
				_selectedTab.selected = false;
				if( _selectedTab.content )
				{
					var tmp : ScrollPane = _tabContentContainer2;
					_tabContentContainer2 = _tabContentContainer1;
					_tabContentContainer1 = tmp;
				}
			}

			_selectedTab = selectedTab;

			if( _selectedTab )
			{
				_selectedTab.selected = true;
				if( _selectedTab.content )
				{
					_tabContentContainer1.view = _selectedTab.content;

					if( !containsComponent( _tabContentContainer1 ) )
						addComponent( _tabContentContainer1 );
				}
			}
			_animation.execute();
		}

		public function addTab ( tab : AccordionTab ) : void
		{
			if( !containsTab( tab ) )
			{
				_tabs.push( tab );
				tab.accordion = this;
				tab.addWeakEventListener( ActionEvent.ACTION, tabClick );
				addComponent( tab );
			}
		}

		public function containsTab ( tab : AccordionTab ) : Boolean
		{
			return _tabs.indexOf( tab ) != -1;
		}

		protected function tweenEnd ( event : CommandEvent ) : void
		{
			if( containsComponent ( _tabContentContainer2 ) )
			{
				removeComponent ( _tabContentContainer2 );
				_tabContentContainer2.view = null;
			}
		}

		public function getScrollableUnitIncrementV ( r : Rectangle = null, direction : Number = 1 ) : Number { return 10 * direction; }
		public function getScrollableUnitIncrementH ( r : Rectangle = null, direction : Number = 1 ) : Number { return 10 * direction; }

		public function getScrollableBlockIncrementV ( r : Rectangle = null, direction : Number = 1 ) : Number { return 50 * direction; }
		public function getScrollableBlockIncrementH ( r : Rectangle = null, direction : Number = 1 ) : Number { return 50 * direction; }

		public function get preferredViewportSize () : Dimension { return preferredSize; }

		public function get tracksViewportH () : Boolean { return true; }
		public function get tracksViewportV () : Boolean { return !ScrollUtils.isContentHeightExceedContainerHeight(this); }

		protected function tabClick ( e : ActionEvent ) : void
		{
			if( _selectedTab != e.target )
				selectedTab = e.target as AccordionTab;
			else
				selectedTab = null;
		}
	}
}

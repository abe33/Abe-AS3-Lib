package aesia.com.ponents.containers 
{
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.events.PropertyEvent;
	import aesia.com.ponents.layouts.components.SlidePaneLayout;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.skinning.icons.magicIconBuild;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 * @author Cédric Néhémie
	 */
	
	[Style(name="upIcon",type="aesia.com.ponents.skinning.icons.Icon")]	[Style(name="downIcon",type="aesia.com.ponents.skinning.icons.Icon")]	[Style(name="leftIcon",type="aesia.com.ponents.skinning.icons.Icon")]	[Style(name="rightIcon",type="aesia.com.ponents.skinning.icons.Icon")]
	
	[Skinable(skin="SlidePane")]
	[Skin(define="SlidePane",
		  inherit="DefaultComponent",
		  
		  state__all__background="new aesia.com.ponents.skinning.decorations::SimpleFill( aesia.com.mon.utils::Color.White )"
	)]
	[Skin(define="SlidePaneButton",
		  inherit="DefaultComponent",
		  
		  state__all__corners="new aesia.com.ponents.utils::Corners()",		  state__all__insets="new aesia.com.ponents.utils::Insets(2)",
		  
		  custom_upIcon="icon(aesia.com.ponents.containers::SlidePane.SCROLL_UP_ICON)", 
		  custom_downIcon="icon(aesia.com.ponents.containers::SlidePane.SCROLL_DOWN_ICON)", 
		  custom_leftIcon="icon(aesia.com.ponents.containers::SlidePane.SCROLL_LEFT_ICON)", 
		  custom_rightIcon="icon(aesia.com.ponents.containers::SlidePane.SCROLL_RIGHT_ICON)" 
	)]
	public class SlidePane extends AbstractScrollContainer
	{
		[Embed(source="../skinning/icons/scrollup.png")]
		static public var SCROLL_UP_ICON : Class;		
		[Embed(source="../skinning/icons/scrolldown.png")]
		static public var SCROLL_DOWN_ICON : Class;		
		[Embed(source="../skinning/icons/scrollleft.png")]
		static public var SCROLL_LEFT_ICON : Class;		
		[Embed(source="../skinning/icons/scrollright.png")]
		static public var SCROLL_RIGHT_ICON : Class;		
		
		protected var _content : Component;
		
		protected var _scrollUpButton : Button;
		protected var _scrollDownButton : Button;
		protected var _scrollLeftButton : Button;
		protected var _scrollRightButton : Button;
		
		protected var _scrollInterval : Number;
		protected var _scrollDelay : Number;
		
		public function SlidePane ( policy : String = "auto", delay : Number = 50 )
		{
			super();
			
			var l : SlidePaneLayout = new SlidePaneLayout( this, policy );
			childrenLayout = l;
			l.viewport = _viewport;
			_scrollDelay = delay;
			
			draw();
		}
		public function get scrollDelay () : Number { return _scrollDelay; }		
		public function set scrollDelay (scrollDelay : Number) : void
		{
			_scrollDelay = scrollDelay;
		}

		override public function set scrollH (scroll : Number) : void
		{
			super.scrollH = scroll;
			checkButtons();
		}

		override public function set scrollV (scroll : Number) : void
		{
			super.scrollV = scroll;
			checkButtons();
		}

		protected function draw () : void
		{
			(childrenLayout as SlidePaneLayout).scrollDownButton = 
			_scrollDownButton = createButton( "SlidePaneButton", "downIcon", overScrollDown );
			
			(childrenLayout as SlidePaneLayout).scrollUpButton =
			_scrollUpButton = createButton( "SlidePaneButton", "upIcon", overScrollUp );
			
			(childrenLayout as SlidePaneLayout).scrollLeftButton =
			_scrollLeftButton = createButton( "SlidePaneButton", "leftIcon", overScrollLeft );
			
			(childrenLayout as SlidePaneLayout).scrollRightButton =
			_scrollRightButton = createButton( "SlidePaneButton", "rightIcon", overScrollRight );
		}

		private function createButton ( style : String, icon : String, over : Function ) : Button
		{
			var bt : Button = new Button("");
			
			bt.styleKey = style;
			bt.icon = bt.style[ icon ].clone();
			bt.addWeakEventListener( MouseEvent.MOUSE_OVER, over );
			bt.addWeakEventListener( MouseEvent.MOUSE_OUT, clearScroll );
			addComponent( bt );
			return bt;
		}
		
		protected function overScrollUp ( e : Event ) : void
		{
			if( _scrollUpButton.enabled )
				_scrollInterval = setInterval( scrollUp , _scrollDelay );
		}
		protected function overScrollDown ( e : Event ) : void
		{
			if( _scrollDownButton.enabled )
				_scrollInterval = setInterval( scrollDown , _scrollDelay );
		}
		protected function overScrollLeft ( e : Event ) : void
		{
			if( _scrollLeftButton.enabled )
				_scrollInterval = setInterval( scrollLeft , _scrollDelay );
		}
		protected function overScrollRight ( e : Event ) : void
		{			if( _scrollRightButton.enabled )
				_scrollInterval = setInterval( scrollRight , _scrollDelay );
		}
		protected function clearScroll ( e : Event = null ) : void
		{
			clearInterval( _scrollInterval );
		}

		override protected function updateModelsAfterResize () : void
		{
			super.updateModelsAfterResize();
			checkButtons ();
		}

		override public function repaint () : void
		{
			super.repaint();
			checkButtons ();
		}

		public function checkButtons () : void
		{
			if( !_hmodel || !_vmodel || !_scrollLeftButton || !_scrollRightButton || !_scrollDownButton || !_scrollUpButton  )
				return;
			
			_scrollLeftButton.enabled = _enabled && _hmodel.value > _hmodel.minimum;			_scrollRightButton.enabled = _enabled && _hmodel.value < _hmodel.maximum;
				
			_scrollUpButton.enabled = _enabled && _vmodel.value > _vmodel.minimum;
			_scrollDownButton.enabled = _enabled && _vmodel.value < _vmodel.maximum;
		}

		override protected function stylePropertyChanged ( e : PropertyEvent ) : void
		{
			switch( e.propertyName )
			{
				case "upIcon" : 
					_scrollUpButton.icon = ( e.propertyValue as Icon ).clone();
					invalidatePreferredSizeCache();
					size = null;
					break;
				case "downIcon" : 
					_scrollDownButton.icon = ( e.propertyValue as Icon ).clone();
					invalidatePreferredSizeCache();
					size = null;
					break;
				case "leftIcon" : 
					_scrollLeftButton.icon = ( e.propertyValue as Icon ).clone();
					invalidatePreferredSizeCache();
					size = null;
					break;
				case "rightIcon" : 
					_scrollRightButton.icon = ( e.propertyValue as Icon ).clone();
					invalidatePreferredSizeCache();
					size = null;
					break;
				default : 
					super.stylePropertyChanged( e );
					break;
			}
		}
	}
}

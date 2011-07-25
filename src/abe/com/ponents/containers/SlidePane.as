package abe.com.ponents.containers 
{
	import abe.com.mon.geom.*;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.core.*;
	import abe.com.ponents.factory.*;
	import abe.com.ponents.layouts.components.SlidePaneLayout;
	import abe.com.ponents.skinning.icons.Icon;

	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 * @author Cédric Néhémie
	 */
	
	[Style(name="upIcon",type="abe.com.ponents.skinning.icons.Icon")]
	[Style(name="downIcon",type="abe.com.ponents.skinning.icons.Icon")]
	[Style(name="leftIcon",type="abe.com.ponents.skinning.icons.Icon")]
	[Style(name="rightIcon",type="abe.com.ponents.skinning.icons.Icon")]
	
	[Skinable(skin="SlidePane")]
	[Skin(define="SlidePane",
		  inherit="NoDecorationComponent"
	)]
	[Skin(define="SlidePaneButton",
		  inherit="DefaultComponent",
		  
		  state__all__corners="new cutils::Corners()",
		  state__all__insets="new cutils::Insets(2)",
		  
		  custom_upIcon="icon(abe.com.ponents.containers::SlidePane.SCROLL_UP_ICON)", 
		  custom_downIcon="icon(abe.com.ponents.containers::SlidePane.SCROLL_DOWN_ICON)", 
		  custom_leftIcon="icon(abe.com.ponents.containers::SlidePane.SCROLL_LEFT_ICON)", 
		  custom_rightIcon="icon(abe.com.ponents.containers::SlidePane.SCROLL_RIGHT_ICON)" 
	)]
	public class SlidePane extends AbstractScrollContainer
	{
	    FEATURES::BUILDER 
	    {
	        static public function buildPreview( factory : ComponentFactory,
                                                 id : String,
                                                 kwargs : Object = null ):void
            {
                ScrollablePanel.buildPreview( factory, id + "_panel" );
                
                factory.group("movables")
                       .build( SlidePane, 
                               id, 
                               null,
                               kwargs, 
                               function( sp : SlidePane, o : Object ) : void
                               {
                                   sp.view = o[ id + "_panel" ];
                                   sp.preferredSize = dm(100,100);
                               } );
            }
	    }
	
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
			bt.mouseEntered.add( over );
			bt.mouseLeaved.add( clearScroll );
			addComponent( bt );
			return bt;
		}
		
		protected function overScrollUp ( c : Component ) : void
		{
			if( _scrollUpButton.enabled )
				_scrollInterval = setInterval( scrollUp , _scrollDelay );
		}
		protected function overScrollDown ( c : Component ) : void
		{
			if( _scrollDownButton.enabled )
				_scrollInterval = setInterval( scrollDown , _scrollDelay );
		}
		protected function overScrollLeft ( c : Component ) : void
		{
			if( _scrollLeftButton.enabled )
				_scrollInterval = setInterval( scrollLeft , _scrollDelay );
		}
		protected function overScrollRight ( c : Component ) : void
		{
			if( _scrollRightButton.enabled )
				_scrollInterval = setInterval( scrollRight , _scrollDelay );
		}
		protected function clearScroll ( c : Component ) : void
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
			
			_scrollLeftButton.enabled = _enabled && _hmodel.value > _hmodel.minimum;
			_scrollRightButton.enabled = _enabled && _hmodel.value < _hmodel.maximum;
				
			_scrollUpButton.enabled = _enabled && _vmodel.value > _vmodel.minimum;
			_scrollDownButton.enabled = _enabled && _vmodel.value < _vmodel.maximum;
		}

		override protected function stylePropertyChanged ( propertyName : String, propertyValue : *) : void
		{
			switch( propertyName )
			{
				case "upIcon" : 
					_scrollUpButton.icon = ( propertyValue as Icon ).clone();
					invalidatePreferredSizeCache();
					size = null;
					break;
				case "downIcon" : 
					_scrollDownButton.icon = ( propertyValue as Icon ).clone();
					invalidatePreferredSizeCache();
					size = null;
					break;
				case "leftIcon" : 
					_scrollLeftButton.icon = ( propertyValue as Icon ).clone();
					invalidatePreferredSizeCache();
					size = null;
					break;
				case "rightIcon" : 
					_scrollRightButton.icon = ( propertyValue as Icon ).clone();
					invalidatePreferredSizeCache();
					size = null;
					break;
				default : 
					super.stylePropertyChanged(propertyName, propertyValue);
					break;
			}
		}
	}
}

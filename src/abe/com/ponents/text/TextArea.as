/**
 * @license
 */
package abe.com.ponents.text
{
	import abe.com.mands.ProxyCommand;
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.mon.utils.Keys;
	import abe.com.ponents.completion.AutoCompletion;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.layouts.display.DOBoxSettings;
	import abe.com.ponents.layouts.display.DOHBoxLayout;
	import abe.com.ponents.menus.CompletionDropDown;
	import abe.com.ponents.scrollbars.ScrollBar;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	[Skinable(skin="Text")]
	public class TextArea extends AbstractTextComponent
	{
		protected var _scrollbar : ScrollBar;

		public function TextArea ()
		{
			super();
			_label.multiline = true;
			_label.wordWrap = true;
			_label.width = _label.height = 100;

			//_childrenLayout = new DOInlineLayout( _childrenContainer );
			_allowHTML = false;
			_allowMask = false;

			_scrollbar = new ScrollBar( 1, 1, 1, 1, 1 );
			_scrollbar.isComponentIndependent = false;

			_childrenContainer.addChild( _scrollbar );
			//_scrollbar.height = _label.height;

			_childrenLayout = new DOHBoxLayout( _childrenContainer,
												0,
												new DOBoxSettings(0, "center", "center", _label as DisplayObject, true, true, true ),
												new DOBoxSettings(0, "left", "center", _scrollbar, false, true, false ));

			FEATURES::KEYBOARD_CONTEXT { 
				//_keyboardContext[ KeyStroke.getKeyStroke( Keys.ENTER ) ] = new ProxyCommand( comfirmInput );
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.UP ) ] = new ProxyCommand( up );
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.DOWN ) ] = new ProxyCommand( down );
			} 

			invalidatePreferredSizeCache();
		}

		public function get scrollbar () : ScrollBar { return _scrollbar; }

		override public function focusOut (e : FocusEvent) : void
		{
			fireDataChangedSignal();
			super.focusOut(e);
		}

		override public function set enabled (b : Boolean) : void
		{
			super.enabled = b;
			_scrollbar.enabled = b;
		}

		override public function repaint () : void
		{
			super.repaint();
			updateTextFormat();
			updateScrollBar();
			_scrollbar.repaint();
		}

		override protected function calculateComponentSize () : Dimension
		{
			var size : Dimension = _size ?
								   _size :
								   	  (_preferredSize ?
									   _preferredSize :
									   new Dimension( _label.width, _label.height )
									   		.grow( _scrollbar.width, 0 )
									   		.grow( _style.insets.horizontal, _style.insets.vertical ) );

			return size;
		}

		override protected function registerToOnStageEvents () : void
		{
			super.registerToOnStageEvents( );

			_label.addEventListener( Event.SCROLL, scroll );
			_label.addEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheelRolled );
			_scrollbar.scrolled.add( scrollbarScrolled );
			_scrollbar.mouseWheelRolled.add( onMouseWheelRolled );
		}

		override protected function unregisterFromOnStageEvents () : void
		{
			super.unregisterFromOnStageEvents( );

			_label.removeEventListener( Event.SCROLL, scroll );
			_label.removeEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheelRolled );
			_scrollbar.scrolled.remove( scrollbarScrolled );
			_scrollbar.mouseWheelRolled.remove( onMouseWheelRolled );
		}
		protected function onMouseWheelRolled(... args) : void
		{
		    var d : Number;
		    if( args[0] is MouseEvent )
		        d = args[0].delta;
		    else
		        d = args[1];
		        
			var willScroll : Boolean = _scrollbar.canScroll &&
									   d < 0 ?
									   	   _scrollbar.scroll < _scrollbar.maxScroll :
									   	   _scrollbar.scroll > _scrollbar.minScroll;

			if( willScroll && args[0] is MouseEvent )
				args[0].stopPropagation();
		}
		protected function updateScrollBar() : void
		{
			_scrollbar.model.minimum = 1;
			_scrollbar.model.maximum = _label.maxScrollV;

			_scrollbar.model.extent = _label.maxScrollV > 1 ?
											_label.bottomScrollV - _label.scrollV :
											Math.floor(_label.height / _label.getLineMetrics(0).height );

			if( _label.scrollV != _scrollbar.model.value )
				_scrollbar.model.value = _label.scrollV;
		}
		override public function registerValue (e : Event = null) : void
		{
			if( _label && _enabled )
			{
				if( _allowHTML )
					_value = _label.htmlText;
				else
					_value = _label.text;
			}

			updateScrollBar();

			FEATURES::SPELLING { 
				checkContent();
			} 
		}
		protected function scroll (event : Event) : void
		{
			FEATURES::SPELLING { 
				renderMispelledWords();
			} 

			updateScrollBar();
		}
		private function scrollbarScrolled ( s : ScrollBar ) : void
		{
			if( _label.scrollV != _scrollbar.model.value )
				_label.scrollV = _scrollbar.model.value;
		}

		protected function up () : void
		{
			FEATURES::AUTOCOMPLETION { 
			    if( _autoCompleteDropDown )
				    _autoCompleteDropDown.up();
			} 
		}

		protected function down () : void
		{
			FEATURES::AUTOCOMPLETION { 
			    if( _autoCompleteDropDown )
				    _autoCompleteDropDown.down();
			} 
		}

		FEATURES::AUTOCOMPLETION { 
		    protected var _autoComplete : AutoCompletion;
		    protected var _autoCompleteDropDown : CompletionDropDown;

		    public function get autoComplete () : AutoCompletion { return _autoComplete; }
		    public function set autoComplete (autoComplete : AutoCompletion) : void
		    {
			    _autoComplete = autoComplete;

			    if( _autoComplete )
			    {
				    if( _autoCompleteDropDown )
					    _autoCompleteDropDown.autoComplete = _autoComplete;
				    else
					    _autoCompleteDropDown = new CompletionDropDown( this, _autoComplete );
			    }
			    else
			    {
				    _autoCompleteDropDown.autoComplete = null;
				    _autoCompleteDropDown = null;
			    }
		    }
		    public function get maxCompletionVisibleItems () : Number { return _autoCompleteDropDown.maxVisibleItems; }
		    public function set maxCompletionVisibleItems (maxCompletionVisibleItems : Number) : void
		    {
			    _autoCompleteDropDown.maxVisibleItems = maxCompletionVisibleItems;
		    }
		} 

		protected function fireDataChangedSignal () : void
		{
			_dataChanged.dispatch( this, _value );
		}
	}
}

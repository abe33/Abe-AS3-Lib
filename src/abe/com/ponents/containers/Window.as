/**
 * @license
 */
package abe.com.ponents.containers 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.geom.dm;
	import abe.com.mon.utils.StageUtils;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.ProxyAction;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.core.AbstractContainer;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.Container;
	import abe.com.ponents.core.focus.Focusable;
	import abe.com.ponents.layouts.components.BorderLayout;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.text.Label;
	import abe.com.ponents.utils.ComponentResizer;
	import abe.com.ponents.utils.Insets;
	import abe.com.ponents.utils.PopupUtils;
	import abe.com.ponents.utils.ToolKit;

	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	
	import org.osflash.signals.Signal;

	[Skinable(skin="Window")]
	[Skin(define="Window",
		  inherit="DefaultComponent",
		  preview="abe.com.ponents.containers::Window.defaultWindowPreview",
		  
		  state__all__corners="new cutils::Corners(5)",
		  state__all__outerFilters="abe.com.ponents.containers::Window.windowShadow()",
		  state__focus_focusandselected__foreground="skin.borderColor"
	)]
	/**
	 * 
	 */
	public class Window extends AbstractContainer 
	{
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		static public function defaultWindowPreview() : Window
		{
			var w : Window = new Window();
			
			w.windowTitle = new WindowTitleBar(_("Sample Window"), null, 15);
			w.preferredSize = dm(150,60);
			
			return w;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		static public function windowShadow () : Array
		{
			return [new DropShadowFilter(1,45,0,.75,4,4)];
		}
		
		protected var _windowContent : Component;
		protected var _windowTitle : Component;
		protected var _windowStatus : Component;
		protected var _modal : Boolean;
		protected var _resizable : Boolean;
		protected var _resizer : ComponentResizer;
		protected var _safePreferredSize : Dimension;
		protected var _maximized : Boolean;
		protected var _minimized : Boolean;
		protected var _minimizedContainer : Container;
		protected var _minimizedButton : Button;
		protected var _closePolicy : String;
		
		protected var _safeX : Number;
		protected var _safeY : Number;
		
		public var windowMinimized : Signal;
		public var windowMaximized : Signal;
		public var windowRestored : Signal;
		public var windowOpened : Signal;
		public var windowClosed : Signal;
		
		public function Window ()
		{
		    windowClosed = new Signal();
		    windowMaximized = new Signal();
		    windowMinimized = new Signal();
		    windowOpened = new Signal();
		    windowRestored = new Signal();
			_childrenLayout = new BorderLayout( this );
			super();
			_allowFocusLoop = true;
			doubleClickEnabled = true;
		}
		public function get resizable () : Boolean { return _resizable; }		
		public function set resizable (resizable : Boolean) : void
		{
			_resizable = resizable;
			if( _resizable )
				_resizer = new ComponentResizer(this);
			else
			{
				_resizer.release();
				_resizer = null;
			}
			firePropertyChangedSignal("resizable", _resizable );
		}

		public function get modal () : Boolean { return _modal; }	
		public function set modal (modal : Boolean) : void 
		{
			if(!displayed)
			{
				_modal = modal;
				firePropertyChangedSignal("modal", _modal);
			}
		}
		public function get windowContent () : Component { return _windowContent; }		
		public function set windowContent (windowContent : Component) : void
		{
			if( _windowContent )
			{
				(_childrenLayout as BorderLayout).center = null;
				removeComponent( _windowContent );			
				
				if( _displayed )
					_windowContent.componentResized.remove( contentResized );			
			}
			
			_windowContent = windowContent;
			
			if( _windowContent )
			{
				if( _windowContent is Panel || 
					_windowContent is Label )
					_windowContent.style.setForAllStates("insets", new Insets(5));
				
				( _childrenLayout as BorderLayout).center = _windowContent;
				addComponentAt( _windowContent, 1 );
				
				if( _displayed )
					_windowContent.componentResized.add( contentResized );			
			}
			
			invalidatePreferredSizeCache();
			firePropertyChangedSignal("windowContent", _windowContent );
		}

		override protected function registerToOnStageEvents () : void
		{
			super.registerToOnStageEvents();
			if( _windowContent )
				_windowContent.componentResized.add( contentResized );	
		}

		override protected function unregisterFromOnStageEvents () : void
		{
			super.unregisterFromOnStageEvents();
			if( _windowContent )
				_windowContent.componentResized.remove( contentResized );
		}

		protected function contentResized ( c : Component, d : Dimension ) : void
		{
			invalidatePreferredSizeCache();
		}		

		public function get windowTitle () : Component { return _windowTitle; }		
		public function set windowTitle (windowTitle : Component) : void
		{
			if( _windowTitle )
			{
				(_childrenLayout as BorderLayout).north = null;
				removeComponent( _windowTitle );			
			}
			
			_windowTitle = windowTitle;
			
			if( _windowTitle )
			{
				(_childrenLayout as BorderLayout).north = _windowTitle;
				addComponent( _windowTitle );			
			}
			invalidatePreferredSizeCache();
			firePropertyChangedSignal("windowTitle", _windowTitle );
		}

		public function get windowStatus () : Component { return _windowStatus; }		
		public function set windowStatus (windowStatus : Component) : void
		{
			if( _windowStatus )
			{
				(_childrenLayout as BorderLayout).south = null;
				removeComponent( _windowStatus );			
			}
			
			_windowStatus = windowStatus;
			
			if( _windowStatus )
			{
				(_childrenLayout as BorderLayout).south = _windowStatus;
				addComponentAt( _windowStatus, 2 );			
			}
			invalidatePreferredSizeCache();
			firePropertyChangedSignal("windowStatus", _windowStatus );
		}
		public function get maximized () : Boolean { return _maximized; }		
		public function get minimized () : Boolean { return _minimized; }
		
		public function get minimizedContainer () : Container { return _minimizedContainer; }		
		public function set minimizedContainer (minimizedContainer : Container) : void
		{
			_minimizedContainer = minimizedContainer;
		}
		
		public function open( closePolicy : String = null ) : void
		{
			_closePolicy = closePolicy;
			if(!displayed)
			{
				if( _modal )
					PopupUtils.showAsModalPopup(this);
				else
					ToolKit.popupLevel.addChild(this);
				
				windowOpened.dispatch( this );
			}
		}
		public function close () : void
		{
			if(displayed)
			{
				if( _modal )
					PopupUtils.pop();
				else
					ToolKit.popupLevel.removeChild(this);
				
				windowClosed.dispatch( this );
			}
		}
		public function maximize () : void
		{
			if( !_maximized )
			{
				if( _minimized )
					restore();
				
				_safeX = x;
				_safeY = y;
				StageUtils.lockToStage( this, StageUtils.WIDTH + 
											  StageUtils.HEIGHT +
											  StageUtils.X_ALIGN_LEFT + 
											  StageUtils.Y_ALIGN_TOP );
				_maximized = true;
				
				if( _resizer )
					_resizer.enabled = false;
				
				windowMaximized.dispatch( this );
			}
		}
		public function restore() : void
		{
			if( _minimized )
			{
				_minimized = false;
				if( _minimizedContainer )
				{
					visible = true;
					_minimizedContainer.removeComponent( _minimizedButton );
					_minimizedButton = null;
					
				}
				else
				{
					if( _windowContent )
						_windowContent.visible = true;
					if( _windowStatus )				
						_windowStatus.visible = true;
						
					if( _safePreferredSize )
					{
						_preferredSize = _safePreferredSize;
						_safePreferredSize = null;
					}
					if( _resizer )
						_resizer.enabled = true;
					
					invalidatePreferredSizeCache();		
					
				}
				windowRestored.dispatch( this );
			}
			else if( _maximized )
			{
				StageUtils.unlockFromStage( this );
				x = _safeX;
				y = _safeY;
				size = null;
				_maximized = false;
				
				if( _resizer )
					_resizer.enabled = true;
				
				windowRestored.dispatch( this );
			}
			
		}
		public function minimize () : void
		{
			if( !_minimized )
			{
				_minimized = true;
				if( _minimizedContainer )
				{
					visible = false;
					var s : String;
					var i : Icon;
					if( _windowTitle && _windowTitle is WindowTitleBar )
					{
						s = (_windowTitle as WindowTitleBar).windowTitle;
						i = (_windowTitle as WindowTitleBar).windowIcon;
					}
					else
					{
						s = _("Restore");	
					}
					_minimizedButton = new Button( new ProxyAction( restore, s, i ) );
					_minimizedContainer.addComponent( _minimizedButton );
				}
				else
				{
					if( _windowContent )
						_windowContent.visible = false;
					if( _windowStatus )				
						_windowStatus.visible = false;
						
					if( _preferredSize )
					{
						_safePreferredSize = _preferredSize;
						_preferredSize = new Dimension(_preferredSize.width, _windowTitle.preferredHeight );
					}
					if( _resizer )
					_resizer.enabled = false;
					
					invalidatePreferredSizeCache();		
				}
				windowMinimized.dispatch( this );
			}
		}
		override public function focusNextChild (child : Focusable) : void 
		{
			super.focusNextChild( child );
		}

		override public function addedToStage (e : Event) : void 
		{
			super.addedToStage( e );
			
			if( _resizer )
				_resizer.enabled = true;
		}

		override public function removeFromStage (e : Event) : void 
		{
			super.removeFromStage( e );
			
			if( _resizer )
				_resizer.enabled = false;
		}
	}
}

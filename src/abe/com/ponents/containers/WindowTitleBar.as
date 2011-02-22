package abe.com.ponents.containers 
{
	import abe.com.patibility.lang._;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.core.AbstractContainer;
	import abe.com.ponents.events.WindowEvent;
	import abe.com.ponents.layouts.components.BoxSettings;
	import abe.com.ponents.layouts.components.HBoxLayout;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.skinning.decorations.GradientFill;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.text.Label;
	import abe.com.ponents.utils.ToolKit;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="WindowTitleBar")]
	[Skin(define="WindowTitleBar",
			  inherit="DefaultComponent",
			
			  state__all__background="new deco::GradientFill(gradient([skin.overSelectedBackgroundColor,skin.selectedBackgroundColor,skin.overSelectedBackgroundColor],[.45,.5,1]),90)",
			  state__all__insets="new cutils::Insets(4)",
			  state__all__corners="new cutils::Corners(5,5,0,0)"
	)]
	public class WindowTitleBar extends AbstractContainer 
	{
		static private const SKIN_DEPENDENCIES : Array = [GradientFill];
		[Embed(source="../skinning/icons/scrolldown.png")]
		static public var WINDOW_MENU_ICON : Class;
		
		// Buttons filters
		static public const MINIMIZE_BUTTON : uint = 1;
		static public const MAXIMIZE_BUTTON : uint = 2;
		static public const CLOSE_BUTTON : uint = 4;
		static public const WINDOW_MENU_BUTTON : uint = 8;
		
		protected var _window : Window;
		protected var _windowIcon : Icon;
		protected var _windowTitle : Label;
		protected var _windowButtons : Panel;
		protected var _windowMenu : Button;		protected var _windowMinimize : Button;		protected var _windowMaximize : Button;
		protected var _windowClose : Button;		protected var _pressedX : Number;
		protected var _pressedY : Number;

		public function WindowTitleBar ( windowTitle : String = "Window", windowIcon : Icon = null, buttons : uint = 0)
		{
			var l : HBoxLayout = new HBoxLayout(this,2);
			_childrenLayout = l;
			super();
			_allowMask = false;
			_allowFocus = false;
			_windowTitle = new WindowTitle( windowTitle );
			_windowIcon = windowIcon;
			
			_windowMenu = buttons & WINDOW_MENU_BUTTON ? new WindowTitleButton(function():void
			{
				
			},"6") : null;
			
			_windowClose = buttons & CLOSE_BUTTON ? new WindowTitleButton(function () :void
			{
				( parentContainer as Window ).close();
			},"r") : null;
						_windowMaximize = buttons & MAXIMIZE_BUTTON ? new WindowTitleButton(function () :void
			{
				var w : Window = parentContainer as Window;
				if( w.maximized )
					w.restore();
				else
					w.maximize();
			},"1") : null;
						_windowMinimize = buttons & MINIMIZE_BUTTON ? new WindowTitleButton(function () :void
			{
				var w : Window = parentContainer as Window;
				if( w.minimized )
					w.restore();
				else
					w.minimize();
			},"0") : null;
			
			if( _windowMenu )
			{
				/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
					_windowMenu.tooltip = _("Open window menu");
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				l.boxes.push( new BoxSettings(16,"center","center", _windowMenu ) );
				addComponent( _windowMenu );
			}
			if( _windowIcon )
			{
				l.boxes.push( new BoxSettings(16,"center","center", _windowIcon ) );
				addComponent( _windowIcon );
				_windowIcon.doubleClickEnabled = true;
			}
			
			l.boxes.push( new BoxSettings(0,"left","center", _windowTitle, true, false, true ) );
			addComponent( _windowTitle );
			_windowTitle.doubleClickEnabled = true;			
			if( _windowClose || _windowMaximize || _windowMinimize )
			{							_windowButtons = new Panel();
				_windowButtons.childrenLayout = new InlineLayout( _windowButtons, 2 );
				
				if( _windowMinimize )
				{
					_windowButtons.addComponent( _windowMinimize );
					/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
						_windowMinimize.tooltip = _("Minimize the window");
					/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				}
					
				if( _windowMaximize )
				{
					_windowButtons.addComponent( _windowMaximize );
					/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
						_windowMaximize.tooltip = _("Maximize the window");
					/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				}
					
				if( _windowClose )
				{
					_windowButtons.addComponent( _windowClose );
					/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
						_windowClose.tooltip = _("Close the window");
					/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				}
				
				addComponent( _windowButtons );				l.boxes.push( new BoxSettings(0,"center","center", _windowButtons ) );
			}
			doubleClickEnabled = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, doubleClick );
		}
		
		public function get windowTitle () : String { return _windowTitle.value; }		public function set windowTitle ( s : String ) : void
		{ 
			_windowTitle.value = s; 
		}
		public function get windowIcon () : Icon { return _windowIcon; }

		override public function mouseDown (e : MouseEvent) : void
		{
			if( !( parentContainer as Window ).modal )
				ToolKit.popupLevel.setChildIndex( parentContainer as DisplayObject, ToolKit.popupLevel.numChildren-1);
			
			super.mouseDown(e);
			_pressedX = mouseX;			_pressedY = mouseY;
			if( !( parentContainer as Window ).maximized )
				stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);		}

		override public function mouseUp (e : MouseEvent) : void
		{
			super.mouseUp( e );
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
		}
		public function stageMouseMove (e : MouseEvent) : void
		{
			if( _pressed )
			{
				( parentContainer as Window ).position = new Point( e.stageX - _pressedX, e.stageY - _pressedY );
			}
		}
		protected function doubleClick (event : MouseEvent) : void
		{
			var w : Window = parentContainer as Window;
			if( w.maximized )
				w.restore();
			else
				w.maximize();
				
			updateButtons();
		}

		override public function addedToStage (e : Event) : void
		{
			super.addedToStage( e );
			_window = parentContainer as Window;
			if( _window )
			{
				registerToWindowEvents( _window );
			}
		}

		override public function removeFromStage (e : Event) : void
		{
			super.removeFromStage( e );
			if( _window )
			{
				unregisterFromWindowEvents(_window);
				_window = null;
			}
		}

		protected function registerToWindowEvents (window : Window) : void
		{
			window.addEventListener(WindowEvent.MAXIMIZE, windowMaximize );			window.addEventListener(WindowEvent.MINIMIZE, windowMinimize );			window.addEventListener(WindowEvent.RESTORE, windowRestore );
		}
		protected function unregisterFromWindowEvents (window : Window) : void
		{
			window.addEventListener(WindowEvent.MAXIMIZE, windowMaximize );
			window.addEventListener(WindowEvent.MINIMIZE, windowMinimize );
			window.addEventListener(WindowEvent.RESTORE, windowRestore );
		}
		
		protected function windowRestore (event : WindowEvent) : void
		{
			updateButtons();		}
		protected function windowMinimize (event : WindowEvent) : void
		{
			updateButtons();		}
		protected function windowMaximize (event : WindowEvent) : void
		{
			updateButtons();
		}
		protected function updateButtons () : void
		{
			if( _windowMaximize )
				_windowMaximize.label = _window.maximized ? "2" : "1";
			if( _windowMinimize )				_windowMinimize.label = _window.minimized ? "2" : "0";
		}
	}
}

import abe.com.ponents.buttons.Button;
import abe.com.ponents.core.Component;
import abe.com.ponents.skinning.icons.Icon;
import abe.com.ponents.text.Label;

import flash.events.Event;
import flash.events.MouseEvent;

[Skinable(skin="WindowTitleButton")]
[Skin(define="WindowTitleButton",
		  inherit="Button",
		  state__all__insets="new abe.com.ponents.utils::Insets(1,0)",
		  state__all__format="new flash.text::TextFormat('Webdings',12)"
)]
internal class WindowTitleButton extends Button
{
	protected var fn : Function;
	public function WindowTitleButton ( fn : Function = null, actionOrLabel : * = null, icon : Icon = null )
	{
		super( actionOrLabel, icon );
		this.fn = fn;
	}

	override public function click (e : Event = null) : void
	{
		fn( );
	}

	override public function mouseDown (e : MouseEvent) : void
	{
		super.mouseDown( e );
		e.stopImmediatePropagation();
	}
	override public function mouseUp (e : MouseEvent) : void
	{
		super.mouseUp( e );
		e.stopImmediatePropagation();
	}
}

internal class WindowTitle extends Label
{
	public function WindowTitle ( text : String = "Label", forComponent : Component = null )
	{
		super( text, forComponent );
		_allowFocus = false;
	}
}

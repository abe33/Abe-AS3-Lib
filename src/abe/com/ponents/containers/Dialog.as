/**
 * @license
 */
package abe.com.ponents.containers 
{
	import abe.com.mands.ProxyCommand;
	import abe.com.mon.geom.dm;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.mon.utils.Keys;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.ProxyAction;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.core.*;
	import abe.com.ponents.events.DialogEvent;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.skinning.decorations.GradientFill;
	import abe.com.ponents.text.Label;
	
	import org.osflash.signals.Signal;

	[Skin(define="DialogButtonsPanel",
		  inherit="EmptyComponent",
		  preview="abe.com.ponents.containers::Dialog.defaultDialogPreview",
		  previewAcceptStyleSetup="false",
			  
		  state__all__insets="new cutils::Insets(4)"
	)]
	[Skin(define="DialogTitle",
		  inherit="EmptyComponent",
		  preview="abe.com.ponents.containers::Dialog.defaultDialogPreview",
		  previewAcceptStyleSetup="false",
			  
		  state__all__background="new deco::GradientFill(gradient([skin.overSelectedBackgroundColor,skin.selectedBackgroundColor,skin.overSelectedBackgroundColor],[.45,.5,1]),90)",
		  state__all__insets="new cutils::Insets(4)",
		  state__all__corners="new cutils::Corners(5,5,0,0)",
		  state__all__borders="new cutils::Borders(1)",
		  state__all__foreground="new deco::SimpleBorders(skin.borderColor)"
	)]
	[Skinable(skin="Dialog")]
	[Skin(define="Dialog",
		  inherit="Window",
		  preview="abe.com.ponents.containers::Dialog.defaultDialogPreview"
	)]
	/**
	 * 
	 */
	public class Dialog extends Window 
	{
		FEATURES::BUILDER { 
		static public function defaultDialogPreview ():Dialog
		{
			var d : Dialog = new Dialog(_("Sample Dialog"), Dialog.CLOSE_BUTTON, new Panel() );
			d.preferredSize= dm(120,60);
			
			return d;
		}
		} 
		
		static private const SKIN_DEPENDENCIES : Array = [GradientFill];
		
		// Buttons filters
		static public const OK_BUTTON : uint = 1;
		static public const CANCEL_BUTTON : uint = 2;
		static public const YES_BUTTON : uint = 4;
		static public const NO_BUTTON : uint = 8;
		static public const CLOSE_BUTTON : uint = 16;
		
		// Dialog result value
		static public const RESULTS_CANCEL : uint = 0;
		static public const RESULTS_OK : uint = 1;
		static public const RESULTS_YES : uint = 2;
		static public const RESULTS_NO : uint = 3;
		
		// Dialog close policy
		static public const CLOSE_ON_RESULT : String = "closeOnResult";
		
		protected var _okButton : Button;
		protected var _cancelButton : Button;
		protected var _yesButton : Button;
		protected var _noButton : Button;
		protected var _closeButton : Button;
		
		protected var _buttons : Array;
		
		public var dialogResponded : Signal;
		
		public function Dialog ( title : String, 
							     buttons : uint, 
							     content : Component = null, 
							     selectedButton : uint = 1 )
		{
			super();
			dialogResponded = new Signal();
			_buttons = [];
			_modal = true;
			createTitle( title );
			createButtons( buttons, selectedButton );
			
			if( content )
			{
				windowContent = content;
				//FIX ne pas mettre en dur les styles 
				//content.style.setForAllStates("insets", new Insets( 4 ));
			}
		}

		override public function set modal (modal : Boolean) : void	{}

		override public function set windowContent (windowContent : Component) : void 
		{
			super.windowContent = windowContent;
			(_windowTitle as Label ).forComponent = windowContent;
		}
		
		public function get buttons () : Array { return _buttons; }
		
		public function get okButton () : Button { return _okButton; }		
		public function get cancelButton () : Button { return _cancelButton; }		
		public function get yesButton () : Button { return _yesButton; }		
		public function get noButton () : Button { return _noButton; }		
		public function get closeButton () : Button { return _closeButton; }
		
		override public function open ( closePolicy : String = null ) : void 
		{
			super.open( closePolicy );
			if( windowContent )
				windowContent.grabFocus();
		}

		protected function createTitle (title : String) : void
		{
			var t : Label = new Label( title );
			t.allowFocus = false;
			t.styleKey = "DialogTitle";
			windowTitle = t;
		}

		protected function createButtons ( buttons : uint, selectedButton : uint = 1 ) : void
		{
			if( buttons > 0 )
			{
				var panel : Panel = new Panel();
				panel.styleKey = "DialogButtonsPanel";
				panel.childrenLayout = new InlineLayout( panel, 4, "right", "center" );
				
				if( buttons & CANCEL_BUTTON )
				{
					_cancelButton = new Button( new ProxyAction( cancel, _("Cancel") ) );
					panel.addComponent( _cancelButton );
					_buttons.push( _cancelButton );
					
					FEATURES::KEYBOARD_CONTEXT { 
						_keyboardContext[ KeyStroke.getKeyStroke( Keys.ESCAPE ) ] = new ProxyCommand( _cancelButton.click, true );
					} 
					
					if( selectedButton == CANCEL_BUTTON )
					{
						_cancelButton.selected = true;
						FEATURES::KEYBOARD_CONTEXT { 
							_keyboardContext[ KeyStroke.getKeyStroke( Keys.ENTER ) ] = new ProxyCommand( _cancelButton.click, true );
						} 
					}
				}
				if( buttons & NO_BUTTON )
				{
					_noButton = new Button( new ProxyAction( no, _("No") ) );
					panel.addComponent( _noButton );
					_buttons.push( _noButton );
					
					if( selectedButton == NO_BUTTON )
					{
						_noButton.selected = true;
						FEATURES::KEYBOARD_CONTEXT { 
							_keyboardContext[ KeyStroke.getKeyStroke( Keys.ENTER ) ] = new ProxyCommand( _noButton.click, true );
						} 
					}
				}
				if( buttons & YES_BUTTON )
				{
					_yesButton = new Button( new ProxyAction( yes, _("Yes") ) );
					panel.addComponent( _yesButton );
					_buttons.push( _yesButton );
					
					if( selectedButton == YES_BUTTON )
					{
						_yesButton.selected = true;
						FEATURES::KEYBOARD_CONTEXT { 
							_keyboardContext[ KeyStroke.getKeyStroke( Keys.ENTER ) ] = new ProxyCommand( _yesButton.click, true );
						} 
					}
				}
				
				if( buttons & OK_BUTTON )
				{
					_okButton = new Button( new ProxyAction( ok, _("Validate") ) );
					panel.addComponent( _okButton );
					_buttons.push( _okButton );
					
					if( selectedButton == OK_BUTTON )
					{
						_okButton.selected = true;
						FEATURES::KEYBOARD_CONTEXT { 
							_keyboardContext[ KeyStroke.getKeyStroke( Keys.ENTER ) ] = new ProxyCommand( _okButton.click, true );
						} 
					}
				}
				if( buttons & CLOSE_BUTTON )
				{
					_closeButton = new Button( new ProxyAction( close, _("Close") ) );
					panel.addComponent( _closeButton );
					_buttons.push( _closeButton );
					
					if( selectedButton == CLOSE_BUTTON )
					{
						_closeButton.selected = true;
						FEATURES::KEYBOARD_CONTEXT { 
							_keyboardContext[ KeyStroke.getKeyStroke( Keys.ENTER ) ] = new ProxyCommand( _closeButton.click, true );
						} 
					}
				}
				
				windowStatus = panel;
			}
		}
		protected function cancel () : void
		{
			checkPolicy();
			fireDialogRespondedSignal( RESULTS_CANCEL );
		}
		
		protected function checkPolicy () : void
		{
			if( _closePolicy == CLOSE_ON_RESULT )
				close();
		}

		protected function ok () : void
		{
			checkPolicy();
			fireDialogRespondedSignal( RESULTS_OK );
		}
		protected function no () : void
		{
			checkPolicy();
			fireDialogRespondedSignal( RESULTS_NO );
		}
		protected function yes () : void
		{
			checkPolicy();
			fireDialogRespondedSignal( RESULTS_YES );
		}

		protected function fireDialogRespondedSignal ( result : uint ) : void
		{
			dialogResponded.dispatch( this, result );
		}
	}
}

/**
 * @license
 */
package aesia.com.ponents.text 
{
	import aesia.com.mands.ProxyCommand;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Keys;
	import aesia.com.ponents.completion.AutoCompletion;
	import aesia.com.ponents.completion.InputMemory;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.forms.FormComponentDisabledModes;
	import aesia.com.ponents.menus.CompletionDropDown;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	[Event(name="dataChange", type="aesia.com.ponents.events.ComponentEvent")]
	public class TextInput extends AbstractTextComponent 
	{
		protected var _displayAsPassword : Boolean;

		public function TextInput ( maxChars : int = 0, 
									password : Boolean = false, 
									id : String = null,
									showLastValueAtStartup : Boolean = false
								  )
		{
			super();
			_label.maxChars = maxChars;
			_displayAsPassword = _label.displayAsPassword = password;
			
			/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.ENTER ) ] = new ProxyCommand( comfirmInput );
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.ESCAPE ) ] = new ProxyCommand( cancelInput );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			/*FDT_IGNORE*/ FEATURES::AUTOCOMPLETION { /*FDT_IGNORE*/
				/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
					if( id )
						this.id = id;
					if( _autoComplete && _autoComplete is InputMemory )
						( _autoComplete as InputMemory ).showLastValue = true;
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
				/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/					_keyboardContext[ KeyStroke.getKeyStroke( Keys.UP ) ] = new ProxyCommand( up );					_keyboardContext[ KeyStroke.getKeyStroke( Keys.DOWN ) ] = new ProxyCommand( down );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		
		public function get maxChars () : int { return _label.maxChars; }
		public function set maxChars ( m : int ) : void 
		{ 
			_label.maxChars = m; 
		}
		
		public function get password () : Boolean { return _displayAsPassword; }
		public function set password ( m : Boolean ) : void 
		{ 
			_displayAsPassword = _label.displayAsPassword = m; 
		}
		
		/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY /*FDT_IGNORE*/
		override public function set id (id : String) : void 
		{
			super.id = id;
			if( id == null )
			{
				if( autoComplete )
					autoComplete = null;
			}
			else
			{
				if( autoComplete  )
				{
					if( autoComplete is InputMemory )
					{
						var mem : InputMemory = autoComplete as InputMemory;
						mem.id = id;
					}
				}
				else
					this.autoComplete = new InputMemory( this, id );
			}
		}
		override protected function registerToOnStageEvents () : void 
		{
			super.registerToOnStageEvents( );
			
			/*FDT_IGNORE*/ FEATURES::AUTOCOMPLETION { /*FDT_IGNORE*/
				_label.addEventListener( KeyboardEvent.KEY_UP, keyUp );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}

		override protected function unregisterFromOnStageEvents () : void 
		{
			super.unregisterFromOnStageEvents( );
			
			/*FDT_IGNORE*/ FEATURES::AUTOCOMPLETION { /*FDT_IGNORE*/
				_label.removeEventListener( KeyboardEvent.KEY_UP, keyUp );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}

		override protected function affectTextValue () : void
		{
			if( _enabled )
			{
				_label.text = String( _value );
				_label.displayAsPassword = _displayAsPassword;			}
			else
			{
				if( _disabledMode != FormComponentDisabledModes.NORMAL )
				{
					_label.text = String( _disabledValue );
					_label.displayAsPassword = false;
				}
				else
				{
					_label.text = String( _disabledValue );
					_label.displayAsPassword = _displayAsPassword;
				}
			}
		}
		override public function registerValue ( e : Event = null ) : void
		{
			if( _label && _enabled )
				_value = _label.text;
				
			/*FDT_IGNORE*/ FEATURES::SPELLING { /*FDT_IGNORE*/
				checkContent();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		public function comfirmInput ( e : Event = null ) : void
		{
			/*FDT_IGNORE*/ FEATURES::AUTOCOMPLETION { /*FDT_IGNORE*/
			if( _autoCompleteDropDown && _autoCompleteDropDown.displayed )
			{
				if(_autoCompleteDropDown.hasSelection)
				{
					_autoCompleteDropDown.validateCompletion();
					return;
				}
				else
					_autoCompleteDropDown.hide();
			}
			/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
				if( _autoComplete is InputMemory )
				  ( _autoComplete as InputMemory ).registerCurrent();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
			registerValue();
			//StageUtils.stage.focus = null;
			fireDataChange();
			focusNext();
		}
		public function cancelInput () : void
		{
			/*FDT_IGNORE*/ FEATURES::AUTOCOMPLETION { /*FDT_IGNORE*/
			if( _autoCompleteDropDown )
			{
				_autoCompleteDropDown.hide();
				replaceSelectedText("");
			}
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}

		/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
		override public function mouseOver (e : MouseEvent) : void
		{
			if( _label.textWidth > _label.width ||
				_label.textWidth > width )
			{
				_tooltip = _enabled ? _value : _disabledValue;
			}
			else
			{
				_tooltip = "";	
			}
			super.mouseOver( e );
		}
		
		override public function mouseOut (e : MouseEvent) : void
		{
			super.mouseOut( e );
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		/*FDT_IGNORE*/ FEATURES::AUTOCOMPLETION { /*FDT_IGNORE*/
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
		protected function up () : void
		{
			if( _autoCompleteDropDown )
				_autoCompleteDropDown.up();
			grabFocus();
		}
		protected function down () : void
		{
			if( _autoCompleteDropDown )
				_autoCompleteDropDown.down();
			grabFocus();
		}
		protected function keyUp (event : KeyboardEvent) : void
		{
			if( _autoComplete )
			{ 
				switch ( event.keyCode )
				{
					case Keys.DOWN : 
					case Keys.UP :
						if( _autoComplete.last )
						{
							var index : Number = _autoComplete.last.length;
							setSelection( index, _label.length );
						}
						break;
					default : 
						break;
				}
			}
		}	
		override public function keyFocusChange (e : FocusEvent) : void
		{
			super.keyFocusChange( e );
			if( _autoCompleteDropDown )
			{
				_autoCompleteDropDown.hide();
				replaceSelectedText("");
			}
		}	
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		protected function fireDataChange () : void 
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.DATA_CHANGE ) );
		}
	}
}

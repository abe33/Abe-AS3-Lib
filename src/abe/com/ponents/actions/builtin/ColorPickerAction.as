/**
 * @license
 */
package abe.com.ponents.actions.builtin 
{
	import abe.com.mands.events.CommandEvent;
	import abe.com.mon.core.Cancelable;
	import abe.com.mon.colors.Color;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.AbstractAction;
	import abe.com.ponents.containers.Dialog;
	import abe.com.ponents.core.edit.Editable;
	import abe.com.ponents.core.edit.Editor;
	import abe.com.ponents.events.DialogEvent;
	import abe.com.ponents.skinning.icons.ColorIcon;

	import flash.display.DisplayObject;
	import flash.events.Event;
	/**
	 * @author Cédric Néhémie
	 */
	public class ColorPickerAction extends AbstractAction implements Cancelable, Editor
	{
		protected var _color : Color;
		protected var _cancelled : Boolean;
		protected var _dial : Dialog;
		protected var _caller : Editable;

		public function ColorPickerAction ( color : Color = null, accelerator : KeyStroke = null)
		{
			if( !color )
				color = Color.Black;
			
			if( !color.name || color.name == "" )
				_color = color;
			else
				_color = color.clone();
			super( _("ColorPicker"), new ColorIcon(_color), _("Edit current color"), accelerator );
		}
		
		public function get color () : Color { return _color; }		
		public function set color (color : Color) : void
		{
			if( !color.name || color.name == "" )
				_color = color;
			else
				_color = color.clone();
			
			if( _color )
			{
				( _icon as ColorIcon ).color = _color;
				firePropertyEvent( "icon", _icon );
			}
		}
		public function get value () : * { return _color; }
		public function set value (v : *) : void
		{
			this.color = v;
		}
		
		public function get caller () : Editable { return _caller; }
		public function set caller (e : Editable) : void
		{
			_caller = e;
		}
		
		override public function execute( ... args ) : void
		{
			_cancelled = false;
			
			ColorEditorInstance.target = _color;
			
			_dial = new Dialog( _("Edit Color"), 3, ColorEditorInstance );
			_dial.addEventListener(DialogEvent.DIALOG_RESULT, dialogResult );
			_dial.open();
		}
		
		public function initEditState (caller : Editable, value : *, overlayTarget : DisplayObject = null) : void
		{
			this.value = value.clone();
			this.caller = caller;
			this.execute();
		}
				
		private function dialogResult (event : DialogEvent) : void
		{
			switch( event.result )
			{
				case Dialog.RESULTS_OK : 
					_color.red = ColorEditorInstance.target.red;
					_color.alpha = ColorEditorInstance.target.alpha;
					_color.blue = ColorEditorInstance.target.blue;
					_color.green = ColorEditorInstance.target.green;
					firePropertyEvent( "icon", _icon );
					fireCommandEnd();
					
					if( _caller )
						_caller.confirmEdit();
					
					break;
				default : 
					fireCommandCancelled();
					break;
			}
			_dial.close();
			_dial.removeEventListener(DialogEvent.DIALOG_RESULT, dialogResult );
			_dial = null;		
		}
		
		public function cancel () : void
		{
			_dial.close();
			_dial.removeEventListener(DialogEvent.DIALOG_RESULT, dialogResult );
			_dial = null;		
			_cancelled = true;
			fireCommandCancelled();
			
			if( _caller )
				_caller.cancelEdit();
		}

		public function isCancelled () : Boolean
		{
			return _cancelled;
		}
		protected function fireCommandCancelled () : void
		{
			dispatchEvent( new CommandEvent(CommandEvent.COMMAND_CANCEL) );
		}
	}
}

import abe.com.ponents.tools.ColorEditor;

internal const ColorEditorInstance : ColorEditor = new ColorEditor();
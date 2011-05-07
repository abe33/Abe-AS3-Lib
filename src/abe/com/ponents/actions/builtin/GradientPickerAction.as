/**
 * @license
 */
package abe.com.ponents.actions.builtin 
{
	import abe.com.mands.events.CommandEvent;
	import abe.com.mon.colors.Color;
	import abe.com.mon.colors.Gradient;
	import abe.com.mon.core.Cancelable;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.AbstractAction;
	import abe.com.ponents.containers.Dialog;
	import abe.com.ponents.events.DialogEvent;
	import abe.com.ponents.skinning.icons.GradientIcon;

	import flash.events.Event;
	/**
	 * @author Cédric Néhémie
	 */
	
	public class GradientPickerAction extends AbstractAction implements Cancelable
	{
		protected var _gradient : Gradient;
		protected var _cancelled : Boolean;
		protected var _dial : Dialog;

		public function GradientPickerAction ( gradient : Gradient = null, accelerator : KeyStroke = null)
		{
			_gradient = gradient ?  gradient : new Gradient([Color.Black, Color.White],[0,1],_("Unnamed Gradient") ) ;
			super( _("GradientPicker"), new GradientIcon(_gradient), _("Edit current gradient"), accelerator );
		}
		public function get gradient () : Gradient { return _gradient; }		
		public function set gradient (gradient : Gradient) : void
		{
			_gradient = gradient;
		}
		override public function execute (e : Event = null) : void
		{
			_cancelled = false;
			GradientEditorInstance.target = _gradient;
			
			_dial = new Dialog( _("Edit Gradient"), 3, GradientEditorInstance );
			_dial.addEventListener(DialogEvent.DIALOG_RESULT, dialogResult );
			_dial.open();
		}
		private function dialogResult (event : DialogEvent) : void
		{
			switch( event.result )
			{
				case Dialog.RESULTS_OK : 
					_gradient.colors = GradientEditorInstance.target.colors;
					_gradient.positions = GradientEditorInstance.target.positions;
					firePropertyEvent( "icon", _icon );
					fireCommandEnd();
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

import abe.com.ponents.tools.GradientEditor;

internal const GradientEditorInstance : GradientEditor = new GradientEditor();
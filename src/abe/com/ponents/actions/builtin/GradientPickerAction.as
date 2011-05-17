/**
 * @license
 */
package abe.com.ponents.actions.builtin 
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.colors.Gradient;
	import abe.com.mon.core.Cancelable;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.AbstractAction;
	import abe.com.ponents.containers.Dialog;
	import abe.com.ponents.events.DialogEvent;
	import abe.com.ponents.skinning.icons.GradientIcon;

	import org.osflash.signals.Signal;
	/**
	 * @author Cédric Néhémie
	 */
	
	public class GradientPickerAction extends AbstractAction implements Cancelable
	{
		protected var _gradient : Gradient;
		protected var _cancelled : Boolean;
		protected var _dial : Dialog;
		
		protected var _commandCancelled : Signal;

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
		override public function execute( ... args ) : void
		{
			_cancelled = false;
			_isRunning = true;
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
					propertyChanged.dispatch( "icon", _icon );
					commandEnded.dispatch( this );
					break;
					
				default :
					commandCancelled.dispatch( this ); 
					break;
			}
			_isRunning = false;
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
			_isRunning = false;
			commandCancelled.dispatch( this );
		}
		public function isCancelled () : Boolean
		{
			return _cancelled;
		}
		public function get commandCancelled () : Signal
		{
			return _commandCancelled;
		}
	}
}

import abe.com.ponents.tools.GradientEditor;

internal const GradientEditorInstance : GradientEditor = new GradientEditor();

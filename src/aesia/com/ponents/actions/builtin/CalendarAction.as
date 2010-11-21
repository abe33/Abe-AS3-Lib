/**
 * @license
 */
package aesia.com.ponents.actions.builtin 
{
	import aesia.com.mands.events.CommandEvent;
	import aesia.com.mon.core.Cancelable;
	import aesia.com.mon.utils.DateUtils;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.containers.Dialog;
	import aesia.com.ponents.events.DialogEvent;
	import aesia.com.ponents.skinning.icons.Icon;

	import flash.events.Event;

	/**
	 * @author Cédric Néhémie
	 */
	public class CalendarAction extends AbstractAction implements Cancelable
	{
		protected var _date : Date;
		protected var _dateFormat : String;
		protected var _cancelled : Boolean;
		protected var _dial : Dialog;
		
		public function CalendarAction ( date : Date, dateFormat : String = "d/m/Y", icon : Icon = null, accelerator : KeyStroke = null)
		{
			_date = date;
			_dateFormat = dateFormat;
			super( DateUtils.format(_date, _dateFormat ), icon, _("Change date"), accelerator );
		}

		override public function execute (e : Event = null) : void
		{
			_cancelled = false;
			CalendarInstance.date = DateUtils.cloneDate(_date);
			
			_dial = new Dialog( _("Select Date"), 3, CalendarInstance );
			_dial.addWeakEventListener(DialogEvent.DIALOG_RESULT, dialogResult );
			_dial.open();
		}
		private function dialogResult (event : DialogEvent) : void
		{
			switch( event.result )
			{
				case Dialog.RESULTS_OK : 
					_date = CalendarInstance.date;
					name = DateUtils.format( _date, _dateFormat );
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

		public function get date () : Date { return _date; }		
		public function set date (date : Date) : void
		{
			_date = date;
			name = DateUtils.format( _date, _dateFormat );
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

import aesia.com.ponents.tools.Calendar;

internal const CalendarInstance : Calendar = new Calendar();
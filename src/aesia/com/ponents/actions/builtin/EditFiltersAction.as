package aesia.com.ponents.actions.builtin
{
	import aesia.com.mands.events.CommandEvent;
	import aesia.com.mon.core.Cancelable;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Reflection;
	import aesia.com.mon.utils.magicClone;
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.containers.Dialog;
	import aesia.com.ponents.events.DialogEvent;
	import aesia.com.ponents.skinning.icons.Icon;

	import flash.events.Event;

	/**
	 * @author cedric
	 */
	public class EditFiltersAction extends AbstractAction implements Cancelable
	{
		protected var _filters : Array;
		protected var _cancelled : Boolean;
		protected var _dial : Dialog;

		public function EditFiltersAction ( filters : Array, icon : Icon = null,  accelerator : KeyStroke = null)
		{
			this._filters = filters;
			super( _("Filters"), icon, _("Edit Filters"), accelerator );
		}

		public function get filters () : Array { return _filters; }
		public function set filters (filters : Array) : void
		{
			_filters = filters;
			updateName();
		}

		protected function updateName () : void
		{
			name = _$( _("Filters : $0"), filters.map( function( o:*, ... args ) : String { return Reflection.getClassName( o ); } ).join(", ") );
		}

		override public function execute (e : Event = null) : void
		{
			_cancelled = false;

			FilterEditorPaneInstance.value = magicClone( _filters );

			_dial = new Dialog( _("Edit Filters"), 3, FilterEditorPaneInstance );
			_dial.addEventListener(DialogEvent.DIALOG_RESULT, dialogResult );
			_dial.open();
		}
		private function dialogResult (event : DialogEvent) : void
		{
			switch( event.result )
			{
				case Dialog.RESULTS_OK :
					_filters = FilterEditorPaneInstance.value;
					updateName ();
					//firePropertyEvent( "icon", _icon );
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
import aesia.com.ponents.tools.FilterEditorPane;

internal const FilterEditorPaneInstance : FilterEditorPane = new FilterEditorPane();
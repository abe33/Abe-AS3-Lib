package abe.com.ponents.actions.builtin
{
	import abe.com.mands.events.CommandEvent;
	import abe.com.mon.core.Cancelable;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.mon.utils.Reflection;
	import abe.com.mon.utils.magicClone;
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.actions.AbstractAction;
	import abe.com.ponents.containers.Dialog;
	import abe.com.ponents.events.DialogEvent;
	import abe.com.ponents.skinning.icons.Icon;

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
			updateName();
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

import abe.com.ponents.tools.FilterEditorPane;

internal const FilterEditorPaneInstance : FilterEditorPane = new FilterEditorPane();

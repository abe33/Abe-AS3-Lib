/**
 * @license
 */
package aesia.com.ponents.actions.builtin 
{
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.StringUtils;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.actions.AbstractTerminalAction;
	import aesia.com.ponents.events.PropertyEvent;
	import aesia.com.ponents.events.UndoManagerEvent;
	import aesia.com.ponents.history.UndoManager;

	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenuItem;

	/**
	 * @author Cédric Néhémie
	 */
	public class RedoAction extends AbstractTerminalAction
	{
		protected var _manager : UndoManager;
		public function RedoAction ( accelerator : KeyStroke, manager : UndoManager )
		{
			super( _("Redo last operation"), null, _("Redo the last undone operation"), "redo", "redo", _("Redo the last undone operation."), null, accelerator );
			_manager = manager;
			_manager.addEventListener( UndoManagerEvent.UNDO_DONE, undoDone );
			_manager.addEventListener( UndoManagerEvent.REDO_DONE, redoDone );
			_manager.addEventListener( UndoManagerEvent.UNDO_ADD, undoAdd );			_manager.addEventListener( UndoManagerEvent.UNDO_REMOVE, undoRemove );
			actionEnabled = _manager.canRedo;
		}

		protected function checkUndoState () : void 
		{
			actionEnabled = _manager.canRedo;
			if( actionEnabled )
				name = StringUtils.tokenReplace( _( "Redo $0" ), _manager.redoObject.label );
			else
				name = _( "Redo last operation" );
		}
		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
		public function get contextMenuItem () : ContextMenuItem
		{
			var cmredo : ContextMenuItem = new ContextMenuItem( name, false, false );
			cmredo.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, execute );
			addEventListener(PropertyEvent.PROPERTY_CHANGE, 
			function( e : PropertyEvent ) : void
			{
				switch( e.propertyName ) 
				{
					case "name" : 
						cmredo.caption = e.propertyValue;
						break;
					case "actionEnabled" : 
						cmredo.enabled = e.propertyValue;
						break;
					default : break;
				}
			});
			return cmredo;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		protected function undoRemove (event : UndoManagerEvent) : void 
		{
			checkUndoState();
		}
		protected function undoAdd (event : UndoManagerEvent) : void
		{
			checkUndoState();
		}
		protected function redoDone (event : UndoManagerEvent) : void
		{
			checkUndoState();
		}
		protected function undoDone (event : UndoManagerEvent) : void
		{
			checkUndoState();
		}
	
		override public function execute (e : Event = null) : void
		{
			_manager.redo();
		}
	}
}

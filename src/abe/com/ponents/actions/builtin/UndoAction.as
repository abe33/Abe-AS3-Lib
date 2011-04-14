/**
 * @license
 */
package abe.com.ponents.actions.builtin 
{
	import abe.com.mon.utils.KeyStroke;
	import abe.com.mon.utils.StringUtils;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.AbstractAction;
	import abe.com.ponents.events.PropertyEvent;
	import abe.com.ponents.events.UndoManagerEvent;
	import abe.com.ponents.history.UndoManager;
	import abe.com.ponents.skinning.icons.magicIconBuild;

	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenuItem;
	/**
	 * @author Cédric Néhémie
	 */
	public class UndoAction extends AbstractAction
	{
		[Embed(source="../../skinning/icons/undo.png")]
		static public var iconClass : Class;
		
		protected var _manager : UndoManager;
		
		public function UndoAction ( accelerator : KeyStroke, manager : UndoManager )
		{
			super( _("Undo last operation"), magicIconBuild(iconClass), null, accelerator );
			_manager = manager;
			_manager.addEventListener( UndoManagerEvent.UNDO_DONE, undoDone );
			_manager.addEventListener( UndoManagerEvent.REDO_DONE, redoDone );
			_manager.addEventListener( UndoManagerEvent.UNDO_ADD, undoAdd );			_manager.addEventListener( UndoManagerEvent.UNDO_REMOVE, undoRemove );
			actionEnabled = _manager.canUndo;
		}
		protected function checkUndoState () : void 
		{			
			actionEnabled = _manager.canUndo;
			if( actionEnabled )
				name = StringUtils.tokenReplace( _( "Undo $0" ), _manager.undoObject.label );
			else
				name = _( "Undo last operation" );
		}
		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
		public function get contextMenuItem () : ContextMenuItem
		{
			var cmundo : ContextMenuItem = new ContextMenuItem( name, false, false );
			cmundo.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, execute );
			addEventListener(PropertyEvent.PROPERTY_CHANGE, 
			function( e : PropertyEvent ) : void
			{
				switch( e.propertyName ) 
				{
					case "name" : 
						cmundo.caption = e.propertyValue;
						break;
					case "actionEnabled" : 
						cmundo.enabled = e.propertyValue;
						break;
					default : break;
				}
			});
			return cmundo;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
		protected function undoRemove (event : UndoManagerEvent) : void 
		{
			checkUndoState ();
		}

		protected function undoAdd (event : UndoManagerEvent) : void
		{
			checkUndoState ();
		}
	
		protected function redoDone (event : UndoManagerEvent) : void
		{
			checkUndoState ();
		}
	
		protected function undoDone (event : UndoManagerEvent) : void
		{
			checkUndoState ();
		}
	
		override public function execute( ... args ) : void
		{
			_manager.undo();
		}
	}
}

/**
 * @license
 */
package abe.com.ponents.actions.builtin 
{
	import abe.com.mon.utils.KeyStroke;
	import abe.com.mon.utils.StringUtils;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.AbstractAction;
	import abe.com.ponents.history.UndoManager;
	import abe.com.ponents.history.Undoable;
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
			_manager.undoDone.add( undoDone );
			_manager.redoDone.add( redoDone );
			_manager.undoAdded.add( undoAdded );
			_manager.undoRemoved.add( undoRemoved );
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
		protected var _contextMenuItem : ContextMenuItem;
		public function get contextMenuItem () : ContextMenuItem
		{
			if( !_contextMenuItem )
			{
				_contextMenuItem = new ContextMenuItem( name, false, false );
				_contextMenuItem.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, execute );
				propertyChanged.add( onPropertyChanged );
			}
			return _contextMenuItem;
		}
		protected function onPropertyChanged( propertyName:String, propertyValue:* ) : void
		{
			switch( propertyName ) 
			{
				case "name" : 
					_contextMenuItem.caption = propertyValue;
					break;
				case "actionEnabled":
					_contextMenuItem.enabled = propertyValue;
					break;
				default : break;
			}
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		protected function undoRemoved () : void 
		{
			checkUndoState();
		}
		protected function undoAdded ( edit : Undoable ) : void
		{
			checkUndoState();
		}
		protected function redoDone ( edit : Undoable ) : void
		{
			checkUndoState();
		}
		protected function undoDone ( edit : Undoable ) : void
		{
			checkUndoState();
		}
	
		override public function execute( ... args ) : void
		{
			_manager.undo();
			super.execute.apply( this, args );
		}
	}
}

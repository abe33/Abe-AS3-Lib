/**
 * @license
 */
package aesia.com.ponents.history 
{
	import aesia.com.ponents.events.UndoManagerEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="redoDone",type="aesia.com.ponents.events.UndoManagerEvent")]		[Event(name="undoDone",type="aesia.com.ponents.events.UndoManagerEvent")]		[Event(name="undoAdd",type="aesia.com.ponents.events.UndoManagerEvent")]		[Event(name="undoRemove",type="aesia.com.ponents.events.UndoManagerEvent")]	
	public class UndoManager extends EventDispatcher
	{
		protected var _undoLimit : Number;
		
		/*FDT_IGNORE*/
		TARGET::FLASH_9		protected var _edits : Array;
				TARGET::FLASH_10		protected var _edits : Vector.<Undoable>;
		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/		protected var _edits : Vector.<Undoable>;
		
		protected var _undoCursor : Number;

		public function UndoManager ( limit : Number = 0 )
		{
			_undoLimit = limit == 0 ? Number.POSITIVE_INFINITY : limit;
			removeAll ();
		}

		public function get undoObject () : Undoable
		{
			if( canUndo )
			{
				var edit : Undoable;
				var c : Number = _undoCursor;
				do
				{
					if( c == 0 )
						return null;
					
					edit = _edits[ --c ];
				}
				while( !edit.isSignificant );
				return edit;
			}
			else return null;
		}
		public function get redoObject () : Undoable
		{
			if( canRedo )
			{
				var edit : Undoable;
				var c : Number = _undoCursor;
				edit = _edits[ c ];
				do
				{
					if( c+1 < _edits.length )
						edit = _edits[ ++c ];
					else
						break;
				}
				while( !edit.isSignificant );
				return edit;
			}
			else return null;
		} 
		
		public function add ( edit : Undoable ) : void
		{
			if( _undoCursor < _edits.length )
				_edits.splice( _undoCursor, _edits.length - _undoCursor );
				
			if( _edits.length + 1 > _undoLimit )
				_edits.shift();
			_edits.push( edit );
			_undoCursor = _edits.length;
			
			fireUndoManagerEvent( UndoManagerEvent.UNDO_ADD );
		}
		public function removeAll () : void 
		{
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { _edits = []; }			TARGET::FLASH_10 { _edits = new Vector.<Undoable>( ); }			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			_edits = new Vector.<Undoable>();/*FDT_IGNORE*/ } /*FDT_IGNORE*/ 
			
			_undoCursor = 0;
			fireUndoManagerEvent( UndoManagerEvent.UNDO_REMOVE );
		}
		
		public function undo() : void
		{
			if( canUndo )
			{
				var edit : Undoable;
				do
				{
					if( _undoCursor == 0 )
						return;
					
					edit = _edits[ --_undoCursor ];
										
					if( edit.canUndo )
						edit.undo();
				}
				while( !edit.isSignificant );
				fireUndoManagerEvent( UndoManagerEvent.UNDO_DONE );
			}
		}
	
		public function redo() : void
		{
			if( canRedo )
			{
				var edit : Undoable;
				edit = _edits[ _undoCursor ];
				do
				{
					if( edit.canRedo )
						edit.redo();
					
					if( _undoCursor+1 < _edits.length )
						edit = _edits[ ++_undoCursor ];
					else
					{
						_undoCursor = _edits.length;
						break;
					}
				}
				while( !edit.isSignificant );
				fireUndoManagerEvent( UndoManagerEvent.REDO_DONE );
			}
		}
		public function get canUndo () : Boolean
		{
			return _undoCursor > 0;
		}

		public function get canRedo () : Boolean
		{
			return _undoCursor < _edits.length;
		}
		protected function fireUndoManagerEvent ( type : String ) : void
		{
			dispatchEvent( new UndoManagerEvent( type ) );
		}
		override public function dispatchEvent( evt : Event) : Boolean 
		{
		 	if (hasEventListener(evt.type) || evt.bubbles) 
		  		return super.dispatchEvent(evt);
		 	return true;
		}
	}
}

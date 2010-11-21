/** * @license */package aesia.com.ponents.history {
	/**
	 * @author Cédric Néhémie
	 */
	public class AbstractUndoable implements Undoable	{		protected var _undoDone : Boolean;		protected var _label : String;
		public function undo () : void		{			_undoDone = true;		}		public function redo () : void		{			_undoDone = false;		}				public function get canUndo () : Boolean		{			return !_undoDone;		}				public function get canRedo () : Boolean		{			return _undoDone;		}				public function get isSignificant () : Boolean		{			return true;		}				public function get label () : String		{
			return _label;		}	}
}

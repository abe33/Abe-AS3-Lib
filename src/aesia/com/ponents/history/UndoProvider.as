package aesia.com.ponents.history 
{

	/**
	 * @author Cédric Néhémie
	 */
	public interface UndoProvider 
	{
		function get undoManager () : UndoManager;
		function set undoManager ( s : UndoManager ) : void;
	}
}

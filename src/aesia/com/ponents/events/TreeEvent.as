package aesia.com.ponents.events {
	import aesia.com.ponents.models.TreePath;	/**
	 * @author Cédric Néhémie
	 */
	public class TreeEvent extends ListEvent 	{		public var path : TreePath;
		public function TreeEvent ( type : String, action : uint, path : TreePath, bubbles : Boolean = false, cancelable : Boolean = false)		{
			super( type, action, null, null, bubbles, cancelable );			this.path = path;
		}	}
}

package abe.com.ponents.models 
	import abe.com.ponents.events.ComponentEvent;
	public class TreeModel extends EventDispatcher implements ListModel
/*-----------------------------------------------------------------------
		public function get root () : TreeNode { return _root; }
		public function get showRoot () : Boolean { return _showRoot; }		
		protected function fireDataChange ( action : uint = 0, indices : Array = null, elements : Array = null ) : void
}
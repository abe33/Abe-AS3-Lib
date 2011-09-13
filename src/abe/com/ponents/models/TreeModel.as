package abe.com.ponents.models {    import org.osflash.signals.Signal;	public class TreeModel implements ListModel	{		protected var _root : TreeNode;		protected var _listData : Array;		protected var _showRoot : Boolean;		protected var _contentType : Class;				protected var _dataChanged : Signal;		public function get dataChanged () : Signal { return _dataChanged; }		public function TreeModel ( root : TreeNode = null )		{		    _dataChanged = new Signal();			_listData = [];			_showRoot = true;			_root = root ? root : new TreeNode();			registerToTreeNodeEvents( _root );			buildData();		}		/*----------------------------------------------------------------------- * GETTER SETTER *----------------------------------------------------------------------*/				public function get root () : TreeNode { return _root; }						public function get showRoot () : Boolean { return _showRoot; }				public function set showRoot (showRoot : Boolean) : void		{			_showRoot = showRoot;			buildData();		}				public function get expandableRoot () : Boolean { return _root.expandable; }				public function set expandableRoot (expandableRoot : Boolean) : void		{			_root.expandable = expandableRoot;			if(!_root.expandable)				_root.expanded = true;			buildData();		}		public function get contentType () : Class { return _contentType; }		public function set contentType (contentType : Class) : void		{			_contentType = contentType;		}		/*----------------------------------------------------------------------- * EVENTS HANDLING *----------------------------------------------------------------------*/				protected function fireDataChangedSignal ( action : uint = 0, indices : Array = null, elements : Array = null ) : void		{			_dataChanged.dispatch( action, indices, elements );		}		protected function treeDataChanged ( a : uint, p : TreePath ) : void		{			buildData();		}		protected function registerToTreeNodeEvents ( o : TreeNode ) : void		{			if( o )				o.dataChanged.add( treeDataChanged );		}		protected function unregisterToTreeNodeEvents ( o : TreeNode ) : void		{			if( o )				o.dataChanged.remove( treeDataChanged );		}				/*----------------------------------------------------------------------- * LIST MODEL IMPLEMENTATION *----------------------------------------------------------------------*/		protected function buildData () : void		{			var a : Array = [];			var n : uint = _listData.length;						if( _showRoot )				a.push( _root );							if( _root.expanded )				insertChildren ( _root, a, 1 );							_listData = a;						var start : uint = Math.min( n, _listData.length );			var end : uint = Math.max( n, _listData.length );			var indices : Array = [];			for( var i:uint = start; i < end;i++)				indices.push(i);						fireDataChangedSignal( n < _listData.length ? DefaultListModel.ADD : DefaultListModel.REMOVE, indices );		}		protected function insertChildren ( node : TreeNode, a : Array, index : int ) : int		{			var n : TreeNode;		 	if( index >= a.length )		 	{		 		for each( n in node.children )		 		{		 			a.push( n );		 			index = a.length;					if( !n.isLeaf && n.expanded )		 				insertChildren( n, a , index );		 		}		 		index = a.length;			 	}		 	else		 	{		 		for each( n in node.children )		 		{		 			a.splice( index++, 0, n );		 			if( !n.isLeaf && n.expanded )		 				index = insertChildren( n, a , index );				 		} 			}		 	return index;		}				public function get size () : uint { return _listData.length; }				public function getElementAt (id : uint) : *		{			if( id < _listData.length )				return _listData[ id ];			else				return null;		}		public function setElementAt ( id : uint, el : * ) : void		{			(_listData[ id ] as TreeNode ).userObject = el;		}		public function addElement (el : *) : void {}		public function addElementAt (el : *, id : uint) : void {}		public function removeElement (el : *) : void {}		public function removeElementAt (id : uint) : void {}				public function contains (el : *) : Boolean		{			return _listData.indexOf( el ) != -1;		}		public function indexOf (el : *) : int		{			return _listData.indexOf( el );		}				public function lastIndexOf (el : *) : int		{			return _listData.lastIndexOf( el );		}				public function sort (...args : *) : Array		{			return null;		}				public function sortOn (fieldName : Object, options : Object = null) : Array		{			return null;		}				public function toArray () : Array		{			return null;		}				public function setElementIndex (el : *, id : uint) : void		{		}	}}
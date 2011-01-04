package aesia.com.ponents.models {
	import aesia.com.mon.utils.Reflection;	/**
	 * @author Cédric Néhémie
	 */
	public class TreePath 	{		static public function pathTo ( node : TreeNode ) : TreePath		{			var n : TreeNode = node;						/*FDT_IGNORE*/			TARGET::FLASH_9 { var p : Array = [ n ]; }			TARGET::FLASH_10 { var p : Vector.<TreeNode> = Vector.<TreeNode> ( [ n ] ); }			TARGET::FLASH_10_1 { /*FDT_IGNORE*/			var p : Vector.<TreeNode> = Vector.<TreeNode> ( [ n ] ); /*FDT_IGNORE*/ } /*FDT_IGNORE*/						while ( n.parent != null )			{				n = n.parent;				p.push( n );			}			p.reverse();			return new TreePath( p );		}				/*FDT_IGNORE*/		TARGET::FLASH_9		protected var _path : Array;				TARGET::FLASH_10		protected var _path : Vector.<TreeNode>;				TARGET::FLASH_10_1 /*FDT_IGNORE*/		protected var _path : Vector.<TreeNode>;				public function TreePath ( ... args )		{			/*FDT_IGNORE*/			TARGET::FLASH_9 { var c : Class = Array; }			TARGET::FLASH_10 { var c : Class = Reflection.getVectorDefinition( TreeNode ); } 			TARGET::FLASH_10_1 { /*FDT_IGNORE*/			var c : Class = Reflection.getVectorDefinition( TreeNode ); /*FDT_IGNORE*/ } /*FDT_IGNORE*/						if( args.length == 1 && args[0] is c )			{				_path = args[0].concat();			}			else if( args.length > 1 )				_path = c( args );			else				_path = new c();		}		public function getLastPathNode () : TreeNode		{			return _path[ _path.length - 1 ];		}		public function getPathNode ( index : int ) : TreeNode		{				return _path[ index ];		}		public function getParentPath () : TreePath		{			/*FDT_IGNORE*/			TARGET::FLASH_9 { var p : Array =  _path.concat(); }			TARGET::FLASH_10 { var p : Vector.<TreeNode> =  _path.concat(); }			TARGET::FLASH_10_1 { /*FDT_IGNORE*/			var p : Vector.<TreeNode> =  _path.concat(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/						p.pop();			return new TreePath( p );		}		public function pathByAddingChild ( node : TreeNode ) : TreePath		{			return new TreePath( _path.concat().push( node ) );		}		public function isDescendant ( path : TreePath ) : Boolean		{			if( path.length <= length )				return false;			else			{				for( var i : Number = 0; i < length; i++ )				{					if( path.getPathNode( i ) != getPathNode( i ) )						return false;				}			}			return true;		}		public function contains ( node : TreeNode ) : Boolean		{			return _path.indexOf( node ) != -1;		}		public function clone () : TreePath { return new TreePath( path ); }				/*FDT_IGNORE*/		TARGET::FLASH_9		public function get path () : Array { return _path; }				TARGET::FLASH_10		public function get path () : Vector.<TreeNode> { return _path; }				TARGET::FLASH_10_1 /*FDT_IGNORE*/		public function get path () : Vector.<TreeNode> { return _path; }				public function get length () : uint { return _path.length;	}				public function toString() : String 		{			return "TreePath["+_path.join("->")+"]";		}	}
}

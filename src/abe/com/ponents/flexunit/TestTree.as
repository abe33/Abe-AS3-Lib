package abe.com.ponents.flexunit 
{
	import abe.com.ponents.models.DefaultListModel;
	import abe.com.ponents.models.ListModel;
	import abe.com.ponents.models.TreeModel;
	import abe.com.ponents.trees.Tree;

	import org.flexunit.runner.IDescription;
	import org.flexunit.runner.notification.Failure;
	/**
	 * @author cedric
	 */
	public class TestTree extends Tree 
	{
		protected var _failures : ListModel;
		
		public function TestTree (model : TreeModel = null)
		{
			_listCellClass = _listCellClass ? _listCellClass : TestTreeCell;			
			_failures = new DefaultListModel([]);			
			super( model );
			loseSelectionOnFocusOut = false;
			editEnabled = false;
			dndEnabled = false;
		}
		public function get failures () : ListModel { return _failures; }
		
		public function getFailuresFor( d : IDescription ) : Array
		{
			var a : Array = [];
			var f : Failure;
			var l : uint; 
			var i : uint;
			
			if( d.isSuite )
			{
				l = d.children.length;
				for( i = 0;i<l;i++ )
				{
					a = a.concat( getFailuresFor( d.children[i] ) );
				}
			}
			else
			{
				l = _failures.size;
				for( i = 0;i<l;i++ )
				{
					f = _failures.getElementAt(i);
					if( f.description.equals( d ) )
						a.push( f );
				}
			}
			return a;
		}
	}
}

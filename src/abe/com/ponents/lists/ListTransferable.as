package abe.com.ponents.lists
{
	import abe.com.ponents.history.UndoManagerInstance;
	import abe.com.ponents.transfer.ComponentsFlavors;
	import abe.com.ponents.transfer.ComponentsTransferModes;
	import abe.com.ponents.transfer.DataFlavor;
	import abe.com.ponents.transfer.Transferable;
	/**
	 * @author Cédric Néhémie
	 */
	public class ListTransferable implements Transferable 
	{
		protected var _data : *;
		protected var _mode : String;
		public var list : List;
		public var index : int;
		
		public function ListTransferable ( data : *, list : List, mode : String = "move", pos : int = 0 )
		{
			this._data = data;
			this._mode = mode;
			this.list = list;
			this.index = pos;
		}
		public function getData (flavor : DataFlavor) : *
		{
			if( ComponentsFlavors.LIST_ITEM.equals( flavor ) )
				return _data;
			else
				return null;
		}
		
		public function get flavors () : Array
		{
			return [ ComponentsFlavors.LIST_ITEM ];
		}
		public function get mode() : String
		{
			return _mode;
		}
		public function transferPerformed () : void
		{
			switch( _mode )
			{
				case ComponentsTransferModes.MOVE : 
					list.model.removeElementAt( index ); 
					UndoManagerInstance.add( new ListTransferPerformedUndoableEdit( list, _data, index ) );
					break;
				case ComponentsTransferModes.COPY : 
					break;
			}
		}
	}
}

import abe.com.ponents.history.AbstractUndoable;
import abe.com.ponents.lists.List;

internal class ListTransferPerformedUndoableEdit extends AbstractUndoable
{
	private var list : List;
	private var value : *;
	private var index : Number;

	public function ListTransferPerformedUndoableEdit ( list : List, value : *, index : Number )
	{
		this.list = list;
		this.value = value;
		this.index = index;
	}
	override public function undo () : void
	{
		list.model.addElementAt( value, index );
		super.undo();
	}
	override public function redo () : void
	{
		list.model.removeElementAt( index );
		super.redo();
	}
	override public function get isSignificant () : Boolean
	{
		return false;
	}
}

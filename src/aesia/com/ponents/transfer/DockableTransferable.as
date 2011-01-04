package aesia.com.ponents.transfer 
{
	import aesia.com.ponents.core.Dockable;
	/**
	 * @author cedric
	 */
	public class DockableTransferable implements Transferable 
	{
		protected var _dockable : Dockable;

		public function DockableTransferable ( dockable : Dockable ) 
		{
			_dockable = dockable;
		}
		public function getData (flavor : DataFlavor) : *
		{ 
			if( ComponentsFlavors.DOCKABLE.equals(flavor) )				return _dockable;
			else if( ComponentsFlavors.COMPONENT.equals(flavor) )
				return _dockable.content;
		}
		
		public function transferPerformed () : void
		{
		}
		
		public function get flavors () : Array { return [ ComponentsFlavors.DOCKABLE, ComponentsFlavors.COMPONENT ]; }		
		public function get mode () : String { return ComponentsTransferModes.MOVE; }
	}
}

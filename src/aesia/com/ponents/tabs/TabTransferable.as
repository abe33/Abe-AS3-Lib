package aesia.com.ponents.tabs 
{
	import aesia.com.ponents.core.SimpleDockable;
	import aesia.com.ponents.transfer.ComponentsFlavors;
	import aesia.com.ponents.transfer.ComponentsTransferModes;
	import aesia.com.ponents.transfer.DataFlavor;
	import aesia.com.ponents.transfer.Transferable;

	/**
	 * @author Cédric Néhémie
	 */
	public class TabTransferable implements Transferable 
	{
		protected var _tab : Tab;
		protected var _pane : TabbedPane;
		
		public function TabTransferable ( tab : Tab, pane : TabbedPane = null )
		{
			_tab = tab;
			_pane = pane;	
		}

		public function getData (flavor : DataFlavor) : *
		{
			if( flavor.equals( ComponentsFlavors.TAB ) )				return _tab;
			else if( flavor.equals( ComponentsFlavors.DOCKABLE ) )
				return new SimpleDockable( _tab.content, _tab.id, _tab.label, _tab.icon.clone() );
			else if( flavor.equals( ComponentsFlavors.COMPONENT ) )
				return _tab.content;
		}

		public function transferPerformed () : void
		{
			_pane.removeTab( _tab );
		}
		
		public function get flavors () : Array { return [ ComponentsFlavors.TAB, ComponentsFlavors.DOCKABLE, ComponentsFlavors.COMPONENT ]; 
		}
		public function get mode () : String { return ComponentsTransferModes.MOVE;	}
	}
}

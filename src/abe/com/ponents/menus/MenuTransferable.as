package abe.com.ponents.menus 
{
	import abe.com.ponents.transfer.ComponentsFlavors;
	import abe.com.ponents.transfer.ComponentsTransferModes;
	import abe.com.ponents.transfer.DataFlavor;
	import abe.com.ponents.transfer.Transferable;

	/**
	 * @author Cédric Néhémie
	 */
	public class MenuTransferable implements Transferable 
	{
		protected var _menu : Menu;

		public function MenuTransferable ( menu : Menu )
		{
			_menu = menu;
		}
		
		public function getData (flavor : DataFlavor) : *
		{
			if( flavor.equals( ComponentsFlavors.MENU ) )
				return _menu;
			else
				return null;
		}
		
		public function transferPerformed () : void
		{
			_menu.menuContainer.removeMenuItem(_menu);
		}
		
		public function get flavors () : Array { return [ ComponentsFlavors.MENU ]; }
		public function get mode () : String { return ComponentsTransferModes.COPY; }
	}
}

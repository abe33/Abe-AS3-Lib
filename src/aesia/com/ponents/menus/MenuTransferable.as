package aesia.com.ponents.menus 
{
	import aesia.com.ponents.transfer.ComponentsFlavors;
	import aesia.com.ponents.transfer.ComponentsTransferModes;
	import aesia.com.ponents.transfer.DataFlavor;
	import aesia.com.ponents.transfer.Transferable;

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

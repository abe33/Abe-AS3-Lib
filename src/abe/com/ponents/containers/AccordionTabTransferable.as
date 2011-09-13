package abe.com.ponents.containers 
{
    import abe.com.ponents.core.*;
    import abe.com.ponents.transfer.*;
	/**
	 * @author cedric
	 */
	public class AccordionTabTransferable implements Transferable 
	{
		protected var _tab : AccordionTab;

		public function AccordionTabTransferable ( tab : AccordionTab ) 
		{
			_tab = tab;
		}
		public function getData (flavor : DataFlavor) : *
		{ 
		    if( ComponentsFlavors.ACCORDION_TAB.equals(flavor) )
		        return _tab;
			if( ComponentsFlavors.DOCKABLE.equals(flavor) )
				return new SimpleDockable( _tab.content, _tab.id, _tab.label, _tab.icon ? _tab.icon.clone() : null );
			else if( ComponentsFlavors.COMPONENT.equals(flavor) )
				return _tab.content;
		}
		
		public function transferPerformed () : void
		{
		    _tab.accordion.removeTab( _tab );
		}
		
		public function get flavors () : Array { return [ ComponentsFlavors.DOCKABLE, ComponentsFlavors.COMPONENT ]; }		
		public function get mode () : String { return ComponentsTransferModes.MOVE; }
	}
}

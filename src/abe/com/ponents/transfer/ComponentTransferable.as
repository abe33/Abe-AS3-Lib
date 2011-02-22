package abe.com.ponents.transfer 
{
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.Container;

	/**
	 * @author Cédric Néhémie
	 */
	public class ComponentTransferable implements Transferable
	{
		protected var _component : Component;
		
		public function ComponentTransferable ( comp : Component )
		{
			_component = comp;
		}

		public function getData (flavor : DataFlavor) :*
		{
			if( flavor.equals( ComponentsFlavors.COMPONENT ) )
				return _component;
			else
				return null;
		}

		public function transferPerformed () : void
		{
			var p : Container = _component.parentContainer;
			if( p )
				p.removeComponent(_component);
			
		}
		
		public function get flavors () : Array
		{
			return [ComponentsFlavors.COMPONENT];
		}
		
		public function get mode () : String
		{
			return ComponentsTransferModes.MOVE;
		}
	}
}

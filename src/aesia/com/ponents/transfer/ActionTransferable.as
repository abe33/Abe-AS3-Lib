/**
 * @license
 */
package aesia.com.ponents.transfer 
{
	import aesia.com.ponents.actions.Action;
	
	
	

	/**
	 * @author Cédric Néhémie
	 */
	public class ActionTransferable implements Transferable 
	{
		protected var _action : Action;
	
		public function ActionTransferable ( action : Action )
		{
			_action = action;
		}
		
		public function getData (flavor : DataFlavor) : *
		{
			if( flavor.equals( ComponentsFlavors.ACTION ) )
				return _action;
			else
				return null;
		}

		public function transferPerformed () : void	{}
		
		public function get flavors () : Array { return [ ComponentsFlavors.ACTION ]; }		
		public function get mode () : String { return ComponentsTransferModes.COPY; }
	}
}

package abe.com.ponents.transfer 
{
	import abe.com.ponents.containers.ToolBar;
	import abe.com.ponents.core.Component;
	/**
	 * @author cedric
	 */
	public class ToolBarTransferable implements Transferable 
	{
		protected var _component : Component;
		protected var _toolbar : ToolBar;

		public function ToolBarTransferable ( c : Component, toolbar : ToolBar ) 
		{
			_component = c;
			_toolbar = toolbar;
		}
		public function getData ( flavor : DataFlavor ) : *
		{
			if( flavor.equals( ComponentsFlavors.TOOLBAR ) )
				return _component;
			else 
				return null;
		}
		public function transferPerformed () : void
		{
			_component.parentContainer.removeComponent( _component );
		}
		public function get flavors () : Array
		{
			return [ ComponentsFlavors.TOOLBAR ];
		}
		public function get mode () : String
		{
			return ComponentsTransferModes.MOVE;
		}
		public function get toolbar () : ToolBar { return _toolbar; }
	}
}

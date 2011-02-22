package abe.com.ponents.core 
{
	/**
	 * @author cedric
	 */
	public interface DockableContainer extends Container 
	{
		function hasDockableClone( dock : Dockable ) : Dockable;
		function numDocks () : uint;
	}
}

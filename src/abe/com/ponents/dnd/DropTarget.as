/**
 * @license
 */
package  abe.com.ponents.dnd 
{
	import abe.com.ponents.core.Component;
	import abe.com.ponents.transfer.*;
	public interface DropTarget
	{
		function get component () : Component;
		
		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		function get supportedFlavors () : Array;
		function dragEnter ( manager : DnDManager, transferable : Transferable, source : DragSource ) : void;
		function dragOver ( manager : DnDManager, transferable : Transferable, source : DragSource ) : void;
		function dragExit ( manager : DnDManager, transferable : Transferable, source : DragSource ) : void;
		function drop ( manager : DnDManager, transferable : Transferable ) : void;
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}

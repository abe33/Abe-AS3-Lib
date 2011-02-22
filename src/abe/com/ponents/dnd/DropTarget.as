/**
 * @license
 */
package  abe.com.ponents.dnd 
{
	import abe.com.ponents.core.Component;

	public interface DropTarget
	{
		function get component () : Component;
		
		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		function get supportedFlavors () : Array;
		function dragEnter ( e : DropTargetDragEvent ) : void;
		function dragOver ( e : DropTargetDragEvent ) : void;
		function dragExit ( e : DropTargetDragEvent ) : void;
		function drop ( e : DropEvent ) : void;
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}

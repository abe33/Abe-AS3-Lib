/**
 * @license
 */
package  aesia.com.ponents.dnd 
{	import aesia.com.ponents.transfer.Transferable;

	import flash.events.Event;

	public class DropTargetDragEvent extends Event 
	{
		public var transferable : Transferable;
		public var flavors : Array;
		public var source : DragSource;
		public function DropTargetDragEvent ( transferable : Transferable, source : DragSource )
		{
			super( "" );
			
			this.transferable = transferable;
			this.flavors = transferable.flavors;
			this.source = source;
		}
		
		public function acceptDrag ( target : DropTarget ) : void
		{
			DnDManagerInstance.acceptDrag( target );
		}
		public function rejectDrag ( target : DropTarget ) : void
		{
			DnDManagerInstance.rejectDrag( target );
		}
	}
}

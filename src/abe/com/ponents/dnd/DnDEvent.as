/**
 * @license
 */
package  abe.com.ponents.dnd 
{
	import abe.com.ponents.transfer.Transferable;

	import flash.events.Event;
	public class DnDEvent extends Event 
	{
		static public const DRAG		  : String = "drag";
		
		static public const DRAG_ENTER  : String = "dragEnter";
		static public const DRAG_EXIT   : String = "dragExit";
		static public const DRAG_ABORT  : String = "dragAbort";
		
		static public const DRAG_ACCEPT : String = "dragAccept";
		static public const DRAG_REJECT : String = "dragReject";
		
		static public const DRAG_START  : String = "dragStart";
		static public const DRAG_STOP  : String = "dragStop";
		
		static public const DROP : String = "drop";			static public const DROP_TARGETS_CHANGE : String = "dropTargetsChange";	
		
		public var transferable : Transferable;
		public var dragSource : DragSource;
		public var dropTarget : DropTarget;

		public function DnDEvent ( type : String,
								   transferable : Transferable,
								   source : DragSource,
								   target : DropTarget = null, 
								   bubbles : Boolean = false, 
								   cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
			
			this.transferable = transferable;
			this.dragSource = source;
			this.dropTarget = target;
		}
	}
}

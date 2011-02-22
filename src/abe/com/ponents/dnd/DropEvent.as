/**
 * @license
 */
package  abe.com.ponents.dnd 
{
	import abe.com.ponents.transfer.Transferable;

	import flash.events.Event;

	public class DropEvent extends Event 
	{
		public var transferable : Transferable;

		public function DropEvent ( transferable : Transferable )
		{
			super( "" );
			this.transferable = transferable;
		}
	}
}

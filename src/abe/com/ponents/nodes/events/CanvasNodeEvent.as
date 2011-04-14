package abe.com.ponents.nodes.events 
{
	import abe.com.ponents.nodes.core.CanvasNode;

	import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class CanvasNodeEvent extends Event 
	{
		static public const CONNECTION_ADD : String = "connectionAdd";		static public const CONNECTION_REMOVE : String = "connectionRemove";
		public var node : CanvasNode;
		public var relatedNode : CanvasNode;
		public var link : *;

		public function CanvasNodeEvent ( type : String, 
										  node : CanvasNode, 
										  relatedNode : CanvasNode = null, 
										  link : * = null, 
										  bubbles : Boolean = false, 
										  cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
			this.node = node;
			this.relatedNode = relatedNode;
			this.link = link;
		}
	}
}

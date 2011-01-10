package aesia.com.ponents.nodes.actions 
{
	import aesia.com.mands.AbstractCommand;
	import aesia.com.ponents.history.UndoManagerInstance;
	import aesia.com.ponents.nodes.core.NodeLink;

	import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class UnlinkNodesCommand extends AbstractCommand
	{
		protected var link : NodeLink;

		public function UnlinkNodesCommand ( link : NodeLink )
		{
			this.link = link;		
		}
		override public function execute (e : Event = null) : void 
		{
			UndoManagerInstance.add( new UnlinkNodesUndoable(link) );
			link.a.removeConnection(link);
			link.b.removeConnection(link);
			super.execute( e );
		}
	}
}

import aesia.com.patibility.lang._;
import aesia.com.ponents.history.AbstractUndoable;
import aesia.com.ponents.nodes.core.NodeLink;

internal class UnlinkNodesUndoable extends AbstractUndoable
{
	private var link : NodeLink;

	public function UnlinkNodesUndoable ( link : NodeLink ) 
	{
		_label = _("Unlink nodes");
		this.link = link;
	}
	override public function undo () : void 
	{
		link.a.addConnection(link);
		link.b.addConnection(link);
		super.undo();
	}
	override public function redo () : void 
	{
		link.a.removeConnection(link);
		link.b.removeConnection(link);
		super.redo();
	}
}
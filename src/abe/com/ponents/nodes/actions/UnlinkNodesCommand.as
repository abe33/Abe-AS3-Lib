package abe.com.ponents.nodes.actions 
{
	import abe.com.mands.AbstractCommand;
	import abe.com.ponents.history.UndoManagerInstance;
	import abe.com.ponents.nodes.core.NodeLink;

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
		override public function execute( ... args ) : void 
		{
			UndoManagerInstance.add( new UnlinkNodesUndoable(link) );
			link.a.removeConnection(link);
			link.b.removeConnection(link);
			super.execute( e );
		}
	}
}

import abe.com.patibility.lang._;
import abe.com.ponents.history.AbstractUndoable;
import abe.com.ponents.nodes.core.NodeLink;

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
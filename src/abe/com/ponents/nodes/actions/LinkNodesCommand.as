package abe.com.ponents.nodes.actions 
{
	import abe.com.mands.AbstractCommand;
	import abe.com.ponents.history.UndoManagerInstance;
	import abe.com.ponents.nodes.core.CanvasNode;
	import abe.com.ponents.nodes.core.NodeLink;
	/**
	 * @author cedric
	 */
	public class LinkNodesCommand extends AbstractCommand
	{
		protected var a : CanvasNode;
		protected var b : CanvasNode;
		protected var link : NodeLink;

		public function LinkNodesCommand ( a : CanvasNode, b : CanvasNode, link : NodeLink )
		{
			this.a = a;
			this.b = b;	
			this.link = link;		
		}
		override public function execute( ... args ) : void 
		{
			UndoManagerInstance.add( new LinkNodesUndoable(a, b, link) );
			a.addConnection(link);			b.addConnection(link);
			super.execute( e );
		}
	}
}

import abe.com.patibility.lang._;
import abe.com.ponents.history.AbstractUndoable;
import abe.com.ponents.nodes.core.CanvasNode;
import abe.com.ponents.nodes.core.NodeLink;

internal class LinkNodesUndoable extends AbstractUndoable
{
	private var a : CanvasNode;
	private var b : CanvasNode;
	private var link : NodeLink;

	public function LinkNodesUndoable ( a : CanvasNode, b : CanvasNode, link : NodeLink ) 
	{
		_label = _("Link nodes");
		this.a = a;
		this.b = b;
		this.link = link;
	}
	override public function undo () : void 
	{
		a.removeConnection(link);
		b.removeConnection(link);
		super.undo();
	}
	override public function redo () : void 
	{
		a.addConnection(link);
		b.addConnection(link);
		super.redo();
	}
}
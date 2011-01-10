package aesia.com.ponents.nodes.actions 
{
	import aesia.com.mands.AbstractCommand;
	import aesia.com.ponents.history.UndoManagerInstance;
	import aesia.com.ponents.nodes.core.CanvasNode;
	import aesia.com.ponents.tools.CameraCanvas;

	import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class DeleteNodeCommand extends AbstractCommand 
	{
		private var layer : uint;
		private var node : CanvasNode;
		private var canvas : CameraCanvas;

		public function DeleteNodeCommand ( canvas : CameraCanvas, layer:uint, node : CanvasNode )
		{
			super( );
			this.canvas = canvas;
			this.node = node;
			this.layer = layer;
		}
		override public function execute (e : Event = null) : void 
		{
			if( node.selected )
				node.selected = false;
			
			canvas.removeComponent( node );
			UndoManagerInstance.add( new DeleteNodeUndoable(canvas, layer, node));
			super.execute( e );
		}
	}
}

import aesia.com.patibility.lang._;
import aesia.com.ponents.history.AbstractUndoable;
import aesia.com.ponents.nodes.core.CanvasNode;
import aesia.com.ponents.tools.CameraCanvas;

internal class DeleteNodeUndoable extends AbstractUndoable
{
	private var layer : uint;
	private var node : CanvasNode;
	private var canvas : CameraCanvas;

	public function DeleteNodeUndoable ( canvas : CameraCanvas, layer : uint, node : CanvasNode ) 
	{
		_label = _("Delete Node");
		this.canvas = canvas;
		this.layer = layer;
		this.node = node;
	}
	override public function undo () : void 
	{
		canvas.addComponentToLayer( node, layer );
		super.undo();
	}
	override public function redo () : void 
	{
		canvas.removeComponent( node );
		super.redo();
	}
	
}

package abe.com.ponents.nodes.actions 
{
    import abe.com.mands.AbstractCommand;
    import abe.com.ponents.history.UndoManagerInstance;
    import abe.com.ponents.nodes.core.CanvasNode;
    import abe.com.ponents.tools.CameraCanvas;
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
		override public function execute( ... args ) : void 
		{
			if( node.selected )
				node.selected = false;
			
			node.removeAllConnections();
			canvas.removeComponent( node );
			UndoManagerInstance.add( new DeleteNodeUndoable(canvas, layer, node));
			super.execute.apply( this, args );
		}
	}
}
import abe.com.patibility.lang._;
import abe.com.ponents.history.AbstractUndoable;
import abe.com.ponents.nodes.core.CanvasNode;
import abe.com.ponents.tools.CameraCanvas;

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

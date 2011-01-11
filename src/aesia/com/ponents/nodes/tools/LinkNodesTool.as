package aesia.com.ponents.nodes.tools 
{
	import aesia.com.ponents.nodes.actions.LinkNodesCommand;
	import aesia.com.ponents.nodes.core.NodeLink;
	import aesia.com.mon.utils.Color;
	import aesia.com.ponents.events.ToolEvent;
	import aesia.com.ponents.nodes.core.CanvasNode;
	import aesia.com.ponents.skinning.cursors.Cursor;
	import aesia.com.ponents.tools.canvas.Tool;
	import aesia.com.ponents.tools.canvas.core.AbstractTool;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author Cédric Néhémie
	 */
	public class LinkNodesTool extends AbstractTool implements Tool 
	{
		private var _linkShape : Shape;
		
		protected var _linkageFunction : Function;
		
		protected var _startObject : CanvasNode;
		protected var _startCenterPoint : Point;
		
		public var relationship : String;
		public var relationshipDirection : String;
		public var defaultLabel : String;

		public function LinkNodesTool ( relationship : String = "undefined", 
										relationshipDirection:String = "ab", 
										linkageFunction : Function = null, 
										defaultLabel: String = null,
										cursor : Cursor = null)
		{
			super( cursor );
			_linkageFunction = linkageFunction;
			_linkShape = new Shape();
			this.relationship = relationship;
			this.relationshipDirection = relationshipDirection;
			this.defaultLabel = defaultLabel;
		}
		override public function actionStarted (e : ToolEvent) : void
		{
			var o : DisplayObject = e.manager.canvasChildUnderTheMouse;
			
			if( o != null && o is CanvasNode )
			{
				_startObject = o as CanvasNode;
				
				var bb : Rectangle = _startObject.getBounds( e.canvas );
				
				e.canvas.addChild( _linkShape );
				
				_startCenterPoint = new Point( ( bb.left + bb.right ) / 2, 
											   ( bb.top + bb.bottom ) / 2 );
			}
		}
	
		override public function actionFinished (e : ToolEvent) : void
		{
			if( _startObject )
			{
				var o : DisplayObject = e.manager.canvasChildUnderTheMouse;
				
				if(  o != null && o != _startObject && o is CanvasNode )
				{
					var endObject : CanvasNode = o as CanvasNode;
					var link : NodeLink = new NodeLink( _startObject, endObject, relationship, relationshipDirection );
					if( defaultLabel )
						link.displayLinkLabel = defaultLabel;
						
					if ( _linkageFunction != null &&  !_linkageFunction( link ) )
						return;
				
					new LinkNodesCommand( _startObject, endObject, link ).execute();
				}
				e.canvas.removeChild( _linkShape );
				_linkShape.graphics.clear();
			}
			_startObject = null;
		}
	
		override public function mousePositionChanged (e : ToolEvent) : void
		{
			if( _startObject != null )
			{
				var mx : Number = e.canvas.mouseX;
				var my : Number = e.canvas.mouseY;

				var offx : Number = mx > _startCenterPoint.x ? -2 : 2;				var offy : Number = my > _startCenterPoint.y ? -2 : 2;
					
				_linkShape.graphics.clear();
				_linkShape.graphics.lineStyle( 2, Color.Black.hexa, .5 );
				_linkShape.graphics.moveTo( _startCenterPoint.x, _startCenterPoint.y );
				_linkShape.graphics.lineTo( mx + offx, my + offy );
			}
		}
		override public function actionAborted (e : ToolEvent) : void
		{
			if( _startObject )
			{
				e.canvas.removeChild( _linkShape );
				_linkShape.graphics.clear();
				_startObject = null;
			}
		}
	}
}

package aesia.com.ponents.tools 
{
	import aesia.com.mon.utils.Color;
	import aesia.com.ponents.events.ToolEvent;
	import aesia.com.ponents.skinning.cursors.Cursor;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	public class LinkObjects extends AbstractTool implements Tool 
	{
		protected var _linkClass : Class;
		protected var _linkageFunction : Function;
		
		protected var _startObject : DisplayObject;
		protected var _linkShape : Shape;
		protected var _startCenterPoint : Point;
		

		public function LinkObjects ( linkClass : Class, linkageFunction : Function, cursor : Cursor = null)
		{
			super( cursor );
			_linkClass = linkClass;
			_linkageFunction = linkageFunction;
			
			_linkShape = new Shape();
		}
		override public function actionStarted (e : ToolEvent) : void
		{
			var o : DisplayObject = e.manager.canvasChildUnderTheMouse;
			
			if( o != null && !( o is _linkClass) )
			{
				_startObject = o;
				
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
				
				if(  o != null && !( o is _linkClass) )
				{

					_linkageFunction( _startObject, o );
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

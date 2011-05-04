package abe.com.ponents.dnd 
{
	import abe.com.ponents.utils.ToolKit;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	/**
	 * @author Cédric Néhémie
	 */
	public class DnDDragObjectRenderer 
	{
		protected var _bitmapData : BitmapData;
		protected var _bitmap : Bitmap;
		
		protected var _localX : Number;		protected var _localY : Number;
		
		public function DnDDragObjectRenderer ( manager : DnDManager )
		{
			_bitmap = new Bitmap();
			_bitmap.alpha = .5;
			
			manager.addEventListener( DnDEvent.DRAG_START, dragStarted );		
			manager.addEventListener( DnDEvent.DRAG_STOP, dragStopped );		
			manager.addEventListener( DnDEvent.DRAG, drag );		
		}
		public function drag ( e : DnDEvent ) : void
		{
			_bitmap.x = ToolKit.popupLevel.mouseX - _localX;
			_bitmap.y = ToolKit.popupLevel.mouseY - _localY;
		}

		public function dragStarted ( e : DnDEvent ) : void
		{
			var g : DisplayObject = e.dragSource.dragGeometry;
			_bitmapData = new BitmapData( g.width+1, g.height+1, true, 0 );
			_bitmapData.draw( g );
			_bitmap.bitmapData = _bitmapData;
			_localX = g.mouseX;			_localY = g.mouseY;
			ToolKit.dndLevel.addChild( _bitmap );
		}

		public function dragStopped ( e : DnDEvent ) : void
		{
			ToolKit.dndLevel.removeChild( _bitmap );
			_bitmapData.dispose();
			_bitmapData = null;
		}
	}
}

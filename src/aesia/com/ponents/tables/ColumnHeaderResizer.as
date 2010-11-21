package aesia.com.ponents.tables 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.core.AbstractComponent;
	import aesia.com.ponents.skinning.cursors.Cursor;
	import aesia.com.ponents.skinning.decorations.SeparatorDecoration;

	import flash.events.MouseEvent;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="ColumnHeaderResizer")]
	[Skin(define="ColumnHeaderResizer",
			  inherit="EmptyComponent",
			  state__all__background="new aesia.com.ponents.skinning.decorations::SeparatorDecoration(color(White),color(Gray),1)"
	)]
	public class ColumnHeaderResizer extends AbstractComponent
	{
		
		static private const SKIN_DEPENDENCIES : Array = [SeparatorDecoration];
		protected var _pressedX : Number;
		protected var _pressedY : Number;
		protected var _dragging : Boolean;
		protected var _column : TableColumnHeader;
		protected var _header : TableHeader;
		
		public function ColumnHeaderResizer ()
		{
			super();
			/*FDT_IGNORE*/ FEATURES::CURSOR { /*FDT_IGNORE*/
			cursor = Cursor.get( Cursor.DRAG_H );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		
		public function get column () : TableColumnHeader { return _column; }	
		public function set column (column : TableColumnHeader) : void
		{
			_column = column;
		}
		public function get header () : TableHeader { return _header; }		
		public function set header (header : TableHeader) : void
		{
			_header = header;
		}
		
		override public function mouseDown (e : MouseEvent) : void
		{
			super.mouseDown( e );
			_pressedX = mouseX;
			_pressedY = mouseY;
			_dragging = true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove );
		}
	
		public function stageMouseMove (e : MouseEvent) : void
		{
			if( _dragging )
			{
				x = parent.mouseX - _pressedX;
				_header.setColumnSize( _column, Math.max( x + width/2 - _column.x, 10 ) );
			}
		}
		override public function mouseUp (e : MouseEvent) : void
		{
			super.mouseUp( e );
			_dragging = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove );
		}
	
		override public function invalidatePreferredSizeCache () : void
		{
			_preferredSizeCache = new Dimension( 6, 20 );
			invalidate( );
		}
	}
}

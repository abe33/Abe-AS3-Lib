package abe.com.ponents.tools.canvas.geom
{
	import abe.com.mon.geom.Geometry;
	import abe.com.mon.geom.Rectangle2;
	
	public class RectangleSprite extends GeometrySprite
	{
		public function RectangleSprite(geom:Geometry)
		{
			super(geom);
		}
		public function get rectangle ():Rectangle2 { return _geometry as Rectangle2; }
		
		override public function get x():Number { return rectangle.x; }
		override public function set x(value:Number):void{ rectangle.x = value; render(); }
		
		override public function get y():Number { return rectangle.y; }
		override public function set y(value:Number):void{ rectangle.y = value; render(); }
	
		
		override public function get rotation():Number { return rectangle.rotation; }
		override public function set rotation(value:Number):void{ rectangle.rotation = value; }
	}
}
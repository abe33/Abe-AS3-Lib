package abe.com.ponents.tools.canvas.geom
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.geom.Geometry;
	
	import flash.display.Sprite;
	
	public class GeometrySprite extends Sprite
	{
		protected var _geometry:Geometry;
		
		static public const GEOMETRY_COLOR : Color = Color.Black;
		
		public function GeometrySprite( geom : Geometry )
		{
			super();
			_geometry = geom;
			
			render();
		}
		public function get geometry():Geometry{ return _geometry; }
		public function set geometry(g:Geometry):void{ _geometry = g; render(); }
		
		override public function get x():Number { return 0; }
		override public function set x(value:Number):void{}
		
		override public function get y():Number { return 0; }
		override public function set y(value:Number):void{}
				
		override public function get rotation():Number { return 0; }
		override public function set rotation(value:Number):void{}
				
		public function get $x ():Number { return super.x; }
		public function set $x (value:Number):void{ super.x = value;}
		
		public function get $y ():Number { return super.y; }
		public function set $y (value:Number):void{ super.y = value;}

		public function get $rotation ():Number { return super.rotation; }
		public function set $rotation (value:Number):void{ super.rotation = value;}
		
		public function render():void {
			this.graphics.clear();
			
			_geometry.fill( this.graphics, GEOMETRY_COLOR.alphaClone(0) ); 
			_geometry.draw( this.graphics, GEOMETRY_COLOR ); 
		}
	}
}
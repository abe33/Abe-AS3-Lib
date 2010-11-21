package aesia.com.ponents.demos 
{
	import aesia.com.ponents.skinning.decorations.AdvancedSlicedBitmapFill;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	[SWF(width="470", height="470")]
	public class AdvancedSlicedBitmapBoxDemo2 extends Sprite 
	{
		[Embed(source="bgstretch.png")]
		private var bgClass : Class;
		
		protected var bgBitmap : BitmapData;
		
		public function AdvancedSlicedBitmapBoxDemo2 ()
		{
			bgBitmap = (new bgClass() as Bitmap).bitmapData;
			
			var s : Sprite = new Sprite();
			var b : Bitmap = new Bitmap( bgBitmap, "auto", false );
			b.x = 8;
			b.y = 8;
			
			var s9b : AdvancedSlicedBitmapFill = new AdvancedSlicedBitmapFill(bgBitmap, 
									  new Rectangle( 8,8,24,24 ), 
			[ {h:'stretch', v:'stretch'}, {h:'stretch', v:'stretch'}, {h:'stretch', v:'stretch'},
			  {h:'stretch', v:'stretch'}, {h:'stretch', v:'stretch'}, {h:'stretch', v:'stretch'},
			  {h:'stretch', v:'stretch'}, {h:'stretch', v:'stretch'}, {h:'stretch', v:'stretch'} ]);

			var a : Array = [ 5, 8, 13, 21, 34, 55, 89, 154 ];
			var _x : Number = 10;
			var _y : Number = 10;
			
			for(var x : Number = 0; x<a.length;x++)
			{
				for(var y : Number = 0; y<a.length;y++)
				{
					s9b.draw( new Rectangle( _x, _y, a[x], a[y]), s.graphics, null );
					
					_y += a[y] + 10;
				}
				_x += a[x] + 10;
				_y = 10;
			}
			/*
			s9b.draw( new Rectangle(8, 8, 4, 4), s.graphics, true);
			s9b.draw( new Rectangle(20, 8, 20, 4), s.graphics, true);
			s9b.draw( new Rectangle(50, 8, 50, 4), s.graphics, true);
			s9b.draw( new Rectangle(110, 8, 100, 4), s.graphics, true);
			s9b.draw( new Rectangle(220, 8, 150, 4), s.graphics, true);
			
			s9b.draw( new Rectangle(8, 20, 4, 20), s.graphics, true);
			s9b.draw( new Rectangle(8, 50, 4, 50), s.graphics, true);
			s9b.draw( new Rectangle(8, 110, 4, 100), s.graphics, true);
			s9b.draw( new Rectangle(8, 220, 4, 150), s.graphics, true);
			
			s9b.draw( new Rectangle(20, 20, 20, 20), s.graphics);
			s9b.draw( new Rectangle(50, 20, 50, 20), s.graphics);
			s9b.draw( new Rectangle(110, 20, 100, 20), s.graphics);
			s9b.draw( new Rectangle(220, 20, 150, 20), s.graphics);
			
			s9b.draw( new Rectangle(20, 50, 20, 50), s.graphics);
			s9b.draw( new Rectangle(20, 110, 20, 100), s.graphics);
			s9b.draw( new Rectangle(20, 220, 20, 150), s.graphics);
			
			s9b.draw( new Rectangle(50,50, 50, 50), s.graphics);
			s9b.draw( new Rectangle(110, 50, 100, 50), s.graphics);
			s9b.draw( new Rectangle(220, 50, 150, 50), s.graphics);
			
			s9b.draw( new Rectangle(50, 110, 50, 100), s.graphics);
			s9b.draw( new Rectangle(50, 220, 50, 150), s.graphics);
			
			s9b.draw( new Rectangle(110, 110, 100, 100), s.graphics);
			s9b.draw( new Rectangle(220, 110, 150, 100), s.graphics);
			s9b.draw( new Rectangle(110, 220, 100, 150), s.graphics);
			s9b.draw( new Rectangle(220, 220, 150, 150), s.graphics);
			*/
			addChild(s);	
		}
	}
}

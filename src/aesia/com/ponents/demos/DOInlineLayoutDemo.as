package aesia.com.ponents.demos 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.layouts.display.DOInlineLayout;
	import aesia.com.ponents.utils.Insets;

	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	[SWF(width="900", height="600")]
	public class DOInlineLayoutDemo extends Sprite 
	{
		protected var containers : Array;
		protected var layouts : Array;
		
		public function DOInlineLayoutDemo ()
		{
			containers = [];
			layouts = [];
			
			var x : Number = 0;			var y : Number = 0;
			
			// Left To Right
			addChild( createBlock( x + 10, y + 10, "left", "top" ) );			addChild( createBlock( x + 125, y + 10, "center", "top" ) );			addChild( createBlock( x + 240, y + 10, "right", "top" ) );	
					
			addChild( createBlock( x + 10, y + 50, "left", "center" ) );
			addChild( createBlock( x + 125, y + 50, "center", "center" ) );
			addChild( createBlock( x + 240, y + 50, "right", "center" ) );
			
			addChild( createBlock( x + 10, y + 90, "left", "bottom" ) );			
			addChild( createBlock( x + 125, y + 90, "center", "bottom" ) );
			addChild( createBlock( x + 240, y + 90, "right", "bottom" ) );
			
			y = 130;
			// Right To Left
			addChild( createBlock( x + 10, y + 10, "left", "top", "rightToLeft" ) );
			addChild( createBlock( x + 125, y + 10, "center", "top", "rightToLeft" ) );
			addChild( createBlock( x + 240, y + 10, "right", "top", "rightToLeft" ) );
						
			addChild( createBlock( x + 10, y + 50, "left", "center", "rightToLeft" ) );
			addChild( createBlock( x + 125, y + 50, "center", "center", "rightToLeft" ) );
			addChild( createBlock( x + 240, y + 50, "right", "center", "rightToLeft" ) );
			
			addChild( createBlock( x + 10, y + 90, "left", "bottom", "rightToLeft" ) );			
			addChild( createBlock( x + 125, y + 90, "center", "bottom", "rightToLeft" ) );
			addChild( createBlock( x + 240, y + 90, "right", "bottom", "rightToLeft" ) );			
			y = 260;
			// Top To Bottom
			addChild( createBlock( x + 10, y + 10, "left", "top", "topToBottom" ) );			addChild( createBlock( x + 70, y + 10, "center", "top", "topToBottom" ) );			addChild( createBlock( x + 130, y + 10, "right", "top", "topToBottom" ) );
						addChild( createBlock( x + 10, y + 95, "left", "center", "topToBottom" ) );			addChild( createBlock( x + 70, y + 95, "center", "center", "topToBottom" ) );			addChild( createBlock( x + 130, y + 95, "right", "center", "topToBottom" ) );
						addChild( createBlock( x + 10, y + 180, "left", "bottom", "topToBottom" ) );			addChild( createBlock( x + 70, y + 180, "center", "bottom", "topToBottom" ) );			addChild( createBlock( x + 130, y + 180, "right", "bottom", "topToBottom" ) );
			
			// Bottom To Top
			x = 190;
			y = 260;
			addChild( createBlock( x + 10, y + 10, "left", "top", "bottomToTop" ) );
			addChild( createBlock( x + 70, y + 10, "center", "top", "bottomToTop" ) );
			addChild( createBlock( x + 130, y + 10, "right", "top", "bottomToTop" ) );
			
			addChild( createBlock( x + 10, y + 95, "left", "center", "bottomToTop" ) );
			addChild( createBlock( x + 70, y + 95, "center", "center", "bottomToTop" ) );
			addChild( createBlock( x + 130, y + 95, "right", "center", "bottomToTop" ) );
			
			addChild( createBlock( x + 10, y + 180, "left", "bottom", "bottomToTop" ) );
			addChild( createBlock( x + 70, y + 180, "center", "bottom", "bottomToTop" ) );
			addChild( createBlock( x + 130, y + 180, "right", "bottom", "bottomToTop" ) );
			
			// size bigger than content
			x = 400; 
			y = 0;
			addChild( createBlock( x + 10, y + 10, "left", "top", "leftToRight", new Dimension( 150, 70 ) ) );			addChild( createBlock( x + 165, y + 10, "center", "top", "leftToRight", new Dimension( 150, 70 ) ) );			addChild( createBlock( x + 320, y + 10, "right", "top", "leftToRight", new Dimension( 150, 70 ) ) );
			
			addChild( createBlock( x + 10, y + 85, "left", "center", "leftToRight", new Dimension( 150, 70 ) ) );
			addChild( createBlock( x + 165, y + 85, "center", "center", "leftToRight", new Dimension( 150, 70 ) ) );
			addChild( createBlock( x + 320, y + 85, "right", "center", "leftToRight", new Dimension( 150, 70 ) ) );
			
			addChild( createBlock( x + 10, y + 160, "left", "bottom", "leftToRight", new Dimension( 150, 70 ) ) );
			addChild( createBlock( x + 165, y + 160, "center", "bottom", "leftToRight", new Dimension( 150, 70 ) ) );
			addChild( createBlock( x + 320, y + 160, "right", "bottom", "leftToRight", new Dimension( 150, 70 ) ) );
			
			// size smaller than content
			y = 260;
			addChild( createBlock( x + 10, y + 10, "left", "top", "leftToRight", new Dimension( 50, 20 ) ) );
			addChild( createBlock( x + 65, y + 10, "center", "top", "leftToRight", new Dimension( 50, 20 ) ) );
			addChild( createBlock( x + 120, y + 10, "right", "top", "leftToRight", new Dimension( 50, 20 ) ) );
			
			addChild( createBlock( x + 10, y + 35, "left", "center", "leftToRight", new Dimension( 50, 20 ) ) );
			addChild( createBlock( x + 65, y + 35, "center", "center", "leftToRight", new Dimension( 50, 20 ) ) );
			addChild( createBlock( x + 120, y + 35, "right", "center", "leftToRight", new Dimension( 50, 20 ) ) );
			
			addChild( createBlock( x + 10, y + 60, "left", "bottom", "leftToRight", new Dimension( 50, 20 ) ) );
			addChild( createBlock( x + 65, y + 60, "center", "bottom", "leftToRight", new Dimension( 50, 20 ) ) );
			addChild( createBlock( x + 120, y + 60, "right", "bottom", "leftToRight", new Dimension( 50, 20 ) ) );		}
		
		protected function createBlock ( x : Number, 
										 y : Number, 
										 halign : String = "left", 
										 valign : String = "center", 
										 direction : String = "leftToRight", 
										 size : Dimension = null ) : DisplayObjectContainer
		{
			var doc : Sprite = new Sprite();
			
			doc.addChild( createBox() );
			doc.addChild( createText("Some text") );
			doc.addChild( createBall() );
			
			var layout : DOInlineLayout = new DOInlineLayout( doc,
															  2, 
															  halign, 
															  valign, 
															  direction );
			
			containers.push( doc );
			layouts.push( layout );
			
			var d : Dimension = size ? size : layout.preferredSize.grow( 4, 4 );
			
			doc.graphics.lineStyle(0,0x00ff00);
			doc.graphics.drawRect(0, 0, d.width, d.height);
			
			layout.layout( size, new Insets(2,2,2,2) );
			
			doc.x = x;
			doc.y = y;
			doc.scrollRect = new Rectangle( 0, 0, d.width+1, d.height+1 );
			
			return doc;
		}
		protected function createBall () : Shape
		{
			var s : Shape = new Shape();
			
			s.graphics.beginFill(0xff0000);
			s.graphics.drawCircle(0, 0, 10);
			s.graphics.endFill();
			
			return s;
		}
		protected function createBox () : Shape
		{
			var s : Shape = new Shape();
			
			s.graphics.beginFill(0x0000ff);
			s.graphics.drawRect(0, 0, 30, 30 );
			s.graphics.endFill();
			
			return s;
		}
		protected function createText ( s : String ) : TextField
		{
			var txt : TextField = new TextField();
			
			txt.autoSize = "left";
			txt.selectable = false;
			txt.text = s;
			
			return txt;
		}
	}
}

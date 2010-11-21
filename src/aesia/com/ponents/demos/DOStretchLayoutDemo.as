package aesia.com.ponents.demos 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.layouts.display.DOStretchLayout;
	import aesia.com.ponents.utils.Insets;

	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * @author Cédric Néhémie
	 */
	public class DOStretchLayoutDemo extends Sprite 
	{
		protected var containers : Array;
		protected var layouts : Array;
		
		public function DOStretchLayoutDemo ()
		{
			containers = [];
			layouts = [];
			
			var x : Number = 0;
			var y : Number = 0;
			
			addChild( createBlock( x + 10, y + 10 ) );			addChild( createBlock( x + 70, y + 10, 2 ) );			addChild( createBlock( x + 10, y + 60, NaN, new Dimension ( 100, 100 ) ) );
			
			
		}
		
		protected function createBlock ( x : Number, 
										 y : Number, 
										 preferredChild : Number = NaN, 
										 size : Dimension = null ) : DisplayObjectContainer
		{
			var doc : Sprite = new Sprite();
			
			doc.addChild( createBox() );
			doc.addChild( createBall() );
			doc.addChild( createText("Some text") );
			
			var layout : DOStretchLayout = new DOStretchLayout( doc, preferredChild );
			
			containers.push( doc );
			layouts.push( layout );
			
			var d : Dimension = size ? size : layout.preferredSize.grow(4, 4);
			
			doc.graphics.lineStyle(0,0x00ff00);
			doc.graphics.drawRect(0, 0, d.width, d.height);
			
			layout.layout( size, new Insets(2, 2, 2, 2 ) );
			
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

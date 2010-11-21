package aesia.com.ponents.demos 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.layouts.display.DOLayerLayout;
	import aesia.com.ponents.utils.Insets;

	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * @author Cédric Néhémie
	 */
	public class DOLayerLayoutDemo extends Sprite 
	{
		protected var containers : Array;
		protected var layouts : Array;
		
		public function DOLayerLayoutDemo ()
		{
			containers = [];
			layouts = [];
			
			var x : Number = 0;
			var y : Number = 0;
			
			addChild( createBlock( x + 10, y + 10, "left", "top" ) );
			addChild( createBlock( x + 60, y + 10, "center", "top" ) );
			addChild( createBlock( x + 110, y + 10, "right", "top" ) );	
					
			addChild( createBlock( x + 10, y + 60, "left", "center" ) );
			addChild( createBlock( x + 60, y + 60, "center", "center" ) );
			addChild( createBlock( x + 110, y + 60, "right", "center" ) );
			
			addChild( createBlock( x + 10, y + 110, "left", "bottom" ) );			
			addChild( createBlock( x + 60, y + 110, "center", "bottom" ) );
			addChild( createBlock( x + 110, y + 110, "right", "bottom" ) );
			
			x = 160;
			addChild( createBlock( x + 10, y + 10, "left", "top", new Dimension(100,100) ) );
			addChild( createBlock( x + 115, y + 10, "center", "top", new Dimension(100,100) ) );
			addChild( createBlock( x + 220, y + 10, "right", "top", new Dimension(100,100) ) );	
					
			addChild( createBlock( x + 10, y + 115, "left", "center", new Dimension(100,100) ) );
			addChild( createBlock( x + 115, y + 115, "center", "center", new Dimension(100,100) ) );
			addChild( createBlock( x + 220, y + 115, "right", "center", new Dimension(100,100) ) );
			
			addChild( createBlock( x + 10, y + 220, "left", "bottom", new Dimension(100,100) ) );			
			addChild( createBlock( x + 115, y + 220, "center", "bottom", new Dimension(100,100) ) );
			addChild( createBlock( x + 220, y + 220, "right", "bottom", new Dimension(100,100) ) );
			
			x = 0;
			y = 160;
			addChild( createBlock( x + 10, y + 10, "left", "top", new Dimension(30,20) ) );
			addChild( createBlock( x + 45, y + 10, "center", "top", new Dimension(30,20) ) );
			addChild( createBlock( x + 80, y + 10, "right", "top", new Dimension(30,20) ) );	
					
			addChild( createBlock( x + 10, y + 35, "left", "center", new Dimension(30,20) ) );
			addChild( createBlock( x + 45, y + 35, "center", "center", new Dimension(30,20) ) );
			addChild( createBlock( x + 80, y + 35, "right", "center", new Dimension(30,20) ) );
			
			addChild( createBlock( x + 10, y + 60, "left", "bottom", new Dimension(30,20) ) );			
			addChild( createBlock( x + 45, y + 60, "center", "bottom", new Dimension(30,20) ) );
			addChild( createBlock( x + 80, y + 60, "right", "bottom", new Dimension(30,20) ) );
			
		}
		protected function createBlock ( x : Number, 
										 y : Number, 
										 halign : String = "left", 
										 valign : String = "center", 
										 size : Dimension = null ) : DisplayObjectContainer
		{
			var doc : Sprite = new Sprite();
			
			doc.addChild( createBox() );
			doc.addChild( createBall() );
			doc.addChild( createText("ABC") );
			
			var layout : DOLayerLayout = new DOLayerLayout( doc,
															halign, 
															valign );
			
			containers.push( doc );
			layouts.push( layout );
			
			var d : Dimension = size ? size : layout.preferredSize.grow( 4, 4 );
			
			doc.graphics.lineStyle(0,0x00ff00);
			doc.graphics.drawRect( 0, 0, d.width, d.height );
			
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
			s.graphics.drawRect(0, 0, 40, 40 );
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

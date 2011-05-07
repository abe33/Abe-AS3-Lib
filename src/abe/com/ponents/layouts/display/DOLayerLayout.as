/**
 * @license
 */
package abe.com.ponents.layouts.display 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.utils.Alignments;
	import abe.com.ponents.utils.Insets;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	/**
	 * @author Cédric Néhémie
	 */
	public class DOLayerLayout extends AbstractDisplayObjectLayout 
	{
		protected var _halign : String;
		protected var _valign : String;
		
		public function DOLayerLayout ( container : DisplayObjectContainer = null,
										halign : String = "center", 
										valign : String = "center" )
		{
			super( container );
			_halign = halign;
			_valign = valign;
		}
		public function get horizontalAlign () : String { return _halign; }		
		public function set horizontalAlign (halign : String) : void
		{
			_halign = halign;
		}
		
		public function get verticalAlign () : String { return _valign; }		
		public function set verticalAlign (valign : String) : void
		{
			_valign = valign;
		}		
		override public function get preferredSize () : Dimension { return estimatedSize(); }

		override public function layout (preferredSize : Dimension = null, insets : Insets = null ) : void
		{
			var d : Dimension = preferredSize ? preferredSize : estimatedSize().grow( insets.horizontal, insets.vertical );
			var l : Number = _container.numChildren;
			var i : Number;
			var c : DisplayObject;
			var bb : Rectangle;
			for(i=0;i<l;i++)
			{
				c = _container.getChildAt(i);
				c.x = c.y = 0;
				bb = c.getBounds(c.parent);
				c.x = Alignments.alignHorizontal( c.width, d.width, insets, _halign ) - bb.left;				c.y = Alignments.alignVertical( c.height, d.height, insets, _valign ) - bb.top;
			}
		}
		protected function estimatedSize() : Dimension
		{
			return calculateContentBounds();
		}
		protected function calculateContentBounds() : Dimension
		{
			var w : Number = 0;
			var h : Number = 0;
			var l : Number = _container.numChildren;
			var i : Number;
			var c : DisplayObject;
			
			for(i=0;i<l;i++)
			{
				c = _container.getChildAt(i);
				w = Math.max(w, c.width);				h = Math.max(h, c.height);
			}
			
			return new Dimension(w,h);
		}
	}
}

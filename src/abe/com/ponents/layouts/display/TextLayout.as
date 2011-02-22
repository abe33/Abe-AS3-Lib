package abe.com.ponents.layouts.display 
{
	import abe.com.mon.core.ITextField;
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.utils.Alignments;
	import abe.com.ponents.utils.Insets;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	/**
	 * @author cedric
	 */
	public class TextLayout extends AbstractDisplayObjectLayout 
	{
		protected var _textField : ITextField;

		public function TextLayout (container : DisplayObjectContainer = null, textField : ITextField = null )
		{
			super( container );
			_textField = textField;
		}
		
		override public function get preferredSize () : Dimension { return estimateSize (); }

		override public function layout ( preferredSize : Dimension = null, insets : Insets = null ) : void
		{
			insets = insets ? insets : new Insets();
			var innerPref : Dimension = estimateSize();
			var s : Dimension = preferredSize ? preferredSize.grow( -insets.horizontal, -insets.vertical ) : innerPref;
			var c : DisplayObject;
			var bb : Rectangle;
			var i : Number;
			var l : Number = _container.numChildren;
			for(i=0;i<l;i++)
			{
				c = _container.getChildAt( i );
				c.x = c.y = 0;
				bb = c.getBounds(c.parent);
				c.width = s.width;
				c.height = s.height;
				c.x = insets.left - bb.left;
				c.y = insets.top - bb.top;
			}
		}

		protected function estimateSize () : Dimension
		{
			if( _textField )
				return new Dimension( _textField.textWidth + 4, _textField.textHeight + 4 );

			var d : Dimension = new Dimension();
			var c : DisplayObject;
			var i : Number;
			var l : Number = _container.numChildren;

			for(i=0;i<l;i++)
			{
				c = _container.getChildAt( i );
				d.width = Math.max( d.width, c.width );
				d.height = Math.max( d.height, c.height );
			}

			return d;
		}
	}
}

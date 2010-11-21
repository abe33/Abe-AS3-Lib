package aesia.com.ponents.builder.styles 
{
	import aesia.com.ponents.layouts.display.DOInlineLayout;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.core.AbstractComponent;
	import aesia.com.ponents.layouts.display.DisplayObjectLayout;

	import flash.text.TextField;

	/**
	 * @author cedric
	 */
	public class DefaultComponentPreview extends AbstractComponent 
	{
		protected var _txt : TextField;
		protected var _childrenLayout : DisplayObjectLayout;
	
		public function DefaultComponentPreview ()
		{
			super();
			_txt = new TextField();
			_txt.selectable = false;
			_txt.autoSize = "left";
			_txt.text = "Sample";
			_childrenLayout = new DOInlineLayout( _childrenContainer, 0, "left", "top" );
			_childrenContainer.addChild(_txt );
			invalidatePreferredSizeCache();
		}

		override public function invalidatePreferredSizeCache () : void
		{
			_txt.defaultTextFormat = _style.format;
			_txt.textColor = _style.textColor.hexa;
			_txt.text = "Sample";
			_preferredSizeCache = _childrenLayout.preferredSize.grow( _style.insets.horizontal, _style.insets.vertical );
			super.invalidatePreferredSizeCache();
		}
		
		public function set selected ( b : Boolean) : void
		{
			_selected = b;
			invalidate(true);
		}

		override protected function _repaint ( size : Dimension ) : void
		{
			super._repaint( size );
			_txt.x = _style.insets.left;
			_txt.y = _style.insets.top;
			_txt.defaultTextFormat = _style.format;
			_txt.textColor = _style.textColor.hexa;
			_txt.text = "Sample";
			
			_childrenLayout.layout(size, _style.insets );
		}
	}
}

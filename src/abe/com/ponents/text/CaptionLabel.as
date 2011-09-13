package abe.com.ponents.text 
{
    import abe.com.ponents.layouts.display.DOInlineLayout;
    import abe.com.ponents.skinning.icons.Icon;
	/**
	 * @author Cédric Néhémie
	 */
	public class CaptionLabel extends Label 
	{
		protected var _icon : Icon;

		public function CaptionLabel ( text : String = "Label", icon : Icon = null )
		{
			super( text, null );
			childrenLayout = new DOInlineLayout( _childrenContainer, 3, "left", "center", "rightToLeft" );
			
			if( icon )
				this.icon = icon;
		}
		override public function invalidatePreferredSizeCache () : void
		{
			super.invalidatePreferredSizeCache();
			
			if( _icon )
			{
				_preferredSizeCache.width += _icon.preferredWidth + ( childrenLayout as DOInlineLayout ).spacing;				_preferredSizeCache.height = Math.max( _preferredSizeCache.height, _icon.preferredHeight + _style.insets.vertical );
			}
		}

		public function get icon () : Icon { return _icon; }		
		public function set icon (icon : Icon) : void
		{
			if( _icon )
			{
				removeComponentChild( _icon );
				_icon.dispose();
			}
			
			_icon = icon;
			if( _icon )
			{
				_icon.init();
				addComponentChild(_icon);
			}
			invalidatePreferredSizeCache();
		}

		override public function repaint () : void 
		{
			_icon.repaint();
			super.repaint();
		}
		
	}
}

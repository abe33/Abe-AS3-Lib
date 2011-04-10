package abe.com.ponents.skinning.icons 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.colors.Color;
	import abe.com.mon.colors.Palette;
	import abe.com.ponents.utils.Insets;

	/**
	 * @author cedric
	 */
	public class PaletteIcon extends ColorIcon 
	{
		static public var paletteColorSize : Number = 5;
		
		static public var paletteBackgroundColor : Color = Color.White;
		
		protected var _palette : Palette;

		public function PaletteIcon ( palette : Palette)
		{
			super( null );
			_contentType = "Palette";
			_palette = palette;
			invalidatePreferredSizeCache();
		}
		override public function clone () : *
		{
			return new PaletteIcon( _palette );
		}

		override protected function drawChecker () : void
		{
			var insets : Insets = _style.insets;	
			
			_childrenContainer.graphics.clear();
			_childrenContainer.graphics.beginFill( paletteBackgroundColor.hexa, alpha);
			_childrenContainer.graphics.drawRect( insets.left, insets.top, width-insets.horizontal, height-insets.vertical );
			_childrenContainer.graphics.endFill();
		}

		override protected function drawColor () : void
		{
			if( _palette )
			{
				var insets : Insets = _style.insets;
				var x : Number = insets.left;				var y : Number = insets.top;
				var n : int = 0;
				
				var l : uint = _palette.colors.length;
				
				loopy:for(var i:int=0;i<4; i++,y += paletteColorSize)
				{
					for(var j:int=0;j<8;j++,x += PaletteIcon.paletteColorSize, n++ )
					{
						_childrenContainer.graphics.beginFill( _palette.getColorAt(n).hexa );
						_childrenContainer.graphics.drawRect( x, y, paletteColorSize, paletteColorSize );
						_childrenContainer.graphics.endFill();
						
						
						if( n+1 >= l )
							break loopy;
					}
					x = insets.left;
				}
			}
		}

		override public function invalidatePreferredSizeCache () : void
		{
			_preferredSizeCache = new Dimension( 8 * PaletteIcon.paletteColorSize, 4 * paletteColorSize );
			invalidate( false );
		}

		public function get palette () : Palette { return _palette; }		
		public function set palette (palette : Palette) : void
		{
			_palette = palette;
			invalidate();
		}
	}
}

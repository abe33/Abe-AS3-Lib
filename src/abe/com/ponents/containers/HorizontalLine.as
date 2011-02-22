package abe.com.ponents.containers 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.core.AbstractComponent;

	[Skinable(skin="HorizontalLine")]
	[Skin(define="HorizontalLine",
		  inherit="EmptyComponent",
		  state__all__insets="new cutils::Insets(3)",
		  state__all__background="new deco::SeparatorDecoration(skin.lightColor,skin.shadowColor,0)"
	)]
	public class HorizontalLine extends AbstractComponent 
	{
		public function HorizontalLine ()
		{
			super();
			invalidatePreferredSizeCache();
		}
		override public function invalidatePreferredSizeCache () : void
		{
			_preferredSizeCache = new Dimension(24,6);
			super.invalidatePreferredSizeCache();
		}
		override public function repaint () : void
		{
			var size : Dimension = calculateComponentSize();
			_repaint( size );			
		}
		
	}
}

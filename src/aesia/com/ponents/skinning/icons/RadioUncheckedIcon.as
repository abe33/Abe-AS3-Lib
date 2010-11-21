package aesia.com.ponents.skinning.icons 
{
	import aesia.com.mon.utils.Color;

	import flash.display.Shape;

	/**
	 * @author Cédric Néhémie
	 */
	public class RadioUncheckedIcon extends Shape
	{
		public function RadioUncheckedIcon ()
		{
			this.graphics.lineStyle( 0, Color.DimGray.hexa );
			this.graphics.beginFill( Color.White.hexa );
			this.graphics.drawCircle(6, 6, 6);
			this.graphics.endFill();
		}
	}
}

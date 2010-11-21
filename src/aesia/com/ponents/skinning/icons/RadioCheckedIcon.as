package aesia.com.ponents.skinning.icons 
{
	import aesia.com.mon.utils.Color;

	import flash.display.Shape;

	/**
	 * @author Cédric Néhémie
	 */
	public class RadioCheckedIcon extends Shape
	{
		public function RadioCheckedIcon ()
		{
			this.graphics.lineStyle( 0, Color.DimGray.hexa );
			this.graphics.beginFill( Color.White.hexa );
			this.graphics.drawCircle(6, 6, 6);
			this.graphics.endFill();
			
			this.graphics.beginFill( Color.Black.hexa );
			this.graphics.drawCircle(6, 6, 3);
			this.graphics.endFill();
		}
	}
}

package aesia.com.ponents.skinning.icons 
{
	import aesia.com.mon.utils.Color;

	import flash.display.Shape;

	/**
	 * @author Cédric Néhémie
	 */
	public class CheckBoxCheckedIcon extends Shape
	{
		public function CheckBoxCheckedIcon ()
		{
			this.graphics.beginFill( Color.DimGray.hexa );
			this.graphics.drawRect(0, 0, 12, 12);
			this.graphics.endFill();
						this.graphics.beginFill( Color.White.hexa );
			this.graphics.drawRect(1, 1, 10, 10);
			this.graphics.endFill();
			
			this.graphics.beginFill( Color.Black.hexa );
			this.graphics.lineStyle( 0, Color.Black.hexa );
			this.graphics.moveTo(2,3);
			this.graphics.lineTo(4.5,7);			this.graphics.lineTo(12,2);			this.graphics.lineTo(4,10);			this.graphics.lineTo(2,3);
			this.graphics.endFill();
		}
	}
}

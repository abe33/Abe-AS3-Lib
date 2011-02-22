package abe.com.ponents.skinning.icons 
{
	import abe.com.ponents.skinning.DefaultSkin;

	import flash.display.Shape;
	/**
	 * @author Cédric Néhémie
	 */
	public class RadioUncheckedIcon extends Shape
	{
		public function RadioUncheckedIcon ()
		{
			this.graphics.beginFill( DefaultSkin.checkBoxBorderColor.hexa );
			this.graphics.drawCircle(6, 6, 6);
			this.graphics.endFill();
			
			this.graphics.beginFill( DefaultSkin.checkBoxBackgroundColor.hexa );
			this.graphics.drawCircle(6, 6, 5);
			this.graphics.endFill();
		}
	}
}

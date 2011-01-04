package aesia.com.ponents.skinning.icons 
{
	import aesia.com.ponents.skinning.DefaultSkin;

	import flash.display.Shape;
	/**
	 * @author Cédric Néhémie
	 */
	public class CheckBoxUncheckedIcon extends Shape
	{
		public function CheckBoxUncheckedIcon ()
		{
			this.graphics.beginFill( DefaultSkin.checkBoxBorderColor.hexa );
			this.graphics.drawRect(0, 0, 12, 12);
			this.graphics.endFill();
			
			this.graphics.beginFill( DefaultSkin.checkBoxBackgroundColor.hexa );
			this.graphics.drawRect(1, 1, 10, 10);
			this.graphics.endFill();
		}
	}
}

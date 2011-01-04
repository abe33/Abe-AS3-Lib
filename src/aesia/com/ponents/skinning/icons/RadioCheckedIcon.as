package aesia.com.ponents.skinning.icons 
{
	import aesia.com.ponents.skinning.DefaultSkin;

	import flash.display.Shape;
	/**
	 * @author Cédric Néhémie
	 */
	public class RadioCheckedIcon extends Shape
	{
		public function RadioCheckedIcon ()
		{
			this.graphics.beginFill( DefaultSkin.checkBoxBorderColor.hexa );			this.graphics.drawCircle(6, 6, 6);			this.graphics.endFill();
			
			this.graphics.beginFill( DefaultSkin.checkBoxBackgroundColor.hexa );
			this.graphics.drawCircle(6, 6, 5);			this.graphics.endFill();
			
			this.graphics.beginFill( DefaultSkin.checkBoxTickColor.hexa );
			this.graphics.drawCircle(6, 6, 3);
			this.graphics.endFill();
		}
	}
}

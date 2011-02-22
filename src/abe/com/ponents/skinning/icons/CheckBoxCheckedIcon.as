package abe.com.ponents.skinning.icons 
{
	import abe.com.ponents.skinning.DefaultSkin;
	import abe.com.mon.utils.Color;

	import flash.display.Shape;

	/**
	 * @author Cédric Néhémie
	 */
	public class CheckBoxCheckedIcon extends Shape
	{
		public function CheckBoxCheckedIcon ()
		{
			this.graphics.beginFill( DefaultSkin.checkBoxBorderColor.hexa );
			this.graphics.drawRect(0, 0, 12, 12);
			this.graphics.endFill();
						this.graphics.beginFill( DefaultSkin.checkBoxBackgroundColor.hexa );
			this.graphics.drawRect(1, 1, 10, 10);
			this.graphics.endFill();
			
			this.graphics.beginFill( DefaultSkin.checkBoxTickColor.hexa );
			this.graphics.lineStyle( 0, DefaultSkin.checkBoxTickColor.hexa );
			this.graphics.moveTo(2,3);
			this.graphics.lineTo(4.5,7);			this.graphics.lineTo(12,2);			this.graphics.lineTo(4,10);			this.graphics.lineTo(2,3);
			this.graphics.endFill();
		}
	}
}

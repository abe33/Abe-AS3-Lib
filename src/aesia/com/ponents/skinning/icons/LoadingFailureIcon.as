package aesia.com.ponents.skinning.icons 
{
	import flash.display.Shape;

	/**
	 * @author Cédric Néhémie
	 */
	public class LoadingFailureIcon extends Shape 
	{
		public function LoadingFailureIcon ()
		{
			this.graphics.lineStyle(2,0xff0000);
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(12, 12);
			
			this.graphics.moveTo(0, 12);
			this.graphics.lineTo(12, 0);
		}
	}
}

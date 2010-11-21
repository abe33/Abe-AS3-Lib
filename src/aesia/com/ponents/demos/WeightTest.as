package aesia.com.ponents.demos 
{
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.buttons.Button;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	public class WeightTest extends Sprite 
	{
		public function WeightTest ()
		{
			StageUtils.setup(this);
			var bt : Button = new Button();
			
			addChild( bt );
		}
	}
}

package abe.com.edia.fx.planet 
{
	import abe.com.mon.colors.Color;

	import flash.display.Shape;
	/**
	 * @author Cédric Néhémie
	 */
	public class CloudShadow extends Shape 
	{
		public var cloud : Cloud;
	
		public function CloudShadow ( cloud : Cloud, color : Color = null )
		{
			this.graphics.beginFill( color.hexa, .2 );
			this.graphics.drawCircle(0, 0, cloud.width / 2 );
			this.graphics.endFill();
			this.cloud = cloud;
		}
		public function update() : void
		{
			rotation = 0;
			scaleY = cloud.scaleY;
			rotation = cloud.rotation;
			visible = !cloud.isBack;
			x = cloud.x * 0.92 ;
			y = cloud.y * 0.92 ;
		}
	}
}

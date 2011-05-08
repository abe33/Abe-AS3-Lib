package abe.com.edia.fx.planet 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	/**
	 * @author Cédric Néhémie
	 */
	public class PlanetObject extends Sprite 
	{
		public var long : Number = 0;
		public var lat : Number = 0;
		
		public function PlanetObject (long : Number = 0, lat : Number = 0)
		{
			this.lat = lat;
			this.long = long;
		}

		public function drawDebug ( p : Planet ) : void
		{
			this.graphics.beginFill(0);
			this.graphics.drawCircle(0, 0, 5);
			this.graphics.endFill();
			
			p.planetMap.fillRect( new Rectangle( long, lat, 2, 2 ), 0xffffff );
		}
	}
}

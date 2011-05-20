package abe.com.edia.fx.planet 
{
	import abe.com.edia.fx.sky.Sky;
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.core.*;

	import flash.events.Event;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="EmptyComponent")]
	public class PlanetPreview extends AbstractComponent 
	{
		protected var _planet : Planet;
		protected var _sky : Sky;

		public function PlanetPreview ( p : Planet, s : Sky )
		{
			super( );
			_planet = p;
			_sky = s;
			
			_childrenContainer.addChild( _sky );
			_childrenContainer.addChild( _planet );
		}

		override public function repaint () : void
		{
			super.repaint( );
			_planet.x = width/2;
			_planet.y = height/2;
			_sky.x = (width-_sky.width)/2;
			_sky.y = (height-_sky.height)/2;
			
			//_sky.size = new Dimension(width,height );
			//_sky.draw();
		}

		override public function invalidatePreferredSizeCache () : void
		{
			_preferredSizeCache = new Dimension( _planet.width, _planet.height );
			invalidate(true);
		}

		public function get planet () : Planet
		{
			return _planet;
		}
		public function set planet (planet : Planet) : void
		{
			_planet = planet;
		}

		override public function click ( ctx : UserActionContext ) : void
		{
			super.click( ctx );
			
			if( hasEventListener(Event.ENTER_FRAME) )
				removeEventListener(Event.ENTER_FRAME, enterFrame);
			else
				addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame (event : Event) : void
		{
			_planet.animate();
			_planet.update();
		}
	}
}

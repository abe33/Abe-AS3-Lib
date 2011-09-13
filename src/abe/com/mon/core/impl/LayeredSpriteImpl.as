/**
 * @license
 */
package abe.com.mon.core.impl
{
    import abe.com.mon.core.LayeredSprite;

    import flash.display.Sprite;
    import flash.events.Event;
	/**
	 * A standard implementation of the <code>LayeredSprite</code> interface.
	 * <fr>
	 * Une implémentation de base de l'interface <code>LayeredSprite</code>.
	 * <p>
	 * Un objet <code>LayeredSpriteImpl</code> est donc constitué en interne
	 * de trois sous-objets <code>Sprite</code> représentant les différents
	 * niveaux de ce <code>LayeredSprite</code>.
	 * </p>
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public class LayeredSpriteImpl extends Sprite implements LayeredSprite
	{
		private var _backgroundCleared : Boolean;
		private var _foregroundCleared : Boolean;
		
		/**
		 * @copy abe.com.mon.core.LayeredSprite#background
		 * @default	new Sprite()
		 */
		protected var _background : Sprite;
		/**
		 * @copy abe.com.mon.core.LayeredSprite#middle
		 * @default	new Sprite()		 */
		protected var _middle : Sprite;
		/**
		 * @copy abe.com.mon.core.LayeredSprite#foreground
		 * @default	new Sprite()		 */
		protected var _foreground : Sprite;

		/**
		 * <code>LayeredSpriteImpl</code> constructor.
		 * <fr>
		 * Constructeur de la classe <code>LayeredSpriteImpl</code>.
		 * </fr>
		 */
		public function LayeredSpriteImpl ()
		{			_background = new Sprite();			_middle = new Sprite();
			_foreground = new Sprite();

			_backgroundCleared = false;
			_foregroundCleared = false;
			addChild( _background );			addChild( _middle );
			addChild( _foreground );
		}

		/**
		 * @inheritDoc
		 */
		public function get background () : Sprite { return _background; }
		/**
		 * @inheritDoc
		 */
		public function get middle () : Sprite { return _middle; }
		/**
		 * @inheritDoc
		 */
		public function get foreground () : Sprite { return _foreground; }
		
		
		/**
		 * @inheritDoc
		 */
		public function clearBackgroundGraphics () : void
		{
			if( !_backgroundCleared )
			{
				_background.graphics.clear();
				addEventListener(Event.EXIT_FRAME, exitFrame );
				_backgroundCleared = true;
			}
		}
		/**
		 * @inheritDoc
		 */
		public function clearForegroundGraphics () : void
		{
			if( !_foregroundCleared )
			{
				_foreground.graphics.clear();
				addEventListener(Event.EXIT_FRAME, exitFrame );
				_foregroundCleared = true;
			}
		}

		private function exitFrame (event : Event) : void
		{
			_backgroundCleared = false;			_foregroundCleared = false;
			removeEventListener(Event.EXIT_FRAME, exitFrame );
		}
	}
}

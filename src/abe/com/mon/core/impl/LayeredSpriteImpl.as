/**
 * @license
 */
package abe.com.mon.core.impl
{
	import abe.com.mon.core.LayeredSprite;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * Une implémentation de base de l'interface <code>LayeredSprite</code>.
	 * <p>
	 * Un objet <code>LayeredSpriteImpl</code> est donc constitué en interne
	 * de trois sous-objets <code>Sprite</code> représentant les différents
	 * niveaux de ce <code>LayeredSprite</code>.
	 * </p>
	 *
	 * @author Cédric Néhémie
	 */
	public class LayeredSpriteImpl extends Sprite implements LayeredSprite
	{
		/**
		 * Référence vers l'objet graphique représentant l'arrière-plan.
		 *
		 * @default	new Sprite()
		 */
		protected var _background : Sprite;
		/**
		 * Référence vers l'objet graphique situé entre l'arrière-plan
		 * et l'avant-plan.
		 *
		 * @default	new Sprite()
		 */		protected var _middle : Sprite;
		/**
		 * Référence vers l'objet graphique représentant l'avant-plan.
		 *
		 * @default	new Sprite()
		 */		protected var _foreground : Sprite;

		/**
		 * Constructeur de la classe <code>LayeredSpriteImpl</code>.
		 */
		public function LayeredSpriteImpl ()
		{
			_background = new Sprite();			_middle = new Sprite();			_foreground = new Sprite();

			_backgroundCleared = false;
			_foregroundCleared = false;

			addChild( _background );			addChild( _middle );			addChild( _foreground );
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

		private var _backgroundCleared : Boolean;
		private var _foregroundCleared : Boolean;
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

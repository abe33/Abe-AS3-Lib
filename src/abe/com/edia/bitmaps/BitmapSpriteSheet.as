/**
 * @license
 */
package abe.com.edia.bitmaps
{
	import abe.com.mon.core.Cloneable;
	import abe.com.mon.core.Suspendable;
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.utils.MathUtils;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseListener;

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	[Event(name="complete",type="flash.events.Event")]
	/**
	 * Version animée de la classe <code>BitmapSprite</code>. La classe <code>BitmapSpriteSheet</code>
	 * reprend les mêmes principe que sa classe mère et fournie en plus des contrôles d'animations rudimentaires.
	 * <p>
	 * L'animation est réalisée sur la base du systèmes de spritesheet. Chaque image de l'animation est présente
	 * sur l'objet <code>data</code>. Chaque image de l'animation ayant une taille identique.
	 * Ensuite, l'animation consiste en le déplacement du <code>Rectangle</code> source au sein de cette image.
	 * En déplacant cette <em>tête de lecture</em> au sein de l'image, à interval régulier, on obtient une animation.
	 * La tête de lecture se déplace horizontalement, de gauche à droite.
	 * </p>
	 * <p>
	 * La vitesse de l'animation est définie par la propriété <code>framerate</code> de l'objet. Le <code>framerate</code>
	 * est exprimé en <em>image/secondes</em>.
	 * </p>
	 * <p>La lecture de l'animation réalisée par une instance de <code>BitmapSpriteSheet</code> est toujours
	 * une lecture en boucle.</p>
	 *
	 * @author Cédric Néhémie
	 * @see http://livedocs.adobe.com/flex/3/langref/flash/display/BitmapData.html BitmapData
	 * @see http://fr.wikipedia.org/wiki/Sprite_(jeu_vidéo) Définition de Sprite sur Wikipédia (fr)
	 * @see http://en.wikipedia.org/wiki/Bit_blit Définition du Bit Blit sur Wikipédia (en)
	 */
	public class BitmapSpriteSheet extends BitmapSprite implements Cloneable, ImpulseListener, Suspendable, IEventDispatcher
	{
		/**
		 * Un objet <code>EventDispatcher</code> composé par l'instance afin de diffuser ses évènements.
		 */
		protected var _dispatcher : EventDispatcher;

		/**
		 * L'image courante dans l'animation.
		 *
		 * @default 0
		 */
		protected var _currentFrame : Number;

		/**
		 * Le nombre total d'images sur laquelle sera jouée l'animation.
		 * <p>
		 * Il est possible de modifier cette valeur à la volée pour restreindre la plage
		 * d'images sur laquelle l'animation est réalisée.
		 * </p>
		 * <p>Le nombre d'image par défaut est calculé de la manière suivante : </p>
		 * <listing>this.totalFrames = Math.ceil( this.data.width / this.area.width );</listing>
		 */
        protected var _totalFrames : Number;

        /**
         * L'image de départ de l'animation.
         * <p>
		 * Il est possible de modifier cette valeur à la volée pour restreindre la plage
		 * d'images sur laquelle l'animation est réalisée.
		 * </p>
         *
		 * @default 0
         */
        protected var _startFrame : Number;

        /**
         * Curseur temporel utilisé pour déterminer à quel moment le changement d'image se produit.
         *
         * @default 0
         */
        protected var _elapsedTime : Number;

        /**
         * Durée d'une image dans l'animation.
         *
         * <p>La valeur par défaut est déterminé par le calcul suivant lors de l'appel au constructeur,
         * ou à la propriété <code>framerate</code> : </p>
         * <listing>_animRate = Math.floor( 1000 / rate );</listing>
         */
        protected var _animRate : Number;

        /**
         * La durée totale de l'animation en millisecondes.
         *
         * <p>La valeur est déterminé par le calcul suivant : </p>
         * <listing>_animDuration = _animRate &#42; totalFrames;</listing>
         */
        protected var _animDuration : Number;

        /**
         * Indique si l'objet est actuellement en lecture.
         */
		protected var _isRunning : Boolean;

		/**
		 * Indique si l'animation boucle en fin de timeline.
		 */
		protected var _looping : Boolean;


		/**
		 * Créer une nouvelle instance de la classe <code>BitmapSpriteSheet</code>.
		 *
		 * @param	data		les données graphique pour cet objet
		 * @param	frameSize	la taille d'une image de la séquence.
		 * 						La taille est identique pour toutes les images.
		 * @param	rate		la cadence de l'animation en <em>images/seconde</em>
		 */
		public function BitmapSpriteSheet ( data : BitmapData = null,
											frameSize : Dimension = null,
											rate : Number = 24  )
		{
			super( data );
			area.width = frameSize ? frameSize.width : 32;
            area.height = frameSize ? frameSize.height : 32;

            _totalFrames = Math.ceil( data ? data.width / area.width : 1 );
            _startFrame = 0;
            currentFrame = 0;
            _elapsedTime = 0;
            _looping = true;
			_dispatcher = new EventDispatcher(this);

            framerate = rate;
		}

		/**
		 * La cadence de l'animation en <em>images/seconde</em>.
		 */
		public function get framerate () : Number { return Math.round( 1000 / _animRate ); }
		public function set framerate ( rate : Number) : void
		{
			_animRate = Math.floor( 1000 / rate );
			_animDuration = _totalFrames * _animRate;
		}
		/**
		 * La durée de l'animation en images.
		 */
		public function get totalFrames () : Number { return _totalFrames; }
		public function set totalFrames (totalFrames : Number) : void
		{
			_totalFrames = totalFrames;
			_animDuration = _totalFrames * _animRate;
		}
		/**
		 * L'animation boucle-t'elle ?
		 */
		public function get looping () : Boolean { return _looping; }
		public function set looping (looping : Boolean) : void
		{
			_looping = looping;
		}
		/**
		 * L'image courante dans l'animation.
		 *
		 * @default 0
		 */
		public function get currentFrame () : Number { return _currentFrame; }
		public function set currentFrame (currentFrame : Number) : void
		{
			_elapsedTime = currentFrame * _animRate;
			computeCurrentFrame();
		}
		 /**
         * L'image de départ de l'animation.
         * <p>
		 * Il est possible de modifier cette valeur à la volée pour restreindre la plage
		 * d'images sur laquelle l'animation est réalisée.
		 * </p>
         *
		 * @default 0
         */
		public function get startFrame () : Number { return _startFrame; }
		public function set startFrame (startFrame : Number) : void
		{
			_startFrame = startFrame;
			computeCurrentFrame();
		}
		/**
		 * Démarre ou redémarre l'animation de cette instance.
		 */
		public function start () : void
		{
			if( !_isRunning )
			{
				_isRunning = true;
				Impulse.register( tick );
			}
		}
		/**
		 * Interrompt l'animation de cette instance.
		 */
		public function stop () : void
		{
			if( _isRunning )
			{
				_isRunning = false;
				Impulse.unregister( tick );
			}
		}
		/**
		 * Renvoie <code>true</code> si cette instance est en court d'animation,
		 * <code>false</code> autrement.
		 *
		 * @return	<code>true</code> si cette instance est en court d'animation,
		 * 			<code>false</code> autrement
		 */
		public function isRunning () : Boolean
		{
			return _isRunning;
		}
		/**
		 * Fonction appelée à chaque interval temporel.
		 * <p>
		 * L'animation est réalisée dans cette fonction.
		 * </p>
		 *
		 * @param	e	objet <code>ImpulseEvent</code> diffusé avec l'évènement
		 */
		public function tick(  bias : Number, biasInSeconds : Number, currentTime : Number ) : void
        {
        	animate( bias );
        }

        /**
         * Déplace le curseur temporel de <code>n</code> millisecondes dans le sens de l'animation.
         * <p>
         * La fonction ajoute le paramètre <code>n</code> au temps écoulé, puis appel successivement les
         * méthodes <code>computeCurrentFrame()</code> et <code>checkLoop()</code>.
         * </p>
         * <p>
		 * Réécrivez cette fonction pour définir votre méthode de gestion de l'animation.
		 * </p>
         * @param	n	nombre de millisecondes dont la tête de lecture va avancer
         * @see #computeCurrentFrame()
         * @see #checkLoop()
         */
        public function animate ( n : Number ) : void
        {
        	_elapsedTime += n;

            computeCurrentFrame ();
            checkLoop ();
		}

		/**
		 * Calcule la position de la tête de lecture en fonction du temps écoulé.
		 * <p>
		 * Si la position de la tête de lecture calculée est différente de l'actuelle,
		 * la méthode <code>updatePlayhead()</code> est appelée.
		 * </p>
		 * @see #updatePlayhead()
		 */
		protected function computeCurrentFrame () : void
		{
            var f : Number = Math.floor( MathUtils.map( _elapsedTime, 0, _animDuration, _startFrame, _startFrame + _totalFrames - 1 ) );

            if( f != currentFrame )
            {
            	_currentFrame = f;
				updatePlayhead ();
            }
		}
		/**
         * Renvoie une copie de l'objet courant.
         *
         * @return une copie de l'objet courant
         */
		override public function clone () : *
		{
			var bas : BitmapSpriteSheet = new BitmapSpriteSheet( data , new Dimension( area.width, area.height ), 1000 / _animRate );
			bas.currentFrame = _currentFrame;
			bas.center = center.clone();
            bas.position = position.clone();
            bas.visible = visible;
			return bas;
		}

		/**
		 * Met à jour la zone source pour le dessin du bitmap en fonction de l'image courante.
		 * <p>
		 * Réécrivez cette fonction pour définir votre méthode de déplacement de la tête lecture.
		 * </p>
		 */
        protected function updatePlayhead () : void
        {
            area.x = _currentFrame * area.width;
		}
		/**
		 * Vérifie si le temps écoulé dépasse la durée de l'animation, auquel cas la fonction
		 * retranche la durée de l'animation au temps écoulé.
		 */
		protected function checkLoop () : void
		{
			if( _elapsedTime > _animDuration )
			{
				if( _looping )
            		_elapsedTime -= _animDuration;
            	else
            	{
            		_elapsedTime = _animDuration;
            		stop();
            		dispatchEvent(new Event(Event.COMPLETE));
            	}
			}
		}

		public function dispatchEvent (event : Event) : Boolean
		{
			return _dispatcher.dispatchEvent(event);
		}
		public function hasEventListener (type : String) : Boolean
		{
			return _dispatcher.hasEventListener(type);
		}
		public function willTrigger (type : String) : Boolean
		{
			return _dispatcher.willTrigger(type);
		}
		public function removeEventListener (type : String, listener : Function, useCapture : Boolean = false) : void
		{
			_dispatcher.removeEventListener(type, listener,useCapture);
		}
		public function addEventListener (type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void
		{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference );
		}
	}
}

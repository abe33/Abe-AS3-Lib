/**
 * @license
 */
package  abe.com.motion
{
	import org.osflash.signals.Signal;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	/**
	 * Un <code>MotionImpulse</code> est un métronome réglant les animations
	 * d'une séries d'objets afin de les synchroniser. Il agit comme un
	 * diffuseur d'évènements, les objets s'enregistrant pour recevoir
	 * l'évènement <code>ImpulseEvent.TICK</code> à chaque pas d'une animation.
	 * <p>
	 * Cet évènement fournit un certain nombre d'informations
	 * permettant aux écouteurs de se synchroniser. La donnée la plus
	 * importante pour synchroniser des objets et la valeur de <code>bias</code>,
	 * cette valeur indique la durée mesurée, en millisecondes,
	 * de la frame précédente, cette durée permet par exemple de déterminer
	 * la distance parcourue par un objet, ou d'incrémenter un compteur
	 * de temps pour un système de rappel à interval.
	 * </p><p>
	 * La classe <code>MotionImpulse</code> fournie des contrôles permettant
	 * d'altérer le déroulement du temps de tout les objets contrôlés par
	 * une instance de <code>MotionImpulse</code>. Il est ainsi possible
	 * de ralentir, ou d'accélérer, le déroulement du temps, de restreindre
	 * l'impact des lags par un lissage ou une limitation des valeurs temporelles
	 * diffusées par l'instance.</p>
	 *
	 * @author Cédric Néhémie
	 * @see ImpulseListener
	 * @see ImpulseEvent
	 */
	public class MotionImpulse extends Shape
	{
		public var tick : Signal;
		/**
		 * Facteur d'altération de la vitesse d'écoulement du temps.
		 * Cette valeur est utilisée afin de multiplier le bias avant sa
		 * diffusion aux écouteurs de la classe.
		 *
		 * @default 1
		 */
		public var speedFactor : Number;
		/**
		 * Facteur de lissage des valeurs de bias. Cette valeur correspond
		 * au nombre de valeurs de bias sur lesquels on calculera la moyenne.
		 * Dès lors que cette valeur est supérieure à 1 le lissage est effectif
		 * et les valeurs mesurée seront utilisées afin de produire la moyenne
		 * qui sera diffusée aux écouteurs.
		 * <p>
		 * Le lissage permet de minimiser l'impact d'un lag, en accélérant ou
		 * ralentissant l'animation, mais peut aussi créer certains effet non
		 * désirés. Par exemple, si une frame dure beaucoup plus longtemps que
		 * la normal, et que le facteur de lissage est assez élevé, on observera
		 * une accélération subite sur toutes les frames suivantes. Pour palier
		 * à cet effet il suffit de définir une limite pour les valeurs de bias.
		 * </p>
		 *
		 * @default 0
		 */
		public var smoothFactor : uint;
		/**
		 * Valeur maximum pour les valeurs de bias, avant transformation par les
		 * facteurs de vitesse et de lissage. La valeur est une valeur en
		 * millisecondes utilisée pour confronter avec la durée de la frame
		 * mesurée. Dès lors que la valeur limite est supérieure ou égale à 1
		 * les valeurs de bias seront soumises à une limitation avant d'être
		 * diffusées aux écouteurs.
		 * <p>
		 * La valeur maximum est dépendante du facteur de vitesse d'écoulement
		 * du temps, par exemple, si le facteur de vitesse est de 2 la valeur
		 * maximum réelle sera de maxBias &#42; 2.
		 * </p>
		 *
		 * @default 0
		 */
		public var maxBias : uint;
		/**
		 * Un entier chargé de contenir le compte d'écouteurs actuellement
		 * enregistré dans cette instance.
		 */
		protected var _listenersCount : Number;
		// Un dictionnaire avec les écouteurs de cette instance
		private var _listernersDict : Dictionary;
		// Temps de fin de la dernière frame
		private var _lastTime : Number;
		// Durées des dernières frames
		private var _pastValues : Array;
		// Somme des durées des dernières frames
		private var _pastValuesSum : Number;
		/**
		 * Créer une nouvelle instance de la classe <code>MotionImpulse</code>.
		 * <p>
		 * Différentes instances de la classe peuvent coéxister,
		 * afin de créer des conditions d'écoulement du temps
		 * différentes d'une instances à l'autre.
		 * </p>
		 * @param	speedFactor		facteur de vitesse d'écoulement
		 * 							du temps pour cette instance
		 * @param	smoothFactor	facteur de lissage des valeurs
		 * 							de bias pour cette instance
		 * @param	maxBias			valeur maximum de bias pour
		 * 							cette instance
		 */
		public function MotionImpulse ( speedFactor : Number = 1,
									    smoothFactor : uint = 0,
									    maxBias : uint = 0 )
		{
			this.speedFactor = speedFactor;
			this.smoothFactor = smoothFactor;
			this.maxBias = maxBias;
			this._pastValues = [];
			this._pastValuesSum = 0;
			this._listenersCount = 0;
			this._listernersDict = new Dictionary(true);
			tick = new Signal(Number,Number,Number);
		}
		/**
		 * Nombre d'écouteurs actuellement enregistré pour l'évènement <code>ImpulseEvent.TICK</code>
		 * sur cette instance de <code>MotionImpulse</code>.
		 */
		public function get listenersCount () : Number { return tick.numListeners; }
		/**
		 * Réalise la mesure de la durée de chaque frame et notifie
		 * tout les écouteurs. Les transformations de l'écoulement du
		 * temps se font également dans cette fonction.
		 *
		 * @param	e	objet <code>Event</code> reçu avec l'évènement
		 */
		public function enterFrame ( e : Event ) : void
		{
			var currentTime : Number = getTimer();
			var bias : Number = ( currentTime - _lastTime ) * speedFactor;

			if( maxBias > 0 ) bias = restrict( bias );
			if( smoothFactor > 0 ) bias = smooth ( bias );

			tick.dispatch( bias, bias / 1000, currentTime );

			_lastTime = currentTime;
		}
		/**
		 * Démarre ou redémarre l'instance.
		 */
		public function start() : void
		{
			this._lastTime = getTimer();
			addEventListener( Event.ENTER_FRAME, enterFrame );
		}
		/**
		 * Stoppe l'instance.
		 */
		public function stop() : void
		{
			removeEventListener( Event.ENTER_FRAME, enterFrame );
		}
		/**
		 * Renvoie <code>true</code> si l'instance courante est
		 * actuellement en train de diffuser ses évènements.
		 * <p>
		 * Une instance n'est pas considérée comme en lecture si
		 * elle ne possède aucun écouteur pour son évènement
		 * <code>ImpulseEvent.TICK</code>.
		 * </p>
		 * @return	<code>true</code> si l'instance courante est
		 * 			actuellement en train de diffuser ses évènements
		 */
		public function isPlaying () : Boolean
		{
			return hasEventListener( Event.ENTER_FRAME );
		}
		/**
		 * Enregistre directement un écouteur pour l'évènement
		 * <code>ImpulseEvent.TICK</code> diffusé par l'instance.
		 *
		 * @param	closure	fonction à enregistrer comme écouteur
		 */
		public function register ( closure : Function ) : void
		{
			tick.add( closure );
			if( tick.numListeners == 1 )
				start();
		}
		/**
		 * Désabonne un écouteur pour l'évènement
		 * <code>ImpulseEvent.TICK</code> diffusé par l'instance.
		 *
		 * @param	closure	fonction à désabonner
		 */
		public function unregister ( closure : Function ) : void
		{
			tick.remove( closure );
			if( tick.numListeners == 0 )
				stop();
		}
		/**
		 * Renvoie une valeur lissée à partir de la valeur passée
		 * en paramètre et des N dernières valeurs. La valeur renvoyée
		 * est issue de la moyenne des N dernières valeurs, où N est
		 * le facteur de lissage de cette instance de MotionImpulse.
		 *
		 * @param	n	la valeur courante à lisser
		 * @return	la valeur lissée avec les N dernières valeurs
		 */
		protected function smooth ( n : Number) : Number
		{
			_pastValues.push( n );
			var l : Number = _pastValues.length;
			if( l > smoothFactor )
			{
				_pastValuesSum -= Number( _pastValues.shift() );
				l--;
			}
			_pastValuesSum += n;

			return _pastValuesSum / l;
		}
		/**
		 * Renvoie la valeur passée en paramètre si celle-ci
		 * est inférieure ou égale à la limite courante pour
		 * cette instance de <code>MotionImpulse</code>.
		 * <p>
		 * La limite courante est définie comme suit :
		 * pas maximum &#42; facteur de vitesse.
		 * Si la valeur passée dépasse cette limite,
		 * la valeur limite est renvoyée.
		 * </p>
		 * @param	n	la valeur à tester contre la limite
		 * @return	la valeur initiale si celle-ci est inférieure
		 * 			à la limite, sinon la valeur limite
		 */
		protected function restrict ( n : Number ) : Number
		{
			var l : Number = maxBias * speedFactor;
			 return n > l ? l : n;
		}
	}
}

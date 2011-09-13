/**
 * @license
 */
package abe.com.motion
{
    import abe.com.mands.AbstractCommand;
    import abe.com.mands.Command;
    import abe.com.mon.core.Runnable;
    import abe.com.mon.core.Suspendable;
    import abe.com.mon.logs.Log;
    import abe.com.motion.properties.SpecialProperty;
    import abe.com.patibility.serialize.sourcesDictionary;

    import org.osflash.signals.Signal;

    import flash.utils.Dictionary;

	/**
	 * La classe <code>AbstractTween</code> sert de classe de base au différentes
	 * implémentations de l'interface <code>Tween</code>. Elle fournie les contrôles
	 * de base définie par l'interface ainsi que le mécanisme de gestion des
	 * propriétés spéciales.
	 * <p>
	 * La classe <code>AbstractTween</code> agie aussi comme gestionnaire global
	 * pour des objets <code>Tween</code> crées avec les méthodes <code>add</code>
	 * des implémentations concrètes.
	 * </p>
	 *
	 * @author Cédric Néhémie
	 */
	public class AbstractTween extends AbstractCommand implements Command,
																  Runnable,
																  Suspendable,
																  ImpulseListener,
																  Tween
	{
		/*---------------------------------------------------------------*
		 * 	SPECIAL PROPERTIES MANAGEMENT
		 *---------------------------------------------------------------*/
		/**
		 * Un objet contenant les paires <code>nom-&gt;propriété spéciale</code> enregistrées
		 * dans la classe <code>SingleTween</code>.
		 *
		 * @default	{}
		 */
		static protected var _specialProperties : Object = {};
		/**
		 * Enregistre des fonctions d'accès en lecture et en écriture pour une propriété spéciale.
		 * <p>
		 * Une propriété spéciale est une propriété d'un objet accessible à l'aide d'une instance de
		 * <code>SingleTween</code> mais qui n'existe pas nécessairement sur l'objet cible. À la place,
		 * des fonctions spécifiques seront appelées en lieu et place de la propriété de l'objet
		 * afin de réaliser les actions de lectures et d'écritures de cette "propriété".
		 * </p>
		 * <p>
		 * Il est possible de transmettre des paramètres supplémentaires dans les fonctions d'accès
		 * à cette propriété spéciale à l'aide du paramètre <code>extraArgs</code>.
		 * </p>
		 * @param	name		nom de la propriété spéciale
		 * @param	getter		fonction d'accès en lecture à cette propriété
		 * @param	setter		fonction d'accès en écriture à cette propriété
		 * @param	extraArgs	une tableau d'arguments supplémentaires à fournir aux fonctions d'accès
		 */
		static public function registerSpecialProperty ( name : String,
														 getter : Function,
														 setter : Function,
														 extraArgs : Array = null ) : void
		{
			_specialProperties[ name ] = new SpecialProperty( getter, setter, extraArgs );
		}
		/**
		 * Renvoie <code>true</code> si la propriété <code>name</code> est une propriété
		 * spéciale enregistrée dans la classe <code>SingleTween</code>.
		 *
		 * @param	name	nom de la propriété à vérifier
		 * @return	<code>true</code> si la propriété est une propriété	spéciale
		 */
		static public function isSpecialProperty ( name : String ) : Boolean
		{
			return _specialProperties.hasOwnProperty(name);
		}
		/*---------------------------------------------------------------*
		 * 	GLOBAL INSTANCES MANAGEMENT
		 *---------------------------------------------------------------*/
		/**
		 * Un dictionnaire contenant toutes les instances de <code>Tween</code>
		 * créées à l'aide des méthodes <code>add</code> des classes concrètes.
		 *
		 * @default	new Dictionary()
		 */
		static protected var _tweenInstances : Dictionary = new Dictionary();
		/**
		 * Recoit l'évènement de fin d'interpolation d'une instance de <code>Tween</code>
		 * globale, se désabonne de cet évènement, puis supprime l'instance du dictionnaire.
		 *
		 * @param	event	évènement diffusé par l'instance
		 */
		static protected function tweenCompleted ( command : Command ) : void
		{
			command.commandEnded.remove( tweenCompleted );
			delete _tweenInstances[command];
		}
		/**
		 * Le nombre d'instances globales actuellement stockées dans le dictionnaire.
		 */
		static public function get tweensCount () : uint
		{
			var n : uint = 0;
			for each( var t : Tween in	_tweenInstances )
				n++;

			return n;
		}
		/**
		 * Redémarre toutes les instances globales mise en pause précédemment.
		 */
		static public function resumeAllTween () : void
		{
			for each( var t : Tween in	_tweenInstances )
				t.start();
		}
		/**
		 * Met en pause toutes les instances globales actuellement stockées
		 * dans la classe.
		 */
		static public function pauseAllTween () : void
		{
			for each( var t : Tween in	_tweenInstances )
				t.stop();
		}
		/*---------------------------------------------------------------*
		 * 	MISC STATIC METHODS
		 *---------------------------------------------------------------*/
		/**
		 * Fonction de transition utilisée par défaut lorsqu'aucune fonction n'est transmis
		 * à une instance.
		 *
		 * @default	function( t : Number,  b : Number,  c : Number, d : Number ) : Number { return c * t / d + b; }
		 */
		static public function noEasing ( t : Number,  b : Number,  c : Number, d : Number ) : Number
		{
			return c * t / d + b;
		};
        sourcesDictionary[ noEasing] = "abe.com.motion::AbstractTween.noEasing";
		/*---------------------------------------------------------------*
		 * 	INSTANCES MEMBERS
		 *---------------------------------------------------------------*/
		public var tweenStarted : Signal;
		public var tweenStopped : Signal;
		public var tweenChanged : Signal;
		public var tweenEnded : Signal;
		/**
		 * La durée de cette interpolation.
		 *
		 * @default 1000
		 */
		protected var _duration   		 : Number;
		/**
		 * La position de la tête de lecture de cette interpolation dans
		 * la plage <code>0-1</code>.
		 *
		 * @default 0
		 */
		protected var _playHead   		 : Number;
		/**
		 * La fonction utilisée pour le calcul de l'interpolation.
		 *
		 * @default noEasing
		 */
		protected var _easing	   	  	 : Function;
		/**
		 * Une valeur booléene indiquant si l'interpolation se produit
		 * en sens inverse ou non.
		 *
		 * @default false
		 */
		protected var _reversedMotion 	 : Boolean;
		/**
		 * L'objet cible de cette interpolation.
		 *
		 * @default null
		 */
		protected var _target 			 : Object;
		/**
		 * Constructeur de la classe <code>AbstractTween</code>.
		 * <p>
		 * Lorsque appelé depuis une classe fille, le constructeur
		 * de <code>AbstractTween</code> devrait être appelée
		 * en tout fin d'initialisation.
		 * </p>
		 * @param	target		la cible de cette interpolation
		 * @param	duration	la durée de cette interpolation
		 * @param	easing		la fonction de transition utilisée
		 * 						pour cette interpolation.
		 */
		public function AbstractTween( 	target : Object,
										duration : Number = 1000,
										easing : Function = null )
		{
			super( );
			tweenStarted = new Signal(Tween);
			tweenStopped = new Signal(Tween);
			tweenChanged = new Signal(Tween);
			tweenEnded = new Signal(Tween);
			_target = target;
			_duration = duration;
			this.easing = easing;
		}
		/**
		 * Une valeur booléenne indiquant si l'interpolation se fait
		 * dans le sens inverse ou non.
		 */
		public function get reversed() : Boolean { return _reversedMotion; }
		public function set reversed( b : Boolean ) : void
		{
			_reversedMotion = b;
		}
		/**
		 * La position de la tête de lecture de cette interpolation dans la plage
		 * <code>0-1</code>.
		 */
		public function get playHeadPosition () : Number { return _playHead / _duration; }
		public function set playHeadPosition ( n : Number ) : void
		{
			if ( n < 0 || n > 1 )
				throw new Error( "The new playhead position must be in the range 0 < n < 1" );

			_playHead = Math.floor( n * _duration );
		}
		/**
		 * La fonction de transition utilisée pour cette interpolation.
		 */
		public function get easing() : Function { return _easing; }
		public function set easing( f : Function ) : void
		{
			_easing = ( f != null ) ?  f : noEasing;
		}
		/**
		 * La durée de cette interpolation.
		 */
		public function get duration() : Number { return _duration; }
		public function set duration( n : Number ) : void
		{
			_duration = n;
		}
		/**
		 * La cible de cette interpolation.
		 */
		public function get target() : Object { return _target; }
		public function set target( o : Object ) : void
		{
			if ( isRunning() )
			{
				/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
				Log.warn( this + ".target is not writable while playing." );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			}
			else
			{
				_target = o;
			}
		}
		/*-----------------------------------------------
		 *	Suspendable IMPLEMENTATION
		 *-----------------------------------------------*/
		/**
		 * Remet à zéro cette instance.
		 * <p>
		 * Lors d'une remise à zéro la tête de lecture est replacée
		 * à la valeur <code>0</code> et les valeurs de départs et
		 * d'arrivée sont redéfinis à l'aide des paramètres courants
		 * de l'instance.
		 * </p>
		 */
		public function reset() : void
		{
			_playHead = !_reversedMotion ? 0 : _duration;
		}
		/**
		 * Démarre l'instance courante si celle-ci n'est pas déjà
		 * en cours de lecture.
		 */
		public function start() : void
		{
			if( !_isRunning )
			{
				_isRunning = true;
				onUpdate();
				Impulse.register( tick );
				tweenStarted.dispatch( this );
			}
		}
		/**
		 * Stoppe l'instance courante si celle-ci n'est pas déjà arrêtée.
		 */
		public function stop() : void
		{
			if( _isRunning )
			{
				_isRunning = false;
				Impulse.unregister( tick );
				tweenStopped.dispatch( this );
			}
		}
		/*-----------------------------------------------
		 *	Command IMPLEMENTATION
		 *-----------------------------------------------*/
		/**
		 * Remet à zéro et démarre l'instance courante.
		 *
		 */
		override public function execute( ... args ) : void
		{
			reset();
			start();
		}
		/**
		 * Renvoie <code>true</code> si l'interpolation est terminée.
		 * <p>
		 * L'animation est terminée lorsque la valeur de la tête de lecture
		 * est supérieure ou égale à la durée de l'animation.
		 * </p>
		 *
		 * @return	<code>true</code> si l'interpolation est terminée
		 */
		public function isMotionFinished () : Boolean
		{
			 return _playHead >= _duration;
		}
		/**
		 * Renvoie <code>true</code> si l'interpolation est terminée
		 * en mode inversée.
		 * <p>
		 * L'animation est terminée lorsque la valeur de la tête de lecture
		 * est inférieure ou égale à <code>0</code>.
		 * </p>
		 *
		 * @return	<code>true</code> si l'interpolation est terminée
		 * 			en mode inversée
		 */
		public function isReversedMotionFinished () : Boolean
		{
			return _playHead <= 0;
		}
		/**
		 * Fonction appelée à chaque avancée de l'interpolation afin de mettre
		 * à jour la cible de l'interpolation.
		 */
		protected function onUpdate () : void
		{
			updateProperties( );
			tweenChanged.dispatch( this );
		}
		/**
		 * Fonction réalisant la mise à jour des propriétés de la cible
		 * sur la base de la position de la tête de lecture de cette
		 * instance.
		 */
		protected function updateProperties () : void {}
		/**
		 * Fonction appelée lors de la fin de l'interpolation.
		 */
		protected function onMotionEnd() : void
		{
			_playHead = _reversedMotion ? 0 : _duration;
			onUpdate();

			stop( );
			_commandEnded.dispatch( this );
			tweenEnded.dispatch( this );
		}
		/**
		 * Accède et renvoie la valeur de la propriété <code>name</code>
		 * sur l'objet <code>target</code>.
		 * <p>
		 * Si la propriété <code>name</code> est une propriété spéciale,
		 * la propriété spéciale est utilisée.
		 * </p>
		 * @param	name	le nom de la propriété
		 * @return	la valeur de cette propriétés
		 */
		protected function getProperty ( name : String ) : Number
		{
			if( isSpecialProperty ( name ) )
				return _specialProperties[name].getter( _target );
			else
				return _target[ name ];
		}
		/**
		 * Définie la valeur de la propriété <code>name</code> de l'objet
		 * cible avec la valeur <code>value</code>.
		 * <p>
		 * Si la propriété <code>name</code> est une propriété spéciale,
		 * la propriété spéciale est utilisée.
		 * </p>
		 * @param	name	le nom de la propriété
		 * @param	value	la nouvelle valeur de la propriété
		 */
		protected function setProperty( name : String, value : Number ) : void
		{
			if( isSpecialProperty ( name ) )
				_specialProperties[name].setter( _target, value, _specialProperties[name].extraArgs );
			else
				_target[ name ] = value;
		}
		/**
		 * Fonction réalisant l'interpolation à chaque pas de l'animation.
		 *
		 * @param	e	évènement diffusé par l'objet <code>MotionImpulse</code>
		 */
		public function tick(  bias : Number, biasInSeconds : Number, currentTime : Number ) : void
		{
			 _playHead += bias * ( _reversedMotion ? -1 : 1 );

			if ( _reversedMotion ? isReversedMotionFinished() : isMotionFinished() )
				onMotionEnd();
			else
				onUpdate();
		}
	}
}

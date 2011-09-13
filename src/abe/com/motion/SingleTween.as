/**
 * @license
 */
package  abe.com.motion
{
    import abe.com.mands.Command;
    import abe.com.mon.core.Runnable;
    import abe.com.mon.core.Suspendable;
    import abe.com.mon.logs.Log;
	/**
	 * La classe <code>SingleTween</code> réalise une interpolation de la valeur d'une propriété
	 * d'un objet cible dans le temps.
	 * <p>
	 * Une instance de la classe <code>SingleTween</code> réalise son animation en utilisant
	 * une instance de la classe <code>MotionImpulse</code>.
	 * </p>
	 */
	public class SingleTween extends AbstractTween implements 	Tween,
																Command,
																Runnable,
																Suspendable,
																ImpulseListener
	{
		/**
		 * Ajoute une instance de la classe dans le dictionnaire global.
		 * <p>
		 * La nouvelle instance est stockée par la classe <code>AbstractTween</code>,
		 * celle-ci s'enregistrant comme écouteurs afin de supprimer l'instance une fois
		 * l'interpolation terminée.
		 * </p>
		 * <p>
		 * Il est possible de créer une instance ne démarrant pas automatiquement
		 * en transmettant la valeur <code>false</code> dans l'argument <code>autoPlay</code>.
		 * </p>
		 *
		 * @param	target			la cible pour cette nouvelle instance
		 * @param	params			un objet contenant les réglages de cette instance
		 * <ul>
		 * <li><code>setter</code> : la propriété à cibler sur la cible</li>
		 * <li><code>end</code> : la valeur de fin de l'interpolation</li>
		 * <li><code>start</code> : la valeur de départ de l'interpolation</li>
		 * <li><code>duration</code> : la durée de l'interpolation</li>
		 * <li><code>easing</code> : la fonction de transition à utiliser</li>
		 * </ul>
		 * @param	autoPlay		un booléen indiquant si l'instance démarre automatiquement
		 * @return	l'instance nouvellement créée
		 */
		static public function add ( target : Object, params : Object, autoPlay : Boolean = true ) : Tween
		{
			var setter : String = params["setter"];
			var end : Number = params["end"];
			var start : Number = params["start"];
			var duration : Number = params["duration"];
			var easing : Function = params["easing"];

			if( setter && !isNaN(end) && !isNaN(duration) )
			{
				var tw : SingleTween = new SingleTween ( target, setter, end, duration, start, easing );
				_tweenInstances[tw] = tw;
				tw.commandEnded.add( tweenCompleted );

				if( autoPlay )
					tw.execute();
				return tw;
			}
			else
				return null;
		}
		/*---------------------------------------------------------------*
		 * 	INSTANCES MEMBERS
		 *---------------------------------------------------------------*/
		/**
		 * La valeur de départ de l'interpolation utilisée dans les calculs.
		 */
		protected var _start	   		 : Number;
		/**
		 * La valeur de fin de l'interpolation utilisée dans les calculs.
		 */
		protected var _end		   		 : Number;
		/**
		 * La valeur de départ de l'interpolation telle que définie par
		 * l'utilisateur, cette valeur fait office de sauvegarde.
		 */
		protected var _startValue 		 : Number;
		/**
		 * La valeur de fin de l'interpolation telle que définie par
		 * l'utilisateur, cette valeur fait office de sauvegarde.
		 */
		protected var _endValue   		 : Number;
		/**
		 * Une chaîne contenant le nom de la propriété de l'objet
		 * ciblée par cette instance.
		 */
		protected var _property 		 : String;
		/**
		 * Constructeur de la classe <code>SingleTween</code>.
		 *
		 * @param	target		la cible de cette interpolation
		 * @param	setter		la propriété ciblée
		 * @param	end			la valeur de fin de l'interpolation
		 * @param	duration	la durée de cette interpolation
		 * @param	start		la valeur de départ de l'interpolation
		 * @param	easing		la fonction de transition utilisée
		 * 						pour cette interpolation.
		 */
		public function SingleTween( 	target : Object,
										setter : String,
										end : Number,
										duration : Number = 1000,
										start : Number = NaN,
										easing : Function = null )
		{

			super( target, duration, easing );

			_property = setter;
			_endValue = end;
			_startValue = isNaN( start ) ? getProperty( _property ) : start;

			reset();
		}
		/**
		 * Une chaîne de caractère correspondant au nom de la propriété
		 * ciblée par cette interpolation.
		 */
		public function get property() : String { return _property; }
		public function set property( p : String ) : void
		{
			if ( isRunning() )
			{
				/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
				Log.warn( this + ".property is not writeable while playing." );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			}
			else
			{
				_property = p;
			}
		}
		/**
		 * La valeur de départ de l'interpolation.
		 */
		public function get startValue () : Number { return _startValue; }
		public function set startValue( n : Number ) : void
		{
			_startValue = n;
		}
		/**
		 * La valeur de fin de l'interpolation.
		 */
		public function get endValue () : Number { return _endValue; }
		public function set endValue( n : Number ) : void
		{
			_endValue = n;
		}
		/*---------------------------------------------------------------*
		 * 	INSTANCES METHODS
		 *---------------------------------------------------------------*/
		/**
		 * @inheritDoc
		 */
		override public function reset() : void
		{
			super.reset();
			_start = _startValue;
			_end = _endValue;

			if( _target )
				setProperty( _property, _reversedMotion ? _end : _start );
		}
		/**
		 * @inheritDoc
		 */
		override public function start () : void
		{
			if ( isNaN( _startValue ) )
			{
				/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
				Log.warn( this + " has no start value." );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			}
			else
				super.start ();
		}
		/**
		 * @inheritDoc
		 */
		override protected function updateProperties () : void
		{
			setProperty ( _property, _easing( _playHead, _start, _end - _start, _duration ) );
		}
	}
}

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
	 * La classe <code>MultiTween</code> permet de réaliser une interpolation
	 * sur plusieurs propriété d'un même objet dans le temps.
	 *
	 * @author Cédric Néhémie
	 */
	public class MultiTween extends AbstractTween implements Tween,
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
		 * <li><code>duration</code> : la durée de l'interpolation</li>
		 * <li><code>easing</code> : la fonction de transition à utiliser</li>
		 * <li><code>foo</code> : la valeur de fin pour la propriété <code>foo</code></li>
		 * </ul>
		 * @param	autoPlay		un booléen indiquant si l'instance démarre automatiquement
		 * @return	l'instance nouvellement créée
		 * @example Créer une interpolation sur les propriétés <code>x</code>, <code>y</code>
		 * et <code>alpha</code> de l'objet <code>myDisplayObject</code> sur une durée
		 * de <code>1000</code> millisecondes :
		 * <listing>MultiTween.add( myDisplayObject, {duration:1000, x:150, y:250, alpha:0} );</listing>
		 */
		static public function add ( target : Object, params : Object, autoPlay : Boolean = true  ) : Tween
		{
			var duration : Number = params["duration"];
			var easing : Function = params["easing"];

			delete params["duration"];
			delete params["easing"];

			var setters : Array = [];
			var ends : Array = [];

			for( var i : String in params )
			{
				setters.push(i);
				ends.push(params[i]);
			}

			if( setters.length > 0 && !isNaN(duration) )
			{
				var tw : MultiTween = new MultiTween ( target, setters, ends, duration, null, easing );
				_tweenInstances[tw] = tw;
				tw.commandEnded.add( tweenCompleted );

				if( autoPlay )
					tw.execute();
				return tw;
			}
			else
				return null;
		}
		/**
		 * Les valeurs de départ de l'interpolation.
		 */
		protected var _nStart	   		 : Array;
		/**
		 * Les valeurs de fin de l'interpolation.
		 */
		protected var _nEnd		   		 : Array;
		/**
		 * Les valeurs de départ de l'interpolation telles que définies
		 * par l'utilisateurs.
		 */
		protected var _nStartValues 	 : Array;
		/**
		 * Les valeurs de fin de l'interpolation telles que définies
		 * par l'utilisateurs.
		 */
		protected var _nEndValues   	 : Array;
		/**
		 * Un tableau contenant le nom des propriétés affectées par
		 * l'interpolation.
		 */
		protected var _properties 		 : Array;

		/**
		 * Constructeur de la classe <code>MultiTween</code>.
		 *
		 * @param	target		la cible de cette interpolation
		 * @param	setters		un tableau avec le nom des propriétés ciblées
		 * @param	ends		les valeurs de fin de l'interpolation
		 * @param	duration	la durée de cette interpolation
		 * @param	starts		les valeurs de départ de l'interpolation
		 * @param	easing		la fonction de transition utilisée
		 * 						pour cette interpolation.
		 */
		public function MultiTween( target : Object,
									setters : Array,
									ends : Array,
									duration : Number,
									starts : Array = null,
									easing : Function = null )
		{


			super( target, duration, easing );

			_properties = setters;
			_nEndValues = ends;
			_duration = duration;

			if ( !starts )
			{
				starts = [];
				var l : Number = _properties.length;
				for(var i : Number=0;i<l;i++)
					starts.push( getProperty( _properties[i] ) );
			}

			_nStartValues = starts;

			reset();
		}
		/**
		 * Un tableau contenant le nom des propriétés ciblées par l'interpolation.
		 */
		public function get properties() : Array { return _properties; }
		public function set properties( p : Array ) : void
		{
			if ( isRunning() )
			{
				/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
				Log.warn( this + ".properties is not writable while playing." );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			}
			else
				_properties = p;
		}
		/**
		 * Un tableau contenant les valeurs de départs pour l'interpolation.
		 */
		public function get startValues () : Array { return _nStartValues; }
		public function set startValues( n : Array ) : void
		{
			_nStartValues = n;
		}
		/**
		 * Un tableau contenant les valeurs de fin de l'interpolation.
		 */
		public function get endValues () : Array { return _nEndValues; }
		public function set endValues( n : Array ) : void
		{
			_nEndValues = n;
		}
		/**
		 * @inheritDoc
		 */
		override public function reset() : void
		{
			super.reset();
			_nStart = _nStartValues;
			_nEnd = _nEndValues;

			for( var i : String in _properties )
				setProperty ( _properties[i], _nStart[ i ] );
		}
		/**
		 * @inheritDoc
		 */
		override public function start() : void
		{
			if ( _nStartValues == null )
			{
				/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
				Log.warn( this + " has no start values." );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			}
			else
				super.start();
		}
		/**
		 * @inheritDoc
		 */
		override protected function updateProperties () : void
		{
			for( var i : String in _properties )
				setProperty ( _properties[i], _easing( _playHead, _nStart[ i ], _nEnd[ i ] - _nStart[ i ], _duration ) );
		}

	}
}

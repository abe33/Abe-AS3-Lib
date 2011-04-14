/**
 * @license
 */
package  abe.com.mands
{
	import abe.com.mon.core.Cancelable;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.core.Suspendable;
	import abe.com.mon.utils.StringUtils;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;

	import org.osflash.signals.Signal;

	import flash.events.Event;
	
	/**
	 * Une commande <code>Interval</code> réalise un appel de fonction à interval régulier,
	 * à l'instar de la fonction <code>setInterval</code>, mais en étant soumis au contrôle
	 * d'un objet <code>MotionImpulse</code>.
	 */
	public class Interval extends AbstractCommand implements Suspendable, Cancelable, Runnable, Command
	{
		private var _n : Number;
		private var _i : uint;
		private var _closure : Function;
		private var _delay : uint;
		private var _count : uint;
		private var _args : Array;
		private var _cancelled : Boolean;
		protected var _commandCancelled : Signal;
		/**
		 * Créer une instance de la classe <code>Interval</code>.
		 * 
		 * @param	closure	la fonction à rappeler à la fin de l'interval
		 * @param	delay	la durée de l'interval
		 * @param	count	le nombre d'appel à réaliser
		 * @param	args	suite d'arguments à transmettre à la fonction
		 */
		public function Interval( closure : Function, delay : uint = 0, count : uint = 0, ... args )
		{
			super();
			_commandCancelled = new Signal();
			this.closure = closure;
			this.delay = delay;
			this.arguments = args;
			this.count = count;
			
			reset();
		}
		public function get commandCancelled () : Signal { return _commandCancelled; }
		
		/**
		 * Éxécute la commande.
		 */
		override public function execute( e : Event = null ) : void
		{
			_cancelled = false;
			reset();
			start();
		}
		/**
		 * Démarre ou redémarre cette instance.
		 */
		public function start () : void
		{
			if( !_cancelled )
			{
				_isRunning = true;
				Impulse.register( tick );
			}
		}
		/**
		 * Arrête cette instance.
		 */
		public function stop () : void
		{
			Impulse.unregister( tick );
			_isRunning = false;
		}	
		/**
		 * Remet à zéro tout les compteurs de cette instance.
		 */	
		public function reset () : void
		{
			_n = 0;
			_i = 0;
		}
		/**
		 * Interrompt l'éxécution en cours.
		 */
		public function cancel() : void
		{
			_cancelled = true;
			stop();
			commandCancelled.dispatch( this );
		}
		/**
		 * Renvoie <code>true</code> si la dernière éxécution de cette
		 * commande a été annulé.
		 */	
		public function isCancelled () : Boolean
		{
			return _cancelled; 
		}
		/**
		 * Réalise l'interval et appelle la fonction de rappel aux moments
		 * adéquats.
		 * 
		 * @param	e	évènement diffusé par le <code>MotionImpulse</code>
		 */
		public function tick ( e : ImpulseEvent ) : void
		{
			try
            {
				_n += e.bias;
			
				if( _n >= _delay )
	            {
					if( _closure != null )
	            		_closure.apply( null, _args );
	            	_n -= _delay;
					
					if( _count != 0 && ++_i >= _count )
					{
						stop();
						reset();
						commandEnded.dispatch( this );
					}	
	            }
	        }
            catch( er : Error )
        	{
        		stop();
				reset();
        		commandFailed.dispatch( this, "L'appel à la fontion à échouer :\n" + er.getStackTrace() );
        	}
		}
		/**
		 * Fonction à rappeller à chaque interval.
		 */    
		public function get closure () : Function {	return _closure; }  
		public function set closure ( closure : Function ) : void { _closure = closure; }
		
		/**
		 * Nombre d'interval à accomplir. Une valeur de <code>0</code>
		 * désactive la limite dans le nombre d'intervales.
		 */    
		public function get count() : uint { return _count; } 
		public function set count ( count : uint ) : void { _count = count; }
		
		/**
		 * Nombre d'itérations réalisées depuis le début de l'éxécution.
		 */    
		public function get iteration () : uint { return _i; }
		
		/**
		 * Taille d'un interval entre deux appels.
		 */    
		public function get delay () : uint { return _delay; }
		public function set delay ( d : uint ) : void { _delay = d; }
		
		/**
		 * Arguments à transmettre à la fonction de rappel.
		 */    
		public function get arguments() : Array { return _args; }
		public function set arguments( args : Array ) : void { _args = args; }
		
		/**
		 * Définie les arguments à transmettre à la fonction de rappel.
		 * 
		 * @param	args	suite d'arguments à transmettre à la fonction de rappel	
		 */    
		public function setArguments( ... args ) : void
		{
			_args = args;
		}
		
		/**
		 * Renvoie la représentation sous forme de chaîne de l'instance courante.
		 * 
		 * @return la représentation sous forme de chaîne de l'instance courante
		 */    
		public function toString() : String
		{
			return StringUtils.stringify( this, {'delay':delay, 'count':count} );
		}
	}
}
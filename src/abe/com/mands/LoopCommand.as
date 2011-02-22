/**
 * @license
 */
package  abe.com.mands
{
	import abe.com.mands.events.CommandEvent;
	import abe.com.mands.events.LoopEvent;
	import abe.com.mon.core.Cancelable;
	import abe.com.mon.core.Iterator;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.core.Suspendable;
	import abe.com.mon.logs.Log;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;

	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * Diffusé au démarrage de la boucle suite à l'appel de la
	 * méthode <code>start</code>.
	 * 
	 * @eventType	abe.com.mands.events.LoopEvent.LOOP_START
	 */
	[Event(name="loopStart", type="abe.com.mands.events.LoopEvent")]
	
	/**
	 * Diffusé en cas d'arrêt de la boucle suite à l'appel de la
	 * méthode <code>stop</code>.
	 * 
	 * @eventType	abe.com.mands.events.LoopEvent.LOOP_STOP
	 */
	[Event(name="loopStop", type="abe.com.mands.events.LoopEvent")]
	
	/**
	 * Diffusé à chaque série d'itérations.
	 * 
	 * @eventType	abe.com.mands.events.LoopEvent.LOOP_PROGRESS
	 */
	[Event(name="loopProgress", type="abe.com.mands.events.LoopEvent")]
	
	/**
	 * Diffusé lorsqu'un appel à <code>cancel</code> conduit à l'arrêt de la commande.
	 * 
	 * @eventType abe.com.mands.events.CommandEvent.COMMAND_CANCEL
	 */
	[Event(name="commandCancel", type="abe.com.mands.events.CommandEvent")]
	
	/**
	 * Une commande <code>LoopCommand</code> encapsule une boucle au sein d'un objet 
	 * et différe les itérations dans le temps.
	 * <p>
	 * Une instance de <code>LoopCommand</code>, qui a été éxécuté, s'est enregistré en tant
	 * qu'écouteur de <code>Impulse</code>. Ensuite sur chaque image de l'animation, elle va
	 * éxécuter un certain nombre d'itérations de la boucle jusqu'à ce que le temps d'éxécution
	 * de ces itérations dépasse la limite définie dans <code>iterationTimeLimit</code>.
	 * </p>
	 */
	public class LoopCommand extends AbstractCommand implements Suspendable, Cancelable, Command, Runnable, Iterator
	{
		/**
		 * Valeur par défaut pour la durée maximale d'éxécution par image de l'animation.
		 */
		static public const DEFAULT_ITERATION_TIME_LIMIT : Number = 15;
		
		/**
		 * Constante définissant l'absence de limite dans la durée d'éxécution par image
		 * de l'animation.
		 */
		static public const NO_LIMIT : Number = Number.POSITIVE_INFINITY;
                
		protected var _iterationTimeLimit : Number;
		protected var _index : Number;
		protected var _isCancelled : Boolean;
		protected var _isDone : Boolean;

		/**
		 * Créer une nouvelle instance de la classe <code>LoopCommand</code>.
		 * 
		 * @param	command			<code>IterationCommand</code> à éxécuter
		 * @param	iterationLimit	temps maximum d'éxécution par image de l'animation
		 */
		public function LoopCommand( iterationLimit : Number = DEFAULT_ITERATION_TIME_LIMIT )
		{
			super();
			_iterationTimeLimit = iterationLimit;
			_isCancelled = false;
			_isDone = false;
		}
				
		/**
		 * Temps maximum d'éxécution par image de l'animation de cette instance.
		 */ 
		public function get iterationTimeLimit () : Number { return _iterationTimeLimit; }
		public function set iterationTimeLimit ( n : Number ) : void
		{
			if( !isRunning() )
				_iterationTimeLimit = n;
		}
		
		/**
		 * Démarre la commande boucle.
		 * 
		 * @param	e	l'objet évènement n'est pas utilisé 
		 * 				par la classe <code>LoopCommand</code>
		 */
		override public function execute ( e : Event = null ) : void
		{
			reset();                        
			start();
		}
		
		public function hasNext () : Boolean { return false; }		
		public function next () : * {}
		public function remove () : void {}
		
		/**
		 * Démarre ou redémarre la boucle.
		 */
		public function start():void
		{
			var msg : String;
			if( !isRunning() )
			{
				Impulse.register( tick );
				_isRunning = true;
				fireLoopStart( _index );
			}

		}
		
		/**
		 * Arrête l'éxécution de la boucle.
		 */
		public function stop():void
		{
			if( _isRunning )
			{
				Impulse.unregister( tick );
				_isRunning = false;
				fireLoopStop( _index );
			}
		}
		
		/**
		 * Remet à zéro l'instance courante. Il n'est pas possible de remettre
		 * à zéro une instance en court d'éxécution. Utilisé la méthode <code>cancel</code>
		 * pour annulée l'éxécution puis remettre à zéro la boucle.
		 */
		public function reset() : void
		{
			var msg : String;
			if( !isRunning() )
			{
				_index = 0;
				_isDone = false;
				_isCancelled = false;
			}
			else
			{
				msg = "Can't reset a process which is already running : " + this;
				
				throw new Error( msg );
			}
		}
		
		/**
		 * Annule l'éxécution de la commande.
		 */
		public function cancel() : void
		{
			if( !isRunning() )
			{
				stop();
	
				_isCancelled = true;
				
				fireCommandCancelled( _index );
			}
		}
		
		/**
		 * Renvoie <code>true</code> si la dernière éxécution de cette
		 * commande a été annulé.
		 */	
		public function isCancelled () : Boolean
		{
			return _isCancelled;
		}

		/**
		 * Réalise une partie de la boucle à chaque appel. Le nombre d'itérations
		 * réalisée pendant une image dépend de la durée d'éxécution de celles-ci,
		 * ainsi il y aura toujours au moins une itération de réalisée, et tant
		 * que le temps d'éxécution ne dépasse pas la limite définie dans 
		 * <code>iterationTimeLimit</code>, la commande lance l'itération suivante.
		 * 
		 * @param	e	évènement diffusé par l'instance de <code>MotionImpulse</code>
		 * 				sur laquelle est branché la commande
		 */
		public function tick ( e : ImpulseEvent ) : void
		{
			var time:Number = 0;
			var tmpTime:Number;
			
			while( time < _iterationTimeLimit )
			{
				tmpTime = getTimer();
				if( hasNext() )
				{
					try
					{					
						iteration( _index, next() );
					}
					catch(e : Error)
					{
						Log.error( _index + "\t" + e.message + "\n" + e.getStackTrace() );
					}
					_index++;
				}
				else
				{
					stop();
					_isDone = true;
					fireLoopProgress( _index );
					fireCommandEnd();
					
					return;
				}
				time += getTimer() - tmpTime;
			}
			fireLoopProgress( _index );
		}
		
		/**
		 * Connecté cette méthode à l'évènement <code>CommandEvent.COMMAND_END</code> d'une
		 * autre commande pour que cette instance démarre automatiquement à la fin de la
		 * commande.
		 * 
		 * @param	e	évènement de fin diffusé par la commande
		 */
		public function commandEnd ( e : Event ): void
		{
			(e.target as Command ).removeEventListener( CommandEvent.COMMAND_END, commandEnd );
			execute( e );
		}

		/**
		 * Notifie les éventuels écouteurs de la commande que son opération 
		 * a été annulé par un appel à la méthode <code>cancel</code>. 
		 * Un évènement de type <code>CommandEvent.COMMAND_CANCEL</code>
		 * est alors diffusé par la classe. 
		 * <p>
		 * A la fin de l'appel, la commande n'est plus considérée comme 
		 * en cours d'exécution.
		 * </p>
		 * 
		 * @param	n	nombre d'itérations réalisées jusqu'à la diffusion 
		 * 				de l'évènement 
		 */
		protected function fireCommandCancelled ( n : Number ) : void
		{
			dispatchEvent( new LoopEvent( CommandEvent.COMMAND_CANCEL, n ) );
		}
		/**
		 * Notifie les éventuels écouteurs de la commande que la boucle
		 * vient de démarrer. 
		 * Un évènement de type <code>LoopEvent.LOOP_START</code>
		 * est alors diffusé par la classe. 
		 * 
		 * @param	n	nombre d'itérations réalisées jusqu'à la diffusion 
		 * 				de l'évènement 
		 */
		protected function fireLoopStart ( n : Number ) : void
		{
			dispatchEvent( new LoopEvent( LoopEvent.LOOP_START, n ) );
		}
		/**
		 * Notifie les éventuels écouteurs de la commande que de nouvelles
		 * itérations viennent d'être réalisées par la commande. 
		 * Une commande ne diffuse qu'un évènement de type 
		 * <code>LoopEvent.LOOP_PROGRESS</code> par image de l'animation. 
		 * 
		 * @param	n	nombre d'itérations réalisées jusqu'à la diffusion 
		 * 				de l'évènement 
		 */
		protected function fireLoopProgress ( n : Number ) : void
		{
			dispatchEvent( new LoopEvent( LoopEvent.LOOP_PROGRESS, n ) );
		}
		
		/**
		 * Notifie les éventuels écouteurs de la commande que la boucle
		 * vient de se terminer. 
		 * Un évènement de type <code>LoopEvent.LOOP_STOP</code>
		 * est alors diffusé par la classe. 
		 * 
		 * @param	n	nombre d'itérations réalisées jusqu'à la diffusion 
		 * 				de l'évènement 
		 */
		protected function fireLoopStop ( n : Number ) : void
		{
			dispatchEvent( new LoopEvent( LoopEvent.LOOP_STOP, n ) );
		}
		/**
		 * Notifie l'objet <code>IterationCommand</code> de cette instance
		 * qu'une nouvelle itération est lancée.
		 * 
		 * @param	i	numéro de l'itération courante
		 * @param	o	valeur de l'itération courante
		 */
		protected function iteration ( i : Number, o : * ) : void {}
	}
}
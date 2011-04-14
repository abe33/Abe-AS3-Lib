/**
 * @license
 */
package  abe.com.mands
{
	import abe.com.mon.core.Cancelable;
	import abe.com.mon.core.Iterator;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.core.Suspendable;
	import abe.com.mon.logs.Log;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;

	import org.osflash.signals.Signal;

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
		
		protected var _commandCancelled : Signal;		
		public var loopStarted : Signal;		public var loopStopped : Signal;		public var loopProgressed : Signal;

		/**
		 * Créer une nouvelle instance de la classe <code>LoopCommand</code>.
		 * 
		 * @param	command			<code>IterationCommand</code> à éxécuter
		 * @param	iterationLimit	temps maximum d'éxécution par image de l'animation
		 */
		public function LoopCommand( iterationLimit : Number = DEFAULT_ITERATION_TIME_LIMIT )
		{
			super();
			loopStarted = new Signal( int );			loopStopped = new Signal( int );			loopProgressed = new Signal( int );			_commandCancelled = new Signal( Command );
			_iterationTimeLimit = iterationLimit;
			_isCancelled = false;
			_isDone = false;
		}
		public function get commandCancelled () : Signal { return _commandCancelled; }		
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
		override public function execute( ... args ) : void
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
				loopStarted.dispatch( _index );
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
				loopStopped.dispatch( _index );
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
				
				commandCancelled.dispatch( this );
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
					loopProgressed.dispatch( _index );
					commandEnded.dispatch( this );
					
					return;
				}
				time += getTimer() - tmpTime;
			}
			loopProgressed.dispatch( _index );
		}
		
		/**
		 * Connecté cette méthode à l'évènement <code>CommandEvent.COMMAND_END</code> d'une
		 * autre commande pour que cette instance démarre automatiquement à la fin de la
		 * commande.
		 * 
		 * @param	e	évènement de fin diffusé par la commande
		 */
		public function onCommandEnded ( command : Command ): void
		{
			command.commandEnded.remove( onCommandEnded );
			execute();
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
/**
 * @license
 */
package abe.com.mon.logs 
{
	import abe.com.mon.utils.StringUtils;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.Capabilities;

	/**
	 * Broadcast when a new message is sent to the class <code>Log</code>.
	 * <fr>
	 * Diffusé lorsque un nouveau message est transmis à la classe <code>Log</code>.
	 * </fr>
	 * @eventType	abe.com.mon.logs.LogEvent.LOG_ADD
	 */
	[Event(name="logAdd", type="abe.com.mon.logs.LogEvent")]
	/**
	 * The <code>Log</code> class provides methods for global dispatching
	 * of information message through the application. 
	 * <p> 
	 * Any object can register as a listener of the global instance
	 * of the class <code>Log</code> to receive messages broadcasted
	 * by the application. 
	 * </p>
	 * <fr>
	 * La classe <code>Log</code> fournie des méthodes globales permettant
	 * la diffusion de message d'information à travers l'application. 
	 * <p>
	 * N'importe quel objet peut s'enregistrer en tant qu'écouteur de l'instance
	 * globale de la classe <code>Log</code> afin de recevoir les messages
	 * diffusés par l'application.
	 * </p>
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public class Log extends EventDispatcher
	{
		/*
		 * global instance
		 */
		static private var instance : Log;
		
		/**
		 * An array which store the message received by the <code>Log</code>
		 * class while no listeners have been registered.
		 */
		protected var _undispatched : Array;

		/**
		 * Returns a reference to the global instance
		 * of class <code>Log</code>.
		 * <fr>
		 * Renvoie une référence vers l'instance globale de la classe
		 * <code>Log</code>.
		 * </fr>
		 * @return	a reference to the global instance
		 * 			of class <code>Log</code>
		 * 			<fr>une référence vers l'instance globale de la classe
		 * 			<code>Log</code></fr>
		 */
		static public function getInstance() : Log
		{
			if( instance == null )
				instance = new Log();
			
			return instance;
		}
		/**
		 * <code>Log</code> class constructor.
		 */
		public function Log () 
		{
			_undispatched = [];
		}
		/**
		 * Broadcasts a message of type <code>DEBUG</code> 
		 * to the listeners of the <code>Log</code> instance.
		 * <fr>
		 * Diffuse un message de type <code>DEBUG</code> aux écouteurs 
		 * de la classe <code>Log</code>.
		 * </fr>
		 * @param	msg			message content
		 * 						<fr>message à diffuser</fr>
		 * @param 	keepHTML	<code>true</code> to keep the HTML formatting in the output
		 * 						<fr><code>true</code> pour conserver le formattage HTML
		 * 						dans la sortie</fr>
		 */
		static public function debug ( msg : *, keepHTML : Boolean = false ) : void
		{
			getInstance().log( String( msg ), LogLevel.DEBUG, keepHTML );
		}
		/**
		 * Broadcasts a message of type <code>INFO</code> 
		 * to the listeners of the <code>Log</code> instance.
		 * <fr>
		 * Diffuse un message de type <code>INFO</code> aux écouteurs 
		 * de la classe <code>Log</code>.
		 * </fr>
		 * @param	msg			message content
		 * 						<fr>message à diffuser</fr>
		 * @param 	keepHTML	<code>true</code> to keep the HTML formatting in the output
		 * 						<fr><code>true</code> pour conserver le formattage HTML
		 * 						dans la sortie</fr>
		 */
		static public function info ( msg : *, keepHTML : Boolean = false ) : void
		{
			getInstance().log( String( msg ), LogLevel.INFO, keepHTML );
		}
		/**
		 * Broadcasts a message of type <code>WARN</code> 
		 * to the listeners of the <code>Log</code> instance.
		 * <fr>
		 * Diffuse un message de type <code>WARN</code> aux écouteurs 
		 * de la classe <code>Log</code>.
		 * </fr>
		 * @param	msg			message content
		 * 						<fr>message à diffuser</fr>
		 * @param 	keepHTML	<code>true</code> to keep the HTML formatting in the output
		 * 						<fr><code>true</code> pour conserver le formattage HTML
		 * 						dans la sortie</fr>
		 */
		static public function warn ( msg : *, keepHTML : Boolean = false ) : void
		{
			getInstance().log( String( msg ), LogLevel.WARN, keepHTML );
		}
		/**
		 * Broadcasts a message of type <code>ERROR</code> 
		 * to the listeners of the <code>Log</code> instance.
		 * <fr>
		 * Diffuse un message de type <code>ERROR</code> aux écouteurs 
		 * de la classe <code>Log</code>.
		 * </fr>
		 * @param	msg			message content
		 * 						<fr>message à diffuser</fr>
		 * @param 	keepHTML	<code>true</code> to keep the HTML formatting in the output
		 * 						<fr><code>true</code> pour conserver le formattage HTML
		 * 						dans la sortie</fr>
		 */
		static public function error ( msg : *, keepHTML : Boolean = false ) : void
		{
			if( msg is Error )
				getInstance().log( StringUtils.stringify( msg ) + "\n" +
								   ( Capabilities.isDebugger ? 
										StringUtils.escapeTags( ( msg as Error ).getStackTrace() ) : 
										StringUtils.escapeTags( ( msg as Error ).message ) ), 
								   LogLevel.ERROR, 
								   keepHTML );
			else
				getInstance().log( String( msg ), 
								   LogLevel.ERROR, 
								   keepHTML );
		}
		/**
		 * Broadcasts a message of type <code>FATAL</code> 
		 * to the listeners of the <code>Log</code> instance.
		 * <fr>
		 * Diffuse un message de type <code>FATAL</code> aux écouteurs 
		 * de la classe <code>Log</code>.
		 * </fr>
		 * @param	msg			message content
		 * 						<fr>message à diffuser</fr>
		 * @param 	keepHTML	<code>true</code> to keep the HTML formatting in the output
		 * 						<fr><code>true</code> pour conserver le formattage HTML
		 * 						dans la sortie</fr>
		 */
		static public function fatal ( msg : *, keepHTML : Boolean = false ) : void
		{
			getInstance().log( String( msg ), LogLevel.FATAL, keepHTML );
		}
		
		/**
		 * Broadcasts a message with a level of importance defined
		 * by <code>level</code> to the listeners of the
		 * <code>Log</code> instance.
		 * <fr>
		 * Diffuse un message de avec un niveau d'importance défini par <code>level</code>
		 * aux écouteurs de la classe <code>Log</code>.
		 * </fr>
		 * @param	msg			message content
		 * 						<fr>message à diffuser</fr>
		 * @param 	level		level of importance of the message
		 * 						<fr>niveau d'importance du message</fr>
		 * @param 	keepHTML	<code>true</code> to keep the HTML formatting in the output
		 * 						<fr><code>true</code> pour conserver le formattage HTML
		 * 						dans la sortie</fr>
		 */
		public function log ( msg : String, level : LogLevel, keepHTML : Boolean = false ) : void
		{
			if( hasEventListener( LogEvent.LOG_ADD ) )
				dispatchEvent( new LogEvent( LogEvent.LOG_ADD, msg, level, keepHTML ) );
			else
				_undispatched.push( new LogEvent( LogEvent.LOG_ADD, msg, level, keepHTML ) );
		}
		/**
		 * Registers an event listener object with an EventDispatcher object
		 * so that the listener receives notification of an event. 
		 * You can register event listeners on all nodes in the display
		 * list for a specific type of event, phase, and priority.
		 * <p>
		 * After you successfully register an event listener, you cannot
		 * change its priority through additional calls to <code>addEventListener()</code>.
		 * To change a listener's priority, you must first call <code>removeListener()</code>. 
		 * Then you can register the listener again with the new priority level.
		 * </p>
		 * <p>
		 * Keep in mind that after the listener is registered, subsequent calls
		 * to <code>addEventListener()</code> with a different <code>type</code>
		 * or <code>useCapture</code> value result in the creation of a separate
		 * listener registration. For example, if you first register a listener
		 * with <code>useCapture</code> set to <code>true</code>, it listens only
		 * during the capture phase. If you call <code>addEventListener()</code>
		 * again using the same listener object, but with <code>useCapture</code>
		 * set to <code>false</code>, you have two separate listeners: one that 
		 * listens during the capture phase and another that listens during
		 * the target and bubbling phases.
		 * </p>
		 * <p>
		 * You cannot register an event listener for only the target phase
		 * or the bubbling phase. Those phases are coupled during registration
		 * because bubbling applies only to the ancestors of the target node.
		 * </p>
		 * <p>
		 * If you no longer need an event listener, remove it by calling 
		 * <code>removeEventListener()</code>, or memory problems could result. 
		 * Event listeners are not automatically removed from memory
		 * because the garbage collector does not remove the listener
		 * as long as the dispatching object exists (unless the 
		 * <code>useWeakReference</code> parameter is set to <code>true</code>).
		 * </p>
		 * <p>
		 * Copying an <code>EventDispatcher</code> instance does not copy the event
		 * listeners attached to it. (If your newly created node needs an event
		 * listener, you must attach the listener after creating the node.)
		 * However, if you move an <code>EventDispatcher</code> instance,
		 * the event listeners attached to it move along with it.
		 * </p>
		 * <p>
		 * If the event listener is being registered on a node while an event
		 * is being processed on this node, the event listener is not triggered
		 * during the current phase but can be triggered during a later phase
		 * in the event flow, such as the bubbling phase.
		 * </p>
		 * <p>
		 * If an event listener is removed from a node while an event is being
		 * processed on the node, it is still triggered by the current actions.
		 * After it is removed, the event listener is never invoked again
		 * (unless registered again for future processing). 
		 * </p> 
		 * @param type				the type of event.
		 * @param listener			the listener function that processes the event. 
		 * 							This function must accept an <code>Event</code>
		 * 							object as its parameter and must return nothing,
		 * 							as this example shows:
		 * 							<listing>function(evt:Event):void</listing> 
		 * 							The function can have any name.
		 * @param useCapture		determines whether the listener works in the capture
		 * 							phase or the target and bubbling phases.
		 * 							If <code>useCapture</code> is set to <code>true</code>, 
		 * 							the listener processes the event only during the capture
		 * 							phase and not in the target or bubbling phase.
		 * 							If <code>useCapture</code> is <code>false</code>,
		 * 							the listener processes the event only during the target
		 * 							or bubbling phase. To listen for the event in all three phases,
		 * 							call <code>addEventListener</code> twice, once with 
		 * 							<code>useCapture</code> set to <code>true</code>,
		 * 							then again with <code>useCapture</code> set to <code>false</code>.
		 * @param priority			the priority level of the event listener. 
		 * 							The priority is designated by a signed 32-bit integer. 
		 * 							The higher the number, the higher the priority. 
		 * 							All listeners with priority <code>n</code> are processed before
		 * 							listeners of priority <code>n-1</code>. If two or more listeners
		 * 							share the same priority, they are processed in the order
		 * 							in which they were added. The default priority is <code>0</code>.
		 * @param useWeakReference 	determines whether the reference to the listener is strong or weak.
		 * 							A strong reference (the default) prevents your listener from
		 * 							being garbage-collected. A weak reference does not.
		 * 							<p>
		 * 							Class-level member functions are not subject to garbage
		 * 							collection, so you can set <code>useWeakReference</code> to <code>true</code>
		 * 							for class-level member functions without subjecting
		 * 							them to garbage collection. If you set <code>useWeakReference</code>
		 * 							to <code>true</code> for a listener that is a nested inner
		 * 							function, the function will be garbage-collected and
		 * 							no longer persistent. If you create references to the inner
		 * 							function (save it in another variable) then it is not
		 * 							garbage-collected and stays persistent.
		 * 							</p>
		 * @throws ArgumentError The listener specified is not a function. 
		 */
		override public function addEventListener ( type : String, 
													listener : Function, 
													useCapture : Boolean = false, 
													priority : int = 0, 
													useWeakReference : Boolean = false ) : void 
		{
			if( type == LogEvent.LOG_ADD )
			{
				var dealWithUndispatched : Boolean = !hasEventListener(LogEvent.LOG_ADD);
	
				super.addEventListener(type, listener, useCapture, priority, useWeakReference);
				
				if( dealWithUndispatched )
					for( var i : uint = 0; i<_undispatched.length;i++)
						dispatchEvent( _undispatched[i] );
			}
			else 				super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		/**
		 * Rewriting the <code>dispatchEvent</code> method to prevent the dispatch
		 * of an event in the absence of listeners for this event.
		 * <fr>
		 * Réécriture de la méthode <code>dispatchEvent</code> afin d'éviter la diffusion
		 * d'évènement en l'absence d'écouteurs pour cet évènement.
		 * </fr>
		 * @param	evt		event object to dispatch
		 * 					<fr>objet évènement à diffuser</fr>
		 * @return	<code>true</code> if the event has been dispatched, <code>false</code>
		 * 			in case of failure or after a call of the <code>preventDefault</code> 
		 * 			method on that object.
		 * 			<fr><code>true</code> si l'évènement a bien été diffusé, <code>false</code>
		 * 			en cas d'échec ou d'appel de la méthode <code>preventDefault</code>
		 * 			sur cet objet évènement</fr>
		 */
		override public function dispatchEvent( evt : Event ) : Boolean 
		{
		 	if (hasEventListener(evt.type) || evt.bubbles) 
		 	{
		  		return super.dispatchEvent(evt);
		  	}
		 	return true;
		}
	}
}
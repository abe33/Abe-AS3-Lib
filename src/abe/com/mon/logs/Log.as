/**
 * @license
 */
package abe.com.mon.logs 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * Diffusé lorsque un nouveau message est transmis à la classe <code>Log</code>.
	 * 
	 * @eventType	abe.com.mon.logs.LogEvent.LOG_ADD
	 */
	[Event(name="logAdd", type="abe.com.mon.logs.LogEvent")]
	/**
	 * La classe <code>Log</code> fournie des méthodes globales permettant
	 * la diffusion de message d'information à travers l'application. 
	 * <p>
	 * N'importe quel objet peut s'enregistrer en tant qu'écouteur de l'instance
	 * globale de la classe <code>Log</code> afin de recevoir les messages
	 * diffusés par l'application.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 */
	public class Log extends EventDispatcher
	{
		/*
		 * Instance globale de la classe Log  
		 */
		static private var instance : Log;
		
		protected var _undispatched : Array;

		/**
		 * Renvoie une référence vers l'instance globale de la classe
		 * <code>Log</code>.
		 * 
		 * @return	une référence vers l'instance globale de la classe
		 * 			<code>Log</code>
		 */
		static public function getInstance() : Log
		{
			if( instance == null )
				instance = new Log();
			
			return instance;
		}
		public function Log () 
		{
			_undispatched = [];
		}
		/**
		 * Diffuse un message de type <code>DEBUG</code> aux écouteurs 
		 * de la classe <code>Log</code>.
		 * 
		 * @param	msg			message à diffuser
		 * @param 	keepHTML	<code>true</code> pour conserver le formattage HTML
		 * 						dans la sortie
		 */
		static public function debug ( msg : *, keepHTML : Boolean = false ) : void
		{
			getInstance().log( String( msg ), LogLevel.DEBUG, keepHTML );
		}
		/**
		 * Diffuse un message de type <code>INFO</code> aux écouteurs 
		 * de la classe <code>Log</code>.
		 * 
		 * @param	msg			message à diffuser
		 * @param 	keepHTML	<code>true</code> pour conserver le formattage HTML
		 * 						dans la sortie
		 */
		static public function info ( msg : *, keepHTML : Boolean = false ) : void
		{
			getInstance().log( String( msg ), LogLevel.INFO, keepHTML );
		}
		/**
		 * Diffuse un message de type <code>WARN</code> aux écouteurs 
		 * de la classe <code>Log</code>.
		 * 
		 * @param	msg			message à diffuser
		 * @param 	keepHTML	<code>true</code> pour conserver le formattage HTML
		 * 						dans la sortie
		 */
		static public function warn ( msg : *, keepHTML : Boolean = false ) : void
		{
			getInstance().log( String( msg ), LogLevel.WARN, keepHTML );
		}
		/**
		 * Diffuse un message de type <code>ERROR</code> aux écouteurs 
		 * de la classe <code>Log</code>.
		 * 
		 * @param	msg			message à diffuser
		 * @param 	keepHTML	<code>true</code> pour conserver le formattage HTML
		 * 						dans la sortie
		 */
		static public function error ( msg : *, keepHTML : Boolean = false ) : void
		{
			getInstance().log( String( msg ), LogLevel.ERROR, keepHTML );
		}
		/**
		 * Diffuse un message de type <code>FATAL</code> aux écouteurs 
		 * de la classe <code>Log</code>.
		 * 
		 * @param	msg			message à diffuser
		 * @param 	keepHTML	<code>true</code> pour conserver le formattage HTML
		 * 						dans la sortie
		 */
		static public function fatal ( msg : *, keepHTML : Boolean = false ) : void
		{
			getInstance().log( String( msg ), LogLevel.FATAL, keepHTML );
		}
		
		/**
		 * Diffuse un message de avec un niveau d'importance définit par <code>level</code>
		 * aux écouteurs de la classe <code>Log</code>.
		 * 
		 * @param	msg			message à diffuser
		 * @param 	level		niveau d'importance du message
		 * @param 	keepHTML	<code>true</code> pour conserver le formattage HTML
		 * 						dans la sortie
		 */
		public function log ( msg : String, level : LogLevel, keepHTML : Boolean = false ) : void
		{
			if( hasEventListener( LogEvent.LOG_ADD ) )
				dispatchEvent( new LogEvent( LogEvent.LOG_ADD, msg, level, keepHTML ) );
			else
				_undispatched.push( new LogEvent( LogEvent.LOG_ADD, msg, level, keepHTML ) );
		}
		override public function addEventListener (type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void 
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
		 * Réécriture de la méthode <code>dispatchEvent</code> afin d'éviter la diffusion
		 * d'évènement en l'absence d'écouteurs pour cet évènement.
		 * 
		 * @param	evt	objet évènement à diffuser
		 * @return	<code>true</code> si l'évènement a bien été diffusé, <code>false</code>
		 * 			en cas d'échec ou d'appel de la méthode <code>preventDefault</code>
		 * 			sur cet objet évènement
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
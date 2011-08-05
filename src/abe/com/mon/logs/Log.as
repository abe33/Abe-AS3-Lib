/**
 * @license
 */
package abe.com.mon.logs 
{
	import abe.com.mon.utils.StringUtils;

	import org.osflash.signals.Signal;

	import flash.system.Capabilities;
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
	public class Log
	{
		/*
		 * global instance
		 */
		static private var instance : Log;
		/**
		 * A reference to the <code>Signal</code> object used to dispatch the
		 * <code>logAdded</code> event. 
		 */
		public var logAdded : Signal;

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
			logAdded = new Signal( String, LogLevel, Boolean );
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
			logAdded.dispatch( msg, level, keepHTML );
		}
	}
}

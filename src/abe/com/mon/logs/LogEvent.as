/**
 * @license
 */
package  abe.com.mon.logs
{
	import flash.events.Event;
	
	/**
	 * La classe <code>LogEvent</code> sert à la diffusion des messages
	 * d'informations au sein d'un programme AS3.
	 * <p>
	 * Les messages diffusés par la classe <code>Log</code> possèdent différents
	 * niveau d'importance, permettant ainsi d'opérer un filtrage sur ces messages.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 */
	public class LogEvent extends Event 
	{
		/**
		 * La constante <code>LogEvent.LOG_ADD</code> définie la 
		 * valeur du <code>type</code> de l'objet <code>ComponentEvent</code>
		 * pour l'évènement <code>repaint</code>.
		 * 
		 * <p>L'objet <code>LogEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'> 
		 * <tr><th>Property</th><th>Value</th></tr> 
		 * <tr><td><code>msg</code></td><td>Le message contenu dans cet évènement.</td></tr> 		 * <tr><td><code>level</code></td><td>Le niveau d'importance de ce message.</td></tr> 		 * <tr><td><code>keepHTML</code></td><td>Une valeur booléenne indiquant si
		 * les écouteurs doivent conserver le formatage HTML du message.</td></tr> 		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>target</code></td><td>L'objet ayant diffusé l'évènement.</td></tr> 
		 * </table>
		 * 
		 * @eventType logAdd
		 */
		static public const LOG_ADD : String = "logAdd";
		
		/**
		 * Un objet <code>LogLevel</code> représentant le niveau d'importance de ce message.
		 */
		public var level : LogLevel;
		/**
		 * Le message contenu par cet évènement.
		 */
		public var msg : String;
		/**
		 * Une valeur booléenne indiquant si
		 * les écouteurs doivent conserver le formatage HTML du message.
		 */
		public var keepHTML : Boolean;
		
		/**
		 * Constructeur de la classe <code>LogEvent</code>.
		 * 
		 * @param	type		type de l'évènement
		 * @param	msg			message de l'évènement
		 * @param	level		niveau d'importance de l'évènement
		 * @param	keepHTML	le formattage HTML doit-il être conservé
		 * @param	bubbles		l'évènement est-il diffusé dans la hierarchie
		 * @param	cancelable	l'évènement est-il annulable
		 */
		public function LogEvent ( type : String, 
								   msg : String, 
								   level : LogLevel, 
								   keepHTML : Boolean = false,
								   bubbles : Boolean = false, 
								   cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
			this.level = level;
			this.msg = msg;
			this.keepHTML = keepHTML;
		}
	}
}

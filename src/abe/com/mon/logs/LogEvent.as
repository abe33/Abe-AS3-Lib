/**
 * @license
 */
package  abe.com.mon.logs
{
	import flash.events.Event;
	
	/**
	 * The <code>LogEvent</code> class is used to broadcast messages
	 * within an AS3 program.
	 * <p>
	 * Messages dispatched by the <code>Log</code> class have different
	 * level of importance, thus allow filtering of these messages.
	 * </p>
	 * <fr>
	 * La classe <code>LogEvent</code> sert à la diffusion des messages
	 * d'informations au sein d'un programme AS3.
	 * <p>
	 * Les messages diffusés par la classe <code>Log</code> possèdent différents
	 * niveau d'importance, permettant ainsi d'opérer un filtrage sur ces messages.
	 * </p>
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public class LogEvent extends Event 
	{
		/**
		 * The constant <code>LogEvent.LOG_ADD</code> defined 
		 * the value of the <code>type</code> property object 
		 * <code>LogEvent</code> for the event <code>logAdd</code>.
		 * <p> 
		 * A <code>LogEvent</code> instance has the following properties:
		 * </p>
		 * <table class='innertable'>
		 * <tr><th> Property</th>				<th>Value</th></tr>
		 * <tr><td> <code>msg</code></td> 		<td> The message in this event. </td></tr>
		 * <tr><td> <code>level</code></td> 	<td> The level of importance of this message. </td></tr>
		 * <tr><td> <code>keepHTML</code></td> 	<td> A boolean value indicating whether the headphones 
		 * 										 	 must keep the HTML formatting of the message. </td></tr>
		 * <tr><td> <code>bubbles</code></td> 	<td> <code>false</code></td></tr>
		 * <tr><td> <code>cancelable</code></td><td> <code>false</code></td></tr>
		 * <tr><td> <code>target</code></td> 	<td> The object that dispatched the event.</td></tr>
		 * </table>
		 * 
		 * <fr>
		 * La constante <code>LogEvent.LOG_ADD</code> définie la 
		 * valeur du <code>type</code> de l'objet <code>LogEvent</code>
		 * pour l'évènement <code>logAdd</code>.
		 * 
		 * <p>L'objet <code>LogEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'> 
		 * <tr><th>Property</th><th>Value</th></tr> 
		 * <tr><td><code>msg</code></td><td>Le message contenu dans cet évènement.</td></tr> 		 * <tr><td><code>level</code></td><td>Le niveau d'importance de ce message.</td></tr> 		 * <tr><td><code>keepHTML</code></td><td>Une valeur booléenne indiquant si
		 * les écouteurs doivent conserver le formatage HTML du message.</td></tr> 		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>target</code></td><td>L'objet ayant diffusé l'évènement.</td></tr> 
		 * </table>
		 * </fr>
		 * @eventType logAdd
		 */
		static public const LOG_ADD : String = "logAdd";
		
		/**
		 * A <code>LogLevel</code> instance representing the level
		 * of importance of this message.
		 * <fr>
		 * Un objet <code>LogLevel</code> représentant le niveau
		 * d'importance de ce message.
		 * </fr>
		 */
		public var level : LogLevel;
		/**
		 * The message in this event.
		 * <fr>
		 * Le message contenu par cet évènement.
		 * </fr>
		 */
		public var msg : String;
		/**
		 * A boolean value indicating whether the listeners
		 * must retain the HTML formatting of the message.
		 * <fr>
		 * Une valeur booléenne indiquant si les écouteurs
		 * doivent conserver le formatage HTML du message.
		 * </fr>
		 */
		public var keepHTML : Boolean;
		
		/**
		 * <code>LogEvent</code> class constructor.
		 * <fr>
		 * Constructeur de la classe <code>LogEvent</code>.
		 * </fr>
		 * @param	type		event's type
		 * 						<fr>type de l'évènement</fr>
		 * @param	msg			event's message
		 * 						<fr>message de l'évènement</fr>
		 * @param	level		event's level
		 * 						<fr>niveau d'importance de l'évènement</fr>
		 * @param	keepHTML	the HTML formatting should be kept ?
		 * 						<fr>le formattage HTML doit-il être conservé ?</fr>
		 * @param	bubbles		the event is broadcast in the hierarchy ?
		 * 						<fr>l'évènement est-il diffusé dans la hierarchie ?</fr>
		 * @param	cancelable	the event is it cancelable ?
		 * 						<fr>l'évènement est-il annulable ?</fr>
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

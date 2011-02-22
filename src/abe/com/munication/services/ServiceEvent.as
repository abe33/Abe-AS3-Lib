/**
 * @license
 */
package abe.com.munication.services
{
	import abe.com.mands.events.CommandEvent;

	/**
	 * @author Cédric Néhémie
	 */
	public class ServiceEvent extends CommandEvent
	{
		/**
		 * La constante <code>ServiceEvent.SERVICE_RESULT</code> définie la
		 * valeur du <code>type</code> de l'objet <code>ServiceEvent</code>
		 * pour l'évènement <code>serviceResult</code>.
		 *
		 * <p>L'objet <code>ServiceEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet <code>Command</code> ayant diffusé l'évènement.</td></tr>		 * <tr><td><code>result</code></td><td>Le résultat (optionnel) de l'appel au service.</td></tr>
		 * </table>
		 *
		 * @eventType serviceResult
		 */
		static public var SERVICE_RESULT : String = "serviceResult";		/**
		 * La constante <code>ServiceEvent.SERVICE_ERROR</code> définie la
		 * valeur du <code>type</code> de l'objet <code>ServiceEvent</code>
		 * pour l'évènement <code>serviceError</code>.
		 *
		 * <p>L'objet <code>ServiceEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet <code>Command</code> ayant diffusé l'évènement.</td></tr>
		 * <tr><td><code>result</code></td><td>Le résultat (optionnel) de l'appel au service.</td></tr>
		 * </table>
		 *
		 * @eventType serviceError
		 */
		static public var SERVICE_ERROR : String = "serviceError";		/**
		 * La constante <code>ServiceEvent.SERVICE_CALL_START</code> définie la
		 * valeur du <code>type</code> de l'objet <code>ServiceEvent</code>
		 * pour l'évènement <code>serviceCallStart</code>.
		 *
		 * <p>L'objet <code>ServiceEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet <code>Command</code> ayant diffusé l'évènement.</td></tr>
		 * <tr><td><code>result</code></td><td>Le résultat (optionnel) de l'appel au service.</td></tr>
		 * </table>
		 *
		 * @eventType serviceCallStart
		 */
		static public var SERVICE_CALL_START : String = "serviceCallStart";
		/**
		 * Le résultat de l'appel au serveur dans le cas où l'évènement est un évènement de résultat.
		 */
		public var results : *;
		/**
		 * Constructeur de la classe <code>ServiceEvent</code>.
		 *
		 * @param	type		le type de l'évènement diffusé
		 * @param	results		le résultat à transmettre avec l'évènement
		 * @param	bubbles		le <i>bubbling</i> est-il autorisé pour cet évènement
		 * @param	cancelable	l'évènement est-il annulable
		 */
		public function ServiceEvent (type : String, results : *, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
			this.results = results;
		}
	}
}

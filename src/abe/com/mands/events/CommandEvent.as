/**
 * @license 
 */
package  abe.com.mands.events
{
	import flash.events.Event;
	/**
	 * Classe d'évènement diffusé par les différentes classes de commandes.
	 * 
	 * @author Cédric Néhémie
	 * @see abe.com.mands.Command
	 */
	public class CommandEvent extends Event
	{
		/**
		 * La constante <code>CommandEvent.COMMAND_END</code> définie la 
		 * valeur du <code>type</code> de l'objet <code>CommandEvent</code>
		 * pour l'évènement <code>commandEnd</code>.
		 * 
		 * <p>L'objet <code>CommandEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'> 
		 * <tr><th>Property</th><th>Value</th></tr> 
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>target</code></td><td>L'objet <code>Command</code> ayant diffusé l'évènement.</td></tr> 
		 * </table>
		 * 
		 * @eventType commandEnd
		 */
		static public const COMMAND_END : String = "commandEnd";
		
		/**
		 * La constante <code>CommandEvent.COMMAND_FAIL</code> définie la 
		 * valeur du <code>type</code> de l'objet <code>CommandEvent</code>
		 * pour l'évènement <code>commandFail</code>.
		 * 
		 * <p>L'objet <code>CommandEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'> 
		 * <tr><th>Property</th><th>Value</th></tr> 
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>target</code></td><td>L'objet <code>Command</code> ayant diffusé l'évènement.</td></tr> 
		 * </table>
		 * 
		 * @eventType commandFail
		 */
		static public const COMMAND_FAIL : String = "commandFail";
		
		/**
		 * La constante <code>CommandEvent.COMMAND_CANCEL</code> définie la 
		 * valeur du <code>type</code> de l'objet <code>CommandEvent</code>
		 * pour l'évènement <code>commandCancel</code>.
		 * 
		 * <p>L'objet <code>CommandEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'> 
		 * <tr><th>Property</th><th>Value</th></tr> 
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>target</code></td><td>L'objet <code>Command</code> ayant diffusé l'évènement.</td></tr> 
		 * </table>
		 * 
		 * @eventType commandCancel
		 */
		static public const COMMAND_CANCEL : String = "commandCancel";
		
		/**
		 * Créer une nouvelle instance de la classe <code>CommandEvent</code>.
		 * 
		 * @param	type		le type de l'évènement diffusé
		 * @param	bubbles		le <i>bubbling</i> est-il autorisé pour cet évènement
		 * @param	cancelable	l'évènement est-il annulable
		 */
		public function CommandEvent( type : String, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
	}
}
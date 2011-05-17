/**
 * @license 
 */
package  abe.com.edia.dialogues
{
	import flash.events.Event;
	/**
	 * Classe d'évènement diffusés par les objets <code>DialogKernel</code>.
	 * 
	 * @author Cédric Néhémie
	 * @see abe.com.edia.dialogues.DialogKernel
	 */
	public class SpeechEvent extends Event
	{
		/**
		 * La constante <code>SpeechEvent.SPEECH_START</code> définie la 
		 * valeur du <code>type</code> de l'objet <code>SpeechEvent</code>
		 * pour l'évènement <code>speechStart</code>.
		 * 
		 * <p>L'objet <code>SpeechEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'> 
		 * <tr><th>Property</th><th>Value</th></tr> 
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>target</code></td><td>L'objet <code>DialogKernel</code> ayant diffusé l'évènement.</td></tr> 		 * <tr><td><code>speechTarget</code></td><td>L'objet <code>Speech</code> courant.</td></tr> 
		 * </table>
		 * 
		 * @eventType speechStart
		 */
		static public const SPEECH_START : String = "speechStart";
		/**
		 * La constante <code>SpeechEvent.SPEECH_END</code> définie la 
		 * valeur du <code>type</code> de l'objet <code>SpeechEvent</code>
		 * pour l'évènement <code>speechEnd</code>.
		 * 
		 * <p>L'objet <code>SpeechEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'> 
		 * <tr><th>Property</th><th>Value</th></tr> 
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>target</code></td><td>L'objet <code>DialogKernel</code> ayant diffusé l'évènement.</td></tr> 
		 * <tr><td><code>speechTarget</code></td><td>L'objet <code>Speech</code> courant.</td></tr> 
		 * </table>
		 * 
		 * @eventType speechEnd
		 */
		static public const SPEECH_END : String = "speechEnd";
		/**
		 * La constante <code>SpeechEvent.NEW_SPEECH</code> définie la 
		 * valeur du <code>type</code> de l'objet <code>SpeechEvent</code>
		 * pour l'évènement <code>newSpeech</code>.
		 * 
		 * <p>L'objet <code>SpeechEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'> 
		 * <tr><th>Property</th><th>Value</th></tr> 
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>target</code></td><td>L'objet <code>DialogKernel</code> ayant diffusé l'évènement.</td></tr> 
		 * <tr><td><code>speechTarget</code></td><td>L'objet <code>Speech</code> courant.</td></tr> 
		 * </table>
		 * 
		 * @eventType newSpeech
		 */
		static public const NEW_SPEECH : String = "newSpeech";
		/**
		 * La constante <code>SpeechEvent.NEW_QUESTION</code> définie la 
		 * valeur du <code>type</code> de l'objet <code>SpeechEvent</code>
		 * pour l'évènement <code>newQuestion</code>.
		 * 
		 * <p>L'objet <code>SpeechEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'> 
		 * <tr><th>Property</th><th>Value</th></tr> 
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>target</code></td><td>L'objet <code>DialogKernel</code> ayant diffusé l'évènement.</td></tr> 
		 * <tr><td><code>speechTarget</code></td><td>L'objet <code>Speech</code> courant.</td></tr> 
		 * </table>
		 * 
		 * @eventType newQuestion
		 */
		static public const NEW_QUESTION : String = "newQuestion";
		
		/**
		 * L'objet <code>Speech</code> courant.
		 */
		public var speechTarget : Speech;
		
		/**
		 * Créer une nouvelle instance de la classe <code>SpeechEvent</code>.
		 * 
		 * @param	type		le type de l'évènement
		 * @param	speech		l'objet <code>Speech</code> cible de l'évènement
		 * @param	bubbles		le <i>bubbling</i> est-il autorisé pour cet évènement
		 * @param	cancelable	l'évènement est-il annulable
		 */
		public function SpeechEvent( type : String, 
									 speech : Speech = null,
									 bubbles : Boolean = false, 
									 cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.speechTarget = speech;
		}
		
	}
}
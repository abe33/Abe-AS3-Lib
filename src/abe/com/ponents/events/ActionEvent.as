package abe.com.ponents.events 
{

	/**
	 * Classe d'évènement diffusés par les objets <code>Action</code>.
	 * 
	 * @author Cédric Néhémie
	 * @see abe.com.ponents.actions.Action
	 */
	public class ActionEvent extends ComponentEvent 
	{
		/**
		 * La constante <code>ActionEvent.ACTION</code> définie la 
		 * valeur du <code>type</code> de l'objet <code>ActionEvent</code>
		 * pour l'évènement <code>action</code>.
		 * 
		 * <p>L'objet <code>ActionEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'> 
		 * <tr><th>Property</th><th>Value</th></tr> 
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>target</code></td><td>L'objet <code>Action</code> ayant diffusé l'évènement.</td></tr> 
		 * </table>
		 * 
		 * @eventType action
		 */
		static public const ACTION : String = "action";
		
		/**
		 * La constante <code>ActionEvent.ACTION_CHANGE</code> définie la 
		 * valeur du <code>type</code> de l'objet <code>ActionEvent</code>
		 * pour l'évènement <code>actionChange</code>.
		 * 
		 * <p>L'objet <code>ActionEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'> 
		 * <tr><th>Property</th><th>Value</th></tr> 
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>target</code></td><td>L'objet <code>Action</code> ayant diffusé l'évènement.</td></tr> 
		 * </table>
		 * 
		 * @eventType actionChange
		 */		static public const ACTION_CHANGE : String = "actionChange";
		
		/**
		 * Créer une nouvelle instance de la classe <code>ActionEvent</code>.
		 * 
		 * @param	type		le type de l'évènement diffusé
		 * @param	bubbles		le <i>bubbling</i> est-il autorisé pour cet évènement
		 * @param	cancelable	l'évènement est-il annulable
		 */
		public function ActionEvent (type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
		}
	}
}

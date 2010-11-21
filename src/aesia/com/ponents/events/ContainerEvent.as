package aesia.com.ponents.events 
{
	import aesia.com.ponents.core.Component;

	/**
	 * Classe d'évènement diffusé par les <code>Container</code>.
	 * 
	 * @author Cédric Néhémie
	 */
	public class ContainerEvent extends ComponentEvent 
	{
		/**
		 * La constante <code>ComponentEvent.CHILD_ADD</code> définie la 
		 * valeur du <code>type</code> de l'objet <code>ContainerEvent</code>
		 * pour l'évènement <code>childAdd</code>.
		 * 
		 * <p>L'objet <code>ContainerEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'> 
		 * <tr><th>Property</th><th>Value</th></tr> 
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>target</code></td><td>L'objet <code>Container</code> ayant diffusé l'évènement.</td></tr> 		 * <tr><td><code>child</code></td><td>L'objet <code>Component</code> ayant été ajouté à un container.</td></tr> 
		 * </table>
		 * 
		 * @eventType childAdd
		 */
		static public const CHILD_ADD : String = "childAdd";
		/**
		 * La constante <code>ComponentEvent.CHILD_REMOVE</code> définie la 
		 * valeur du <code>type</code> de l'objet <code>ContainerEvent</code>
		 * pour l'évènement <code>childRemove</code>.
		 * 
		 * <p>L'objet <code>ContainerEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'> 
		 * <tr><th>Property</th><th>Value</th></tr> 
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>target</code></td><td>L'objet <code>Container</code> ayant diffusé l'évènement.</td></tr> 
		 * <tr><td><code>child</code></td><td>L'objet <code>Component</code> ayant été supprimer d'un container.</td></tr> 
		 * </table>
		 * 
		 * @eventType childRemove
		 */
		static public const CHILD_REMOVE : String = "childRemove";
		
		/**
		 * Une référence vers l'enfant du <code>Container</code> concerné par cet évènement.
		 */
		protected var _child : Component;
		
		/**
		 * Créer une nouvelle instance de la classe <code>ContainerEvent</code>.
		 * 
		 * @param	type		le type de l'évènement diffusé
		 * @param	child		l'enfant du <code>Container</code> concerné par cet évènement
		 * @param	bubbles		le <i>bubbling</i> est-il autorisé pour cet évènement
		 * @param	cancelable	l'évènement est-il annulable
		 */
		public function ContainerEvent ( type : String, 
										 child : Component = null,
										 bubbles : Boolean = false, 
										 cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		public function get child () : Component { return _child; }
	}
}

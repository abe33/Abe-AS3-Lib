package aesia.com.ponents.events 
{
	import flash.events.Event;

	/**
	 * 
	 * 
	 * @author Cédric Néhémie
	 */
	public class PropertyEvent extends Event 
	{
		/**
		 * La constante <code>PropertyEvent.PROPERTY_CHANGE</code> définie la 
		 * valeur du <code>type</code> de l'objet <code>PropertyEvent</code>
		 * pour l'évènement <code>propertyChange</code>.
		 * 
		 * <p>L'objet <code>PropertyEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'> 
		 * <tr><th>Property</th><th>Value</th></tr> 
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>target</code></td><td>L'objet ayant diffusé l'évènement.</td></tr> 		 * <tr><td><code>propertyName</code></td><td>le nom de la propriété qui a été transformée</td></tr> 		 * <tr><td><code>propertyValue</code></td><td>la nouvelle valeur de la propriété</td></tr> 
		 * </table>
		 * 
		 * @eventType propertyChange
		 */
		static public const PROPERTY_CHANGE : String = "propertyChange";
		
		/**
		 * Nom de la propriété ayant été modifiée.
		 */
		public var propertyName : String;
		/**
		 * Nouvelle valeur de la propriété modifiée.
		 */		public var propertyValue : *;
		
		/**
		 * 
		 * @param type
		 * @param pname
		 * @param pvalue
		 * @param bubbles
		 * @param cancelable
		 */
		public function PropertyEvent ( type : String, 
										pname : String, 
										pvalue : *, 
										bubbles : Boolean = false, 
										cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
			propertyName = pname;			propertyValue = pvalue;
		}
	}
}

/**
 * @license
 */
package  abe.com.mands.events
{
	import flash.events.Event;
	/**
	 * Évènement utilisé par la classe <code>LoopCommand</code> pour
	 * fournir les informations d'une itération à l'<code>IterationCommand</code>
	 * définie pour la <code>LoopCommand</code>.
	 */
	public class IterationEvent extends Event
	{
		/**
		 * La constante <code>IterationEvent.ITERATION</code> définie la
		 * valeur du <code>type</code> de l'objet <code>IterationEvent</code>
		 * pour l'évènement <code>iteration</code>.
		 *
		 * <p>L'objet <code>IterationEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet <code>Command</code> ayant diffusé l'évènement.</td></tr>		 * <tr><td><code>iteration</code></td><td>Un entier contenant le numéros de cette itération.</td></tr>		 * <tr><td><code>value</code></td><td>La valeur de cette itération.</td></tr>
		 * </table>
		 *
		 * @eventType iteration
		 */
		static public const ITERATION : String = "iteration";
		/**
		 * Numéro de l'itération courante.
		 */
		public var iteration : uint;

		/**
		 * Valeur de l'itération courante.
		 */
		public var value : *;

		/**
		 * Créer une nouvelle instance de la classe <code>IterationEvent</code>.
		 *
		 * @param	type		le type de l'évènement diffusé
		 * @param	iteration	numéro de l'itération courante
		 * @param	value		valeur de l'itération courante
		 * @param	bubbles		le <i>bubbling</i> est-il autorisé pour cet évènement
		 * @param	cancelable	nementl'évènement est-il annulable
		 */
		public function IterationEvent( type:String, iteration : uint, value : *, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
			this.iteration = iteration;
			this.value = value;
		}

	}
}
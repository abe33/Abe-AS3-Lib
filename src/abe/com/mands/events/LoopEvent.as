/**
 * @license
 */
package  abe.com.mands.events
{
	import flash.events.Event;
	/**
	 * Évènement diffusé par un objet <code>LoopCommand</code> durant son éxécution.
	 *
	 * @see	abe.com.mands.LoopCommand
	 */
	public class LoopEvent extends Event
	{
		/**
		 * Diffusé au démarage d'une boucle.
		 *
		 * <p>L'objet <code>LoopEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet <code>LoopCommand</code> ayant diffusé l'évènement.</td></tr>		 * <tr><td><code>count</code></td><td>Le nombre d'itérations réalisées au moment de la diffusion de l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType	loopStart
		 */
		static public const LOOP_START : String = "loopStart";

		/**
		 * Diffusé à l'arrêt d'une boucle.
		 *
		 * <p>L'objet <code>LoopEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet <code>LoopCommand</code> ayant diffusé l'évènement.</td></tr>
		 * <tr><td><code>count</code></td><td>Le nombre d'itérations réalisées au moment de la diffusion de l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType	loopStop
		 */
		static public const LOOP_STOP : String = "loopStop";

		/**
		 * Diffusé à chaque image de l'animation durant l'éxécution
		 * d'une <code>LoopCommand</code>.
		 *
		 * <p>L'objet <code>LoopEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet <code>LoopCommand</code> ayant diffusé l'évènement.</td></tr>
		 * <tr><td><code>count</code></td><td>Le nombre d'itérations réalisées au moment de la diffusion de l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType	loopProgress
		 */
		static public const LOOP_PROGRESS : String = "loopProgress";

		/**
		 * Nombre d'itérations réalisées au moment de la diffusion de l'évènement.
		 */
		public var count : uint;

		/**
		 * Créer une nouvelle instance de la classe <code>LoopEvent</code>.
		 *
		 * @param	type		le type de l'évènement diffusé
		 * @param	count		nombre d'itérations réalisées au moment de la
		 * 						diffusion de l'évènement
		 * @param	bubbles		le <i>bubbling</i> est-il autorisé pour cet évènement
		 * @param	cancelable	nementl'évènement est-il annulable
		 */
		public function LoopEvent(type:String, count : uint, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.count = count;
		}
	}
}
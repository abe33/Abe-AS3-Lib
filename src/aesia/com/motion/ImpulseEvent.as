/**
 * @license
 */
package  aesia.com.motion
{
	import flash.events.Event;
	/**
	 * La classe <code>ImpulseEvent</code> est utilisée par la classe
	 * <code>MotionImpulse</code> afin de diffuser les informations
	 * temporelles.
	 */
	public class ImpulseEvent extends Event
	{
		/**
		 * La constante <code>ImpulseEvent.TICK</code> définie la
		 * valeur du <code>type</code> de l'objet <code>ImpulseEvent</code>
		 * pour l'évènement <code>tick</code>.
		 *
		 * <p>L'objet <code>ImpulseEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>		 * <tr><td><code>target</code></td><td>L'objet <code>MotionImpulse</code> ayant diffusé l'évènement.</td></tr>		 * <tr><td><code>bias</code></td><td>La durée en millisecondes de la frame précédente.</td></tr>		 * <tr><td><code>biasInSeconds</code></td><td>La durée en secondes de la frame précédente.</td></tr>		 * <tr><td><code>time</code></td><td>La durée en millisecondes depuis le début de l'animation
		 * telle que renvoyée par la fonction <code>getTimer</code>.</td></tr>
		 * </table>
		 *
		 * @see http://livedocs.adobe.com/flex/3/langref/flash/utils/package.html#getTimer() flash.utils.getTimer()
		 * @see MotionImpulse
		 * @see ImpulseListener
		 * @eventType tick
		 */
		static public const TICK : String = "tick";
		/**
		 * Valeur de bias courante en millisecondes.
		 */
		public var bias : Number;
		/**
		 * Valeur de bias courante en secondes.
		 */
		public var biasInSeconds : Number;
		/**
		 * Temps en millisecondes depuis le départ de l'animation,
		 * tel que renvoyée par la fonction <code>getTimer</code>.
		 *
		 * @see http://livedocs.adobe.com/flex/3/langref/flash/utils/package.html#getTimer() flash.utils.getTimer()
		 */
		public var time : Number;
		/**
		 * Créer une nouvelle instance de la classe <code>ImpulseEvent</code>
		 *
		 * @param	type		le type de l'évènement diffusé
		 * @param	bias		valeur de bias courante en millisecondes
		 * @param	time		temps en millisecondes depuis le départ de l'animation,
		 * 						tel que renvoyée par la fonction <code>getTimer</code>
		 * @param	bubbles		le <em>bubbling</em> est-il autorisé pour cet évènement
		 * @param	cancelable	l'évènement est-il annulable
		 */
		public function ImpulseEvent ( type : String,
									   bias : Number = 0,
									   time : Number = 0,
									   bubbles : Boolean = false,
									   cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );

			this.bias = bias;
			this.time = time;
			this.biasInSeconds = bias / 1000;
		}
	}
}

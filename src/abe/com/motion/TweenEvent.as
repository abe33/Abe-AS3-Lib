/**
 * @license
 */
package  abe.com.motion
{
	import flash.events.Event;
	/**
	 * La classe <code>TweenEvent</code> est utilisé par les objets <code>Tween</code>
	 * ou <code>MultiTween</code> lors de la diffusion des évènements relatifs à leur
	 * interpolation.
	 *
	 * @author Cédric Néhémie
	 */
	public class TweenEvent extends Event
	{
		/**
		 * La constante <code>TweenEvent.TWEEN_START</code> définie la
		 * valeur du <code>type</code> de l'objet <code>TweenEvent</code>
		 * pour l'évènement <code>tweenStart</code>.
		 *
		 * <p>L'objet <code>TweenEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet <code>Tween</code> ou <code>MultiTween</code>
		 * ayant diffusé l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType tweenStart
		 */
		static public const TWEEN_START : String = "tweenStart";
		/**
		 * La constante <code>TweenEvent.TWEEN_STOP</code> définie la
		 * valeur du <code>type</code> de l'objet <code>TweenEvent</code>
		 * pour l'évènement <code>tweenStop</code>.
		 *
		 * <p>L'objet <code>TweenEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet <code>Tween</code> ou <code>MultiTween</code>
		 * ayant diffusé l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType tweenStop
		 */
		static public const TWEEN_STOP : String = "tweenStop";
		/**
		 * La constante <code>TweenEvent.TWEEN_CHANGE</code> définie la
		 * valeur du <code>type</code> de l'objet <code>TweenEvent</code>
		 * pour l'évènement <code>tweenChange</code>.
		 *
		 * <p>L'objet <code>TweenEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet <code>Tween</code> ou <code>MultiTween</code>
		 * ayant diffusé l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType tweenChange
		 */
		static public const TWEEN_CHANGE : String = "tweenChange";
		/**
		 * La constante <code>TweenEvent.TWEEN_END</code> définie la
		 * valeur du <code>type</code> de l'objet <code>TweenEvent</code>
		 * pour l'évènement <code>tweenEnd</code>.
		 *
		 * <p>L'objet <code>TweenEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet <code>Tween</code> ou <code>MultiTween</code>
		 * ayant diffusé l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType tweenEnd
		 */		static public const TWEEN_END : String = "tweenEnd";

		/**
		 * Constructeur de la classe <code>TweenEvent</code>.
		 *
		 * @param	type		le type de l'évènement diffusé
		 * @param	bubbles		le <em>bubbling</em> est-il autorisé pour cet évènement
		 * @param	cancelable	l'évènement est-il annulable
		 */
		public function TweenEvent( type:String, bubbles:Boolean=false, cancelable:Boolean=false )
		{
			super(type, bubbles, cancelable);
		}
	}
}
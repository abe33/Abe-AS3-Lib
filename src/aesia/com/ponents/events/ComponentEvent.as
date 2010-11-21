/**
 * @license
 */
package aesia.com.ponents.events
{
	import flash.events.Event;

	/**
	 * Classe d'évènement diffusé par les composants.
	 *
	 * @author Cédric Néhémie
	 */
	public class ComponentEvent extends Event
	{
		/**
		 * La constante <code>ComponentEvent.REPAINT</code> définie la
		 * valeur du <code>type</code> de l'objet <code>ComponentEvent</code>
		 * pour l'évènement <code>repaint</code>.
		 *
		 * <p>L'objet <code>ComponentEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet ayant diffusé l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType repaint
		 */
		static public const REPAINT : String = "repaint";
		/**
		 * La constante <code>ComponentEvent.SCROLL</code> définie la
		 * valeur du <code>type</code> de l'objet <code>ComponentEvent</code>
		 * pour l'évènement <code>scroll</code>.
		 *
		 * <p>L'objet <code>ComponentEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet ayant diffusé l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType scroll
		 */		static public const SCROLL : String = "scroll";
		/**
		 * La constante <code>ComponentEvent.ENABLED_CHANGE</code> définie la
		 * valeur du <code>type</code> de l'objet <code>ComponentEvent</code>
		 * pour l'évènement <code>enableChange</code>.
		 *
		 * <p>L'objet <code>ComponentEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet ayant diffusé l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType enableChange
		 */
		static public const ENABLED_CHANGE : String = "enableChange";		/**
		 * La constante <code>ComponentEvent.SELECTED_CHANGE</code> définie la
		 * valeur du <code>type</code> de l'objet <code>ComponentEvent</code>
		 * pour l'évènement <code>selectedChange</code>.
		 *
		 * <p>L'objet <code>ComponentEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet ayant diffusé l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType selectedChange
		 */
		static public const SELECTED_CHANGE : String = "selectedChange";
		/**
		 * La constante <code>ComponentEvent.SELECTION_CHANGE</code> définie la
		 * valeur du <code>type</code> de l'objet <code>ComponentEvent</code>
		 * pour l'évènement <code>selectionChange</code>.
		 *
		 * <p>L'objet <code>ComponentEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet ayant diffusé l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType selectionChange
		 */
		static public const SELECTION_CHANGE : String = "selectionChange";		/**
		 * La constante <code>ComponentEvent.VALUE_CHANGE</code> définie la
		 * valeur du <code>type</code> de l'objet <code>ComponentEvent</code>
		 * pour l'évènement <code>valueChange</code>.
		 *
		 * <p>L'objet <code>ComponentEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet ayant diffusé l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType valueChange
		 */
		static public const VALUE_CHANGE : String = "valueChange";
		/**
		 * La constante <code>ComponentEvent.MODEL_CHANGE</code> définie la
		 * valeur du <code>type</code> de l'objet <code>ComponentEvent</code>
		 * pour l'évènement <code>modelChange</code>.
		 *
		 * <p>L'objet <code>ComponentEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet ayant diffusé l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType modelChange
		 */
		static public const MODEL_CHANGE : String = "modelChange";		/**
		 * La constante <code>ComponentEvent.TEXT_CONTENT_CHANGE</code> définie la
		 * valeur du <code>type</code> de l'objet <code>ComponentEvent</code>
		 * pour l'évènement <code>textContentChange</code>.
		 *
		 * <p>L'objet <code>ComponentEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet ayant diffusé l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType textContentChange
		 */
		static public const TEXT_CONTENT_CHANGE : String = "textContentChange";
		/**
		 * La constante <code>ComponentEvent.DATA_CHANGE</code> définie la
		 * valeur du <code>type</code> de l'objet <code>ComponentEvent</code>
		 * pour l'évènement <code>dataChange</code>.
		 *
		 * <p>L'objet <code>ComponentEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet ayant diffusé l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType dataChange
		 */
		static public const DATA_CHANGE : String = "dataChange";
		/**
		 * La constante <code>ComponentEvent.RELEASE_OUTSIDE</code> définie la
		 * valeur du <code>type</code> de l'objet <code>ComponentEvent</code>
		 * pour l'évènement <code>releaseOutside</code>.
		 *
		 * <p>L'objet <code>ComponentEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet ayant diffusé l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType releaseOutside
		 */
		static public const RELEASE_OUTSIDE : String = "releaseOutside";
		/**
		 * La constante <code>ComponentEvent.CLOSE</code> définie la
		 * valeur du <code>type</code> de l'objet <code>ComponentEvent</code>
		 * pour l'évènement <code>close</code>.
		 *
		 * <p>L'objet <code>ComponentEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet ayant diffusé l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType close
		 */
		static public const CLOSE : String = "close";		/**
		 * La constante <code>ComponentEvent.LAYOUT</code> définie la
		 * valeur du <code>type</code> de l'objet <code>ComponentEvent</code>
		 * pour l'évènement <code>layout</code>.
		 *
		 * <p>L'objet <code>ComponentEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet ayant diffusé l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType layout
		 */
		static public const LAYOUT : String = "layout";

		/**
		 * La constante <code>ComponentEvent.COMPONENT_RESIZE</code> définie la
		 * valeur du <code>type</code> de l'objet <code>ComponentEvent</code>
		 * pour l'évènement <code>componentResize</code>.
		 *
		 * <p>L'objet <code>ComponentEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet ayant diffusé l'évènement.</td></tr>
		 * </table>
		 *
		 * @eventType componentResize
		 */
		static public const COMPONENT_RESIZE : String = "componentResize";

		/**
		 * Créer une nouvelle instance de la classe <code>ComponentEvent</code>.
		 *
		 * @param	type		le type de l'évènement diffusé
		 * @param	bubbles		le <i>bubbling</i> est-il autorisé pour cet évènement
		 * @param	cancelable	l'évènement est-il annulable
		 */
		public function ComponentEvent ( type : String, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
	}
}

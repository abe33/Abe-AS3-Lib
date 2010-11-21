/**
 * @license
 */
package  aesia.com.edia.camera
{
	import aesia.com.mon.geom.Rectangle2;

	import flash.events.Event;

	/**
	 * Classe d'évènement diffusé par les différentes classes de caméra.
	 */
	public class CameraEvent extends Event
	{
		/**
		 * La constante <code>CameraEvent.CAMERA_CHANGE</code> définie la 
		 * valeur du <code>type</code> de l'objet <code>CameraEvent</code>
		 * pour l'évènement <code>cameraChange</code>.
		 * 
		 * <p>L'objet <code>CameraEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'> 
		 * <tr><th>Property</th><th>Value</th></tr> 
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>target</code></td><td>L'objet <code>Camera</code> ayant diffusé l'évènement.</td></tr> 		 * <tr><td><code>camera</code></td><td>L'objet <code>Camera</code> ayant diffusé l'évènement.</td></tr> 		 * <tr><td><code>screen</code></td><td>Le rectangle représentant l'écran de la caméra au moment 
		 * de la diffusion de l'évènement.</td></tr> 
		 * <tr><td><code>zoom</code></td><td>La valeur de zoom de la caméra au moment de la diffusion.</td></tr> 
		 * </table>
		 * 
		 * @eventType cameraChange
		 */
		static public const CAMERA_CHANGE : String = "cameraChange";
		
		/**
		 * La constante <code>CameraEvent.DOF_CHANGE</code> définie la 
		 * valeur du <code>type</code> de l'objet <code>CameraEvent</code>
		 * pour l'évènement <code>dofChange</code>.
		 * 
		 * <p>L'objet <code>CameraEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'> 
		 * <tr><th>Property</th><th>Value</th></tr> 
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr> 
		 * <tr><td><code>target</code></td><td>L'objet <code>Camera</code> ayant diffusé l'évènement.</td></tr> 
		 * <tr><td><code>camera</code></td><td>L'objet <code>Camera</code> ayant diffusé l'évènement.</td></tr> 
		 * <tr><td><code>screen</code></td><td>Le rectangle représentant l'écran de la caméra au moment 
		 * de la diffusion de l'évènement.</td></tr> 
		 * <tr><td><code>zoom</code></td><td>La valeur de zoom de la caméra au moment de la diffusion.</td></tr> 
		 * </table>
		 * 
		 * @eventType dofChange
		 */
		static public const DOF_CHANGE : String = "dofChange";
		
		/**
		 * Créer une nouvelle instance de la classe <code>CameraEvent</code>.
		 * 
		 * @param	type		le type de l'évènement diffusé
		 * @param	bubbles		le <i>bubbling</i> est-il autorisé pour cet évènement
		 * @param	cancelable	nementl'évènement est-il annulable
		 */
		public function CameraEvent ( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		/**
		 * Renvoie une référence à la caméra ayant déclenchée la diffusion de l'évènement
		 * courant.
		 * 
		 * @return	la caméra ayant déclenchée la diffusion de l'évènement courant
		 */
		public function get camera () : Camera
		{
			return target as Camera;
		}
		
		/**
		 * Renvoie le rectangle représentant le champs de la caméra ayant diffusé
		 * l'évènement courant.
		 * 
		 * @return	le rectangle représentant le champs de la caméra ayant diffusé
		 * 			l'évènement courant
		 */
		public function get screen () : Rectangle2
		{
			return (target as Camera).screen;
		}
		
		/**
		 * Renvoie la valeur de zoom de la caméra ayant diffusé l'évènement courant.
		 * 
		 * @return	la valeur de zoom de la caméra ayant diffusé l'évènement courant
		 */
		public function get zoom() : Number
		{
			return (target as Camera).zoom;
		}
	}
}
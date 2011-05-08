/**
 * @license
 */
package  abe.com.mands.events
{
	import flash.events.ProgressEvent;
	/**
	 * Évènement diffusé par un objet <code>Estimator</code> durant son analyse d'un transfert.
	 *
	 * @see abe.com.mands.load.Estimator
	 */
	public class LoadingEstimationEvent extends ProgressEvent
	{
		/**
		 * La constante <code>LoadingEstimationEvent.ESTIMATIONS_AVAILABLE</code> définie la
		 * valeur du <code>type</code> de l'objet <code>LoadingEstimationEvent</code>
		 * pour l'évènement <code>estimationsAvailable</code>.
		 *
		 * <p>L'objet <code>LoadingEstimationEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet <code>Estimator</code> ayant diffusé l'évènement.</td></tr>
		 * <tr><td><code>downloadRate</code></td><td>Le taux de transfert estimé à ce stade.</td></tr>		 * <tr><td><code>remainingTime</code></td><td>Le temps restant pour ce téléchargement		 * avec le taux de transfert de la dernière estimation.</td></tr>
		 * <tr><td><code>bytesLoaded</code></td><td>Le nombre d'octets déjà téléchargé.</td></tr>		 * <tr><td><code>bytesTotal</code></td><td>Le nombre d'octets total à télécharger.</td></tr>
		 * </table>
		 *
		 * @eventType estimationsAvailable
		 */
		static public const ESTIMATIONS_AVAILABLE : String = "estimationsAvailable";

		/**
		 * La constante <code>LoadingEstimationEvent.NEW_ESTIMATION</code> définie la
		 * valeur du <code>type</code> de l'objet <code>LoadingEstimationEvent</code>
		 * pour l'évènement <code>newEstimation</code>.
		 *
		 * <p>L'objet <code>LoadingEstimationEvent</code> possède les propriétés suivantes :</p>
		 * <table class='innertable'>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 * <tr><td><code>target</code></td><td>L'objet <code>Estimator</code> ayant diffusé l'évènement.</td></tr>
		 * <tr><td><code>downloadRate</code></td><td>Le taux de transfert estimé à ce stade.</td></tr>
		 * <tr><td><code>remainingTime</code></td><td>Le temps restant pour ce téléchargement
		 * avec le taux de transfert de la dernière estimation.</td></tr>
		 * <tr><td><code>bytesLoaded</code></td><td>Le nombre d'octets déjà téléchargé.</td></tr>
		 * <tr><td><code>bytesTotal</code></td><td>Le nombre d'octets total à télécharger.</td></tr>
		 * </table>
		 *
		 * @eventType newEstimation
		 */
		static public const NEW_ESTIMATION : String = "newEstimation";

		/**
		 * Taux de transfert calculé lors de la dernière évaluation.
		 */
		public var downloadRate : Number;
		/**
		 * Temps de téléchargement restant avec le taux de transfert
		 * calculé lors de la dernière évaluation.
		 */
		public var remainingTime : Number;

		/**
		 * Créer une nouvelle instance de la classe <code>LoadingEstimationEvent</code>.
		 *
		 * @param type			type de l'évènement diffusé
		 * @param downloadRate	taux de transfert calculé lors de la dernière estimation
		 * @param remainingTime	temps de téléchargement restant avec le taux de transfert courant
		 * @param loaded		nombre d'octets déjà téléchargé
		 * @param total			nombre d'octets total du téléchargement
		 * @param bubbles		le <i>bubbling</i> est-il autorisé pour cet évènement
		 * @param cancelable	l'évènement est-il annulable
		 */		public function LoadingEstimationEvent( type : String,
												downloadRate : Number = 0,
												remainingTime : Number = 0,
												loaded : Number = 0,
												total : Number = 0,
												bubbles : Boolean = false,
												cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable, loaded, total );
			this.downloadRate = downloadRate;
			this.remainingTime = remainingTime;

		}
	}
}
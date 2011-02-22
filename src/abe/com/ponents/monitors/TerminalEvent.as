/**
 * @license 
 */
package  abe.com.ponents.monitors
{
	import abe.com.ponents.events.ComponentEvent;

	/**
	 * Évènement diffusé par un objet <code>Terminal</code>
	 * à une commande lors de l'éxécution de celle-ci.
	 */
	public class TerminalEvent extends ComponentEvent
	{
		/**
		 * Nom de la commande éxécutée.
		 */
		public var command : String;
		/**
		 * Options définie pour la commande éxécutée.
		 */
		public var options : String;
		/**
		 * Objet terminal dans lequel la commande a été éxécuté.
		 */
		public var terminal : Terminal;
		
		
		/**
		 * Créer une nouvelle instance de la classe <code>TerminalEvent</code>.
		 * 
		 * @param	type		le type de l'évènement diffusé
		 * @param	command		nom de la commande éxécutée
		 * @param	options		options définie pour la commande éxécutée
		 * @param	terminal	objet terminal dans lequel la commande a été éxécuté
		 * @param	bubbles		le <i>bubbling</i> est-il autorisé pour cet évènement
		 * @param	cancelable	nementl'évènement est-il annulable
		 */
		public function TerminalEvent( 	type:String, 
										command : String, 
										options : String = "", 
										terminal : Terminal = null,
										bubbles:Boolean=false, 
										cancelable:Boolean=false )
		{
			super(type, bubbles, cancelable);
			this.command = command;
			this.options = options;
			this.terminal = terminal;
		}
		
	}
}
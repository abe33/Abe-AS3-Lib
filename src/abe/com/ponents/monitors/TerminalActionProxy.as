/**
 * @license 
 */
package  abe.com.ponents.monitors
{
	import abe.com.mands.Command;
	import abe.com.mands.events.CommandEvent;
	import abe.com.mon.colors.Color;
	import abe.com.mon.core.Cancelable;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.ponents.actions.AbstractTerminalAction;
	import abe.com.ponents.actions.TerminalAction;
	import abe.com.ponents.skinning.icons.Icon;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	/**
	 * Un objet <code>TerminalActionProxy</code> permet d'utiliser n'importe quelle classe implémentant
	 * l'interface <code>Command</code> comme commande dans un terminal.
	 * <p>
	 * Les commandes de terminal créées à l'aide de la classe <code>TerminalActionProxy</code> n'ont qu'un
	 * usage possible et aucune options.
	 * </p>
	 */
	public class TerminalActionProxy extends AbstractTerminalAction implements TerminalAction, Command, Runnable
	{
		/**
		 * La commande à éxécuter.
		 */
		public var proxy : Command;
		
		/**
		 * Créer une nouvelle instance de la classe <code>TerminalActionProxy</code>.
		 * 
		 * @param	command		commande à éxécuter
		 * @param	commandName	alias de la commande dans le terminal
		 * @param	description	description de la commande
		 */
		public function TerminalActionProxy( command : Command, 
											 name : String = "",
											 icon : Icon = null,
											 longDescription : String = "", 
											 commandN : String = "", 
											 usage : String = "", 
											 documentation : String = "", 
											 accelerator : KeyStroke = null )
		{
			proxy = command;
			super( name, icon, longDescription, commandN, usage, documentation, null, accelerator );
		}
		/**
		 * Éxécute la commande enregistrée par cette instance de <code>TerminalActionProxy</code>.
		 * 
		 * @param	e	<code>TerminalEvent</code> diffusé par le terminal
		 */
		override public function execute( ... args ) : void 
		{
			var te : TerminalEvent = e as TerminalEvent;
			te.terminal.echo( "<font color='" + Color.DeepSkyBlue.html + "'>Éxécute la commande</font> " +
							  proxy + "<font color='" + Color.DeepSkyBlue.html + "'>...</font>" );
			
			registerToCommandEvents( proxy );
			proxy.execute( e );
		}
		/**
		 * Enregistre l'instance courante comme écouteur pour les évènements
		 * diffusé par la commande <code>c</code> passée en paramètre. 
		 * <p>
		 * La fonction s'enregistre pour les évènements suivant : 
		 * </p>
		 * <ul>
		 * <li><code>CommandEvent.COMMAND_END</code> : 
		 * la fonction réceptrice est <code>commandEnd</code></li>
		 * <li><code>CommandEvent.COMMAND_FAIL</code> : 
		 * la fonction réceptrice est <code>commandFailed</code></li>
		 * <li><code>CommandEvent.COMMAND_CANCEL</code> : 
		 * la fonction réceptrice est <code>commandCancelled</code>.
		 * <p>
		 * Cet évènement est écouté uniquement si <code>c</code> implémente
		 * l'interface <code>Cancelable</code>.
		 * </p></li>
		 * </ul> 
		 * 
		 * @param	c	commande à laquelle on souhaite s'enregistrer
		 */
		protected function registerToCommandEvents ( c : Command ) : void
		{
			c.addEventListener( CommandEvent.COMMAND_END, commandEnd );
			c.addEventListener( CommandEvent.COMMAND_FAIL, commandFailed );
			
			if( c is Cancelable )
				c.addEventListener( CommandEvent.COMMAND_CANCEL, commandCancelled );
		}
		
		/**
		 * Enlève l'instance courante de la liste des écouteurs pour la commande
		 * <code>c</code> passée en paramètre.
		 * <p>
		 * La fonction réalise la suppression des écouteurs enregistrés par la 
		 * fonction <code>registerToCommandEvents</code>.
		 * </p>
		 * 
		 * @param	c	commande à laquelle on souhaite se désinscrire
		 */
		protected function unregisterToCommandEvents ( c : Command ) : void
		{
			c.removeEventListener( CommandEvent.COMMAND_END, commandEnd );
			c.removeEventListener( CommandEvent.COMMAND_FAIL, commandFailed );
			
			if( c is Cancelable )
				c.removeEventListener( CommandEvent.COMMAND_CANCEL, commandCancelled );
		}
		/**
		 * Notifie les éventuels écouteurs de la commande que son opération 
		 * a été annulé par un appel à la méthode <code>cancel</code>. 
		 * Un évènement de type <code>CommandEvent.COMMAND_CANCEL</code>
		 * est alors diffusé par la classe. 
		 * <p>
		 * A la fin de l'appel, la commande n'est plus considérée comme 
		 * en cours d'exécution.
		 * </p>
		 */
		protected function fireCommandCancelled () : void
		{
			_isRunning = false;
			dispatchEvent( new CommandEvent( CommandEvent.COMMAND_CANCEL ) );
		}
		
		/*
		 *
		 */
		private function commandEnd ( e : Event ) : void
		{
			unregisterToCommandEvents( proxy );
			fireCommandEnd();
		}
		/*
		 *
		 */
		private function commandFailed ( e : Event ) : void
		{
			unregisterToCommandEvents( proxy );
			
			var evt : ErrorEvent = e as ErrorEvent;
			
			fireCommandFailed( evt.text );
		}
		/*
		 *
		 */
		private function commandCancelled ( e : Event ) : void
		{
			unregisterToCommandEvents( proxy );
			fireCommandCancelled();
		}	
	}
}
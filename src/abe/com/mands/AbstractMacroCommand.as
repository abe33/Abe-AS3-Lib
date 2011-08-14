/**
 * @license
 */
package  abe.com.mands
{

	import abe.com.mon.core.Cancelable;
	import abe.com.mon.core.Runnable;

	/**
	 * Implémentation de base de l'interface <code>MacroCommand</code>. En règle
	 * générale, il suffit d'étendre <code>AbstractMacroCommand</code> et de réécrire
	 * la méthode <code>execute</code> afin de créer une nouvelle macro-commande.
	 * <p>
	 * La classe <code>AbstractMacroCommand</code> fournie la gestion de l'ajout
	 * et de la suppression de sous-commandes. Par défaut, il est possible d'ajouter
	 * une même commande un nombre infini de fois dans une <code>AbstractMacroCommand</code>. 
	 * </p>
	 */
	public class AbstractMacroCommand extends AbstractCommand implements Command, MacroCommand, Runnable
	{
		/**
		 * Vecteur contenant toutes les sous-commandes de cette instance.
		 */
		
		TARGET::FLASH_9
		protected var _aCommands : Array;
		
		TARGET::FLASH_10
		protected var _aCommands : Vector.<Command>;
		
		TARGET::FLASH_10_1 
		protected var _aCommands : Vector.<Command>;
		
		/**
		 * Instancier une <code>AbstractCommand</code> est possible mais
		 * inutile. Par contre appeler le super-constructeur permet 
		 * d'initialiser le tableau utiliser en interne pour stocker les
		 * sous-commandes. 
		 */
		public function AbstractMacroCommand()
		{
			super();
			
			TARGET::FLASH_9 {
				_aCommands = [];
			}
			
			TARGET::FLASH_10 {
				_aCommands = new Vector.<Command>();
			}
			TARGET::FLASH_10_1 { 
			_aCommands = new Vector.<Command>();
			} 
		}
		
		/**
		 * Ajoute une <code>Command</code> à l'instance courante. 
		 * <p>
		 * Une instance de <code>Command</code> peut être insérée
		 * autant de fois que désiré à cette instance. La nouvelle
		 * sous-commande est ajouté à la fin du tableau de sous-commandes. 
		 * </p>
		 * 
		 * @param	c	commande à ajouter à cette instance
		 * @return	<code>true</code> si la commande a été
		 * 			ajouté avec succès, <code>false</code>
		 * 			autrement
		 */
		public function addCommand ( command : Command ) : Boolean
		{
			if( command == null ) 
				return false;
				
			var l : Number = _aCommands.length;
			return (l != _aCommands.push( command ) );
		}
		
		public function addCommands ( ... commands ) : Boolean
		{
			var b : Boolean = false;
			for each( var c : Command in commands )
				b = addCommand( c ) || b;
			
			return b;
		}
		
		TARGET::FLASH_9
		public function addCommandsVector ( commands : Array ) : Boolean
		{
			var b : Boolean = false;
			for each( var c : Command in commands )
				b = addCommand( c ) || b;
			
			return b;
		}
		TARGET::FLASH_10
		public function addCommandsVector ( commands : Vector.<Command> ) : Boolean
		{
			var b : Boolean = false;
			for each( var c : Command in commands )
				b = addCommand( c ) || b;
			
			return b;
		}
		
		TARGET::FLASH_10_1 
		public function addCommandsVector ( commands : Vector.<Command> ) : Boolean
		{
			var b : Boolean = false;
			for each( var c : Command in commands )
				b = addCommand( c ) || b;
			
			return b;
		}
		
		/**
		 * Enlève une <code>Command</code> à l'instance courante. 
		 * <p>
		 * Si la commande est référencée plusieurs fois dans le
		 * tableau de sous-commandes toutes les références à cette
		 * commande seront supprimées.
		 * </p> 
		 * 
		 * @param	c	commande à supprimer de cette instance
		 * @return	<code>true</code> si la commande a été
		 * 			supprimé avec succès, <code>false</code>
		 * 			autrement
		 */		
		public function removeCommand (command : Command) : Boolean
		{
			var id : Number = _aCommands.indexOf( command ); 

			if ( id == -1 ) return false;
			
			do
			{
				_aCommands.splice( id, 1 );
			}
			while ( ( id = _aCommands.indexOf( command ) ) != -1 );

			return true;
		}
		
		/**
		 * Supprime toutes les sous-commandes stockées 
		 * par l'instance courante.
		 */
		public function removeAllCommands() : void
		{
			var l : Number = _aCommands.length;
			var i : Number;
			
			for( i = 0; i < l; i++ )
			{
				var c : Command = _aCommands[ i ];
				if( c )
				{
					unregisterToCommandSignals( c );
				}
			}
			
			TARGET::FLASH_9 { _aCommands = []; }
			TARGET::FLASH_10 { _aCommands = new Vector.<Command>(); }
			TARGET::FLASH_10_1 { _aCommands = new Vector.<Command>(); } 
		}
		
		/**
		 * Réécrivez cette méthode pour définir le comportement de votre 
		 * classe lors de la fin d'éxécution d'une sous-commande. 
		 */
		protected function onCommandEnded ( command : Command ) : void	{}
		
		/**
		 * Réécrivez cette méthode pour définir le comportement de votre 
		 * classe lors d'un échec d'éxécution d'une sous-commande. 
		 */
		protected function onCommandFailed ( command : Command, s : String ) : void {}
		
		/**
		 * Réécrivez cette méthode pour définir le comportement de votre 
		 * classe lors d'une annulation d'éxécution d'une commande implémentant
		 * <code>Cancelable</code>. 
		 */
		protected function onCommandCancelled ( command : Command ) : void {}
		
		/**
		 * Enregistre l'instance courante comme écouteur pour les évènements
		 * diffusé par la commande <code>c</code> passée en paramètre. 
		 * <p>
		 * La fonction s'enregistre pour les évènements suivant : 
		 * </p>
		 * @param	c	commande à laquelle on souhaite s'enregistrer
		 */
		protected function registerToCommandSignals ( c : Command ) : void
		{
			c.commandEnded.add( onCommandEnded );
			c.commandFailed.add( onCommandFailed );
			
			if( c is Cancelable )
				( c as Cancelable).commandCancelled.add( onCommandCancelled );
		}
		
		/**
		 * Enlève l'instance courante de la liste des écouteurs pour la commande
		 * <code>c</code> passée en paramètre.
		 * <p>
		 * La fonction réalise la suppression des écouteurs enregistrés par la 
		 * fonction <code>registerToCommandSignals</code>.
		 * </p>
		 * @param	c	commande à laquelle on souhaite se désinscrire
		 */
		protected function unregisterToCommandSignals ( c : Command ) : void
		{
			c.commandEnded.remove( onCommandEnded );
			c.commandFailed.remove( onCommandFailed );
			
			if( c is Cancelable )
				( c as Cancelable).commandCancelled.remove( onCommandCancelled );
		}
		/**
		 * Nombre de commandes actuellement enregistrées dans cette macro commande. 
		 */
		public function get length () : uint
		{
			return _aCommands.length;	
		}
	}
}

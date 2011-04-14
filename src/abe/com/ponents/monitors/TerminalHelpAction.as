/**
 * @license 
 */
package  abe.com.ponents.monitors
{
	import abe.com.mands.Command;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.AbstractTerminalAction;
	import abe.com.ponents.actions.TerminalAction;
	import abe.com.ponents.actions.TerminalActionOption;

	import flash.events.Event;

	/**
	 * La commande <code>HelpAction</code> affiche la liste des commandes disponibles
	 * dans un objet <code>Terminal</code> et permet d'afficher l'aide détaillée d'une
	 * commande.
	 * <p>
	 * La commande <code>HelpAction</code> est présente par défaut dans toute
	 * instance de <code>Terminal</code>. 
	 * </p><p>
	 * La commande <code>help</code> permet de la déclencher au sein du terminal.
	 * Si elle est suivie du nom d'une autre commande, elle déclenche l'affichage
	 * de l'aide détaillé de cette commande. Elle accepte l'option <code>--help</code>
	 * (<code>-h</code>) qui déclenche l'affichage de l'aide de cette commande.
	 * </p>
	 */
	public class TerminalHelpAction extends AbstractTerminalAction implements TerminalAction, Command, Runnable
	{
		/**
		 * Créer une nouvelle instance de la classe <code>HelpAction</code>.
		 */
		public function TerminalHelpAction( accelerator : KeyStroke = null )
		{
			var options : Vector.<TerminalActionOption> = new Vector.<TerminalActionOption> ();
			options.push( new TerminalActionOption( "-h", 		_("'-help' alias.") ) );
			options.push( new TerminalActionOption( "--help", 	_("Print the command's help.") ) );
			
			super(	_("Terminal Help"),
					null,
					_("Print the complete list of registered commands.<br/>Type 'help [command]' to get the detailled help for '[command]'."),
					"help", 
			
				  	// usages
				 	"help<br/>"+
				  	"help [command]<br/>"+
				  	"help [options]",
				  	
				  	// description
				  	_("Print the complete list of registered commands.<br/>Type 'help [command]' to get the detailled help for '[command]'."),
				  	// options
				  	options, 
				  	accelerator );
		}
		/**
		 * Réalise l'opération de la commande en fonction des paramètres et option définis.
		 * 
		 * @param	e	objet <code>TerminalEvent</code> fournit par le <code>Terminal</code> dans
		 * 				lequel la commande a été appelé
		 */
		override public function execute( ... args ) : void
		{
			var te : TerminalEvent = e as TerminalEvent;
			
			var o : Object = parseOptions( te.options );	
			var command : TerminalAction;		
			if( o.length == 0 )
			{
				var commands : Object = te.terminal.getCommands();
				var a : Array = [];
				for( var i : String in commands )
				{
					a.push( formatCommandInfoSummary( commands[i] ) );
				}
				a.sort();
				te.terminal.echo( a.join("\n") );
				fireCommandEnd();
			}
			else if ( o.hasOwnProperty( "--help" ) || o.hasOwnProperty( "-h" ) )
			{
				te.terminal.echo( this.formatCommandInfoDetails( this ) );
				fireCommandEnd();
			}
			else if ( o.value != null )
			{
				command = te.terminal.getCommands()[ o.value ];
				
				if( command != null )
				{
					te.terminal.echo( formatCommandInfoDetails( command ) );
					fireCommandEnd();
				}
				else
				{
					fireCommandFailed( _( "Unknown command '$0'." ).replace("$0", o.value ) );
				}
			}
			else
			{
				fireCommandFailed( _("Unknown parameters in '$0', type 'help --help' to display the full command's informations.").replace("$0", te.options ) );
			}
		}
	}
}
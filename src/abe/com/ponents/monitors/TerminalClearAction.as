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
	 * 
	 */
	public class TerminalClearAction extends AbstractTerminalAction implements TerminalAction, Command, Runnable
	{
		public function TerminalClearAction( accelerator : KeyStroke = null )
		{
			var options : Vector.<TerminalActionOption> = new Vector.<TerminalActionOption> ();
			options.push( new TerminalActionOption( "-h", 		_("'-help' alias.") ) );
			options.push( new TerminalActionOption( "--help", 	_("Print the command's help.") ) );
			
			super(	_("Clear Terminal"),
					null,
					_("Clear the terminal content."), 
					"clear", 
					
				  	// usages
				 	"clear<br/>"+
				  	"clear [options]",
				  	
				  	// description
				  	_("Clear the terminal content."), 
				  	// options
				  	options,
				  	accelerator
				 );
		}
		override public function execute( ... args ) : void
		{
			var te : TerminalEvent = e as TerminalEvent;
			var o : Object = parseOptions( te.options );
			if( o.length == 0 )
			{
				te.terminal.clear();
			}
			else if( o.hasOwnProperty( "--help" ) || o.hasOwnProperty( "-h" ) )
			{
				te.terminal.echo( this.formatCommandInfoDetails( this ) );
			}
			else
			{
				fireCommandFailed( 	_("Unknown parameters in '$0', type 'clear --help' to display the full command's informations.").replace("$0", te.options ) );
			}
		}
	}
}
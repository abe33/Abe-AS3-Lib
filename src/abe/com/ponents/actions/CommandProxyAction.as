package abe.com.ponents.actions 
{
	import abe.com.mands.Command;
	import abe.com.mon.core.Cancelable;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.ponents.skinning.icons.Icon;
	/**
	 * @author cedric
	 */
	public class CommandProxyAction extends AbstractAction 
	{
		protected var _command : Command;

		public function CommandProxyAction ( command : Command,
											 name : String = "", 
											 icon : Icon = null, 
											 longDescription : String = null,
											 accelerator : KeyStroke = null)
		{
			super( name, icon, longDescription, accelerator );
			_command = command;
		}
		public function get command () : Command { return _command; }
		public function set command (command : Command) : void { _command = command; }
		
		override public function execute( ... args ) : void 
		{
			registerToCommandEvents(_command );
			_command.execute();
		}
		protected function registerToCommandEvents (command : Command) : void 
		{
			command.commandEnded.add( onCommandEnded );
			command.commandFailed.add( onCommandFailed );
			if( command is Cancelable )
			  ( command as Cancelable ).commandCancelled.add( onCommandCancelled );
		}
		protected function unregisterFromCommandEvents (command : Command) : void 
		{
			command.commandEnded.remove( onCommandEnded );
			command.commandFailed.remove( onCommandFailed );
			if( command is Cancelable )
			  ( command as Cancelable ).commandCancelled.remove( onCommandCancelled );
		}
		protected function onCommandEnded ( command : Command ) : void 
		{
			unregisterFromCommandEvents(_command);
			commandEnded.dispatch( this );
		}
		protected function onCommandCancelled ( command : Command ) : void 
		{
			unregisterFromCommandEvents(_command);
			commandEnded.dispatch( this );
		}
		protected function onCommandFailed ( command : Command, msg : String ) : void 
		{		
			unregisterFromCommandEvents(_command);	
			commandFailed.dispatch( this, msg );
		}
	}
}

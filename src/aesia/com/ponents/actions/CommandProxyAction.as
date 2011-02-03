package aesia.com.ponents.actions 
{
	import aesia.com.mands.Command;
	import aesia.com.mands.events.CommandEvent;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.ponents.skinning.icons.Icon;

	import flash.events.ErrorEvent;
	import flash.events.Event;
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
		
		override public function execute (e : Event = null) : void 
		{
			registerToCommandEvents(_command );
			_command.execute();
		}
		protected function registerToCommandEvents (command : Command) : void 
		{
			command.addEventListener( CommandEvent.COMMAND_END, commandEnd );
			command.addEventListener( CommandEvent.COMMAND_FAIL, commandFailed );
			command.addEventListener( CommandEvent.COMMAND_CANCEL, commandCancelled );
		}
		protected function unregisterFromCommandEvents (command : Command) : void 
		{
			command.removeEventListener( CommandEvent.COMMAND_END, commandEnd );
			command.removeEventListener( CommandEvent.COMMAND_FAIL, commandFailed );
			command.removeEventListener( CommandEvent.COMMAND_CANCEL, commandCancelled );
		}
		protected function commandEnd (event : CommandEvent) : void 
		{
			unregisterFromCommandEvents(_command);
			fireCommandEnd();
		}
		protected function commandCancelled (event : CommandEvent) : void 
		{
			unregisterFromCommandEvents(_command);
			fireCommandEnd();
		}
		protected function commandFailed (event : ErrorEvent) : void 
		{		
			unregisterFromCommandEvents(_command);	
			fireCommandFailed( event.text );
		}
	}
}

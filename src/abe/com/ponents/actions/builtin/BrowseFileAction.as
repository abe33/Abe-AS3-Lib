/**
 * @license
 */
package abe.com.ponents.actions.builtin
{
	import abe.com.mands.Command;
	import abe.com.mands.events.CommandEvent;
	import abe.com.mon.core.Cancelable;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.ponents.actions.AbstractAction;
	import abe.com.ponents.actions.Action;
	import abe.com.ponents.skinning.icons.Icon;

	import flash.events.Event;
	import flash.net.FileReference;

	/*FDT_IGNORE*/TARGET::AIR { 
	import flash.filesystem.File;
	} /*FDT_IGNORE*/
	/**
	 * @author Cédric Néhémie
	 */
	public class BrowseFileAction extends AbstractAction implements Command, Action, Cancelable
	{
		/*FDT_IGNORE*/
		TARGET::AIR
		protected var _fileReference : File;
		TARGET::WEB /*FDT_IGNORE*/
		protected var _fileReference : FileReference;

		protected var _filters : Array;
		protected var _isCanceled : Boolean;

		public function BrowseFileAction ( name : String = "",
										   icon : Icon = null,
									       filters : Array = null,
										   longDescription : String = null,
										   accelerator : KeyStroke = null )
		{
			super( name, icon, longDescription, accelerator );
			_filters = filters;
		}
		/*FDT_IGNORE*/
		TARGET::AIR
		public function get fileReference () : File { 	return _fileReference;	}
		TARGET::WEB /*FDT_IGNORE*/
		public function get fileReference () : FileReference { 	return _fileReference;	}
		
		public function get size (): Number { return _fileReference.size; }
		
		public function get filters () : Array { return _filters; }
		public function set filters (filters : Array) : void { _filters = filters; }
		
		override public function execute( ... args ) : void
		{
			_isCanceled = false;

			/*FDT_IGNORE*/
			TARGET::AIR { fileReference = new File(); }
			TARGET::WEB { /*FDT_IGNORE*/
			_fileReference = new FileReference(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/

			registerToFileReferenceEvents( _fileReference );
			_fileReference.browse(_filters);
		}
		protected function browseCancel (event : Event) : void
		{
			_isCanceled = true;
			fireCommandCancelled();
			unregisterFromFileReferenceEvents(_fileReference);
		}
		protected function fileSelect (event : Event) : void
		{
			fireCommandEnd();
			unregisterFromFileReferenceEvents(_fileReference);
		}
		protected function registerToFileReferenceEvents ( fileReference : FileReference ) : void
		{
			fileReference.addEventListener( Event.SELECT, fileSelect );			fileReference.addEventListener( Event.CANCEL, browseCancel );
		}
		protected function unregisterFromFileReferenceEvents ( fileReference : FileReference ) : void
		{
			fileReference.removeEventListener( Event.SELECT, fileSelect );
			fileReference.removeEventListener( Event.CANCEL, browseCancel );
		}
		public function cancel () : void
		{
			_isCanceled = true;
			fireCommandCancelled();
		}
		public function isCancelled () : Boolean
		{
			return _isCanceled;
		}
		protected function fireCommandCancelled () : void
		{
			_isRunning = false;
			dispatchEvent( new CommandEvent( CommandEvent.COMMAND_CANCEL ) );
		}
	}
}

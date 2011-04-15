package abe.com.ponents.actions.builtin
{
	import abe.com.mon.core.Cancelable;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.ponents.actions.AbstractAction;
	import abe.com.ponents.skinning.icons.Icon;

	import org.osflash.signals.Signal;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	/**
	 * @author Cédric Néhémie
	 */
	public class SaveFileAction extends AbstractAction implements Cancelable
	{
		/*FDT_IGNORE*/
		TARGET::AIR { protected var _fileReference : File; }
		TARGET::WEB {/*FDT_IGNORE*/
		protected var _fileReference : FileReference; /*FDT_IGNORE*/ } /*FDT_IGNORE*/


		protected var _fileName : String;
		protected var _validationFunction : Function;
		protected var _data : *;
		
		protected var _commandCancelled : Signal;
		protected var _isCancelled : Boolean;

		public function SaveFileAction ( fileName : String = null,
										 data : * = null,
										 name : String = "",
										 icon : Icon = null,
										 longDescription : String = null,
										 accelerator : KeyStroke = null)
		{
			super( name, icon, longDescription, accelerator );
			_fileName = fileName;
			_data = data;
		}
		public function get data () : * { return _data; }
		public function set data (data : *) : void
		{
			_data = data;
		}

		public function get validationFunction () : Function { return _validationFunction; }
		public function set validationFunction (validationFunction : Function) : void
		{
			_validationFunction = validationFunction;
		}

		public function get fileName () : String { return _fileName; }
		public function set fileName (fileName : String) : void
		{
			_fileName = fileName;
		}
		override public function execute( ... args ) : void
		{
			_isCancelled = false;
			_isRunning = true;
			if( _data && _fileName && ( _validationFunction == null || _validationFunction() ) )
			{
				/*FDT_IGNORE*/
				TARGET::AIR { fileReference = new File(); }
				TARGET::WEB { /*FDT_IGNORE*/
				_fileReference = new FileReference(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/

				registerToFileReferenceEvents( _fileReference );
				_fileReference.save(_data, _fileName );
			}
		}
		protected function registerToFileReferenceEvents ( fileReference : FileReference ) : void
		{
			fileReference.addEventListener( Event.COMPLETE, complete );
			fileReference.addEventListener( IOErrorEvent.IO_ERROR, ioError );
			fileReference.addEventListener( Event.CANCEL, browseCancel );
		}
		protected function unregisterFromFileReferenceEvents ( fileReference : FileReference ) : void
		{
			fileReference.removeEventListener( Event.COMPLETE, complete );
			fileReference.removeEventListener( IOErrorEvent.IO_ERROR, ioError );
			fileReference.removeEventListener( Event.CANCEL, browseCancel );
		}
		protected function ioError (event : IOErrorEvent) : void
		{
			_isRunning = false;
			commandFailed.dispatch( this, event.text );
			unregisterFromFileReferenceEvents(_fileReference);
		}
		protected function browseCancel (event : Event) : void
		{			_isRunning = false;
			_isCancelled = true;
			commandCancelled.dispatch( this );
			unregisterFromFileReferenceEvents(_fileReference);
		}
		protected function complete (event : Event) : void
		{			_isRunning = false;
			commandEnded.dispatch( this );
			unregisterFromFileReferenceEvents(_fileReference );
		}
		public function get commandCancelled () : Signal { return _commandCancelled; }
		public function cancel () : void
		{
			_isRunning = false;
			_isCancelled = true;
			_fileReference.cancel();
			_commandCancelled.dispatch( this );
		}
		public function isCancelled () : Boolean
		{
			return _isCancelled;
		}
	}
}
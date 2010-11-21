package aesia.com.ponents.actions.builtin
{
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.skinning.icons.Icon;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.FileReference;

	/**
	 * @author Cédric Néhémie
	 */
	public class SaveFileAction extends AbstractAction
	{
		/*FDT_IGNORE*/TARGET::WEB {/*FDT_IGNORE*/
		protected var _fileReference : FileReference;
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		/*FDT_IGNORE*/TARGET::AIR { /*FDT_IGNORE*/
		protected var _fileReference : File;
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		protected var _fileName : String;
		protected var _validationFunction : Function;
		protected var _data : *;

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
		override public function execute (e : Event = null) : void
		{
			if( _data && _fileName && ( _validationFunction == null || _validationFunction() ) )
			{
				/*FDT_IGNORE*/TARGET::WEB {/*FDT_IGNORE*/
					_fileReference = new FileReference();
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/

				/*FDT_IGNORE*/TARGET::AIR {/*FDT_IGNORE*/
					_fileReference = new File();
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/

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
			fireCommandFailed();
			unregisterFromFileReferenceEvents(_fileReference);
		}
		protected function browseCancel (event : Event) : void
		{
			fireCommandEnd();
			unregisterFromFileReferenceEvents(_fileReference);
		}
		protected function complete (event : Event) : void
		{
			fireCommandEnd();
			unregisterFromFileReferenceEvents(_fileReference );
		}
	}
}
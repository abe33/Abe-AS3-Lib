package abe.com.ponents.actions.builtin
{
	import abe.com.mon.logs.Log;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.skinning.icons.Icon;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	/**
	 * @author cedric
	 */
	public class LoadFileAction extends BrowseFileAction
	{
		protected var _preventLargeFile : Number;

		public function LoadFileAction ( name : String = "",
										 icon : Icon = null,
										 filters : Array = null,
										 longDescription : String = null,
										 accelerator : KeyStroke = null,
										 preventLargeFile : Number = -1 )
		{
			super( name, icon, filters, longDescription, accelerator );
			_preventLargeFile = preventLargeFile;
		}

		public function get data () : * {return _fileReference ? _fileReference.data : null; }

		override protected function fileSelect (event : Event) : void
		{
			if( _preventLargeFile > 0 )
			{
				if( size <= _preventLargeFile )
					_fileReference.load();
				else commandFailed.dispatch( this, _$(_("The selected file exceeds the limit, $0MB instead of $1MB."),
											Math.floor( size / ( 1024*1024 ) ), Math.floor( _preventLargeFile / ( 1024*1024 ) ) ) );

			}
			else				_fileReference.load();
		}
		protected function complete (event : Event) : void
		{
			_isRunning = false;
			commandEnded.dispatch( this );
		}
		protected function ioError (event : IOErrorEvent) : void
		{
			_isRunning = false;
			commandFailed.dispatch( this, event.text );
			unregisterFromFileReferenceEvents(_fileReference);
		}
		protected function securityError ( event : SecurityErrorEvent ) : void
		{
			_isRunning = false;
			commandFailed.dispatch( this, event.text );
			unregisterFromFileReferenceEvents(_fileReference);
		}
		protected function httpStatus ( event : HTTPStatusEvent ) : void
		{
			/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
				Log.error( _$(_("Operation failed with status $0"), event.status) );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		override protected function registerToFileReferenceEvents (fileReference : FileReference) : void
		{
			super.registerToFileReferenceEvents( fileReference );
			fileReference.addEventListener( IOErrorEvent.IO_ERROR, ioError );			fileReference.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityError );			fileReference.addEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatus );
			fileReference.addEventListener( Event.COMPLETE, complete );
		}

		override protected function unregisterFromFileReferenceEvents (fileReference : FileReference) : void
		{
			super.unregisterFromFileReferenceEvents( fileReference );
			fileReference.removeEventListener( IOErrorEvent.IO_ERROR, ioError );
			fileReference.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityError );
			fileReference.removeEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatus );
			fileReference.removeEventListener( Event.COMPLETE, complete );
		}
	}
}

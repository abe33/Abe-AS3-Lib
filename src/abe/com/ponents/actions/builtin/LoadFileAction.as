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
				else fireCommandFailed( _$(_("Le fichier choisi excède la taille limite, $0 Mo au lieu de $1 Mo maximum."),
										Math.floor( size / ( 1024*1024 ) ), Math.floor( _preventLargeFile / ( 1024*1024 ) ) ) );

			}
			else
		}
		protected function complete (event : Event) : void
		{
			fireCommandEnd();
		}
		protected function ioError (event : IOErrorEvent) : void
		{
			fireCommandFailed( event.text );
			unregisterFromFileReferenceEvents(_fileReference);
		}
		protected function securityError ( event : SecurityErrorEvent ) : void
		{
			fireCommandFailed( event.text );
			unregisterFromFileReferenceEvents(_fileReference);
		}
		protected function httpStatus ( event : HTTPStatusEvent ) : void
		{
			/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
				Log.error( "Operation failed with status " + event.status );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		override protected function registerToFileReferenceEvents (fileReference : FileReference) : void
		{
			super.registerToFileReferenceEvents( fileReference );
			fileReference.addEventListener( IOErrorEvent.IO_ERROR, ioError );
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
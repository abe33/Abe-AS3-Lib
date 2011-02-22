package abe.com.ponents.actions.builtin
{
	import abe.com.mon.utils.KeyStroke;
	import abe.com.patibility.lang._;
	import abe.com.ponents.skinning.icons.Icon;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileFilter;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	/**
	 * @author Cédric Néhémie
	 */
	public class OpenBitmapAction extends LoadFileAction
	{
		protected var _loader : Loader;
		protected var _bitmap : BitmapData;
		protected var _integrityTimeout : int;

		public function OpenBitmapAction ( name : String = "", icon : Icon = null, filters : Array = null, longDescription : String = null, accelerator : KeyStroke = null, preventLargeFile : Number = -1 )
		{
			super ( name,
					icon,
					filters ? filters : [new FileFilter(_("Image Files(*.jpg,*.gif,*.jpeg, *.png)"), "*.jpg;*.jpeg;*.png;*.gif")],
					longDescription,
					accelerator,
					preventLargeFile );

			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, error );
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete );
		}

		override public function get data () : *
		{
			return _bitmap;
		}

		override protected function complete ( event : Event ) : void
		{
			var data : * = event.target.data;
			_loader.loadBytes(data);
			_integrityTimeout = setTimeout( checkIntegrity, 500 );
		}
		protected function checkIntegrity () : void
		{
			if( !_loader.content || !(_loader.content as Bitmap).bitmapData )
				fireCommandFailed(_("Le Bitmap est trop grand pour être affiché, la taille maximum est de 16 Millions de pixels sans qu'aucun côté ne fasse plus de 8191 pixels."));
		}

		protected function loaderComplete ( event : Event ) : void
		{
			clearTimeout ( _integrityTimeout );
			_bitmap = ( _loader.content as Bitmap ).bitmapData;
			fireCommandEnd();
		}

		protected function error ( event : IOErrorEvent ) : void
		{
			fireCommandFailed( event.text );
		}
	}
}

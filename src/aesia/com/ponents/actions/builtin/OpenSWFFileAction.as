package aesia.com.ponents.actions.builtin
{
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.ponents.skinning.icons.Icon;

	import com.kode80.swf.SWF;

	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	/**
	 * @author Cédric Néhémie
	 */
	public class OpenSWFFileAction extends LoadFileAction
	{
		protected var _bytes : ByteArray;
		protected var _swf : SWF;
		
		public function OpenSWFFileAction ( name : String,
											icon : Icon = null,
											longDescription : String = null,
											accelerator : KeyStroke = null )
		{
			super( name, icon, [new FileFilter("SWF file (*.swf)", "*.swf")], longDescription, accelerator );
		}
	
		override protected function complete ( event : Event ) : void
		{
			_bytes = _fileReference.data;
			_swf = new SWF();
			_swf.readFrom(_bytes);
	
			super.complete ( event );
		}

		public function get bytes () : ByteArray { return _bytes; }
		public function get swf () : SWF { return _swf; }
	}
}

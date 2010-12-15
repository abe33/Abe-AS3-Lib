package aesia.com.ponents.tools 
{
	import aesia.com.ponents.tools.canvas.Tool;
	import aesia.com.ponents.tools.canvas.core.AbstractTool;
	import aesia.com.ponents.skinning.cursors.Cursor;

	public class FreeTransform extends AbstractTool implements Tool 
	{
		protected var selection : ObjectSelection;

		public function FreeTransform ( selection : ObjectSelection, cursor : Cursor = null)
		{
			super( cursor );
			this.selection = selection;
		}
	}
}

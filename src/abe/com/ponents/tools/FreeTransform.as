package abe.com.ponents.tools 
{
    import abe.com.ponents.skinning.cursors.Cursor;
    import abe.com.ponents.tools.canvas.Tool;
    import abe.com.ponents.tools.canvas.core.AbstractTool;
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

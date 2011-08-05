package abe.com.ponents.nodes.renderers.nodes
{
	import abe.com.ponents.text.Label;

	public class NoteRenderer extends DefaultNodeRenderer
	{
		public function NoteRenderer()
		{
			super();
		}
		override public function render(userObject:*):*
		{
			var l : Label = super.render(userObject);
			l.wordWrap = true;
			
			return l;
		}
	}
}
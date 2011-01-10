package aesia.com.ponents.nodes.renderers.nodes 
{
	import aesia.com.ponents.nodes.core.CanvasNode;
	import aesia.com.ponents.text.Label;
	/**
	 * @author cedric
	 */
	public class DefaultNodeRenderer implements NodeRenderer 
	{
		static public const LABEL_NAME : String = "NodeLabel";
		
		public function render (userObject : *) : *
		{
			var l : Label = new Label( String ( userObject ) );
			l.name = LABEL_NAME;
			return l;
		}
		public function update (c : CanvasNode, userObject : *) : void
		{
			( c.getComponentByName(LABEL_NAME) as Label ).value = String( userObject );
		}
	}
}

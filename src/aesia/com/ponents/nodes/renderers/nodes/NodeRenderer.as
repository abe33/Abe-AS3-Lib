package aesia.com.ponents.nodes.renderers.nodes 
{
	import aesia.com.ponents.nodes.core.CanvasNode;
	/**
	 * @author cedric
	 */
	public interface NodeRenderer 
	{
		function render( userObject : * ) : *; 		function update( c : CanvasNode, userObject : * ) : void; 
	}
}

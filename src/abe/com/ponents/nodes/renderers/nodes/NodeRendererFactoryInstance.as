package abe.com.ponents.nodes.renderers.nodes
{
	/**
	 * @author cedric
	 */
	public const NodeRendererFactoryInstance : NodeRendererFactory = new NodeRendererFactory({
			'CanvasNote':new NoteRenderer()
	});
}

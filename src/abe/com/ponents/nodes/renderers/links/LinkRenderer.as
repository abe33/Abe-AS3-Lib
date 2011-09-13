package abe.com.ponents.nodes.renderers.links 
{
    import abe.com.ponents.nodes.core.NodeLink;

    import flash.display.Graphics;
    import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public interface LinkRenderer 
	{
		function render( link : NodeLink, a : Point, b : Point, g : Graphics ) : void;
	}
}

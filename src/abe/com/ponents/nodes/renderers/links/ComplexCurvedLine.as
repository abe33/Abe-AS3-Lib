package abe.com.ponents.nodes.renderers.links 
{
	import abe.com.ponents.nodes.core.NodeLink;

	import flash.display.Graphics;
	import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class ComplexCurvedLine implements LinkRenderer 
	{
		protected var _startDecoration : ComplexRendererElement;
		protected var _endDecoration : ComplexRendererElement;
		protected var _lineRenderer : LinkRenderer;
	
		public function ComplexCurvedLine ( line : LinkRenderer, 
										  	startDeco : ComplexRendererElement = null, 
										  	endDeco : ComplexRendererElement = null ) 
		{
			this._startDecoration = startDeco;
			this._endDecoration = endDeco;
			this._lineRenderer = line;
		}
		
		public function render (link : NodeLink, a : Point, b : Point, g : Graphics) : void
		{
		}
	}
}

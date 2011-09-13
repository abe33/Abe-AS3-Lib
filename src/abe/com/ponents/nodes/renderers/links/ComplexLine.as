package abe.com.ponents.nodes.renderers.links 
{
    import abe.com.ponents.nodes.core.NodeLink;
    import abe.com.ponents.nodes.core.RelationshipDirection;

    import flash.display.Graphics;
    import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class ComplexLine implements LinkRenderer 
	{
		protected var _startDecoration : ComplexRendererElement;		protected var _endDecoration : ComplexRendererElement;
		protected var _lineRenderer : LinkRenderer;
		

		public function ComplexLine ( line : LinkRenderer, 
										  startDeco : ComplexRendererElement = null, 
										  endDeco : ComplexRendererElement = null ) 
		{
			this._startDecoration = startDeco;
			this._endDecoration = endDeco;
			this._lineRenderer = line;
		}
		
		public function render (link : NodeLink, a : Point, b : Point, g : Graphics) : void
		{
			var d : Point = b.subtract(a);
			var start : Point;			var end : Point;
			var o : Point;
			switch( link.relationshipDirection )
			{
				case RelationshipDirection.A_TO_B : 
					if( _startDecoration )
					{
						o = d.clone();
						o.normalize( _startDecoration.length );
						start = a.add( o );
					}
					else
						start = a;
					
					if( _endDecoration )
					{
						o = d.clone();
						o.normalize( _endDecoration.length );
						end = b.subtract( o );
					}
					else
						end = b;
						
					_lineRenderer.render(link, start, end, g);
					
					if( _startDecoration )
						_startDecoration.render(link, b, a, g);
						
					if( _endDecoration )
						_endDecoration.render(link, a, b, g);
					break;
				case RelationshipDirection.B_TO_A : 
					if( _startDecoration )
					{
						o = d.clone();
						o.normalize( _startDecoration.length );
						start = b.subtract( o );
					}
					else
						start = b;
					
					if( _endDecoration )
					{
						o = d.clone();
						o.normalize( _endDecoration.length );
						end = a.add( o );
					}
					else
						end = a;
						
					_lineRenderer.render(link, start, end, g);
					
					if( _startDecoration )
						_startDecoration.render(link, a, b, g);
						
					if( _endDecoration )
						_endDecoration.render(link, b, a, g);
					break;
				case RelationshipDirection.BOTH : 
					if( _endDecoration )
					{
						o = d.clone();
						o.normalize( _endDecoration.length );
						start = a.add( o );
						end = b.subtract( o );
					}
					else
					{
						start = a;
						end = b;
					}
						
					_lineRenderer.render(link, start, end, g);
					
					if( _endDecoration )
					{
						_endDecoration.render(link, a, b, g);						_endDecoration.render(link, b, a, g);
					}
					break;
				case RelationshipDirection.NONE : 
				default : 
					_lineRenderer.render(link, a, b, g);
					break;
			}
		}
	}
}

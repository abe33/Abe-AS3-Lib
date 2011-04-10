package abe.com.ponents.nodes.renderers.links
{
	import abe.com.mon.colors.Color;
	
	/**
	 * @author cedric
	 */
	public const LinkRendererFactoryInstance : LinkRendererFactory = new LinkRendererFactory( {
								 "undefined"	:new ComplexLine( new SimpleLine(), null,			   new ArrowLine() ),
								 "aggregate"	:new ComplexLine( new SimpleLine(), new DiamondFill(1, null, Color.White ) ),
								 "compose"		:new ComplexLine( new SimpleLine(), new DiamondFill() ),
								 "generalize"	:new ComplexLine( new SimpleLine(), null, 			   new TriangleFill()),
								 "implements"	:new ComplexLine( new DashedLine(), null, 			   new TriangleFill( 1, null, Color.White ))
							   } );
}

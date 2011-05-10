package abe.com.prehension.tools
{
	import abe.com.ponents.ressources.ClassCollection;
	import abe.com.ponents.skinning.decorations.*;

	/**
	 * The <code>CoreDecoration</code> purpopse is to embed all the core decorations the <code>StyleEditor</code> 
	 * can use by default.
	 * 
	 * @author Cédric Néhemie
	 */
	public class CoreDecorations extends ClassCollection 
	{		
		public function CoreDecorations () 
		{
			collectionName = "Core Decorations";
			collectionType = "decorations";
			classes = [
						 AdvancedSlicedBitmapFill,		 ArrowSideBorders,				 ArrowSideFill,
						 ArrowSideGradientBorders,		 ArrowSideGradientFill,			 BitmapDecoration,
						 BorderedGradientFill,			 EmptyFill,						 FieldSetBorders,
						 GradientBorders,				 GradientFill,					 GraphMonitorBorder,
						 LineBorders,					 MacroDecoration,				 NoDecoration,
						 PushButtonFill,				 SeparatorDecoration,			 SimpleBorders,
						 SimpleEllipsisBorders,			 SimpleEllipsisFill,			 SimpleFill,
						 SlicedBitmapFill,				 StripFill,						 HSliderTrackFill,
						 VSliderTrackFill
					 ];
		}
	}
}

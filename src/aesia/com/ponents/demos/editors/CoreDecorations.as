package aesia.com.ponents.demos.editors 
{
	import aesia.com.ponents.factory.ressources.ClassCollection;
	import aesia.com.ponents.skinning.decorations.AdvancedSlicedBitmapFill;
	import aesia.com.ponents.skinning.decorations.ArrowSideBorders;
	import aesia.com.ponents.skinning.decorations.ArrowSideFill;
	import aesia.com.ponents.skinning.decorations.ArrowSideGradientBorders;
	import aesia.com.ponents.skinning.decorations.ArrowSideGradientFill;
	import aesia.com.ponents.skinning.decorations.BitmapDecoration;
	import aesia.com.ponents.skinning.decorations.BorderedGradientFill;
	import aesia.com.ponents.skinning.decorations.EmptyFill;
	import aesia.com.ponents.skinning.decorations.FieldSetBorders;
	import aesia.com.ponents.skinning.decorations.GradientBorders;
	import aesia.com.ponents.skinning.decorations.GradientFill;
	import aesia.com.ponents.skinning.decorations.GraphMonitorBorder;
	import aesia.com.ponents.skinning.decorations.LineBorders;
	import aesia.com.ponents.skinning.decorations.MacroDecoration;
	import aesia.com.ponents.skinning.decorations.NoDecoration;
	import aesia.com.ponents.skinning.decorations.PushButtonFill;
	import aesia.com.ponents.skinning.decorations.SeparatorDecoration;
	import aesia.com.ponents.skinning.decorations.SimpleBorders;
	import aesia.com.ponents.skinning.decorations.SimpleEllipsisBorders;
	import aesia.com.ponents.skinning.decorations.SimpleEllipsisFill;
	import aesia.com.ponents.skinning.decorations.SimpleFill;
	import aesia.com.ponents.skinning.decorations.SlicedBitmapFill;
	import aesia.com.ponents.skinning.decorations.StripFill;
	import aesia.com.ponents.sliders.HSliderTrackFill;
	import aesia.com.ponents.sliders.VSliderTrackFill;
	
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
			collectionName = "Core Decorations";			collectionType = "decorations";
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

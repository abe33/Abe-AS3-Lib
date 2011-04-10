package abe.com.ponents.demos.editors 
{
	import abe.com.ponents.ressources.ClassCollection;
	import abe.com.ponents.skinning.decorations.AdvancedSlicedBitmapFill;
	import abe.com.ponents.skinning.decorations.ArrowSideBorders;
	import abe.com.ponents.skinning.decorations.ArrowSideFill;
	import abe.com.ponents.skinning.decorations.ArrowSideGradientBorders;
	import abe.com.ponents.skinning.decorations.ArrowSideGradientFill;
	import abe.com.ponents.skinning.decorations.BitmapDecoration;
	import abe.com.ponents.skinning.decorations.BorderedGradientFill;
	import abe.com.ponents.skinning.decorations.EmptyFill;
	import abe.com.ponents.skinning.decorations.FieldSetBorders;
	import abe.com.ponents.skinning.decorations.GradientBorders;
	import abe.com.ponents.skinning.decorations.GradientFill;
	import abe.com.ponents.skinning.decorations.GraphMonitorBorder;
	import abe.com.ponents.skinning.decorations.HSliderTrackFill;
	import abe.com.ponents.skinning.decorations.LineBorders;
	import abe.com.ponents.skinning.decorations.MacroDecoration;
	import abe.com.ponents.skinning.decorations.NoDecoration;
	import abe.com.ponents.skinning.decorations.PushButtonFill;
	import abe.com.ponents.skinning.decorations.SeparatorDecoration;
	import abe.com.ponents.skinning.decorations.SimpleBorders;
	import abe.com.ponents.skinning.decorations.SimpleEllipsisBorders;
	import abe.com.ponents.skinning.decorations.SimpleEllipsisFill;
	import abe.com.ponents.skinning.decorations.SimpleFill;
	import abe.com.ponents.skinning.decorations.SlicedBitmapFill;
	import abe.com.ponents.skinning.decorations.StripFill;
	import abe.com.ponents.skinning.decorations.VSliderTrackFill;
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

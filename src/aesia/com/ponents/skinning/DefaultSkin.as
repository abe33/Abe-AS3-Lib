package aesia.com.ponents.skinning 
{
	import flash.filters.DropShadowFilter;
	import flash.filters.BevelFilter;
	import aesia.com.ponents.skinning.decorations.GradientBorders;
	import aesia.com.ponents.skinning.decorations.GradientFill;
	import aesia.com.mon.utils.Gradient;
	import aesia.com.mon.geom.ColorMatrix;
	import aesia.com.mon.utils.Color;
	import aesia.com.ponents.skinning.decorations.EmptyFill;
	import aesia.com.ponents.skinning.decorations.NoDecoration;

	import flash.filters.ColorMatrixFilter;

	[Skin(define="EmptyComponent",
		  inherit="DefaultComponent",

		  state__all__background="new deco::EmptyFill()",
		  state__all__foreground="new deco::NoDecoration()"
	)]
	[Skin(define="NoDecorationComponent",
		  inherit="DefaultComponent",

		  state__all__background="new deco::NoDecoration()",
		  state__all__foreground="new deco::NoDecoration()"
	)]
	[Skin(define="Text",
		  inherit="DefaultComponent",
		  
		  state__all__background="new deco::SimpleFill( skin.textBackgroundColor )",

		  custom_mispellWordsColor="skin.textMispellWordsColor",
		  custom_embedFonts="false"
	)]
	[Skin(define="DefaultGradientComponent",
		  inherit="DefaultComponent",
		  preview="aesia.com.ponents.core::AbstractComponent.defaultPreview",

	      //state__all__innerFilters="skin.createGradientInnerFilters()",	      state__all__outerFilters="skin.createGradientOuterFilters()",	      //state__disabled__innerFilters="skin.createGradientInnerFilters().concat(skin.createDisabledInnerFilters())",
		  state__0_4__background="skin.NormalGradient",
		  state__1_5__background="skin.NormalGradient",
		  state__2_6__background="skin.OverGradient",
		  state__3_7__background="skin.NormalGradient",
		  state__8_12__background="skin.SelectedGradient",
		  state__9_13__background="new deco::SimpleFill(skin.disabledSelectedBackgroundColor)",
		  state__10_14__background="skin.OverSelectedGradient",
		  state__11_15__background="skin.PressedSelectedGradient",

		  state__0_3__foreground="new deco::SimpleBorders(skin.borderColor)",
		  state__2__foreground="new deco::SimpleBorders(skin.overBorderColor)",
		  state__focus_focusandselected__foreground="new deco::SimpleBorders(skin.focusBorderColor)",
		  state__selected__foreground="new deco::SimpleBorders(skin.selectedBorderColor)",
		  state__disabled__foreground="new deco::SimpleBorders(skin.disabledBorderColor)",
		  state_disabled_selected__foreground="new deco::SimpleBorders(skin.disabledSelectedBorderColor)"
	)]
	[Skin(define="DefaultComponent",
		  inherit="",
		  preview="aesia.com.ponents.core::AbstractComponent.defaultPreview",

		  state__all__insets="new cutils::Insets()",
		  state__all__borders="new cutils::Borders()",
		  state__all__corners="new cutils::Corners()",
		  state__all__format="new txt::TextFormat('Verdana',11,0,false,false,false)",

		  state__all__textColor="skin.textColor",
		  state__disabled__textColor="skin.disabledTextColor",
		  state__disabled__innerFilters="skin.createDisabledInnerFilters()",

		  state__0_4__background="new deco::SimpleFill(skin.backgroundColor)",
		  state__1_5__background="new deco::SimpleFill(skin.disabledBackgroundColor)",		  state__2_6__background="new deco::SimpleFill(skin.overBackgroundColor)",		  state__3_7__background="new deco::SimpleFill(skin.pressedBackgroundColor)",
		  state__8_12__background="new deco::SimpleFill(skin.selectedBackgroundColor)",
		  state__9_13__background="new deco::SimpleFill(skin.disabledSelectedBackgroundColor)",
		  state__10_14__background="new deco::SimpleFill(skin.overSelectedBackgroundColor)",
		  state__11_15__background="new deco::SimpleFill(skin.pressedSelectedBackgroundColor)",

		  state__0_3__foreground="new deco::SimpleBorders(skin.borderColor)",
		  state__2__foreground="new deco::SimpleBorders(skin.overBorderColor)",
		  state__focus_focusandselected__foreground="new deco::SimpleBorders(skin.focusBorderColor)",
		  state__selected__foreground="new deco::SimpleBorders(skin.selectedBorderColor)",
		  state__disabled__foreground="new deco::SimpleBorders(skin.disabledBorderColor)",
		  state_disabled_selected__foreground="new deco::SimpleBorders(skin.disabledSelectedBorderColor)"
	)]
	/**
	 * @author cedric
	 */
	dynamic public class DefaultSkin
	{
		static public const DEPENDENCIES : Array = [ GradientFill, GradientBorders ];
		
		static public const PastelYellow : Color = new Color("#fff7f5ef");		static public const OverYellow : Color = new Color("#ffdde0d9");
		static public const FocusGreen : Color = new Color("#ff9eb923");		static public const SelectionLightCyan : Color = new Color("#ffb7d8cc");		static public const SelectionBlue : Color = new Color("#ff8abac8");		static public const SelectionGreen : Color = new Color("#ffd7e2c0");		static public const SelectionYellow : Color = new Color("#ffeeebcb");
		static public const BorderBlue : Color = new Color("#ff8ea5ac");		static public const ListColor : Color = new Color("#ffffffff");		static public const RulerBlue : Color = new Color("#ffa9bfc6");		static public const DarkBlue : Color = new Color("#ff3a545c");

		/*
		 * Constant Decoration
		 */
		static public const noDecoration:NoDecoration = new NoDecoration();
		static public const emptyDecoration:EmptyFill = new EmptyFill();
		
		static public const GradientBrightness : uint = 15;		static public const GradientRatios : Array = [ .1,.5,.9];
		
		static public const NormalGradient : GradientFill = new GradientFill( 
															new Gradient( 
															[ 
																PastelYellow.brighterClone(GradientBrightness), 
																PastelYellow,
																PastelYellow.brighterClone(GradientBrightness) 
															], 
															GradientRatios ), 90 );
		
		static public const OverGradient : GradientFill = new GradientFill( 
															new Gradient( 
															[ 
																OverYellow.brighterClone(GradientBrightness), 
																OverYellow,
																OverYellow.brighterClone(GradientBrightness) 
															], 
															GradientRatios ), 90 );
		static public const SelectedGradient : GradientFill = new GradientFill( 
															new Gradient( 
															[ 
																SelectionLightCyan.brighterClone(GradientBrightness), 
																SelectionLightCyan,
																SelectionLightCyan.brighterClone(GradientBrightness) 
															], 
															GradientRatios ), 90 );
		static public const DisabledSelectedGradient : GradientFill = new GradientFill( 
															new Gradient( 
															[ 
																SelectionLightCyan.brighterClone(GradientBrightness).alphaClone(0x66), 
																SelectionLightCyan.alphaClone(0x66),
																SelectionLightCyan.brighterClone(GradientBrightness).alphaClone(0x66) 
															], 
															GradientRatios ), 90 );
		static public const OverSelectedGradient : GradientFill = new GradientFill( 
															new Gradient( 
															[ 
																SelectionGreen.brighterClone(GradientBrightness), 
																SelectionGreen,
																SelectionGreen.brighterClone(GradientBrightness) 
															], 
															GradientRatios ), 90 );
		static public const PressedSelectedGradient : GradientFill = new GradientFill( 
															new Gradient( 
															[ 
																SelectionYellow.brighterClone(GradientBrightness), 
																SelectionYellow,
																SelectionYellow.brighterClone(GradientBrightness) 
															], 
															GradientRatios ), 90 );
		
		/*
		 * DnD Colors
		 */
		static public var dropZoneColor : Color = Color.Black;
		
		/*
		 * CheckBox Colors
		 */
		static public var checkBoxBackgroundColor : Color = Color.White;
		static public var checkBoxBorderColor : Color = BorderBlue;
		static public var checkBoxTickColor : Color = DarkBlue;
		/*
		 * Text Colors
		 */
		static public var textColor : Color = Color.Black;
		static public var textDisabledColor : Color = Color.Gray;
		static public var textBackgroundColor : Color = Color.White;
		static public var textMispellWordsColor : Color = Color.Red;
		
		/*
		 * Ruler Colors
		 */
		static public var rulerTextColor : Color = Color.White;
		static public var rulerBackgroundColor : Color = RulerBlue;
		/*
		 * Background Colors
		 */
		static public var backgroundColor : Color = PastelYellow;		static public var focusBackgroundColor : Color = PastelYellow;		static public var selectedBackgroundColor : Color = SelectionLightCyan;		static public var focusSelectedBackgroundColor : Color = SelectionLightCyan;
				static public var overBackgroundColor : Color = OverYellow;		static public var overFocusBackgroundColor : Color = OverYellow;		static public var overSelectedBackgroundColor : Color = SelectionGreen;		static public var overFocusSelectedBackgroundColor : Color = SelectionGreen;
		
		static public var pressedBackgroundColor : Color = PastelYellow;
		static public var pressedFocusBackgroundColor : Color = PastelYellow;
		static public var pressedSelectedBackgroundColor : Color = SelectionYellow;
		static public var pressedFocusSelectedBackgroundColor : Color = SelectionYellow;
		
		static public var disabledBackgroundColor : Color = PastelYellow.alphaClone(0x66);
		static public var disabledSelectedBackgroundColor : Color = SelectionLightCyan.alphaClone(0x66);
		
		static public var containerBackgroundColor : Color = Color.White;
		static public var menuSelectedBackgroundColor : Color = SelectionLightCyan;
		/*
		 * Border Colors
		 */
		static public var borderColor : Color = BorderBlue;
		static public var focusBorderColor : Color = FocusGreen;
		static public var selectedBorderColor : Color = SelectionBlue;
		static public var focusSelectedBorderColor : Color = FocusGreen;
		
		static public var overBorderColor : Color = BorderBlue;
		static public var overFocusBorderColor : Color = FocusGreen;
		static public var overSelectedBorderColor : Color = SelectionBlue;
		static public var overFocusSelectedBorderColor : Color = FocusGreen;
		
		static public var pressedBorderColor : Color = BorderBlue;
		static public var pressedFocusBorderColor : Color = FocusGreen;
		static public var pressedSelectedBorderColor : Color = SelectionBlue;
		static public var pressedFocusSelectedBorderColor : Color = FocusGreen;
		
		static public var disabledBorderColor : Color = BorderBlue.alphaClone(0x66);
		static public var disabledSelectedBorderColor : Color = SelectionBlue.alphaClone(0x66);
		
		static public var lightColor : Color = Color.White;
		static public var shadowColor : Color = BorderBlue;
		
		/*
		 * List Colors
		 */
		static public var listBackgroundColor : Color = ListColor;
		static public var listOverBackgroundColor : Color = OverYellow.alphaClone(0x66);		static public var listPressedBackgroundColor : Color = OverYellow.alphaClone(0x66);		static public var listDisabledBackgroundColor : Color = ListColor;
		
		static public var listSelectedBackgroundColor : Color = SelectionLightCyan.alphaClone(0xbb);
		static public var listOverSelectedBackgroundColor : Color = SelectionGreen;		static public var listPressedSelectedBackgroundColor : Color = SelectionYellow;		static public var listDisabledSelectedBackgroundColor : Color = SelectionYellow.alphaClone(0x66);
	
		static public var treeIndentLineColor : Color = BorderBlue;
		/*
		 * ProgressBar Colors
		 */
		static public var progressBackgroundColor : Color = RulerBlue.brighterClone(20);
		static public var progressBackgroundColor1 : Color = progressBackgroundColor;		static public var progressBackgroundColor2 : Color = progressBackgroundColor;
		
		static public var progressDisabledBackgroundColor1 : Color = progressBackgroundColor.alphaClone(0x66);
		static public var progressDisabledBackgroundColor2 : Color = progressBackgroundColor.alphaClone(0x66);
		
		/*
		 * Slider Colors
		 */
		static public var sliderTickColor : Color = BorderBlue;
		static public var sliderTrackBackgroundColor1 : Color = RulerBlue;		static public var sliderTrackBackgroundColor2 : Color = BorderBlue;
		
		static public var sliderTrackDisabledBackgroundColor1 : Color = RulerBlue.alphaClone(0x66);
		static public var sliderTrackDisabledBackgroundColor2 : Color = BorderBlue.alphaClone(0x66);
		
		/*
		 * Tooltip Colors
		 */
		static public var tooltipBackgroundColor : Color = new Color(0xfff3cda7);
		static public var tooltipBorderColor : Color = new Color(0xffdca670);
		static public var tooltipTextColor : Color = Color.Black;

		/**
		 * Renvoie un tableau contenant les filtres de transformation par défaut pour
		 * les composants désactivés.
		 * <p>
		 * Le tableau contient un objet <code>ColorMatrixFilter</code> enlevant toute saturation
		 * au composant et réduisant l'opacité de <code>100</code>.
		 * </p>
		 * @return	un tableau contenant les filtres de transformation par défaut pour
		 * 			les composants désactivés
		 */
		static public function createDisabledInnerFilters () : Array
		{
			var m : ColorMatrix = new ColorMatrix();
			m.adjustSaturation( -100 );
			m.adjustAlpha( -100 );
			return [ new ColorMatrixFilter( m ) ];
		}
		static public function createGradientInnerFilters () : Array
		{
			return [];
			return [ new BevelFilter(1, 215, lightColor.hexa, lightColor.alpha/300, shadowColor.hexa, shadowColor.alpha/400, 0, 0, 1, 1, "outer" ) ];
		}
		static public function createGradientOuterFilters () : Array
		{
			return [ new DropShadowFilter( 0, 45, shadowColor.hexa, .7, 2, 2, 1, 3 ) ];
		}
	}
}

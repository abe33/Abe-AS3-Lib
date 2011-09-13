package abe.com.ponents.builder.styles
{
    import abe.com.patibility.lang._$;

    import flash.filters.BevelFilter;
    import flash.filters.BlurFilter;
    import flash.filters.ColorMatrixFilter;
    import flash.filters.ConvolutionFilter;
    import flash.filters.DropShadowFilter;
    import flash.filters.GlowFilter;
    import flash.filters.GradientBevelFilter;
    import flash.filters.GradientGlowFilter;
    import flash.geom.Point;
    import flash.text.TextFormat;
    import flash.utils.getQualifiedClassName;


	/**
	 * @author cedric
	 */
	public function initializePrototypeSerializableSupport () : void
	{
		Point.prototype.toSource = function() : String { return this.toReflectionSource().replace("::","."); };
		Point.prototype.toReflectionSource = function() : String
		{
			return "new " + getQualifiedClassName(this) + _$("($0,$1)", this.x, this.y );
		};
/*-----------------------------------------------------------------------------*
 * 	TEXTFORMAT SERIALIZATION
 *-----------------------------------------------------------------------------*/
 		TextFormat.prototype.toSource = function() : String { return this.toReflectionSource().replace("::","."); };
		TextFormat.prototype.toReflectionSource = function() : String
		{
			return "new " + getQualifiedClassName(this) + _$("('$0',$1,$2,$3,$4,$5)",   this.font, 
															 							this.size, 
																						this.color, 
																						this.bold, 
																						this.italic, 
																						this.underline );
		};
/*-----------------------------------------------------------------------------*
 * 	FILTERS SERIALIZATION
 *-----------------------------------------------------------------------------*/
		BlurFilter.prototype.toSource = function() : String { return this.toReflectionSource().replace("::","."); };
		BlurFilter.prototype.toReflectionSource = function() : String
		{
			return "new " + getQualifiedClassName(this) + _$("($0,$1,$2)", this.blurX, 
																		   this.blurY,
																		   this.quality 
																		   );
		};
		
		GlowFilter.prototype.toSource = function() : String { return this.toReflectionSource().replace("::","."); };
		GlowFilter.prototype.toReflectionSource = function() : String
		{
			return "new " + getQualifiedClassName(this) + _$("($0,$1,$2,$3,$4,$5,$6,$7)", 
																		   this.color,
																		   this.alpha,
																		   this.blurX, 
																		   this.blurY,
																		   this.strength,
																		   this.quality,
																		   this.inner,
																		   this.knockout
																		   );
		};
		
		DropShadowFilter.prototype.toSource = function() : String { return this.toReflectionSource().replace("::","."); };
		DropShadowFilter.prototype.toReflectionSource = function() : String
		{
			return "new " + getQualifiedClassName(this) + _$("($0,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10)",
																		   this.distance,
																		   this.angle, 
																		   this.color,
																		   this.alpha,
																		   this.blurX, 
																		   this.blurY,
																		   this.strength,
																		   this.quality,
																		   this.inner,
																		   this.knockout,
																		   this.hideObject
																		   );
		};
		
		BevelFilter.prototype.toSource = function() : String { return this.toReflectionSource().replace("::","."); };
		BevelFilter.prototype.toReflectionSource = function() : String
		{
			return "new " + getQualifiedClassName(this) + _$("($0,$1,$2,$3,$4,$5,$6,$7,$8,$9,'$10',$11)",
																		   this.distance,
																		   this.angle, 
																		   this.highlightColor,
																		   this.highlightAlpha,
																		   this.shadowColor,
																		   this.shadowAlpha,
																		   this.blurX, 
																		   this.blurY,
																		   this.strength,
																		   this.quality,
																		   this.type,
																		   this.knockout
																		   );
		};
		
		ColorMatrixFilter.prototype.toSource = function() : String { return this.toReflectionSource().replace("::","."); };
		ColorMatrixFilter.prototype.toReflectionSource = function() : String
		{
			return "new " + getQualifiedClassName(this) + _$("([$0])", this.matrix.join(",") );
		};
		
		ConvolutionFilter.prototype.toSource = function() : String { return this.toReflectionSource().replace("::","."); };
		ConvolutionFilter.prototype.toReflectionSource = function() : String
		{
			return "new " + getQualifiedClassName(this) + _$("($0,$1,[$2],$3,$4,$5,$6,$7,$8)", 
																			this.matrixX,
																			this.matrixY,
																			this.matrix.join(","),
																			this.divisor,
																			this.bias,
																			this.preserveAlpha,
																			this.clamp,
																			this.color,
																			this.alpha
																			);
		};
		
		GradientGlowFilter.prototype.toSource = function() : String { return this.toReflectionSource().replace("::","."); };
		GradientGlowFilter.prototype.toReflectionSource = function() : String
		{
			return "new " + getQualifiedClassName(this) + _$("($0,$1,[$2],[$3],[$4],$5,$6,$7,$8,$9,$10)", 
																		   this.distance,
																		   this.angle, 
																		   this.colors,
																		   this.alphas,																		   this.ratios,
																		   this.blurX, 
																		   this.blurY,
																		   this.strength,
																		   this.quality,
																		   this.type,
																		   this.knockout
																		   );
		};
		GradientBevelFilter.prototype.toSource = function() : String { return this.toReflectionSource().replace("::","."); };
		GradientBevelFilter.prototype.toReflectionSource = function() : String
		{
			return "new " + getQualifiedClassName(this) + _$("($0,$1,[$2],[$3],[$4],$5,$6,$7,$8,$9,$10)", 
																		   this.distance,
																		   this.angle, 
																		   this.colors,
																		   this.alphas,
																		   this.ratios,
																		   this.blurX, 
																		   this.blurY,
																		   this.strength,
																		   this.quality,
																		   this.type,
																		   this.knockout
																		   );
		};
		
	}
}

package abe.com.ponents.swf.timeline.frames
{
	import abe.com.ponents.utils.Borders;
	import abe.com.mon.utils.Reflection;
	import abe.com.mon.utils.MathUtils;

	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	[Skinable(skin="MotionTweenKeyFrame")]
	[Skin(define="MotionTweenKeyFrame",
			  inherit="KeyFrame",
			  state__all__background="new abe.com.ponents.skinning.decorations::SimpleFill(color(0x88ccccff))"
	)]
	/**
	 * @author Cédric Néhémie
	 */
	public class MotionTweenKeyFrame extends KeyFrame
	{
		public function MotionTweenKeyFrame ( frame : uint, frameName : String = null, script : String = null )
		{
			super ( frame, frameName, script );
		}


		override public function repaint () : void
		{
			if( nextFrame && Reflection.getClass ( this ) == Reflection.getClass ( nextFrame ) )
				style.borders = new Borders(0, 0, 0, 1);			else
				style.borders = new Borders(0, 0, 1, 1);

			super.repaint ();
		}

		override protected function drawFrameExtension () : void
		{
			var h : Number = height;			var w : Number = width;
			var g : Graphics = _childrenContainer.graphics;

			if( nextFrameIsEmpty )
			{
				var m : Matrix = new Matrix ();
				m.createGradientBox ( 6, 6, MathUtils.deg2rad ( 0 ), frameWidth, 0 );
				g.lineStyle();
				g.beginGradientFill( GradientType.LINEAR,
									[0x000000,0x000000,0x000000,0x000000],
									[1,1,0,0],
									[0,127,128,255],
									m,
									SpreadMethod.REPEAT );
				g.drawRect ( frameWidth, h - 5, w - frameWidth, 1 );
				g.endFill();
			}
			else
			{
				/*
				g.lineStyle ( 0, Color.Black.hexa, 1, true );
				g.moveTo ( frameWidth, h - 7 );
				g.lineTo ( frameWidth + 3, h - 5 );
				g.lineTo ( frameWidth, h - 3 );

				g.moveTo ( w - 6, h - 7 );
				g.lineTo ( w - 3, h - 5 );
				g.lineTo ( w - 6, h - 3 );
				*/

				g.lineStyle();
				g.beginFill(0);
				g.drawRect( frameWidth + 2, h - 5, w - frameWidth - 4, 1 );

				g.drawRect( frameWidth, h - 7, 1, 1 );				g.drawRect( frameWidth + 1, h - 6, 1, 1 );
				g.drawRect( frameWidth + 1, h - 4, 1, 1 );				g.drawRect( frameWidth, h - 3, 1, 1 );

				g.drawRect( w-5, h - 7, 1, 1 );
				g.drawRect( w-4, h - 6, 1, 1 );
				g.drawRect( w-4, h - 4, 1, 1 );
				g.drawRect( w-5, h - 3, 1, 1 );

				g.endFill();
			}
		}

	}
}

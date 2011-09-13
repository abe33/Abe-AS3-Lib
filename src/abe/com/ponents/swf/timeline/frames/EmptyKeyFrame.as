package abe.com.ponents.swf.timeline.frames
{
    import abe.com.mon.colors.Color;

	[Skinable(skin="EmptyKeyFrame")]
	[Skin(define="EmptyKeyFrame",
			  inherit="KeyFrame",
			  state__all__background="new abe.com.ponents.skinning.decorations::SimpleFill(color(White))"
	)]
	/**
	 * @author Cédric Néhémie
	 */
	public class EmptyKeyFrame extends KeyFrame
	{
		public function EmptyKeyFrame ( frame : uint, frameName : String = null, script : String = null )
		{
			super ( frame, frameName, script );
		}
		override protected function drawDot () : void
		{
			var x : Number = frameWidth / 2 - .5;
			var y : Number = height - DOT_RADIUS - 2;

			_childrenContainer.graphics.beginFill( Color.Black.hexa );
			_childrenContainer.graphics.drawCircle ( x, y, DOT_RADIUS );
			_childrenContainer.graphics.drawCircle ( x, y, DOT_RADIUS-.5 );
			_childrenContainer.graphics.endFill();
		}

	}
}

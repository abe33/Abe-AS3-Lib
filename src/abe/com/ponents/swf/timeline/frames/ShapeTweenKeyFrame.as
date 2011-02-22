package abe.com.ponents.swf.timeline.frames
{
	[Skinable(skin="ShapeTweenKeyFrame")]
	[Skin(define="ShapeTweenKeyFrame",
			  inherit="KeyFrame",
			  state__all__background="new abe.com.ponents.skinning.decorations::SimpleFill(color(0x88ccffcc))"
	)]
	/**
	 * @author Cédric Néhémie
	 */
	public class ShapeTweenKeyFrame extends MotionTweenKeyFrame
	{
		public function ShapeTweenKeyFrame ( frame : uint, frameName : String = null, script : String = null )
		{
			super ( frame, frameName, script );
		}
	}
}

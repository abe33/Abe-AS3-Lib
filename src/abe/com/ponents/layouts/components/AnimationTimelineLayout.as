package abe.com.ponents.layouts.components
{
	import abe.com.ponents.swf.timeline.frames.EmptyKeyFrame;
	import abe.com.ponents.swf.timeline.frames.KeyFrame;
	import abe.com.ponents.swf.timeline.TimelineLayer;
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.geom.dm;
	import abe.com.ponents.core.Container;
	import abe.com.ponents.swf.timeline.AnimationTimeline;
	import abe.com.ponents.utils.Insets;

	/**
	 * @author Cédric Néhémie
	 */
	public class AnimationTimelineLayout extends AbstractComponentLayout
	{
		protected var _timeline : AnimationTimeline;
		protected var _framesWidth : uint;
		protected var _framesHeight : uint;
		public function AnimationTimelineLayout ( container : AnimationTimeline = null, framesWidth : uint = 6, framesHeight : uint = 12 )
		{
			super ( container );
			_framesWidth = framesWidth;			_framesHeight = framesHeight;
		}
		override public function set container ( o : Container ) : void
		{
			super.container = o;
			_timeline = container as AnimationTimeline;
		}
		override public function layout ( preferredSize : Dimension = null, insets : Insets = null ) : void
		{
			insets = insets ? insets : new Insets ();
			preferredSize = preferredSize ? preferredSize : estimatedSize ().grow ( insets.horizontal, insets.vertical );

			var l : uint = _timeline.layersLength;
			var m : uint;
			var i:uint;			var j:uint;
			var layer : TimelineLayer;
			var frame : KeyFrame;			var nextFrame : KeyFrame;
			var y : uint = 0;
			var w : uint;
			for(i=0;i<l;i++)
			{
				layer = _timeline.layers[i];
				m = layer.frames.length;
				for(j=0;j<m;j++)
				{
					frame = layer.frames[j];
					if( j+1 < m )						nextFrame = layer.frames[j+1];
					else
						nextFrame = null;

					frame.x = 1 + frame.frame * _framesWidth;					frame.y = 1 + y;

					if( nextFrame )
						w = ( nextFrame.frame - frame.frame ) * _framesWidth;
					else
						w = _framesWidth;
					frame.nextFrame = nextFrame;					frame.previousFrame = j-1 > 0 ? layer.frames[j-1] : null;

					frame.size = dm ( w, _framesHeight );
					frame.frameWidth = _framesWidth;
				}
				y += _framesHeight;
			}
		}
		override public function get preferredSize () : Dimension
		{
			return estimatedSize();
		}
		protected function estimatedSize () : Dimension
		{
			return dm ( 1+_timeline.framesLength * _framesWidth, 1+_timeline.layersLength * _framesHeight );
		}

	}
}

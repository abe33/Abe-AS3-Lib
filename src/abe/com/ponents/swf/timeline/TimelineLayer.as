package abe.com.ponents.swf.timeline
{
	/**
	 * @author Cédric Néhémie
	 */
	public class TimelineLayer
	{
		protected var _frames : Array;

		public function TimelineLayer ( ... frames )
		{
			if( frames.length > 0 )
			{
				if( frames[0] is Array )
					_frames = frames[0];
				else
					_frames = frames;
			}
			else
				_frames = [];
		}

		public function get frames () : Array { return _frames; }
		public function set frames ( frames : Array ) : void
		{
			_frames = frames;
		}
		public function get length() : uint { return _frames[_frames.length-1].frame + 1; }
		public function sortFrames () : void
		{
			_frames.sortOn("position");
		}
	}
}

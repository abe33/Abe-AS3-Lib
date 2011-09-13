package abe.com.ponents.skinning.icons
{
    import abe.com.mon.utils.MovieClipUtils;

    import flash.display.MovieClip;
	/**
	 * @author Cédric Néhémie
	 */
	public class MovieClipIcon extends DOIcon
	{
		public function MovieClipIcon ( c : Class )
		{
			super ( c );
			_contentType = "MovieClip";
		}
		override public function init () : void
		{
			super.init ();
			MovieClipUtils.stop ( _icon as MovieClip );
		}
		override public function clone () : * 
		{ 
			return new MovieClipIcon( _class ); 
		}
	}
}

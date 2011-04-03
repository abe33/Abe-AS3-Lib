package abe.com.ponents.factory.ressources.handlers 
{
	import abe.com.patibility.humanize.plural;
	import flash.display.MovieClip;
	import abe.com.mon.utils.Reflection;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.factory.ressources.LibraryAsset;
	import abe.com.ponents.factory.ressources.preview.MovieClipPreview;

	import flash.display.DisplayObject;
	/**
	 * @author cedric
	 */
	public class MovieClipHandler extends DisplayObjectHandler 
	{
		public function MovieClipHandler ()
		{
		}
		override public function getPreview (o : *) : Component 
		{
			try
			{
				var d : DisplayObject = Reflection.buildInstance( o as Class ) as DisplayObject;
				if( !instance )
					instance = new MovieClipPreview();
				instance.displayObject = d;
				return instance;
			}
			catch( e : Error )
			{				
			}
			return LibraryAsset.DEFAULT_HANDLER.getPreview( o );
		}
		override public function getDescription (o : *) : String 
		{
			try
			{
				var d : MovieClip = Reflection.buildInstance( o as Class ) as MovieClip;
				return _$( "$0\n<font color='#666666'>Duration :</font> ${totalFrames}",
							{
								'totalFrames':d.totalFrames + plural(d.totalFrames, " frame", " frames")
							},
							super.getDescription( o ) );
			}
			catch( e : Error ) {}
			return "";
		}
	}
}

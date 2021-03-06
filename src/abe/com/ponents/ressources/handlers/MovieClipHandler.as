package abe.com.ponents.ressources.handlers 
{
	import abe.com.mon.utils.Reflection;
	import abe.com.patibility.humanize.plural;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.ressources.ClassCollectionViewer;
	import abe.com.ponents.ressources.preview.MovieClipPreview;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	/**
	 * @author cedric
	 */
	public class MovieClipHandler extends DisplayObjectHandler 
	{
		public function MovieClipHandler () {}
		override public function get title () : String { return "MovieClip"; }
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
			catch( e : Error ) {}
			return ClassCollectionViewer.DEFAULT_HANDLER.getPreview( o );
		}
		override public function getDescription (o : *) : String 
		{
			try
			{
				var d : MovieClip = Reflection.buildInstance( o as Class ) as MovieClip;
				return HandlerUtils.getField( "Duration", d.totalFrames + plural(d.totalFrames, " frame", " frames") );
			}
			catch( e : Error ) {}
			return "";
		}
	}
}

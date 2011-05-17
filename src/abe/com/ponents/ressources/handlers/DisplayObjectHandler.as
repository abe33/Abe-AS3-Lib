package abe.com.ponents.ressources.handlers 
{
	import abe.com.mon.utils.Reflection;
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.ressources.ClassCollectionViewer;
	import abe.com.ponents.ressources.preview.DisplayObjectPreview;

	import flash.display.DisplayObject;
	/**
	 * @author cedric
	 */
	public class DisplayObjectHandler implements TypeHandler 
	{
		public var instance : DisplayObjectPreview;
		public function getPreview (o : *) : Component
		{
			try
			{
				var d : DisplayObject = Reflection.buildInstance( o as Class ) as DisplayObject;
				if( !instance )
					instance = new DisplayObjectPreview();
				instance.displayObject = d;
				return instance;
			}
			catch( e : Error )
			{				
			}
			return ClassCollectionViewer.DEFAULT_HANDLER.getPreview( o );
		}
		public function getDescription ( o : * ) : String 
		{ 
			try
			{
				var d : DisplayObject = Reflection.buildInstance( o as Class ) as DisplayObject;
				return HandlerUtils.getField( "Size", _$( "${width}px x ${height}px", { 'width':d.width, 'height':d.height } ) );
			}
			catch( e : Error ) {}
			return _("<font size='9' color='#ff0000'>Object cannot be instanciated</font>");
		}
		
		public function getIconHandler () : Function { return null; }
		public function get title () : String { return "DisplayObject"; }
	}
}

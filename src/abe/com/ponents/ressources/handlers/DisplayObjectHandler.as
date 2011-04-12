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
				var s : String = _("<font color='#666666'>Size :</font>${width} x ${height}");				return _$( s, {
								'width':d.width,								'height':d.height
							  } );
			}
			catch( e : Error ) {}
			return "";
		}
		
		public function getIconHandler () : Function { return null; }
	}
}

package abe.com.ponents.factory.ressources.handlers 
{
	import abe.com.patibility.lang._$;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.factory.ressources.preview.FontPreview;

	import flash.text.Font;
	/**
	 * @author cedric
	 */
	public class FontHandler implements TypeHandler 
	{
		public var instance : FontPreview;
		
		public function getPreview (o : *) : Component
		{
			if(!instance)
				instance = new FontPreview();
				
			var f : Font = new o() as Font;
			instance.font = f;
			return instance;
		}
		public function getDescription (o : *) : String
		{
			var f : Font = new o() as Font;
			var s : String = _$("<font color='#666666'>Name :</font>$0\n<font color='#666666'>Style :</font>$1\n<font color='#666666'>Type :</font>$2", 
								f.fontName, 
								f.fontStyle, 
								f.fontType );
			return s;
		}
		public function getIconHandler () : Function { return null; }
	}
}

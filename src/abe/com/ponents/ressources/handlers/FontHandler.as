package abe.com.ponents.ressources.handlers 
{
    import abe.com.ponents.core.Component;
    import abe.com.ponents.ressources.preview.FontPreview;

    import flash.text.Font;
	/**
	 * @author cedric
	 */
	public class FontHandler implements TypeHandler 
	{
		public var instance : FontPreview;
		public function get title () : String { return "Font"; }
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
			var s : String = HandlerUtils.getFields({
													'Font Name':f.fontName, 
													'Font Style':f.fontStyle, 
													'Font Type':f.fontType
													});
			return s;
		}
		public function getIconHandler () : Function { return null; }
	}
}

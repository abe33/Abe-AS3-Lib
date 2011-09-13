package abe.com.ponents.ressources.handlers 
{
    import abe.com.ponents.containers.Panel;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.layouts.components.InlineLayout;
    import abe.com.ponents.text.Label;
	/**
	 * @author cedric
	 */
	public class DefaultHandler implements TypeHandler 
	{
		public var instance : Panel;

		public function getPreview ( o : * ) : Component
		{
			if( !instance )
			{
				instance = new Panel();
				instance.childrenLayout = new InlineLayout(instance, 0, "center", "center");
				instance.addComponent( new Label( "<font color='#666666' size='16'><b>&lt;unsupported&gt;</b></font>" ) );
				
			}
			return instance;
		}
		public function getDescription ( o : * ) : String { return ""; }
		public function getIconHandler () : Function { return null; }
		public function get title () : String { return ""; }
	}
}

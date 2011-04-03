package abe.com.ponents.factory.ressources.handlers 
{
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.text.Label;
	/**
	 * @author cedric
	 */
	public class DefaultHandler implements TypeHandler 
	{
		public function getPreview ( o : * ) : Component
		{
			var p : Panel = new Panel();
			p.childrenLayout = new InlineLayout(p, 0, "center", "center");
			p.addComponent( new Label( "<font color='#666666' size='16'><b>&lt;unsupported&gt;</b></font>" ) );
			return p;
		}
		public function getDescription ( o : * ) : String { return ""; }
		public function getIconHandler () : Function { return null; }
	}
}

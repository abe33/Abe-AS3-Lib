package aesia.com.ponents.containers
{
	import aesia.com.ponents.buttons.AbstractButton;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.layouts.display.DOInlineLayout;
	import aesia.com.ponents.skinning.decorations.GradientFill;
	import aesia.com.ponents.skinning.icons.Icon;

	[Skinable(skin="AccordionTab")]
	[Skin(define="AccordionTab",
			  inherit="Button",
			  state__all__corners="new aesia.com.ponents.utils::Corners(0)",
			  state__all__borders="new aesia.com.ponents.utils::Borders(0,0,0,1)",
			  state__all__background="new aesia.com.ponents.skinning.decorations::GradientFill(gradient([color(Gainsboro),color(LightGrey),color(Gainsboro)],[.5,.5,1]),90)"
	)]
	/**
	 * @author Cédric Néhémie
	 */
	public class AccordionTab extends AbstractButton
	{
		static private var SKIN_DEPENDENCIES : Array = [GradientFill];

		protected var _content : Component;
		protected var _accordion : Accordion;

		public function AccordionTab ( name : String, content : Component = null, icon : Icon = null )
		{
			super ( name, icon );
			( _childrenLayout as DOInlineLayout ).horizontalAlign = "left";			( _childrenLayout as DOInlineLayout ).direction = "rightToLeft";
			_allowFocus = false;
			_allowSelected = false;
			_content = content;
		}
		public function get content () : Component { return _content; }
		public function set content (content : Component) : void
		{
			_content = content;
		}
		public function get accordion () : Accordion { return _accordion; }
		public function set accordion (accordion : Accordion) : void
		{
			_accordion = accordion;
		}
	}
}

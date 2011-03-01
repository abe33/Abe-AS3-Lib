package abe.com.ponents.containers
{
	import abe.com.ponents.core.Dockable;
	import abe.com.ponents.transfer.DockableTransferable;
	import abe.com.ponents.transfer.Transferable;
	import abe.com.ponents.buttons.DraggableButton;
	import abe.com.ponents.buttons.AbstractButton;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.layouts.display.DOInlineLayout;
	import abe.com.ponents.skinning.decorations.GradientFill;
	import abe.com.ponents.skinning.icons.Icon;

	[Skinable(skin="AccordionTab")]
	[Skin(define="AccordionTab",
			  inherit="Button",
			  state__all__corners="new cutils::Corners(0)",
			  state__all__borders="new cutils::Borders(0,0,0,1)",
			  state__all__background="new deco::GradientFill(gradient([skin.overSelectedBackgroundColor,skin.selectedBackgroundColor,skin.overSelectedBackgroundColor],[.5,.5,1]),90)"
	)]
	/**
	 * @author Cédric Néhémie
	 */
	public class AccordionTab extends DraggableButton implements Dockable
	{
		static private var SKIN_DEPENDENCIES : Array = [GradientFill];

		protected var _content : Component;
		protected var _accordion : Accordion;

		public function AccordionTab ( name : String, content : Component = null, icon : Icon = null )
		{
			super ( name, icon );
			( _childrenLayout as DOInlineLayout ).horizontalAlign = "left";
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
		override public function get transferData () : Transferable { return new DockableTransferable( this ); }
	}
}
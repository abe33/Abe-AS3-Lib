package abe.com.ponents.containers
{
    import abe.com.ponents.buttons.DraggableButton;
    import abe.com.ponents.core.*;
    import abe.com.ponents.layouts.display.DOInlineLayout;
    import abe.com.ponents.skinning.decorations.GradientFill;
    import abe.com.ponents.skinning.icons.Icon;
    import abe.com.ponents.transfer.Transferable;

	[Skinable(skin="AccordionTab")]
	[Skin(define="AccordionTab",
			  inherit="Button",
			  state__all__corners="new cutils::Corners(0)",
			  state__all__borders="new cutils::Borders(0,0,0,1)"
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
			( _childrenLayout as DOInlineLayout ).direction = "rightToLeft";
			_allowFocus = false;
			_allowSelected = false;
			_selected = true;
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
		override public function get transferData () : Transferable 
		{ 
		    return new AccordionTabTransferable( this ); 
		}
	}
}

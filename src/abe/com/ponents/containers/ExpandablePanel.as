package abe.com.ponents.containers
{
    import abe.com.ponents.core.Component;
    import abe.com.ponents.layouts.components.InlineLayout;
    import abe.com.ponents.skinning.icons.magicIconBuild;

    import org.osflash.signals.Signal;

    /**
     * @author cedric
     */
    [Skinable(skin="EmptyComponent")]
    public class ExpandablePanel extends Panel
    {
        [Embed(source="../skinning/icons/plus_box.png")]
        static public const EXPAND_ICON : Class;
        [Embed(source="../skinning/icons/minus_box.png")]
        static public const COLLAPSE_ICON : Class;
        
        protected var _label : ExpandablePanelTitle;
        protected var _content : Component;
        
        public var expanded : Signal;
        
        public function ExpandablePanel ( label : String, content : Component, expanded : Boolean = true )
        {
            this.expanded = new Signal();
            
            _childrenLayout = new InlineLayout(this, 0, "left", "top", "topToBottom", true );
            super();
            
            _label = new ExpandablePanelTitle(label);
            _label.mouseReleased.add(function( c : ExpandablePanelTitle ):void{
                swapContent();
            });
            _content = content;
            _content.visible = expanded;
            
            if( _content.visible )
                _label.icon = magicIconBuild( COLLAPSE_ICON );
            else
                _label.icon = magicIconBuild( EXPAND_ICON );
            
            addComponents( _label, _content );
        }

        protected function swapContent () : void
        {
            if( _content.visible )
            {
                _label.icon = magicIconBuild( EXPAND_ICON );
                _content.visible = false;
            }
            else
            {
                _label.icon = magicIconBuild( COLLAPSE_ICON );
                 _content.visible = true;
            }
            expanded.dispatch( this, _content.visible );
        }
    }
}
import abe.com.ponents.buttons.Button;
import abe.com.ponents.layouts.display.DOInlineLayout;
import abe.com.ponents.skinning.icons.Icon;

[Skinable(skin="ExpandablePanelTitle")]
[Skin(define="ExpandablePanelTitle",
	  inherit="Button",
      state__all__corners="new cutils::Corners(1)")]
internal class ExpandablePanelTitle extends Button
{
    public function ExpandablePanelTitle ( actionOrLabel : * = null, icon : Icon = null )
	{
		super( actionOrLabel, icon );
        (_childrenLayout as DOInlineLayout).horizontalAlign = "left";
        (_childrenLayout as DOInlineLayout).direction = "rightToLeft";
	}

}
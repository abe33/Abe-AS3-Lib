package abe.com.ponents.containers
{
    import abe.com.ponents.buttons.Button;
    import abe.com.ponents.layouts.components.InlineLayout;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.containers.Panel;

    /**
     * @author cedric
     */
    public class ExpandablePanel extends Panel
    {
        protected var _label : Button;
        protected var _content : Component;
        public function ExpandablePanel ( label : String, content : Component )
        {
            _childrenLayout = new InlineLayout(this, 0, "left", "top", "topToBottom", true );
            super();
            
            _label = new Button(label);
            _content = content;
            
            addComponents( _label, _content );
        }
    }
}

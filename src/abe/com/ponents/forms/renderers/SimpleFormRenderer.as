package abe.com.ponents.forms.renderers
{
    import abe.com.ponents.buttons.CheckBox;
    import abe.com.ponents.containers.Panel;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.forms.FormField;
    import abe.com.ponents.forms.FormObject;
    import abe.com.ponents.layouts.components.InlineLayout;
    import abe.com.ponents.layouts.display.DOInlineLayout;
    import abe.com.ponents.text.Label;
    import abe.com.ponents.utils.Insets;

    /**
     * @author cedric
     */
    public class SimpleFormRenderer implements FormRenderer
    {
        public function render ( o : FormObject ) : Component
        {
            var p : Panel = new Panel();
            p.childrenLayout = new InlineLayout(p, 1, "left", "top", "topToBottom", true );
            p.style.insets = new Insets(4);
            for each( var f : FormField in o.fields )
            {
                if( f.component is CheckBox )
                {
                  ( f.component as CheckBox ).label = f.name;
                  ( ( f.component as CheckBox ).childrenLayout as DOInlineLayout ).horizontalAlign = "left";
                }
                else
                {
                    var l : Label = new Label( f.name +" :", f.component );
                    p.addComponent( l );
                }
                p.addComponent( f.component );
            }
            return p;    
        }
    }
}

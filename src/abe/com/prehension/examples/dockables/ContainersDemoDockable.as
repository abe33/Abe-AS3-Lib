package abe.com.prehension.examples.dockables 
{
    import abe.com.ponents.containers.*;
    import abe.com.ponents.factory.ComponentFactory;
    import abe.com.ponents.layouts.components.GridLayout;
    import abe.com.ponents.skinning.icons.*;
    import abe.com.ponents.tabs.*;
    import abe.com.ponents.utils.Insets;
    /**
     * @author cedric
     */
    public class ContainersDemoDockable extends DemoDockable 
    {
        public function ContainersDemoDockable ( id : String, label : String = null, icon : Icon = null)
        {
            super( id, null, label, icon );
        }
        override public function build (factory : ComponentFactory) : void
        {
            /*
             * BUTTONS
             */
            TabbedPane.buildPreview( factory, "containersDemoTabbedPane1" );
            TabbedPane.buildPreview( factory, "containersDemoTabbedPane2", {'enabled':false, 'tabsPosition':"west"} );
            
            Accordion.buildPreview( factory, "containersDemoAccordion1" );
            Accordion.buildPreview( factory, "containersDemoAccordion2", {'enabled':false} );
            
            ScrollPane.buildPreview( factory, "containersDemoScrollPane1" );
            ScrollPane.buildPreview( factory, "containersDemoScrollPane2", {'enabled':false} );
            
            SlidePane.buildPreview( factory, "containersDemoSlidePane1" );
            SlidePane.buildPreview( factory, "containersDemoSlidePane2", {'enabled':false} ); 
           
            factory.group("containers").build( Panel, 
                           "containersDemoPanel",
                           null,
                           { 'childrenLayout':new GridLayout(null, 2, 4, 3, 3 ) },
                           onBuildComplete );
        }
        protected function onBuildComplete ( p : Panel, ctx : Object ) : void 
        {
            for each ( var i : String in [
                               "containersDemoTabbedPane1",
                               "containersDemoTabbedPane2",
                               "containersDemoTabbedPane3",
                               "containersDemoAccordion1",
                               "containersDemoAccordion2",
                               "containersDemoScrollPane1",
                               "containersDemoScrollPane2",
                               "containersDemoSlidePane1",
                               "containersDemoSlidePane2"
                           ] )
                ctx["containersDemoPanel"].addComponent( ctx[i] );
            
            ctx["containersDemoPanel"].style.setForAllStates("insets", new Insets(4));
            _content = p;
        }
    }
}

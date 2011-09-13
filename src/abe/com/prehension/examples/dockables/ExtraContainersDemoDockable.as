package abe.com.prehension.examples.dockables 
{
    import abe.com.ponents.containers.*;
    import abe.com.ponents.factory.*;
    import abe.com.ponents.skinning.icons.*;
    /**
     * @author cedric
     */
    public class ExtraContainersDemoDockable extends DemoDockable 
    {
        public function ExtraContainersDemoDockable ( id : String, label : String = null, icon : Icon = null)
        {
            super( id, null, label, icon );
        }
        override public function build (factory : ComponentFactory) : void
        {
            /*
             * BUTTONS
             */
            ScrollPane.buildPreview( factory, "extraContainersDemoSplitPane_panel1" );
            ScrollPane.buildPreview( factory, "extraContainersDemoSplitPane_panel2" );
            ScrollPane.buildPreview( factory, "extraContainersDemoSplitPane_panel3" );
            factory.group("containers")
                   .build( SplitPane,
                           "extraContainersDemoSplitPane1",
                           contextMixedArgs( 1, false, "extraContainersDemoSplitPane_panel2", true, "extraContainersDemoSplitPane_panel3", true ) )
                   .build( SplitPane,
                           "extraContainersDemoSplitPane2",
                           contextMixedArgs( 0, false, "extraContainersDemoSplitPane_panel1", true, "extraContainersDemoSplitPane1", true ),
                           null,                        
                           onBuildComplete );
        }
        protected function onBuildComplete ( p : SplitPane, ctx : Object ) : void 
        {
            _content = p;
        }
    }
}

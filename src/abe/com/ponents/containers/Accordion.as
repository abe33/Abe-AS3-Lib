package abe.com.ponents.containers
{
    import abe.com.mon.geom.*;
    import abe.com.mon.logs.*;
    import abe.com.motion.SingleTween;
    import abe.com.ponents.core.*;
    import abe.com.ponents.containers.*;
    import abe.com.ponents.factory.*;
    import abe.com.ponents.layouts.components.AccordionLayout;
    import abe.com.ponents.scrollbars.Scrollable;
    import abe.com.ponents.utils.ScrollUtils;

    import flash.geom.Rectangle;

    [Skinable(skin="Accordion")]
    [Skin(define="Accordion",
          inherit="DefaultComponent",
          preview="abe.com.ponents.containers::Accordion.defaultAccordionPreview"
    )]
    [Skin(define="AccordionContentContainer",
          inherit="DefaultComponent",
          state__all__borders="new cutils::Borders(0,0,0,1)",
          state__all__background="skin.emptyDecoration"
    )]
    /**
     * @author cedric
     */
    public class Accordion extends AbstractContainer implements Scrollable
    {
        FEATURES::BUILDER {
            static public function defaultAccordionPreview () : Accordion
            {
                var tp : Accordion = new Accordion(
                                             new AccordionTab("Tab 1", new Panel() ),
                                             new AccordionTab("Tab 2", new Panel() ) ); 
                tp.preferredSize = dm(100,100);
                return tp;        
            }
            static public function buildPreview( factory : ComponentFactory,
                                                 id : String,
                                                 kwargs : Object = null ):void
            {
                ScrollablePanel.buildPreview( factory, id + "_tab1_panel" );
                ScrollablePanel.buildPreview( factory, id + "_tab2_panel" );
                ScrollablePanel.buildPreview( factory, id + "_tab3_panel" );
                factory.group("movables")
                       .build( AccordionTab, id + "_tab1", contextMixedArgs( "Tab 1", false, id + "_tab1_panel", true ) )
                       .build( AccordionTab, id + "_tab2", contextMixedArgs( "Tab 2", false, id + "_tab2_panel", true ) )
                       .build( AccordionTab, id + "_tab3", contextMixedArgs( "Tab 3", false, id + "_tab3_panel", true ) )
                       .build( Accordion, 
                               id, 
                               contextArgs( id + "_tab1", 
                                            id + "_tab2", 
                                            id + "_tab3" ),
                               kwargs );
            }
        }
    
        protected var _tabs : Array;
        protected var _selectedTab : AccordionTab;
        protected var _tabContentContainer1 : ScrollPane;
        protected var _tabContentContainer2 : ScrollPane;

        protected var _animation : SingleTween;
        protected var _transition : Number;

        public function Accordion ( ... tabs )
        {
            _childrenLayout = new AccordionLayout(this);
            super ();

            _allowFocus = false;

            _tabContentContainer1 = new ScrollPane();
            _tabContentContainer1.styleKey = "EmptyComponent";
            _tabContentContainer1.viewport.styleKey = "AccordionContentContainer";
            _tabContentContainer1.allowFocus = false;

            _tabContentContainer2 = new ScrollPane();
            _tabContentContainer2.styleKey = "EmptyComponent";
            _tabContentContainer2.viewport.styleKey = "AccordionContentContainer";
            _tabContentContainer2.allowFocus = false;

            _animation = new SingleTween ( this, "transition", 1, 500, 0 );
            _animation.commandEnded.add( tweenEnd );

            _tabs = [];
            for each( var tab : AccordionTab in tabs )
                if( tab )
                    addTab( tab );
        }

        public function get tabs () : Array { return _tabs; }
        public function get tabContentContainer1 () : ScrollPane { return _tabContentContainer1; }
        public function get tabContentContainer2 () : ScrollPane { return _tabContentContainer2; }

        public function get transition () : Number { return _transition; }
        public function set transition ( transition : Number ) : void
        {
            _transition = transition;
            
            var p : Container = parentContainer;
            if( p )
            {
                p = p.parentContainer;
                if( p && p is AbstractScrollContainer )
                {
                    invalidatePreferredSizeCache();
                    ( p as AbstractScrollContainer ).invalidate();
                    fireComponentResizedSignal();
                }
                else
                {
                    invalidate(true);
                }
            }
        }

        public function get selectedTab () : AccordionTab { return _selectedTab; }
        public function set selectedTab ( selectedTab : AccordionTab ) : void
        {
            if( _selectedTab )
            {
                _selectedTab.selected = false;
                if( _selectedTab.content )
                {
                    var tmp : ScrollPane = _tabContentContainer2;
                    _tabContentContainer2 = _tabContentContainer1;
                    _tabContentContainer1 = tmp;
                }
            }

            _selectedTab = selectedTab;

            if( _selectedTab )
            {
                _selectedTab.selected = true;
                if( _selectedTab.content )
                {
                    _tabContentContainer1.view = _selectedTab.content;

                    if( !containsComponent( _tabContentContainer1 ) )
                        addComponent( _tabContentContainer1 );
                }
            }
            _animation.execute();
        }

        public function addTab ( tab : AccordionTab ) : void
        {
            if( !containsTab( tab ) )
            {
                _tabs.push( tab );
                tab.accordion = this;
                tab.buttonClicked.add( tabClicked );
                addComponent( tab );
            }
        }
        public function removeTab ( tab : AccordionTab ) : void
        {
            if( containsTab( tab ) )
            {
                _tabs.splice( _tabs.indexOf( tab ), 1 );
                tab.accordion = null;
                tab.buttonClicked.remove( tabClicked );
                removeComponent( tab );
                
                if ( selectedTab == tab )
                    selectedTab = null;
            }
        }
        public function containsTab ( tab : AccordionTab ) : Boolean
        {
            return _tabs.indexOf( tab ) != -1;
        }

        protected function tweenEnd ( t : SingleTween ) : void
        {
            if( containsComponent ( _tabContentContainer2 ) )
            {
                removeComponent ( _tabContentContainer2 );
                _tabContentContainer2.view = null;
            }
        }

        public function getScrollableUnitIncrementV ( r : Rectangle = null, direction : Number = 1 ) : Number { return 10 * direction; }
        public function getScrollableUnitIncrementH ( r : Rectangle = null, direction : Number = 1 ) : Number { return 10 * direction; }

        public function getScrollableBlockIncrementV ( r : Rectangle = null, direction : Number = 1 ) : Number { return 50 * direction; }
        public function getScrollableBlockIncrementH ( r : Rectangle = null, direction : Number = 1 ) : Number { return 50 * direction; }

        public function get preferredViewportSize () : Dimension { return preferredSize; }

        public function get tracksViewportH () : Boolean { return true; }
        public function get tracksViewportV () : Boolean { return !ScrollUtils.isContentHeightExceedContainerHeight(this); }

        protected function tabClicked ( tab : AccordionTab ) : void
        {
            if( _selectedTab != tab )
                selectedTab = tab;
            else
                selectedTab = null;
        }
    }
}

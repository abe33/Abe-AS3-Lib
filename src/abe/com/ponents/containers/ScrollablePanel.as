package abe.com.ponents.containers 
{
    import abe.com.mon.geom.*;
    import abe.com.ponents.core.*;
    import abe.com.ponents.buttons.*;
    import abe.com.ponents.text.*;
    import abe.com.ponents.factory.*;
    import abe.com.ponents.layouts.components.*;
    import abe.com.ponents.scrollbars.Scrollable;
    import abe.com.ponents.utils.*;

    import flash.geom.Rectangle;
    /**
     * @author cedric
     */
    public class ScrollablePanel extends Panel implements Scrollable 
    {
        FEATURES::BUILDER {
            static public function buildPreview( factory : ComponentFactory, 
                                                 id : String, 
                                                 kwargs : Object = null ) : void
            {
                factory.group("movables")
                       .build( Label, 
                               id + "_label", 
                               ["This is a sample label with wordWrap enabled. This is a sample label with wordWrap enabled. This is a sample label with wordWrap enabled. This is a sample label with wordWrap enabled. This is a sample label with wordWrap enabled. This is a sample label with wordWrap enabled. This is a sample label with wordWrap enabled. This is a sample label with wordWrap enabled. "],
                               {'wordWrap':true} )
                       .build( Button, 
                               id + "_button", 
                               ["A sample button"] )
                       .build( CheckBox, 
                               id + "_checkBox", 
                               ["A sample checkbox"] )
                       .build( ScrollablePanel, 
                               id, 
                               null,
                               {'childrenLayout':new InlineLayout(null, 4,"left","top","topToBottom",true)},
                               function ( p : Panel, ctx : Object ) : void
                               {
                                    p.addComponents( ctx[id + "_label"],
                                                     ctx[id + "_button"],
                                                     ctx[id + "_checkBox"] );
                                    p.style.insets = new Insets(4);
                               } );
               
            }
        }
        
        protected var _tracksViewportHPolicy : String;
        protected var _tracksViewportVPolicy : String;
        
        public function ScrollablePanel () 
        {
            _tracksViewportHPolicy = ScrollPolicies.ALWAYS;
            _tracksViewportVPolicy = ScrollPolicies.AUTO;
        }
        public function get tracksViewportHPolicy () : String { return _tracksViewportHPolicy; }
        public function set tracksViewportHPolicy (tracksViewportHPolicy : String) : void {    _tracksViewportHPolicy = tracksViewportHPolicy; }
        public function get tracksViewportVPolicy () : String { return _tracksViewportVPolicy; }
        public function set tracksViewportVPolicy (tracksViewportvPolicy : String) : void { _tracksViewportVPolicy = tracksViewportvPolicy; }
        
        public function get preferredViewportSize () : Dimension { return preferredSize; }
        public function get tracksViewportH () : Boolean 
        { 
            switch(_tracksViewportHPolicy)
            {
                case ScrollPolicies.NEVER : 
                    return false;
                case ScrollPolicies.AUTO : 
                    return !ScrollUtils.isContentWidthExceedContainerWidth( this );
                case ScrollPolicies.ALWAYS:
                default:
                    return true;
            }
        }
        public function get tracksViewportV () : Boolean 
        { 
            switch(_tracksViewportVPolicy)
            {
                case ScrollPolicies.NEVER : 
                    return false;
                case ScrollPolicies.AUTO : 
                    return !ScrollUtils.isContentHeightExceedContainerHeight( this );
                case ScrollPolicies.ALWAYS:
                default:
                    return true;
            }
        }
        
        public function getScrollableUnitIncrementV (r : Rectangle = null, direction : Number = 1) : Number    { return direction * 10; }
        public function getScrollableUnitIncrementH (r : Rectangle = null, direction : Number = 1) : Number { return direction * 10; }
        public function getScrollableBlockIncrementV (r : Rectangle = null, direction : Number = 1) : Number { return direction * 50; }
        public function getScrollableBlockIncrementH (r : Rectangle = null, direction : Number = 1) : Number { return direction * 50; }

        private var _childrenInvalidationSetProgramatically : Boolean;
        override public function invalidatePreferredSizeCache () : void 
        {
            if( !_childrenInvalidationSetProgramatically )
            {
                _childrenInvalidationSetProgramatically = true;
                for each ( var c : AbstractComponent in _children )
                    c.invalidatePreferredSizeCache();
                _childrenInvalidationSetProgramatically = false;
            }
            super.invalidatePreferredSizeCache( );
        }
    }
}

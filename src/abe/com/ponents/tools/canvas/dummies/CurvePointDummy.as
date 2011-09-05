package abe.com.ponents.tools.canvas.dummies
{
    import abe.com.mon.geom.FreeFormSplineVertex;
    import abe.com.patibility.lang._;
    import abe.com.ponents.utils.ContextMenuItemUtils;

    import org.osflash.signals.Signal;

    import flash.events.ContextMenuEvent;
    import flash.geom.Point;

    /**
     * @author cedric
     */
    public class CurvePointDummy extends SquareDummy
    {
        public var moved : Signal;
        public var point : Point;
        
        public var curve : CurveDummy;
        public var preHandle : CurveHandleDummy;
        public var postHandle : CurveHandleDummy;
        
        public function CurvePointDummy ( point : Point )
        {
            moved = new Signal();
            this.point = point;
            super ();
            this.x = point.x;
            this.y = point.y;
            init();
        }
        
        override public function get isSelectable () : Boolean { return true; }
        
        override public function set x ( value : Number ) : void {
            var oldX : Number = x;
            
            super.x = value;
            point.x = value;
            
            if( preHandle )
            {
                preHandle.valueSetProgramatically = true;
                preHandle.x += value - oldX;
                preHandle.valueSetProgramatically = false;
            }
            if( postHandle )
            {
                postHandle.valueSetProgramatically = true;
                postHandle.x += value - oldX;
                postHandle.valueSetProgramatically = false;
            }
            
            moved.dispatch(this);
            draw();
        }

        override public function set y ( value : Number ) : void {
            var oldY : Number = y;
            super.y = value;
            point.y = value;
            
            if( preHandle )
            {
                preHandle.valueSetProgramatically = true;
                preHandle.y += value - oldY;
                preHandle.valueSetProgramatically = false;
            }
            if( postHandle )
            {
                postHandle.valueSetProgramatically = true;
                postHandle.y += value - oldY;
                postHandle.valueSetProgramatically = false;
            }
            
            moved.dispatch(this);
            draw();
        }
        
        
        override public function init () : void
        {
            super.init ();
            if( point is FreeFormSplineVertex )
              ( point as FreeFormSplineVertex ).typeChanged.add(typeChanged);
              
            FEATURES::MENU_CONTEXT {
                createContextMenu ();
            }
        }

        override public function dispose () : void
        {
            super.dispose ();
            if( point is FreeFormSplineVertex )
              ( point as FreeFormSplineVertex ).typeChanged.remove(typeChanged);
        }

        private function typeChanged ( v : FreeFormSplineVertex, t : uint ) : void
        {
            FEATURES::MENU_CONTEXT{
                updateTypeMenuItemCaptions();
            }
        }

        override public function remove():void
        {
            curve.deletePoint( this );
        }
        FEATURES::MENU_CONTEXT {
            protected function createContextMenu () : void
		    {
                addNewContextMenuItemForGroup( 
                	_("Delete Vertex"), 
                    "delete", 
                    function(... args ):void
                    { 
                        remove(); 
                    }, 
                    "controls" );
                        
                addNewContextMenuItemForGroup( 
                	ContextMenuItemUtils.getBooleanContextMenuItemCaption(
                    	_("Corner"),
						(point as FreeFormSplineVertex).type == FreeFormSplineVertex.CORNER ), 
                        "corner", 
                        corner, 
                        "type" );
                addNewContextMenuItemForGroup( 
                	ContextMenuItemUtils.getBooleanContextMenuItemCaption(
                    	_("Bezier"),
						(point as FreeFormSplineVertex).type == FreeFormSplineVertex.BEZIER ), 
                        "bezier", 
                        bezier, 
                        "type" );
                addNewContextMenuItemForGroup( 
                	ContextMenuItemUtils.getBooleanContextMenuItemCaption(
                    	_("Bezier Corner"),
						(point as FreeFormSplineVertex).type == FreeFormSplineVertex.BEZIER_CORNER ), 
                        "bezierCorner", 
                        bezierCorner, 
                        "type" );
                addNewContextMenuItemForGroup( 
                	ContextMenuItemUtils.getBooleanContextMenuItemCaption(
                    	_("Smooth"),
						(point as FreeFormSplineVertex).type == FreeFormSplineVertex.SMOOTH ), 
                        "smooth", 
                        smooth, 
                        "type" );
            }
            protected function corner (event : ContextMenuEvent) : void
		    {
                (point as FreeFormSplineVertex).type = FreeFormSplineVertex.CORNER;
		    }
            protected function bezier (event : ContextMenuEvent) : void
		    {
                (point as FreeFormSplineVertex).type = FreeFormSplineVertex.BEZIER;
		    }
            protected function bezierCorner (event : ContextMenuEvent) : void
		    {
                (point as FreeFormSplineVertex).type = FreeFormSplineVertex.BEZIER_CORNER;
		    }
            protected function smooth (event : ContextMenuEvent) : void
		    {
                (point as FreeFormSplineVertex).type = FreeFormSplineVertex.SMOOTH;
		    }
             protected function updateTypeMenuItemCaptions () : void
		    {
			    setContextMenuItemCaption( 
                	"corner", 
                    ContextMenuItemUtils.getBooleanContextMenuItemCaption(
                    	_("Corner"),
						(point as FreeFormSplineVertex).type == FreeFormSplineVertex.CORNER ) );
				setContextMenuItemCaption( 
                	"bezier", 
                    ContextMenuItemUtils.getBooleanContextMenuItemCaption(
                    	_("Bezier"),
						(point as FreeFormSplineVertex).type == FreeFormSplineVertex.BEZIER ) );
				setContextMenuItemCaption( 
                	"bezierCorner", 
                    ContextMenuItemUtils.getBooleanContextMenuItemCaption(
                    	_("Bezier Corner"),
						(point as FreeFormSplineVertex).type == FreeFormSplineVertex.BEZIER_CORNER ) );
				setContextMenuItemCaption( 
                	"smooth", 
                    ContextMenuItemUtils.getBooleanContextMenuItemCaption(
                    	_("Smooth"),
						(point as FreeFormSplineVertex).type == FreeFormSplineVertex.SMOOTH ) );
				
		    }
            
        }
    }
}

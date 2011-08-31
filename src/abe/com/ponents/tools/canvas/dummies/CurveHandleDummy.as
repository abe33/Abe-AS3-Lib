package abe.com.ponents.tools.canvas.dummies
{
    import abe.com.mon.geom.FreeFormSplineVertex;

    import flash.geom.Point;

    /**
     * @author cedric
     */
    public class CurveHandleDummy extends CurvePointDummy
    {
        public var ptTarget : FreeFormSplineVertex;
        public var altHandle : CurveHandleDummy;
        public var valueSetProgramatically : Boolean;
        
        public function CurveHandleDummy ( ptSource : Point, ptTarget : FreeFormSplineVertex )
        {
            this.ptTarget = ptTarget;
            super (ptSource);
        }

        override public function remove () : void
        {
            x = ptTarget.x;
            y = ptTarget.y;
        }
        
        override public function init () : void
        {
            super.init ();
            ptTarget.typeChanged.add(targetTypeChanged);
        }

        override public function dispose () : void
        {
            super.dispose ();
            ptTarget.typeChanged.remove(targetTypeChanged);
        }
        private function targetTypeChanged(pt:FreeFormSplineVertex,t:uint):void
        {
            switch( t )
            {
                case FreeFormSplineVertex.CORNER:
                case FreeFormSplineVertex.SMOOTH : 
                	visible = false;
                    break;
                case FreeFormSplineVertex.BEZIER : 
                case FreeFormSplineVertex.BEZIER_CORNER :
                default : 
                	visible = true;
                    break;
            }
            valueSetProgramatically = true;
           	x = point.x;
           	y = point.y;
            valueSetProgramatically = false;
            draw();
        }

        override public function draw () : void
        {
            clear();
            graphics.beginFill(0, 0);
            graphics.drawCircle(0, 0, 8);
            graphics.endFill();
            
            graphics.beginFill(_selected ? SELECTED_COLOR.hexa : DEFAULT_COLOR.hexa, 1);
            graphics.drawRect(-2, -2, 4, 4);
            graphics.endFill();
            
            graphics.lineStyle(0, DEFAULT_COLOR.hexa );
            var d : Point = ptTarget.subtract(point);
            var d2 : Point = d.clone();
            d2.normalize(4);
            
            graphics.moveTo(0,0);
            graphics.lineTo(d.x/scaleX - d2.x, d.y/scaleY - d2.y);
        }
        
        
        override public function set scaleX ( value : Number ) : void {
            super.scaleX = value;
            draw();
        }
        override public function set scaleY ( value : Number ) : void {
            super.scaleY = value;
            draw();
        }
        
        override public function set x ( value : Number ) : void 
        {
            super.x = value;
            if( !valueSetProgramatically )
            {
	            if( point == ptTarget.preHandle )
	            	ptTarget.preHandle = point;
	            else
	            	ptTarget.postHandle = point;
	            
	            if( altHandle )
	            {
	                altHandle.valueSetProgramatically = true;
	            	altHandle.x = altHandle.point.x;
	            	altHandle.y = altHandle.point.y;
	                altHandle.valueSetProgramatically = false;
	            }
            }
        }
		override public function set y ( value : Number ) : void 
        {
            super.y = value;
            if( !valueSetProgramatically )
            {
	            if( point == ptTarget.preHandle )
	            	ptTarget.preHandle = point;
	            else
	            	ptTarget.postHandle = point;
	                
	            if( altHandle )
	            {
	            	altHandle.valueSetProgramatically = true;
	            	altHandle.x = altHandle.point.x;
	            	altHandle.y = altHandle.point.y;
	                altHandle.valueSetProgramatically = false;
	            }
            }
        }

        override public function clear () : void
        {
            graphics.clear();
        }
        
        FEATURES::MENU_CONTEXT {
            override protected function createContextMenu () : void {}
        }
    }
}

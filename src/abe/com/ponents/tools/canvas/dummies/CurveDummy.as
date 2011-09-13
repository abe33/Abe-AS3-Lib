package abe.com.ponents.tools.canvas.dummies
{
    import abe.com.patibility.serialize.SourceSerializer;
    import abe.com.edia.camera.CameraLayer;
    import abe.com.mon.colors.Color;
    import abe.com.mon.geom.FreeFormSpline;
    import abe.com.mon.geom.FreeFormSplineVertex;
    import abe.com.mon.logs.Log;
    import abe.com.mon.utils.PointUtils;
    import abe.com.patibility.lang._;
    import abe.com.ponents.builder.dialogs.PrintDialog;
    import abe.com.ponents.tools.CameraCanvas;

    import org.osflash.signals.Signal;

    import flash.display.DisplayObject;
    import flash.geom.Point;

    /**
     * @author cedric
     */
    public class CurveDummy extends AbstractDummy
    {

        protected var _dummies : Array;
        protected var _curve : FreeFormSpline;
        
        private var _x : Number;
        private var _y : Number;
        
        public var removed : Signal;
        public var repainted : Signal;
        
        public function CurveDummy ( curve : FreeFormSpline )
        {
            _defaultColor = Color.Black;
            _selectedColor = Color.Red;
            _x = _y = 0;
            _curve = curve;
            removed = new Signal();
            repainted = new Signal();
            super();
            init();
        }

        override public function remove () : void
        {
            var canvas : CameraCanvas = (parent.parent.parent as CameraCanvas);
            var index : int = canvas.getLayerDepth( parent as CameraLayer );
            var l : int = _dummies.length;
            while (--l-(-1) )
            {
                var d : CurvePointDummy = _dummies[l];
                canvas.removeBillboardLayerObject(d, index );
                canvas.removeBillboardLayerObject(d.preHandle, index );
                canvas.removeBillboardLayerObject(d.postHandle, index );
                removeDummy(d);
            }
            canvas.removeLayerObject(this, index );
            removed.dispatch( this, _curve );
            dispose();
        }
        
        override public function get x () : Number { return _x; }
        override public function set x ( value : Number ) : void {
            
            for each( var d : CurvePointDummy in _dummies )
                d.x += value - _x;
            _x = value;
        }
        override public function get y () : Number { return _y; }
        override public function set y ( value : Number
         ) : void {
            for each( var d : CurvePointDummy in _dummies )
                d.y += value - _y;
            _y = value;
        }

        override public function get hasSubObjects () : Boolean { return true; }
        override public function get isSelectable () : Boolean { return true; }
		override public function get isMovable () : Boolean { return true; }
        
        public function get dummies () : Array { return _dummies; }
        public function set dummies ( dummies : Array ) : void { _dummies = dummies; }
        
        override public function set selected ( b : Boolean ) : void {
            super.selected = b;
            for each( var d : CurvePointDummy in _dummies )
            {
                var t : uint = ( d.point as FreeFormSplineVertex ).type;
                d.visible = b;
                d.postHandle.visible = b && ( t == 2 || t == 1 );
                d.preHandle.visible = b && ( t == 2 || t == 1 );
            }
        }
        
        override public function isSubObject ( o : DisplayObject ) : Boolean
        {
            for each( var cd : CurvePointDummy in _dummies )
           	{
                if( cd == o )
                	return true;
                if( cd.preHandle == o )
                	return true;
                if( cd.postHandle == o )
                	return true;
            }
            return false;
        }

        override public function dispose () : void
        {
            super.dispose ();
            _curve = null;
            _dummies = null;
        }
        override public function init () : void
        {
            _dummies = [];
            super.init ();
            super.x = super.y = _x = _y = 0;
            
            FEATURES::MENU_CONTEXT {
                createContextMenu();
            }
        }
        FEATURES::MENU_CONTEXT {
            protected function createContextMenu () : void
		    {
                addNewContextMenuItemForGroup( _("Delete Curve"), "delete", function(... args ):void
                { 
                    remove(); 
                }, "controls" );
                addNewContextMenuItemForGroup( _("Print Curve Source"), "print", printSource, "controls" );
                addNewContextMenuItemForGroup( _("Print Curve Reflection Source"), "printReflection", printReflectionSource, "controls" );
            }
	        private function printSource (... args) : void
	        {
                var s : String = new SourceSerializer().serialize(_curve);
                Log.debug( s );
                new PrintDialog( s , _("Source")).open();
	        }
            private function printReflectionSource (... args) : void
	        {
                var s : String = new SourceSerializer(true).serialize(_curve);
                Log.debug( s);
                new PrintDialog(s, _("Reflection Source")).open();
	        }
        }
        
        public function updateCurve():void
        {
            draw();
        }
        override public function draw () : void
        {
            clear();
            if( !_curve )
            	return;
            
			_curve.draw( graphics, color );
            var l : Number = _curve.numSegments * _curve.bias;
            
            if( l == 0 )
            	return;
                
			var i : Number;


			for( i=0; i < l; i++ )
            {
                var pt1 : Point = _curve.getPathPoint( i/l );
				var pt2 : Point = _curve.getPathPoint( (i+1)/l );
                var dir : Point = pt1.subtract(pt2);
                var perp : Point = PointUtils.rotate(dir, Math.PI/2);
                perp.normalize(4);
                
				graphics.beginFill(0,0);
				graphics.moveTo( pt1.x+perp.x, pt1.y+perp.y );
				graphics.lineTo( pt2.x+perp.x, pt2.y+perp.y);
				graphics.lineTo( pt2.x-perp.x, pt2.y-perp.y);
				graphics.lineTo( pt1.x-perp.x, pt1.y-perp.y);
				graphics.lineTo( pt1.x+perp.x, pt1.y+perp.y);
                graphics.endFill();
            }
            repainted.dispatch(this,_curve);
        }
        
        private function dummyChanged ( ... args ) : void
        {
            draw();
        }
        
        public function getDummyForPoint( pt : FreeFormSplineVertex ):CurvePointDummy
        {
            for each( var d : CurvePointDummy in _dummies )
            	if( pt == d.point )
                	return d;
			return null;
        }
        public function addDummy ( o : CurvePointDummy ) : void
		{
		    if( !containsDummy( o ) )
		    {
		        _dummies.push( o );
                o.curve = this;
                o.moved.add( dummyChanged );
                ( o.point as FreeFormSplineVertex ).typeChanged.add( dummyChanged );
                o.postHandle.moved.add(dummyChanged);
                o.preHandle.moved.add(dummyChanged);
		    } 
        }
		public function removeDummy ( o : CurvePointDummy ) : void
		{
		    if( containsDummy( o ) )
		    {
                o.moved.remove( dummyChanged );
                ( o.point as FreeFormSplineVertex ).typeChanged.remove( dummyChanged );
                o.postHandle.moved.remove(dummyChanged);
                o.preHandle.moved.remove(dummyChanged);
		        _dummies.splice( findDummy( o ), 1 );
		    } 
		}
        
        public function deletePoint ( o : CurvePointDummy ) : void
        {
            var index : int = _curve.vertices.indexOf(o.point);
            removeDummy( o );
            _curve.vertices.splice(index,1);
            _curve.updateSplineData();
            draw();
            
            o.preHandle.parent.removeChild(o.preHandle);
            o.postHandle.parent.removeChild(o.postHandle);
            o.parent.removeChild(o);
        }
        
		public function containsDummy ( o : CurvePointDummy ) : Boolean { return  findDummy( o ) != -1; }

        public function findDummy ( o : CurvePointDummy ) : int
        {
            return _dummies.indexOf ( o );
        }

        public function get curve () : FreeFormSpline {
            return _curve;
        }

        public function set curve ( curve : FreeFormSpline ) : void {
            _curve = curve;
        }
    }
}

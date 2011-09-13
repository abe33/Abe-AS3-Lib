package abe.com.mon.geom
{
    import abe.com.mon.core.Serializable;

    import org.osflash.signals.Signal;

    import flash.geom.Point;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="x,y,type,preHandle,postHandle")]
    public class FreeFormSplineVertex extends Point implements Serializable
    {
        static public const CORNER 			: uint = 0;
        static public const BEZIER 			: uint = 1;
        static public const BEZIER_CORNER 	: uint = 2;
        static public const SMOOTH		 	: uint = 3;

		protected var _type : uint;
        protected var _preHandle : Point;        
        protected var _postHandle : Point; 
        
        public var typeChanged : Signal;       

        public function FreeFormSplineVertex ( 	x : Number = 0, 
        										y : Number = 0, 
                                                type : uint = 0, 
                                                preHandle : Point = null, 
                                                postHandle : Point = null )
        {
            typeChanged = new Signal();
            super ( x, y );
            _type = type;
            _preHandle = preHandle ? preHandle : pt(x,y);
            _postHandle = postHandle ? postHandle : pt(x,y);
        }

        public function get type () : uint {
            return _type;
        }

        public function set type ( type : uint ) : void {
            _type = type;
            if( _type == BEZIER )
            	preHandle = preHandle;
            
            typeChanged.dispatch(this, type);
        }

        public function get preHandle () : Point { return _preHandle; }
        public function set preHandle ( p : Point ) : void {
            switch( _type )
            {
                case BEZIER :
                	_preHandle = p;
                	var d : Point = this.subtract(_preHandle);
                	d.normalize(Point.distance(this, _postHandle));
                    _postHandle.x = x+d.x;
                    _postHandle.y = y+d.y;
                	break; 
                case SMOOTH : 
                    break;
                case CORNER:
                case BEZIER_CORNER :
                	default : 
                	_preHandle = p;
            }
        }
        
        public function get postHandle () : Point { return _postHandle; }
        public function set postHandle ( p : Point ) : void {
            switch( _type )
            {
                case BEZIER :
                	_postHandle = p;
                	var d : Point = this.subtract(_postHandle);
                	d.normalize(Point.distance(this, _preHandle));
                    _preHandle.x = x+d.x;
                    _preHandle.y = y+d.y;
                	break; 
                case SMOOTH : 
                    break;
                case CORNER:
                case BEZIER_CORNER :
                	default : 
                	_postHandle = p;
            }
        }
 
        override public function clone () : Point
        {
            return new FreeFormSplineVertex(x, y, _type, _preHandle, _postHandle);
        }
    }
}

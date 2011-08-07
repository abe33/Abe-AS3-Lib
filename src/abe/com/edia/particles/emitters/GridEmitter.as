package abe.com.edia.particles.emitters
{
    import abe.com.mon.geom.Dimension;
    import abe.com.mon.geom.pt;
    import abe.com.patibility.lang._$;

    import flash.geom.Point;
    import flash.utils.getQualifiedClassName;

    /**
     * @author cedric
     */
    public class GridEmitter implements FixedCoordsEmitter
    {
        protected var _cellSize : Dimension;
        protected var _rows : Number;
        protected var _cols : Number;
        protected var _coords : Array;
        protected var _iterator : int;
        
        public function GridEmitter ( cellSize : Dimension, rows : Number = 3, cols : Number = 3 )
        {
            _rows = rows;
            _cols = cols;
            _cellSize = cellSize;
            
            updateCount();
        }
                
        public function get coords () : Array { return _coords; }
        
        public function get cellSize () : Dimension { return _cellSize; }
        public function set cellSize ( cellSize : Dimension ) : void { _cellSize = cellSize; updateCount(); }

        public function get rows () : Number { return _rows; }
        public function set rows ( rows : Number ) : void { _rows = rows; updateCount(); }

        public function get cols () : Number { return _cols; }
        public function set cols ( cols : Number ) : void { _cols = cols; updateCount(); }

        public function get ( n : Number = NaN ) : Point
        {
            var i : int = _iterator;
            _iterator++;
            _iterator %= _coords.length;
            return _coords[ i ];
        }
        protected function updateCount():void
        {
            var l:int = _rows * _cols;
            var c : int = 0;
            var r : int = 0;
            var a : Array = [];
            for( var i : int = 0;i<l;i++)
            {
                a.push(pt( _cellSize.width * c, _cellSize.height * r ));
                c++;
                if( c >= _cols )
                {
                 	r++;
                    c = 0;   
                }
            }
            _iterator = 0;
            _coords = a;
        }
        
        public function toSource():String
        {
            return _$( "new $0($1)" , getQualifiedClassName( this ).replace("::","."), getSourceArguments() );
        }
        public function toReflectionSource():String
        {
            return _$( "new $0($1)" , getQualifiedClassName( this ).replace("::","."), getReflectionSourceArguments() );
        }
        protected function getSourceArguments():String
        {
            return [ _cellSize.toSource(), _rows, _cols ].join(", ");
        }
        protected function getReflectionSourceArguments():String
        {
            return [ _cellSize.toReflectionSource(), _rows, _cols ].join(", ");
        } 
        public function clone () : *
        {
            return new GridEmitter(_cellSize.clone(), _rows, _cols );
        }


    }
}

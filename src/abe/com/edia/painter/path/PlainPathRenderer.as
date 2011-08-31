package abe.com.edia.painter.path
{
    import abe.com.mon.colors.Color;
    import abe.com.mon.geom.Path;

    import flash.display.Graphics;
    import flash.geom.Point;

    /**
     * @author cedric
     */
    public class PlainPathRenderer implements PathRenderer
    {
        private var _color : Color;
        private var _size : uint;
        
        public function PlainPathRenderer ( color : Color, size : uint = 0 )
        {
            _color = color;
            _size = size;
        }

        public function beforePaint ( path : Path, on : Graphics ) : void
        {
        }

        public function afterPaint ( path : Path, on : Graphics ) : void
        {
        }

        public function paint ( path : Path, on : Graphics, from : Point, to : Point, fromPathPos : Number, toPathPos : Number ) : void
        {
            on.lineStyle( _size, _color.hexa, _color.alpha/255 );
            on.moveTo( from.x , from.y);
            on.lineTo( to.x, to.y );
        }
    }
}

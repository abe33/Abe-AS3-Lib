package abe.com.ponents.tools.canvas.dummies
{
    import abe.com.ponents.tools.canvas.dummies.AbstractDummy;

    /**
     * @author cedric
     */
    public class SquareDummy extends AbstractDummy
    {
        protected var _plain : Boolean;
        protected var _size : int;
        
        public function SquareDummy ( size : Number = 6 )
        {
            super ();
            _size = size;
        }

        override public function draw () : void
        {
            clear();
            graphics.beginFill(0, 0);
            graphics.drawCircle(0, 0, _size);
            graphics.endFill();
            
            if( _plain )
            	graphics.beginFill( color.hexa, 1 );
            graphics.lineStyle(0, color.hexa );
            graphics.drawRect(-_size/2, -_size/2, _size, _size );
        }
        
    }
}

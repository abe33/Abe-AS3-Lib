package abe.com.ponents.tools.canvas.dummies
{
    import flash.geom.Point;

    /**
     * @author cedric
     */
    public class DiamondDummy extends AbstractDummy
    {
        protected var _radius : Number;
        public function DiamondDummy ( pos : Point, radius : Number = 4 )
        {
            _radius = radius;
            super ();
            this.x = pos.x;
            this.y = pos.y;
            init();
        }

        override public function draw () : void
        {
            graphics.clear();
            graphics.beginFill(0, 0);
            graphics.moveTo(0, -_radius - 2 );
            graphics.lineTo(_radius+2, 0);
            graphics.lineTo(0,_radius+2);
            graphics.lineTo(-_radius-2, 0);
            graphics.lineTo(0,-_radius-2);
            graphics.endFill();
            
            graphics.lineStyle(0, _selected ? SELECTED_COLOR.hexa : DEFAULT_COLOR.hexa);
            graphics.moveTo(0, -_radius );
            graphics.lineTo(_radius, 0);
            graphics.lineTo(0,_radius);
            graphics.lineTo(-_radius, 0);
            graphics.lineTo(0,-_radius);
            
            graphics.moveTo(0, -_radius );
            graphics.lineTo(0,_radius);
            
            graphics.moveTo(-_radius, 0 );
            graphics.lineTo(_radius, 0);
        }
    }
}

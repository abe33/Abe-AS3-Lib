package abe.com.ponents.tools.canvas.dummies
{
    import abe.com.edia.bitmaps.BitmapSprite;
    import abe.com.mon.colors.Color;

    /**
     * @author cedric
     */
    public class SpriteDummy extends AbstractDummy
    {
        private var _sprite : BitmapSprite;
        public function SpriteDummy ( spr : BitmapSprite )
        {
            super ();
            _sprite = spr;
        }
        override public function draw () : void
        {
            graphics.clear();
            var c : Color = color;
            
            graphics.beginFill(0, 0);
            graphics.lineStyle(0, c.hexa, .5);
            graphics.drawRect(-_sprite.center.x, -_sprite.center.y, _sprite.area.width, _sprite.area.height);
            graphics.endFill();
            
            graphics.lineStyle(0, c.hexa);
            graphics.moveTo(-2, 0);
            graphics.lineTo(2, 0);
            
            graphics.moveTo(0,-2);
            graphics.lineTo(0,2);
        }

        override public function set x ( value : Number ) : void {
            super.x = Math.floor( value );
            _sprite.position.x = x;
        }

        override public function set y ( value : Number ) : void {
            super.y = Math.floor(value);
            _sprite.position.y = y;
        }
    }
}

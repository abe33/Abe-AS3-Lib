package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;
    import flash.geom.Rectangle;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="box")]
    public class OutOfBoxReboundActionStrategy extends AbstractActionStrategy
    {
        protected var _box : Rectangle;
        public function OutOfBoxReboundActionStrategy ( r : Rectangle )
        {
            _box = r;
        }

        public function get box () : Rectangle {return _box;}
        public function set box ( box : Rectangle ) : void {_box = box;}
        
        override public function process ( particle : Particle ) : void
        {
            if( particle.position.x < _box.left )
            {
            	particle.position.x = _box.left;
                particle.velocity.x *= -1;
            }
            else if ( particle.position.x > _box.right )
            {
            	particle.position.x = _box.right;
                particle.velocity.x *= -1;
            }
            
            if( particle.position.y < _box.top )
            {
            	particle.position.y = _box.top;
                particle.velocity.y *= -1;
            }
            else if ( particle.position.y > _box.bottom )
            {
            	particle.position.y = _box.bottom;
                particle.velocity.y *= -1;
            }
        }
    }
}

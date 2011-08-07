package abe.com.edia.particles.actions
{
	import abe.com.edia.particles.core.Particle;
	import abe.com.mon.geom.pt;
	import flash.geom.Point;

    /**
     * @author cedric
     */
    public class FollowTargetActionStrategy extends AbstractActionStrategy
    {
        protected var _target : Object;
        protected var _position : Point;
        protected var _influence : Number;
        
        public function FollowTargetActionStrategy ( target : Object, influence : Number = 400 )
        {
            this.target = target;
            _influence = influence;
        }

		public function get target () : Object { return _target; }
        public function set target ( target : Object ) : void {
            if( !target.hasOwnProperty("x") || !target.hasOwnProperty("y") )
            	throw new Error("Target object must have both x and y properties.");
            
            _target = target;
        }

        override public function prepare ( bias : Number, biasInSecond : Number, currentTime : Number ) : void
        {
            _position = pt( _target.x, _target.y ); 
            super.prepare ( bias, biasInSecond, currentTime );
        }

        override public function process ( particle : Particle ) : void
        {
            var d : Point = _position.subtract(particle.position);
            var l : Number = particle.velocity.length;
            var l2 : Number = d.length;
            
	        particle.velocity.x += d.x * _nTimeStep * ( 1 / ( d.length/_influence ) );
	        particle.velocity.y += d.y * _nTimeStep * ( 1 / ( d.length/_influence ) );
            particle.velocity.normalize( l );
            
        }
    }
}

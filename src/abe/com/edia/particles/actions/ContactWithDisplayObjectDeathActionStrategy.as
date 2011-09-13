package abe.com.edia.particles.actions
{
    import abe.com.edia.particles.core.Particle;

    import flash.display.DisplayObject;
    /**
     * @author cedric
     */
    [Serialize(constructorArgs="displayObject")]
    public class ContactWithDisplayObjectDeathActionStrategy extends AbstractActionStrategy
    {
        protected var _displayObject : DisplayObject;
        
        public function ContactWithDisplayObjectDeathActionStrategy ( displayObject : DisplayObject = null )
        {
            _displayObject = displayObject;
        }

        override public function process ( particle : Particle ) : void
        {
            if( particle.hasParasite("contactDisplayObject") )
            {
                if( ( particle.getParasite("contactDisplayObject") as DisplayObject).hitTestPoint( particle.position.x, particle.position.y ) )
                	particle.die();
            }
            else if( _displayObject && _displayObject.hitTestPoint( particle.position.x, particle.position.y ) )
            	particle.die();
        }
    }
}

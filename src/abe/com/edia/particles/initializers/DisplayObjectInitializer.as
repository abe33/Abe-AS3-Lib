package abe.com.edia.particles.initializers
{
    import abe.com.edia.particles.core.DisplayObjectParticle;
    import abe.com.edia.particles.core.Particle;
    import abe.com.patibility.lang._;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
	
    [Serialize(constructorArgs="factory,parent,defaults,method")]
	public class DisplayObjectInitializer extends AbstractInitializer
	{
		static public const BACK : uint = 0;
		static public const FRONT : uint = 1;
		
		protected var _factory : Function;
		protected var _parent : DisplayObjectContainer;
        protected var _method : uint;
        protected var _defaults : Object;
		
		public function DisplayObjectInitializer ( factory : Function, 
        										   doParent : DisplayObjectContainer, 
                                                   defaults : Object = null,
                                                   method : uint = FRONT )
		{
			_factory = factory;
			_parent = doParent;
			_method = method;
            _defaults = defaults;
		} 
		
		override public function initialize( particle : Particle ) : void
		{
			var doObj : DisplayObject = _factory(particle) as DisplayObject;
            
            if( !doObj )
            	throw new Error(_("The provided factory function doesn't return a DisplayObject"));
			
            for( var i : String in _defaults )
            	if( doObj.hasOwnProperty( i ) )
                	doObj[i] = _defaults[i];
            
			( particle as DisplayObjectParticle ).displayObject = doObj;
            
			
			switch ( _method )
			{
				case BACK : 
                	_parent.addChildAt( doObj, 0 ); break;
				case FRONT :
                default :  
                	_parent.addChild( doObj ); break;
            }
        }

        public function get factory () : Function {
            return _factory;
        }

        public function set factory ( factory : Function ) : void {
            _factory = factory;
        }

        public function get parent () : DisplayObjectContainer {
            return _parent;
        }

        public function set parent ( parent : DisplayObjectContainer ) : void {
            _parent = parent;
        }

        public function get method () : uint {
            return _method;
        }

        public function set method ( method : uint ) : void {
            _method = method;
        }

        public function get defaults () : Object {
            return _defaults;
        }

        public function set defaults ( defaults : Object ) : void {
            _defaults = defaults;
        }
	}
}
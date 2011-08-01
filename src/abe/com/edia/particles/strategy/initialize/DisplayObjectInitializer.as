package abe.com.edia.particles.strategy.initialize
{
    import abe.com.edia.particles.core.DisplayObjectParticle;
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.utils.getReflectionSource;
    import abe.com.mon.utils.getSource;
    import abe.com.mon.utils.magicToReflectionSource;
    import abe.com.mon.utils.magicToSource;
    import abe.com.patibility.lang._;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;

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
			var doObj : DisplayObject = _factory() as DisplayObject;
            
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

        override protected function getSourceArguments () : String
        {
            return [ getSource( _factory, "${graphicFactory}" ), 
            		 getSource( _parent, "${container}" ), 
                     magicToSource( _defaults ), 
                     _method ].join(", ");
        }

        override protected function getReflectionSourceArguments () : String
        {
            return [ getReflectionSource( _factory, "${graphicFactory}" ), 
            		 getReflectionSource( _parent, "${container}" ), 
                     magicToReflectionSource( _defaults ), 
                     _method ].join(", ");
        }

	}
}
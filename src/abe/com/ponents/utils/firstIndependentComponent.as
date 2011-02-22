package abe.com.ponents.utils
{
	import abe.com.ponents.core.Component;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;


	/**
	 * @author cedric
	 */
	public function firstIndependentComponent ( d : DisplayObject ) : Component
	{
		if( d && d is Component && (d as Component).isComponentIndependent )
			return d as Component;
		
		var p : DisplayObjectContainer;
		do
		{
			p = d.parent;
			
			if( p && p is Component && (p as Component).isComponentIndependent )
				return p as Component;
				
			d = p;
		}
		while( p );
		
		return null;
	}
}

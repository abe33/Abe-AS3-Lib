package aesia.com.ponents.layouts.components.splits 
{
	import aesia.com.ponents.core.Component;

	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	public class Leaf extends Node 
	{
		public var component : Component;
		
		public function Leaf ( component : Component, weight : Number = 1 )
		{
			super( );
			this.component = component;
			this.weight = weight;
		}

		override public function get bounds () : Rectangle
		{
			return this.component.getBounds( this.component.parent );
		}
	}
}

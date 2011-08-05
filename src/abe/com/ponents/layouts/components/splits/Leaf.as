package abe.com.ponents.layouts.components.splits 
{
	import abe.com.mon.utils.StringUtils;
	import abe.com.ponents.core.Component;

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
		public function toString() : String {
			return StringUtils.stringify( this, {'component':component});
		}
	}
}

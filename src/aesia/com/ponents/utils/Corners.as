package aesia.com.ponents.utils 
{
	import aesia.com.mon.core.Serializable;
	import aesia.com.mon.core.Equatable;
	import aesia.com.mon.core.Cloneable;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Cédric Néhémie
	 */
	public class Corners implements Cloneable, Equatable, Serializable
	{
		public var topLeft : Number;		public var topRight : Number;
		public var bottomLeft : Number;		public var bottomRight : Number;

		public function Corners ( topLeft : Number = 0, topRight : Number = 0, bottomLeft : Number = 0, bottomRight : Number = 0 )
		{
			if( arguments.length == 1 )
			{
				this.topLeft = this.topRight = this.bottomLeft = this.bottomRight = topLeft; 
			}
			else
			{
				this.topLeft = topLeft;
				this.topRight = topRight;
				this.bottomLeft = bottomLeft;
				this.bottomRight = bottomRight;
			}
		}
		public function toString() : String 
		{
			return getQualifiedClassName(this)+"("+topLeft+","+topRight+","+bottomLeft+","+bottomRight+")";
		}
		public function clone () : *
		{
			return new Corners(topLeft, topRight, bottomLeft, bottomRight);
		}
		public function toSource () : String
		{
			return toReflectionSource().replace("::", ".");
		}
		public function toReflectionSource () : String
		{
			return "new " + getQualifiedClassName(this)+"("+topLeft+","+topRight+","+bottomLeft+","+bottomRight+")";
		}
		public function equals (o : *) : Boolean
		{
			if( o is Corners )
			{
				var i : Corners = o as Corners;
				
				return 	i.topLeft == topLeft && 
						i.topRight == topRight && 
						i.bottomLeft == bottomLeft && 
						i.bottomRight == bottomRight;
			}
			return false;
		}
	}
}

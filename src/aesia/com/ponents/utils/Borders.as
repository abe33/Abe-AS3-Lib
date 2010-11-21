package aesia.com.ponents.utils 
{
	import aesia.com.mon.core.Cloneable;
	import aesia.com.mon.core.Equatable;
	import aesia.com.mon.core.Serializable;

	import flash.utils.getQualifiedClassName;

	/**
	 * @author Cédric Néhémie
	 */
	public class Borders implements Cloneable, Serializable, Equatable
	{
		public var left : Number;
		public var right : Number;
		public var top : Number;
		public var bottom : Number;
		
		public function Borders ( left : Number = 1, top : Number = 1, right : Number = 1, bottom : Number = 1 )
		{
			if( arguments.length == 1 )
			{
				this.left = this.right = this.top = this.bottom = left;
			}
			else
			{
				this.left = left;
				this.right = right;
				this.top = top;
				this.bottom = bottom;
			}
		}
		public function get horizontal () : Number
		{
			return left + right;
		}
		public function get vertical () : Number
		{
			return top + bottom;
		}
		public function toString() : String 
		{
			return getQualifiedClassName(this)+"("+left+","+top+","+right+","+bottom+")";
		}
		
		public function clone () : *
		{
			return new Borders(left, top, right, bottom);
		}
		public function toSource () : String
		{
			return toReflectionSource().replace("::", ".");
		}
		
		public function toReflectionSource () : String
		{
			return "new " + getQualifiedClassName(this)+"("+left+","+top+","+right+","+bottom+")";
		}
		
		public function equals (o : *) : Boolean
		{
			if( o is Borders )
			{
				var i : Borders = o as Borders;
				return 	i.top == top && 
						i.left == left && 
						i.right == right && 
						i.bottom == bottom;
			}
			return false;
		}
	}
}

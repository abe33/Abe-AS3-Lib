/**
 * @license
 */
package abe.com.ponents.utils 
{
	import abe.com.mon.core.Cloneable;
	import abe.com.mon.core.Equatable;
	import abe.com.mon.core.Serializable;

	import flash.utils.getQualifiedClassName;
	/**
	 * @author Cédric Néhémie
	 */
	public class Insets implements Cloneable, Serializable, Equatable
	{
		public var left : Number;		public var right : Number;		public var top : Number;		public var bottom : Number;
		
		public function Insets ( left : Number = 0, top : Number = 0, right : Number = 0, bottom : Number = 0 )
		{
			if( arguments.length == 1 )
			{
				this.left = this.right = this.top = this.bottom = left;
			}
			else if( arguments.length == 2 )
			{
				this.left = this.right = left;
				this.top = this.bottom = top;
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
			return new Insets(left, top, right, bottom );
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
			if( o is Insets )
			{
				var i : Insets = o as Insets;
				return 	i.top == top && 
						i.left == left && 
						i.right == right && 
						i.bottom == bottom;
			}
			return false;
		}
	}
}

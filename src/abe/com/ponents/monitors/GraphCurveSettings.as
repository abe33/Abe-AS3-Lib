package abe.com.ponents.monitors 
{
	import abe.com.mon.colors.Color;

	/**
	 * @author Cédric Néhémie
	 */
	public class GraphCurveSettings 
	{
		public var color : Color;
		public var size : Number;
		public var filled : Boolean;
		public var name : String;
		public var visible : Boolean;
		
		public function GraphCurveSettings ( name : String, color : Color = null, size : Number = 0, filled : Boolean = false )
		{
			this.color = color;
			this.size = size;
			this.filled = filled;
			this.name = name;
			this.visible = true;
		}
	}
}

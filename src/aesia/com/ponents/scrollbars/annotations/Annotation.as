package aesia.com.ponents.scrollbars.annotations
{
	import aesia.com.mon.utils.Color;
	/**
	 * @author Cédric Néhémie
	 */
	public class Annotation
	{
		public var position : Number;
		public var type : String;
		public var label : String;
		public var color : Color;

		public function Annotation ( position : Number, label : String, type : String, color : Color = null )
		{
			this.position = position;
			this.label = label;
			this.type = type;
			this.color = color ? color : Color.Yellow;
		}
	}
}

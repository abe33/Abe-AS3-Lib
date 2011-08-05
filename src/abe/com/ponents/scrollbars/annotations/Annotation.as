package abe.com.ponents.scrollbars.annotations
{
    import abe.com.mon.colors.Color;
    import abe.com.mon.utils.StringUtils;
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
        public function toString() : String 
        {
            return StringUtils.stringify(this,{'type':type,'position':position});
        }
	}
}

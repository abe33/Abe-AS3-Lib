package abe.com.ponents.forms 
{

	/**
	 * @author Cédric Néhémie
	 */
	public class FormCategory 
	{
		public var fields : Array;
		public var name : String;
		public var order : Number;
		
		public function FormCategory ( name : String, fields : Array = null, order : Number = NaN )
		{
			this.name = name;
			this.fields = fields ? fields : [];
			this.order = order;
		}
	}
}

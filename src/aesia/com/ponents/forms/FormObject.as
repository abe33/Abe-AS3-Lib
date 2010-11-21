package aesia.com.ponents.forms 
{

	/**
	 * @author Cédric Néhémie
	 */
	public class FormObject 
	{
		public var target : *;
		public var fields : Array;		public var categories : Array;
		
		public function FormObject ( target : *, fields : Array, categories : Array = null )
		{
			this.target = target;
			this.fields = fields;
			this.categories = categories;
		}
		public function get hasCategories () : Boolean
		{
			return categories && categories.length > 0;
		}
	}
}

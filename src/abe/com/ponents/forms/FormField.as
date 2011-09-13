package abe.com.ponents.forms 
{
    import abe.com.ponents.core.Component;
	/**
	 * @author Cédric Néhémie
	 */
	public class FormField 
	{
		public var name : String;
		public var memberName : String;
		public var component : Component;
		public var order : Number;
		public var type : Class;
		public var description : String;

		public function FormField ( name : String, memberName : String, component : Component, order : Number, type : Class, description : String = "" )
		{
			this.name = name;
			this.memberName = memberName;
			this.component = component;
			this.order = order;
			this.type = type;
			this.description = description;
		}

		public function toString() : String {
			return "[object FormField("+name+","+component+","+order+")]";
		}
	}
}

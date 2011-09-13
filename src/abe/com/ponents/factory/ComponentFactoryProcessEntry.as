package abe.com.ponents.factory 
{
    import abe.com.mon.utils.StringUtils;
	/**
	 * @author cedric
	 */
	public class ComponentFactoryProcessEntry 
	{
		public var id : String;
		public var clazz : Class;
		public var args : *;
		public var kwargs : *;
		public var kwargsOrder : Array;
		public var callback : Function;

		public function ComponentFactoryProcessEntry ( clazz : Class, 
													   id : String = null, 
													   args : * = null, 
													   kwargs : * = null, 
													   callback : Function = null, 
													   kwargsOrder : Array = null) 
		{
			this.clazz = clazz;
			this.id = id;
			this.args = args;
			this.kwargs = kwargs;
			this.callback = callback;
			this.kwargsOrder = kwargsOrder;
		}
		public function toString() : String 
		{
			return StringUtils.stringify( this, {"clazz":clazz,"args":args,"kwargs":kwargs,"callback":callback,"kwargsOrder":kwargsOrder } );
		}
	}
}

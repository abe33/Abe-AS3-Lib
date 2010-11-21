package aesia.com.ponents.factory 
{
	import aesia.com.patibility.lang._$;
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
			return _$("<b>ComponentFactoryProcessEntry.&lt;$0&gt;</b>\n<b>id :</b>$1\n<b>args :</b>$2\n<b>kwargs :</b>$3\n<b>callback :</b>$4\n<b>kwargsOrder :</b>$5",
					   clazz,
					   id,
					   args,
					   kwargs,
					   callback,
					   kwargsOrder );
		}
	}
}

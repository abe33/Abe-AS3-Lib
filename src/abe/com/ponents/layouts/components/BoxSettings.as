package abe.com.ponents.layouts.components 
{
	import abe.com.ponents.core.Component;

	/**
	 * @author Cédric Néhémie
	 */
	public class BoxSettings 
	{
		public var size : Number;
		public var halign : String;
		public var valign : String;
		public var object : Component;
		public var fitH : Boolean;		public var fitW : Boolean;
		public var stretch : Boolean;
		
		public function BoxSettings ( size : Number, 
									  halign : String = "left", 
									  valign : String = "center", 
									  object : Component = null, 
									  fitW : Boolean = false,
									  fitH : Boolean = false,
									  stretch : Boolean = false )
		{
			this.size = size;
			this.halign = halign;
			this.valign = valign;
			this.object = object;
			this.fitH = fitH;			this.fitW = fitW;
			this.stretch = stretch;
		}
	}
}

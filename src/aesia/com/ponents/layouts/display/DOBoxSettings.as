package aesia.com.ponents.layouts.display
{
	import aesia.com.mon.utils.StringUtils;

	import flash.display.DisplayObject;
	/**
	 * @author Cédric Néhémie
	 */
	public class DOBoxSettings
	{
		public var size : Number;
		
		public var halign : String;
		public var valign : String;
		public var object : DisplayObject;
		public var fitH : Boolean;
		public var fitW : Boolean;
		public var stretch : Boolean;

		public function DOBoxSettings ( size : Number,
									  halign : String = "left",
									  valign : String = "center",
									  object : DisplayObject = null,
									  fitW : Boolean = false,
									  fitH : Boolean = false,
									  stretch : Boolean = false )
		{
			this.size = size;
			this.halign = halign;
			this.valign = valign;
			this.object = object;
			this.fitH = fitH;
			this.fitW = fitW;
			this.stretch = stretch;
		}
		public function toString() : String 
		{
			return StringUtils.stringify(this, {
												'size':size,
												'halign':halign,
												'valign':valign, 
												'fitW':fitW, 
												'fitH':fitH,
												'stretch':stretch,
												'object':object 
											   } );
		}
	}
}

/**
 * @license
 */
package abe.com.edia.text.builds 
{
	import abe.com.edia.text.fx.CharEffect;

	public class BuildContext 
	{
		//public var format : TextFormat;
		public var effects : Vector.<CharEffect>;
		public var filters : Array;
		public var link : String;
		public var align : String;		public var embedFonts : Boolean;		public var cacheAsBitmap : Boolean;
		public var backgroundColor : Number;
		
		public function BuildContext ()
		{
			effects = new Vector.<CharEffect> ();
			filters = new Array();
			align = "left";
		}	
	}
}

package abe.com.ponents.layouts.components 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.utils.Alignments;
	import abe.com.ponents.utils.Insets;
	/**
	 * @author cedric
	 */
	public class ColumnSettings 
	{
		public var halign : String;		public var valign : String;
		/*FDT_IGNORE*/
		TARGET::FLASH_9		public var components : Array;
				TARGET::FLASH_10		public var components : Vector.<Component>;
		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/		public var components : Vector.<Component>;
		
		public var gap : Number;
		public var stretch : Boolean;

		public function ColumnSettings ( halign : String = "left", valign : String = "top", gap : Number = 3, stretch : Boolean = false, ... comps ) 
		{
			this.halign = halign;
			this.valign = valign;
			this.stretch = stretch;
			this.gap = gap;
			
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { this.components = [];}			TARGET::FLASH_10 { this.components = new Vector.<Component>();}			TARGET::FLASH_10_1 {
			/*FDT_IGNORE*/
			this.components = new Vector.<Component>();/*FDT_IGNORE*/}/*FDT_IGNORE*/
			
			if( comps.length > 0 )
			{
				var l : int = comps.length;
				for( var i : int = 0; i<l; i++ )
					components.push( comps[i] );
			}
		}
		public function layout ( x : Number = 0, y : Number = 0, w : Number = 0, h : Number = 0, href : Number = 0 ) : void
		{
			var l : int = components.length;
			var i : int;
			var c : Component;
			
			for(i=0;i<l;i++)
			{
				c = components[i];	
				c.x = x + Alignments.alignHorizontal( c.width, w, new Insets(), halign );
				c.y = y + Alignments.alignVertical( h, href, new Insets(), valign);
				y += c.height + gap;
			}
		}
		public function get preferredSize () : Dimension
		{
			var w : Number = 0;
			var h : Number = 0;
			var l : int = components.length;
			var i : int;
			var c : Component;
			for(i=0;i<l;i++)
			{
				c = components[i];	
				w = Math.max( w, c.preferredWidth );
				h += c.preferredHeight;
				if( i != 0 )
					h += gap;	
			}
			
			return new Dimension( w, h );
		}
	}
}

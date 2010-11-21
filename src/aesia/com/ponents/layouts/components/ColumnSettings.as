package aesia.com.ponents.layouts.components 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.utils.Alignments;
	import aesia.com.ponents.utils.Insets;

	/**
	 * @author cedric
	 */
	public class ColumnSettings 
	{
		public var halign : String;		public var valign : String;
		public var components : Vector.<Component>;
		public var gap : Number;
		public var stretch : Boolean;

		public function ColumnSettings ( halign : String = "left", valign : String = "top", gap : Number = 3, stretch : Boolean = false, ... comps ) 
		{
			this.halign = halign;
			this.valign = valign;
			this.stretch = stretch;
			this.gap = gap;
			this.components = new Vector.<Component>();
			
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

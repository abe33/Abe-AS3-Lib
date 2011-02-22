package abe.com.ponents.layouts.components 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.core.Container;
	import abe.com.ponents.utils.Insets;
	/**
	 * @author cedric
	 */
	public class ColumnsLayout extends AbstractComponentLayout 
	{
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		protected var _columns : Array;		
		TARGET::FLASH_10		protected var _columns : Vector.<ColumnSettings>;		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/		protected var _columns : Vector.<ColumnSettings>;
		
		protected var _gap : Number;

		public function ColumnsLayout (container : Container = null, gap : Number = 3, ... columns )
		{
			super( container );
			this._gap = gap;
			
			/*FDT_IGNORE*/
			TARGET::FLASH_9 {this._columns = []; }			TARGET::FLASH_10 {this._columns = new Vector.<ColumnSettings>();}			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			this._columns = new Vector.<ColumnSettings>(); /*FDT_IGNORE*/}/*FDT_IGNORE*/
			
			if( columns.length > 0 )
			{
				var l : int = columns.length;
				for(var i:int=0;i<l;i++)
					_columns.push( columns[i] );
			}
		}

		override public function get preferredSize () : Dimension {	return estimateSize(); }

		override public function layout (preferredSize : Dimension = null, insets : Insets = null) : void 
		{
			insets = insets ? insets : new Insets();
			
			var innerPref : Dimension = estimateSize();
			var prefDim : Dimension = preferredSize ? preferredSize : innerPref.grow( insets.horizontal, insets.vertical );
			var x : Number = insets.left;
			var y : Number = insets.top;
			var l : Number = _columns.length;
			var i : Number = 0;
			var c : ColumnSettings;
			var s : Dimension;
			var dif : Number = prefDim.width - innerPref.width;
			var r : Number = 0;
			var perColumnRest : Number;
			
			for(i=0;i<l;i++)
			{
				c = _columns[i];
				if( c.stretch )
					r++;
			}
			
			perColumnRest = dif/r;
			
			
			for(i=0;i<l;i++)
			{
				c = _columns[i];
				s = c.preferredSize;
				if( c.stretch )
					s.width += perColumnRest;
				
				c.layout(x, y, s.width, s.height, prefDim.height );
				x += s.width + _gap;
			}
		}
		
		protected function estimateSize () : Dimension 
		{
			var w : Number = 0;
			var h : Number = 0;
			var l : int = _columns.length;
			var i : int;
			var c : ColumnSettings;
			for(i=0;i<l;i++)
			{
				c = _columns[i];	
				var s : Dimension = c.preferredSize;
				h = Math.max( h, s.height );
				w += s.width;
				if( i != 0 )
					w += _gap;	
			}
			
			return new Dimension( w, h );
		}
	}
}

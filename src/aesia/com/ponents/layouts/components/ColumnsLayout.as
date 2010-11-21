package aesia.com.ponents.layouts.components 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.core.Container;
	import aesia.com.ponents.utils.Insets;

	/**
	 * @author cedric
	 */
	public class ColumnsLayout extends AbstractComponentLayout 
	{
		protected var _columns : Vector.<ColumnSettings>;
		protected var _gap : Number;

		public function ColumnsLayout (container : Container = null, gap : Number = 3, ... columns )
		{
			super( container );
			this._gap = gap;
			this._columns = new Vector.<ColumnSettings>();
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

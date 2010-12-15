package aesia.com.ponents.layouts.components 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.core.Container;
	import aesia.com.ponents.utils.Insets;

	/**
	 * @author Cédric Néhémie
	 */
	public class GridLayout extends AbstractComponentLayout 
	{
		protected var _rows : Number;		protected var _cols : Number;		protected var _hgap : Number;		protected var _vgap : Number;
		
		public function GridLayout ( 	container : Container = null, 
										rows : Number = 1, 
										cols : Number = 1, 
										hgap : Number = 3, 
										vgap : Number = 3 )
		{
			super( container );
			_rows = rows;
			_cols = cols;
			_hgap = hgap;
			_vgap = vgap;
		}

		override public function get preferredSize () : Dimension { return estimatedSize (); }
		
		override public function layout ( preferredSize : Dimension = null, insets : Insets = null ) : void
		{
			insets = insets ? insets : new Insets();
			var innerPref : Dimension = estimatedSize();
			var prefDim : Dimension = preferredSize ? preferredSize : innerPref.grow( insets.horizontal, insets.vertical );
			
			var cols : Number = _cols;			var rows : Number = _rows;
			if( isNaN( rows ) )
				rows = Math.ceil( _container.childrenCount / _cols );
			else if( _container.childrenCount > _cols * _rows )
				cols = Math.ceil( _container.childrenCount / _rows );
			
			var cellWidth : Number = ( prefDim.width - ( _hgap * ( cols-1 ) ) - insets.horizontal ) / cols;			var cellHeight : Number = ( prefDim.height - ( _vgap * ( rows-1 ) ) - insets.vertical ) / rows;
			
			var l : Number = _container.childrenCount;
			var i : Number = 0;
			var c : Component;
			
			var row : Number = 0;
			var col : Number = 0;
			
			var x : Number = insets.left;
			var y : Number = insets.top;
			
			for(i=0;i<l;i++)
			{
				c = _container.children[i];
				
				c.size = new Dimension( cellWidth, cellHeight );
				c.x = x;
				c.y = y;
				
				col++;
				x += cellWidth + _hgap;
				
				if( col >= cols )
				{
					col = 0;
					x = insets.left;
					
					row++;
					y += cellHeight + _vgap;
				}
			}
			super.layout( preferredSize, insets );		}

		public function estimatedSize () : Dimension
		{
			var width : Number;
			var height : Number;
			var maxSize : Dimension = maxComponentSize();
			
			var cols : Number = _cols;			var rows : Number = _rows;
			if( isNaN( rows ) )
				rows = Math.ceil( _container.childrenCount / _cols );
			else 
			if( _container.childrenCount > _cols * _rows )
				cols = Math.ceil( _container.childrenCount / _rows );
			
			width = maxSize.width * cols + _hgap * (cols-1);			height = maxSize.height * rows + _vgap * (rows-1);
			
			return new Dimension( width, height );
		}
		protected function maxComponentSize () : Dimension
		{
			var l : Number = _container.childrenCount;
			var i : Number = 0;
			var c : Component;
			var maxWidth : Number = 0;
			var maxHeight : Number = 0;
			
			for(i=0;i<l;i++)
			{
				c = _container.children[i];
				maxWidth = Math.max( maxWidth, c.preferredSize.width );
				maxHeight = Math.max( maxHeight, c.preferredSize.height );
			}
			
			return new Dimension( maxWidth, maxHeight );
		}
	}
}

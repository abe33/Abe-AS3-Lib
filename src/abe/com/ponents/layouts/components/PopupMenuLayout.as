package abe.com.ponents.layouts.components 
{
    import abe.com.mon.geom.Dimension;
    import abe.com.ponents.core.Container;
    import abe.com.ponents.menus.MenuItem;
    import abe.com.ponents.utils.Insets;
	/**
	 * @author Cédric Néhémie
	 */
	public class PopupMenuLayout extends AbstractComponentLayout 
	{
		protected var _gap : Number;
	
		public function PopupMenuLayout (container : Container = null, gap : Number = 0 )
		{
			super( container );
			_gap = gap;
		}
		
		public function get gap () : Number { return _gap; }		
		public function set gap (gap : Number) : void
		{
			_gap = gap;
		}
		
		override public function get preferredSize () : Dimension { return estimatedSize (); }
		
		override public function layout (preferredSize : Dimension = null, insets : Insets = null) : void
		{
			insets = insets ? insets : new Insets();
			
			var innerPref : Dimension = estimatedSize();
			var prefDim : Dimension = preferredSize ? preferredSize.grow( -insets.horizontal, -insets.vertical ) : innerPref;
			var i : Number; 
			var item : MenuItem;
			var l : Number = _container.childrenCount;
			var y : Number = 0;
			
			for( i = 0; i < l; i++ )
			{
				item = _container.children[i] as MenuItem;
				item.width = prefDim.width;
				item.y = insets.top + y;
				item.x = insets.left;
				y += item.preferredSize.height + _gap;
			}
			super.layout( preferredSize, insets );
		}
		
		protected function harmonizeBoxesSize () : void
		{
			var i : Number; 
			var j : Number; 
			var item : MenuItem;
			var l : Number = _container.childrenCount;
			var m : Number;
			var a : Array = [];
					
			for( i = 0; i < l; i++ )
			{
				item = _container.children[i] as MenuItem;	
				var c : Array = item.columnsSizes;
				m = c.length;		
				
				for( j=0; j<m;j++ )
					a[ j ] = isNaN( a[ j ] ) ? c[j] : Math.max( a[ j ], c[ j ] );
				
			}
			for( i = 0; i < l; i++ )
			{
				item = _container.children[i] as MenuItem;
				item.columnsSizes = a;
			}
		}
	
		public function estimatedSize () : Dimension
		{
			harmonizeBoxesSize ();
			
			var i : Number; 
			var item : MenuItem;
			var l : Number = _container.childrenCount;
			var w : Number = 0;
			var h : Number = 0;
			
			for( i = 0; i < l; i++ )
			{
				item = _container.children[i] as MenuItem;	
				var d : Dimension = item.preferredSize;
				h += d.height;
				w = Math.max( item.preferredWidth, w );
			}
			h += _gap * ( l-1 );
			return new Dimension( w, h );
		}
	}
}

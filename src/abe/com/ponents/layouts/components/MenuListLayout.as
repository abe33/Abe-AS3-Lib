package abe.com.ponents.layouts.components 
{
    import abe.com.mon.geom.Dimension;
    import abe.com.ponents.lists.List;
    import abe.com.ponents.menus.MenuItem;
	/**
	 * @author Cédric Néhémie
	 */
	public class MenuListLayout extends OldListLayout 
	{
		protected var _lastBoxesSize : Array;
		public function MenuListLayout (container : List = null, gap : Number = 0, fixedHeight : Boolean = true)
		{
			super( container, gap, fixedHeight );
		}
		public function harmonizeBoxesSize () : void
		{
			if( _list.model )
			{
				var i : Number; 
				var j : Number; 
				var item : MenuItem;
				var l : Number = _list.model.size;
				var m : Number;
				var a : Array = [];
						
				for( i = 0; i < l; i++ )
				{
					item = _list.model.getElementAt(i) as MenuItem;	
					var c : Array = item.columnsSizes;
					m = c.length;		
					
					for( j=0; j<m;j++ )
						a[ j ] = isNaN( a[ j ] ) ? c[j] : Math.max( a[ j ], c[ j ] );
					
				}
				
				_lastBoxesSize = a;
				( _list.sampleCell as MenuItem ).columnsSizes = _lastBoxesSize;
				for( i = 0; i < l; i++ )
				{
					item = _list.model.getElementAt(i) as MenuItem;
					item.columnsSizes = _lastBoxesSize;
				}
			}
		}
		override public function estimatedSize () : Dimension
		{
			harmonizeBoxesSize();
			return super.estimatedSize();
		}
	}
}

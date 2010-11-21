/**
 * @license
 */
package aesia.com.ponents.layouts.components 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.lists.List;
	import aesia.com.ponents.lists.ListCell;
	import aesia.com.ponents.utils.Insets;

	import flash.geom.Point;

	/**
	 * @author Cédric Néhémie
	 */
	public class OldListLayout extends AbstractComponentLayout 
	{
		protected var _gap : Number;
		protected var _list : List;
		protected var _estimatedLocations : Vector.<Point>;
		protected var _lastEstimatedSize : Dimension;
		protected var _modelHasChanged : Boolean;
		protected var _fixedHeight : Boolean;
		protected var _lastPreferredCellHeight : Number;

		public function OldListLayout (container : List = null, gap : Number = 0, fixedHeight : Boolean = true )
		{
			super( container );
			_list = container;
			_gap = gap;
			_fixedHeight = fixedHeight;
			_estimatedLocations = new Vector.<Point>();
		}
		
		public function get gap () : Number { return _gap; }		
		public function set gap (gap : Number) : void
		{
			_gap = gap;
		}
		
		override public function get preferredSize () : Dimension { return estimatedSize (); }
		public function get fixedHeight () : Boolean { return _fixedHeight; }		public function set fixedHeight ( b : Boolean ) : void { _fixedHeight = b; }
		public function get lastEstimatedSize () : Dimension { return _lastEstimatedSize; }
		public function get lastPreferredCellHeight () : Number { return _lastPreferredCellHeight; }		public function set lastPreferredCellHeight  ( n : Number ) : void 
		{ 
			_lastPreferredCellHeight = n;
		}
		
		override public function layout (preferredSize : Dimension = null, insets : Insets = null) : void
		{
			insets = insets ? insets : new Insets();
						
			var prefDim : Dimension = preferredSize ? preferredSize.grow( -insets.horizontal, -insets.vertical ) : estimatedSize();
			var i : Number; 
			var item : ListCell;
			var l : Number = _container.childrenCount;
			for( i = 0; i < l; i++ )
			{
				item = _container.children[i] as ListCell;
				var p : Point = getLocationAt( item.index );
				if( !_fixedHeight )
					item.size = new Dimension( prefDim.width, item.preferredSize.height );
				else
					item.size = new Dimension( prefDim.width, _lastPreferredCellHeight );
				item.y = insets.top + p.y;
				item.x = insets.left + p.x;			}
			dispatchEvent( new ComponentEvent( ComponentEvent.LAYOUT ) );
		}
		
		public function addComponent ( id : int ) : void
		{
			if( !_lastEstimatedSize )
				_lastEstimatedSize = estimatedSize();
			
			var d : Dimension = _list.getItemPreferredSize( id );
				
			if( _fixedHeight )
			{
				_lastPreferredCellHeight = Math.max( d.height, _lastPreferredCellHeight ); 
				_lastEstimatedSize.height += _lastPreferredCellHeight;				_lastEstimatedSize.width = Math.max( d.width, _lastEstimatedSize.width );
			}
			else
			{
				_estimatedLocations.push( new Point(0, _lastEstimatedSize.height) );
				
				_lastEstimatedSize.height += d.height;
				_lastEstimatedSize.width = Math.max( d.width, _lastEstimatedSize.width );
			}
		}
		public function addComponents ( ids : Array ) : void
		{
			if( !_lastEstimatedSize )
				_lastEstimatedSize = estimatedSize();
				
			if( _fixedHeight )
			{
				_lastEstimatedSize.height += _lastPreferredCellHeight*ids.length;
			}
			else
			{
				var l : Number = ids.length;
				var i : Number;
				for (i=0;i<l;i++)
				{
					var d : Dimension = _list.getItemPreferredSize( ids[i] );
					_lastEstimatedSize.height += d.height;
					_lastEstimatedSize.width = Math.max( d.width, _lastEstimatedSize.width );
				}
			}
		}
		public function addNComponents ( n : uint ) : void
		{
			if( _fixedHeight )
			{
				_lastEstimatedSize.height += _lastPreferredCellHeight * n;
			}
		}
		public function removeNComponents ( n : uint ) : void
		{
			if( _fixedHeight )
			{
				_lastEstimatedSize.height -= _lastPreferredCellHeight * n;
			}
		}
		public function removeComponent ( id : int ) : void
		{
			if( _fixedHeight )
			{
				_lastEstimatedSize.height -= _lastPreferredCellHeight;
			}
			else
			{
				_lastEstimatedSize.height -= _list.getItemPreferredSize( id ).height;
			}
		}
		public function removeComponents ( ids : Array ) : void
		{
			if( _fixedHeight )
			{
				_lastEstimatedSize.height -= _lastPreferredCellHeight*ids.length;
			}
			else
			{
				var l : Number = ids.length;
				var i : Number;
				for (i=0;i<l;i++)
				{
					_lastEstimatedSize.height -= _list.getItemPreferredSize( ids[ i ] ).height;
				}
			}
		}
		public function removeAll() : void 
		{
			_lastEstimatedSize = null;
		}
		
		public function estimatedSize () : Dimension
		{
			if( !_list.model )
				return new Dimension(0,0);
			else if( _lastEstimatedSize && _lastPreferredCellHeight > 0 )
				return _lastEstimatedSize;
			
			var i : Number; 
			var l : Number = _list.model.size;
			
			var w : Number = 0;			var h : Number = 0;
			var d : Dimension;
			
			if( !_fixedHeight )
			{
				_estimatedLocations = new Vector.<Point>( l );
				
				for( i = 0; i < l; i++ )
				{
					d = _list.getItemPreferredSize(i);
					
					_estimatedLocations [ i ] = new Point(0,h);
					
					w = Math.max( w, d.width );
					h += d.height;
				}
			}
			else if ( l > 0 )
			{
				var maxh : Number = 0;
				for( i = 0; i < l; i++ )
				{
					d = _list.getItemPreferredSize(i);
					maxh = Math.max( d.height, maxh );
					w = Math.max( w, d.width );
				}
				d = _list.getItemPreferredSize(0);
				h = maxh * l;
				_lastPreferredCellHeight = maxh;
			}
			
			h += _gap * ( l-1 );
			return _lastEstimatedSize = new Dimension( w, h );
		}
		public function clearEstimatedSize () : void
		{
			_lastEstimatedSize = null;
		}

		public function getLocationAt ( id : Number ) : Point
		{
			return _fixedHeight ? new Point( 0, id * _lastPreferredCellHeight ) : _estimatedLocations[id];
		}

		public function getIndexAt( y : Number ) : uint
		{
			if( _fixedHeight )
			{
				return ( y - (y % _lastPreferredCellHeight) ) / _lastPreferredCellHeight;
			}
			else
			{
				var i : Number; 
				var l : Number = _estimatedLocations.length;
				for( i = 0; i < l; i++ )
				{
					var d : Point = _estimatedLocations[ i ];
					if( d.y > y )
						return i-1;
				}
				return y >= _lastEstimatedSize.height ? _list.model.size-1 : 0;
			}
		}
	}
}

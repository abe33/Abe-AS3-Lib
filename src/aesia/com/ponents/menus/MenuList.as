package aesia.com.ponents.menus 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.layouts.components.MenuListLayout;
	import aesia.com.ponents.lists.List;
	import aesia.com.ponents.lists.ListCell;
	import aesia.com.ponents.models.ListModel;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="EmptyComponent")]
	public class MenuList extends List 
	{
		public function MenuList ( lm : ListModel = null)
		{
			_listCellClass = MenuItem;
			_childrenLayout = new MenuListLayout( this, 0, false );
			super( lm );
			_loseSelectionOnFocusOut = false;
		}

		override public function selectPrevious () : void
		{
			var nextIndex : int;
			var i : MenuItem;
			if( _allowMultiSelection )
			{
				if( selectedIndices.length == 0 )
					nextIndex = _model.size - 1;
				else 
				{
					if( selectedIndices[0] - 1 < 0 )
						nextIndex = _model.size - 1;
					else
					{
						nextIndex = selectedIndices[0] - 1;
						i = _model.getElementAt(nextIndex) as MenuItem;
						while( !i.enabled )
						{
							if( nextIndex == 0 )
							nextIndex = _model.size;
							
							i = _model.getElementAt( --nextIndex );
						}
					}
				}
				selectedIndices = [ nextIndex ];
				ensureIndexIsVisible( selectedIndices[0] );
			}
			else
			{
				
				if( isNaN( selectedIndex ) )
					nextIndex = _model.size - 1;
				else if( selectedIndex - 1 < 0 )
					nextIndex = _model.size - 1;
				else	
				{
					nextIndex = selectedIndex - 1;
					i = _model.getElementAt(nextIndex) as MenuItem;
					while( !i.enabled )
					{
						if( nextIndex == 0 )
							nextIndex = _model.size;
						
						i = _model.getElementAt( --nextIndex );
					}
				}

				selectedIndex = nextIndex;
				ensureIndexIsVisible( selectedIndex );
			}
			fireComponentEvent( ComponentEvent.SELECTION_CHANGE );
			repaintSelection();
		}
		override public function selectNext () : void
		{
			var nextIndex : int = -1;
			var i : MenuItem;
			var n : uint = 0;
			var l : uint;
			if( _allowMultiSelection )
			{
				if( selectedIndices.length == 0 )
					nextIndex = 0;
				else 
				{
					if( selectedIndices[0] + 1 >= _model.size  )
						nextIndex = 0;
					else
					{
						nextIndex = selectedIndices[0] + 1;
						i = _model.getElementAt(nextIndex) as MenuItem;
						l = _model.size;
						while( !i.enabled && n++ < l )
						{
							if( nextIndex+1 >= _model.size )
								nextIndex = -1;
							
							i = _model.getElementAt( ++nextIndex );
						}
					}
				}
				if( nextIndex != -1)
				{
					selectedIndices = [ nextIndex ];
					ensureIndexIsVisible( selectedIndices[0] );
				}
			}
			else
			{
				
				if( isNaN( selectedIndex ) )
					nextIndex = 0;
				else if( selectedIndex + 1 >= _model.size )
					nextIndex = 0;
				else	
				{
					nextIndex = selectedIndex + 1;
					i = _model.getElementAt(nextIndex) as MenuItem;
					while( !i.enabled && n++ < l )
					{
						if( nextIndex+1 >= _model.size )
							nextIndex = -1;
						
						i = _model.getElementAt( ++nextIndex );
					}
				}

				selectedIndex = nextIndex;
				ensureIndexIsVisible( selectedIndex );
			}
			fireComponentEvent( ComponentEvent.SELECTION_CHANGE );
			repaintSelection();
		}
		override protected function getCell (itemIndex : int = 0, childIndex : int = 0) : ListCell
		{
			if( childIndex < _children.length )
			{
			 	var curCell : ListCell = _children[childIndex] as ListCell;
			 	if( curCell.index < _firstVisibleIndex &&
			 		curCell.index > _lastVisibleIndex &&
			 	    _childrenContainer.contains( curCell as DisplayObject) )
					_childrenContainer.removeChild( curCell as DisplayObject );
			}
			if( itemIndex < _model.size && itemIndex <= _lastVisibleIndex )
			{
				var nextCell : ListCell = _model.getElementAt( itemIndex ) as ListCell;				if( !_childrenContainer.contains( nextCell as DisplayObject) )
					_childrenContainer.addChild( nextCell as DisplayObject );
				
				return nextCell;			
			}
			else return null;		
		}
		override protected function setCell (cell : ListCell, data : *, index : uint) : void
		{
			if( cell )
			{
				cell.index = index;
				if( cell == _sampleListCellInstance )
				{
					if( data )
					{
						( cell as MenuItem ).action = (data as MenuItem).action;
					}
				}
			}
		}

		override public function applySelection (item : ListCell, v : Boolean) : void
		{
			( item as MenuItem ).itemSelected = v;
		}

		override protected function releaseCell (item : ListCell) : void
		{
			if( item && _childrenContainer.contains( item as DisplayObject) )
				_childrenContainer.removeChild(item as DisplayObject);
		}

		override public function getItemPreferredSize (i : int) : Dimension
		{
			var item : MenuItem;
			if( ( item = _model.getElementAt( i ) as MenuItem ) is MenuSeparator )
				return item.preferredSize;
			else
				return super.getItemPreferredSize( i );
		}
		/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
		override protected function getSearchValue (v : *) : String 
		{
			return (v as MenuItem).label;
		}
		override public function removeFromStage (e : Event) : void 
		{
			if( displayed )
			{
				super.removeFromStage( e );
				if( _searchField )
					hideSearch();
			}
		}
		override protected function hideSearch () : void 
		{
			super.hideSearch();
			selectedValue.click();
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}

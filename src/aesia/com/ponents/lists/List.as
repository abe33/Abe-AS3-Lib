/**
 * @license
 */
package aesia.com.ponents.lists 
{
	import aesia.com.ponents.buttons.Button;
	import aesia.com.mands.ProxyCommand;
	import aesia.com.mon.core.IDisplayObject;
	import aesia.com.mon.core.IDisplayObjectContainer;
	import aesia.com.mon.core.IInteractiveObject;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.AllocatorInstance;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Keys;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.containers.AbstractScrollContainer;
	import aesia.com.ponents.containers.DropPanel;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.containers.Viewport;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.core.Container;
	import aesia.com.ponents.core.edit.Editable;
	import aesia.com.ponents.core.focus.Focusable;
	import aesia.com.ponents.dnd.DnDManagerInstance;
	import aesia.com.ponents.dnd.DropEvent;
	import aesia.com.ponents.dnd.DropTarget;
	import aesia.com.ponents.dnd.DropTargetDragEvent;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.events.ListEvent;
	import aesia.com.ponents.history.UndoManager;
	import aesia.com.ponents.history.UndoManagerInstance;
	import aesia.com.ponents.history.UndoProvider;
	import aesia.com.ponents.layouts.components.OldListLayout;
	import aesia.com.ponents.models.DefaultListModel;
	import aesia.com.ponents.models.ListModel;
	import aesia.com.ponents.scrollbars.Scrollable;
	import aesia.com.ponents.transfer.ComponentsFlavors;
	import aesia.com.ponents.utils.ScrollUtils;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	[Event(name="selectionChange", type="aesia.com.ponents.events.ComponentEvent")]	[Event(name="modelChange", type="aesia.com.ponents.events.ComponentEvent")]
	[Skinable(skin="List")]
	[Skin(define="List",
		  inherit="DropPanel",
		  preview="aesia.com.ponents.lists::List.defaultListPreview",
		  
		  state__all__background="new aesia.com.ponents.skinning.decorations::SimpleFill( aesia.com.mon.utils::Color.White )",
		  state__all__foreground="new aesia.com.ponents.skinning.decorations::NoDecoration()"
	)]
	/**
	 * @author Cédric Néhémie
	 */
	public class List extends DropPanel implements DropTarget, 
												   Scrollable, 
												   UndoProvider, 
												   Component,
												   Container, 
												   IDisplayObject, 
												   IDisplayObjectContainer,
												   IInteractiveObject
	{
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		static public function defaultListPreview () : List
			{
				var l : List = new List(_("Sample Item 1"), 
										_("Sample Item 2"), 
										_("Sample Item 3") );
				l.selectedIndex = 1;
				
				return l;
			}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		protected var _model : ListModel;
		protected var _allowMultiSelection : Boolean;
		protected var _listCellClass : Class;
		
		// for single selection mode
		protected var _selectedIndex : int;
		protected var _selectedValue : *;
		
		// for multi selection mode
		protected var _selectedIndices : Array;
		protected var _selectedValues : Array;		protected var _selectedItems : Array;
		
		protected var _editEnabled : Boolean;
		protected var _scrollDuringDragTimeout : Number;
		protected var _loseSelectionOnFocusOut : Boolean;
		protected var _oldModelSize : Number;
		protected var _sampleListCellInstance : ListCell;
		
		protected var _modelHasChanged : Boolean;
		protected var _parentAsScrolled : Boolean;
		
		protected var _firstVisibleIndex : int;
		protected var _lastVisibleIndex : int;
		protected var _undoManager : UndoManager;
		
		protected var _itemFormatingFunction : Function;

		public function List ( ... args )
		{			
			_undoManager = UndoManagerInstance;
			_listCellClass = _listCellClass ? _listCellClass : DefaultListCell;
			_selectedIndices = [];
			_selectedIndex = -1;
			_selectedValues = [];
			_childrenLayout = _childrenLayout ? _childrenLayout : new OldListLayout( this );
			_editEnabled = true;
			_loseSelectionOnFocusOut = true;
			_oldModelSize = -1;
			super( true );
			_allowChildrenFocus = false;			
			_sampleListCellInstance = AllocatorInstance.get( _listCellClass, 
																{ 
																	owner:this, 
																	focusParent:this, 
																	enabled:_enabled, 
																	allowEdit:_editEnabled
																} );
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			_sampleListCellInstance.allowDrag = _allowDrag;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			_allowMask = false;

			if( ( args as Array ).length > 1 )
				model = new DefaultListModel( args );
			else if( ( args as Array ).length == 1 )
			{
				if( args[0] is Array )
					model = new DefaultListModel( args[0] );
				else if( args[0] is ListModel )
					model = args[0];
			}
			else
				model = new DefaultListModel();

			/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.F2 ) ] = new ProxyCommand( editSelected );
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.UP ) ] = new ProxyCommand( selectPrevious );
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.DOWN ) ] = new ProxyCommand( selectNext );
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.UP, KeyStroke.getModifiers( false, true ) ) ] = new ProxyCommand( shiftUp );
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.DOWN, KeyStroke.getModifiers( false, true ) ) ] = new ProxyCommand( shiftDown );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		
		public function get listLayout () : OldListLayout { return _childrenLayout as OldListLayout; }
		public function get modelHasChanged () : Boolean { return _modelHasChanged; }

		public function get loseSelectionOnFocusOut () : Boolean { return _loseSelectionOnFocusOut; }	
		public function set loseSelectionOnFocusOut (loseSelectionOnFocusOut : Boolean) : void
		{
			_loseSelectionOnFocusOut = loseSelectionOnFocusOut;
		}
		
		public function get preferredViewportSize () : Dimension { return preferredSize; }
		
		public function get tracksViewportH () : Boolean { return true; }		
		public function get tracksViewportV () : Boolean { return !ScrollUtils.isContentHeightExceedContainerHeight( this ); }
		
		public function get firstVisibleIndex () : int { return _firstVisibleIndex; }		
		public function get lastVisibleIndex () : int { return _lastVisibleIndex; }
		
		public function getItemPreferredSize ( i : int ) : Dimension
		{
			setCell( _sampleListCellInstance, _model.getElementAt(i), i );
						
			return _sampleListCellInstance.preferredSize;	
		}
		
		public function get itemFormatingFunction () : Function { return _itemFormatingFunction; }		
		public function set itemFormatingFunction ( itemFormatingFunction : Function ) : void
		{
			_itemFormatingFunction = itemFormatingFunction;
			listLayout.clearEstimatedSize();
			updateCellsData( );
			invalidatePreferredSizeCache();
		}
		public function get hasFormatingFunction () : Boolean
		{
			return _itemFormatingFunction != null;
		}

		public function get sampleCell () : ListCell { return _sampleListCellInstance; }
		public function getScrollableUnitIncrementV ( r : Rectangle = null, direction : Number = 1 ) : Number 
		{ 
			var increment : Number;
			var index : int = listLayout.getIndexAt( -y );
			var d : Dimension;
			var p : Point;
			
			
			if( direction > 0 )
			{
				p = listLayout.getLocationAt(index);
				
				if( listLayout.fixedHeight )
					increment = y + p.y + listLayout.lastPreferredCellHeight;				else
				{
					d = getItemPreferredSize(index);
					increment = y + p.y + d.height;				}
			}
			else
			{
				index--;
				if( index >= 0 )
				{
					p = listLayout.getLocationAt(index);
					increment = y + p.y;
				}
				else
					increment = y;
			}
			return increment; 
		}
		public function getScrollableUnitIncrementH ( r : Rectangle = null, direction : Number = 1 ) : Number { return width / 100 * direction; }
		
		public function getScrollableBlockIncrementV ( r : Rectangle = null, direction : Number = 1 ) : Number { return getScrollableUnitIncrementV( r, direction ) * 10; }
		public function getScrollableBlockIncrementH ( r : Rectangle = null, direction : Number = 1 ) : Number { return width / 10 * direction; }
		
/*-----------------------------------------------------------------------------------
 * LIST IMPLEMENTATIONS
 *----------------------------------------------------------------------------------*/

		public function get editEnabled () : Boolean { return _editEnabled;	}		
		public function set editEnabled (editEnabled : Boolean) : void
		{
			_editEnabled = editEnabled;
			doubleClickEnabled = editEnabled;
			
			for each ( var c : ListCell in _children)
				c.allowEdit = editEnabled;
		}

		override public function set enabled (b : Boolean) : void
		{
			var old : Boolean = _enabled;
			super.enabled = b;
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			if( old != _enabled )
			{
				if( _enabled && _allowDrag )
					DnDManagerInstance.registerDropTarget( this );
				else if( !_enabled && _allowDrag )
					DnDManagerInstance.unregisterDropTarget( this );
			}
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}

		public function get model () : ListModel { return _model; }	
		public function set model ( model : ListModel ) : void
		{
			if( !model )
				return;
			
			if( _model )
				_model.removeEventListener( ComponentEvent.DATA_CHANGE, dataChanged );
			
			_model = model;
				
			if( _model )	
				_model.addEventListener( ComponentEvent.DATA_CHANGE, dataChanged );
				
			dataChanged(null);
			fireComponentEvent( ComponentEvent.MODEL_CHANGE );
		}

		public function get length () : Number { return _model.size; }
		public function get items () : Vector.<Component>
		{
			return _children.concat();
		}
		
		public function get allowMultiSelection () : Boolean { return _allowMultiSelection; }
		public function set allowMultiSelection ( b : Boolean ) : void
		{
			_allowMultiSelection = b;
			
			if( b )
			{
				if( selectedIndex != -1 )
					selectedIndices = [ selectedIndex ];
				else
					selectedIndices = [];
			}
			else
			{
				if ( selectedIndices.length != 0 )
				{
					var index: int = selectedIndices[0];
					
					selectedIndices = [];				
					selectedIndex = index;
				}
			}
		}
		public function get listCellClass () : Class { return _listCellClass; }		
		public function set listCellClass ( listCellClass : Class ) : void
		{
			AllocatorInstance.release( _sampleListCellInstance );
			
			_listCellClass = listCellClass;
			_sampleListCellInstance = AllocatorInstance.get( _listCellClass, 
															{ 
																owner:this, 
																focusParent:this, 
																enabled:_enabled, 
																allowEdit:_editEnabled
															} );
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			_sampleListCellInstance.allowDrag = _allowDrag;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			//_sampleListCellInstance = getCell();
			if( _model.size > 0 )
			{
				removeAllComponents();
				listLayout.clearEstimatedSize();
				buildChildren();
				invalidatePreferredSizeCache();
			}
			firePropertyEvent("listCellClass", _listCellClass );
		}

		public function get undoManager () : UndoManager { return _undoManager; }		
		public function set undoManager (s : UndoManager) : void
		{
			_undoManager = s;
		}
		
/*-----------------------------------------------------------------------------------
 * SINGLE SELECTION GETTERS/SETTERS
 *----------------------------------------------------------------------------------*/
		public function get selectedIndex() : int { return _selectedIndex; }
		public function set selectedIndex( i : int ) : void
		{
			if( !_allowMultiSelection )
			{
				_selectedIndex = i;
				
				if(!isNaN( _selectedIndex ) )
				{
					_selectedValue = _model.getElementAt( _selectedIndex );
					ensureIndexIsVisible( i );
					var item : ListCell = getListCellWithIndex( _selectedIndex );
					if( item && stage )
						stage.focus = item as InteractiveObject;
				}
				else
				{
					_selectedValue = null;
				}
				
				fireComponentEvent( ComponentEvent.SELECTION_CHANGE );
				repaintSelection();
			}
		}
		
		public function applySelection ( item : ListCell, v : Boolean) : void
		{
			item.selected = v;
		}

		public function get selectedValue() : *
		{
			return _selectedValue;
		}
		
		public function clearSelection () : void
		{
			if( !_allowMultiSelection )
				selectedIndex = -1;
			else
				selectedIndices = [];			
		}

/*-----------------------------------------------------------------------------------
 * MULTI SELECTION GETTERS/SETTERS
 *----------------------------------------------------------------------------------*/
		public function get selectedIndices() : Array {	return _selectedIndices; }
		public function set selectedIndices( a : Array ) : void
		{
			if( _allowMultiSelection )
			{
				_selectedIndices = a;
				
				var l : Number;
				var values : Array = [];
				var i : Number;
				l = _selectedIndices.length;
					
				for( i = 0; i < l; i++ )
					values.push( ( _model.getElementAt( _selectedIndices [ i ] ) ) );
				
				_selectedValues = values;
				
				repaintSelection();
					
				fireComponentEvent( ComponentEvent.SELECTION_CHANGE );
			}
		}
		public function get selectedValues() : Array
		{
			return _selectedValues;
		}
/*-----------------------------------------------------------------------------------
 * MULTI SELECTION METHODS
 *----------------------------------------------------------------------------------*/	
		public function selectAll () : void
		{
			if( _allowMultiSelection )
			{
				var a : Array = [];
				
				for( var i:int=0;i<_model.size;i++)
					a.push(i);
				
				selectedIndices = a;
			}
		}
		
		public function addToSelection ( item : ListCell ) : void
		{
			if( _allowMultiSelection )
			{
				_selectedIndices.push( item.index );
				_selectedValues.push ( _model.getElementAt(item.index) );
				
				ensureCellIsVisible( item );
				fireComponentEvent( ComponentEvent.SELECTION_CHANGE );
				repaintSelection ();
			}
		}
		public function addToSelectionIndex ( index : Number  ) : void
		{
			if( _allowMultiSelection )
			{
				_selectedIndices.push( index );
				_selectedValues.push( _model.getElementAt( index ) );
				
				ensureIndexIsVisible( index );
				fireComponentEvent( ComponentEvent.SELECTION_CHANGE );
				repaintSelection ();
			}
		}
		public function expandSelectionTo ( item : ListCell ) : void
		{
			if( _allowMultiSelection )
			{
				_selectedIndices.sort();
				var indexStart : Number = _selectedIndices[_selectedIndices.length-1];				var indexEnd : Number = item.index;
				var i : int;
				if( indexEnd > indexStart )
					for( i = indexStart; i <= indexEnd; i++ )
						addToSelectionIndex( i );
				else
					for( i = indexEnd; i <= indexStart; i++ )
						addToSelectionIndex( i );
			}
		}
		
		public function removeFromSelection ( item : ListCell ) : void
		{
			if( _allowMultiSelection )
			{
				var i : Number = item.index;
				_selectedIndices.splice( _selectedIndices.indexOf( i ), 1 );
				_selectedValues.splice( _model.getElementAt( i ), 1 );

				fireComponentEvent( ComponentEvent.SELECTION_CHANGE );
				repaintSelection ();
			}
		}
		public function removeFromSelectionIndex ( index : Number ) : void
		{
			if( _allowMultiSelection )
			{
				_selectedIndices.splice( _selectedIndices.indexOf( index ), 1 );
				_selectedValues.splice( _model.getElementAt( index ), 1 );
				
				fireComponentEvent( ComponentEvent.SELECTION_CHANGE );
				repaintSelection ();
			}
		}

		public function selectPrevious () : void
		{
			if( _allowMultiSelection )
			{
				/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
				if( _selectedIndices.length == 1 && _selectedIndices[0] != -1 )
					( _selectedItems[0] as ListCell ).hideToolTip();
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
				if( _selectedIndices.length == 0 )
					selectedIndices = [ _model.size - 1 ];
				else if( _selectedIndices[0] - 1 < 0 )
					selectedIndices = [ _model.size - 1 ];
				else
					selectedIndices = [ _selectedIndices[0] - 1 ];
				
				ensureIndexIsVisible( _selectedIndices[0] );
				
				/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
				if( _selectedIndices.length == 1 )
					( _selectedItems[0] as ListCell ).showToolTip( true );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
					
			}
			else
			{
				/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
				if( _selectedIndex != -1 )
					( _selectedItems[0] as ListCell ).hideToolTip();
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
				if( isNaN( selectedIndex ) )
					selectedIndex = _model.size - 1;
				else if( selectedIndex - 1 < 0 )
					selectedIndex = _model.size - 1;
				else	
					selectedIndex = selectedIndex - 1;

				ensureIndexIsVisible( selectedIndex );
				
				/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
				if(  _selectedIndex != -1 )
					( _selectedItems[0] as ListCell ).showToolTip( true );	
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
			}
			fireComponentEvent( ComponentEvent.SELECTION_CHANGE );
			repaintSelection();
		}
		public function selectNext () : void
		{
			if( _allowMultiSelection )
			{
				/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
				if( _selectedIndices.length == 1 && _selectedIndices[0] != -1 )
					( _selectedItems[0] as ListCell ).hideToolTip();
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
					
				if( _selectedIndices.length == 0 )
					selectedIndices = [ 0 ];
				else if( _selectedIndices[0] + 1 >= _model.size )
					selectedIndices = [ 0 ];
				else
					selectedIndices = [ _selectedIndices[0] + 1 ];
				
				ensureIndexIsVisible( _selectedIndices[0] );
				
				/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
				if( _selectedIndices.length == 1 )
					( _selectedItems[0] as ListCell ).showToolTip( true );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				 
			}
			else
			{
				/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
				if( _selectedIndex != -1 )
					( _selectedItems[0] as ListCell ).hideToolTip();
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
					
				var nextIndex : Number;
				if( isNaN( selectedIndex ) )
					nextIndex = 0;
				else
				{
					if( selectedIndex + 1 >= _model.size )
						nextIndex = 0;
					else
						nextIndex = selectedIndex + 1;
					
				}
				
				selectedIndex = nextIndex;
				ensureIndexIsVisible( selectedIndex );
				
				/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
				if( _selectedIndex != -1  )
					( _selectedItems[0] as ListCell ).showToolTip( true );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
			}
			fireComponentEvent( ComponentEvent.SELECTION_CHANGE );
			repaintSelection();
		}
		protected function shiftUp () : void
		{
			if( _allowMultiSelection )
				if( _selectedIndices.length > 1 )
					removeFromSelectionIndex( _selectedIndices[ _selectedIndices.length - 1 ] );
		}
		protected function shiftDown () : void
		{
			if( _allowMultiSelection )
				addToSelectionIndex( _selectedIndices[ _selectedIndices.length - 1 ] + 1 );
		}

		protected function buildChildren () : void
		{
			var p : Container = parentContainer;
			var y : Number = p ? -this.y : 0;
			var h : Number = p ? p.height : height;
			
			var a : Array = [];
			var item : ListCell;
			
			_firstVisibleIndex = listLayout.getIndexAt(y);
			_lastVisibleIndex = listLayout.getIndexAt( y + h );
			
			if( isNaN( _firstVisibleIndex ) || isNaN( _lastVisibleIndex ) )
				return;			
			
			if( _lastVisibleIndex < _firstVisibleIndex )
				_lastVisibleIndex = _model.size-1;
			else if( _lastVisibleIndex < _model.size-1 )
				_lastVisibleIndex++;
				
			var l : Number = Math.max( _lastVisibleIndex - _firstVisibleIndex, _children.length );
			
			var i : uint;			var j : uint;
			for( i = _firstVisibleIndex, j=0; j <= l; i++, j++ )
			{
				item = getCell( i, j );//_children[ j ] as ListCell;
				if( i < _model.size && i <= _lastVisibleIndex )
				{
					a.push( item );
				}
				else if( j < _children.length )
				{
					releaseCell( item );
				}
			}
			_children = Vector.<Component> ( a );
		}
		public function updateCellsData () : void
		{
			var item : ListCell;
			var data : *;
			var i : uint;			var j : uint;
			var l : Number = _children.length;
			for( i = _firstVisibleIndex, j=0; j < l; i++, j++ )
			{
				item = _children[j] as ListCell;
				data = _model.getElementAt( i );
				setCell( item, data, i );
			}
		}
		protected function releaseCell (item : ListCell) : void
		{
			_childrenContainer.removeChild( item as DisplayObject );
			AllocatorInstance.release(item);
		}
		protected function getCell ( itemIndex : int = 0, childIndex : int = 0 ) : ListCell
		{
			var cell : ListCell;
			if( childIndex < _children.length )
				cell = _children[ childIndex ] as ListCell;
			else if( itemIndex < _model.size && 
					 itemIndex <= _lastVisibleIndex )
			{	
				cell = AllocatorInstance.get( _listCellClass, { owner:this, 
																focusParent:this, 
																enabled:_enabled, 
																interactive:_interactive,
																allowEdit:_editEnabled
																 } );
				/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
				cell.allowDrag = _allowDrag;
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
				
				if( !_childrenContainer.contains( cell as DisplayObject) )
					_childrenContainer.addChild( cell as DisplayObject );
			}
			return cell;
		}
		protected function setCell ( cell : ListCell, data : *, index : uint ) : void
		{
			if( cell )
			{
				cell.value = data;
				cell.index = index;
				cell.selected = _allowMultiSelection ? _selectedIndices.indexOf(index) != -1 : 
													   _selectedIndex == index;
			}
		}
		public function getListCellWithIndex( index : uint ) : ListCell
		{
			for each( var lc : ListCell in _children )
				if( lc.index == index )
					return lc;
			
			return null;
		}

		override public function removeAllComponents () : void
		{
			var l : Number = childrenCount;
			while( l--)
			{
				var lc : ListCell = _children[l] as ListCell;
				removeComponent( lc );
				lc.dispose();
			}
		}
/*-----------------------------------------------------------------------------------
 * VALIDATION, LAYOUT & REPAINT
 *----------------------------------------------------------------------------------*/

		override public function repaint () : void
		{
			if( _modelHasChanged || _parentAsScrolled )
			{
				buildChildren();
				_modelHasChanged = false;				_parentAsScrolled = false;
			}
			updateCellsData ();
			super.repaint();
		}
		public function repaintSelection () : void
		{
			var a : Array = [];
			var i : Number;
			var l : Number = _children.length;
			var item : ListCell;
			if( _allowMultiSelection )
			{
				for( i = 0; i < l; i++ )
				{
					item = _children[ i ] as ListCell;
					applySelection( item, _selectedIndices.indexOf( item.index ) != -1 );
					if( _selectedIndices.indexOf( item.index ) != -1 )
						a.push(item);
				}
			}
			else
			{
				for( i = 0; i < l; i++ )
				{
					item = _children[ i ] as ListCell;
					applySelection( item, _selectedIndex == item.index );
					
					if( _selectedIndex == item.index )						a.push(item);
				}
			}
			_selectedItems = a;
		}
		override protected function calculateComponentSize () : Dimension
		{
			return super.calculateComponentSize();
			//var d : Dimension = super.calculateComponentSize( );
			//return new Dimension( d.width, _childrenLayout.preferredSize.height );
		}
		
		override public function focusNextChild (child : Focusable) : void
		{
			var b : Boolean = false;
			var c : Component;
			if( child is Editable && (child as Editable).isEditing )
			{
				(child as Editable).confirmEdit();
				b = true;
			}
			
			var index : Number = ( child as ListCell ).index + 1 ;
			
			if( index < _model.size )
			{
				ensureIndexIsVisible( index );
				c = getListCellWithIndex( index );
				c.grabFocus();
				
				//ensureRectIsVisible( new Rectangle( c.x, c.y, c.width, c.height ) );
				
				if( c is Editable && b )				
					(c as Editable).startEdit();
			}
			else if( b )
			{
				ensureIndexIsVisible( 0 );
				c = getListCellWithIndex( 0 );
				c.grabFocus();
				
				ensureRectIsVisible( new Rectangle( c.x, c.y, c.width, c.height ) );
					
				if( c is Editable )				
					(c as Editable).startEdit();
			}
			else
				focusNext();
		}

		override public function focusPreviousChild (child : Focusable) : void
		{
			var b : Boolean = false;
			var c : Component;
			if( child is Editable && (child as Editable).isEditing )
			{
				(child as Editable).confirmEdit();
				b = true;
			}
			
			var index : Number = ( child as ListCell ).index - 1;
			/*
			if( index == -1 )
				index = _children.length;
			*/
			if( index >= 0 )
			{
				ensureIndexIsVisible( index );
				c = getListCellWithIndex( index );
				c.grabFocus();
				
				ensureRectIsVisible( new Rectangle( c.x, c.y, c.width, c.height ) );
				
				if( c is Editable && b )				
					(c as Editable).startEdit();
			}
			else if( b )
			{
				ensureIndexIsVisible( _model.size - 1 );
				c = getListCellWithIndex(_model.size - 1 );
				c.grabFocus();
				
				ensureRectIsVisible( new Rectangle( c.x, c.y, c.width, c.height ) );
				
				if( c is Editable )				
					(c as Editable).startEdit();
			}
			else
				focusPrevious();
		}
/*--------------------------------------------------------------
 *  MISC METHODS
 *-------------------------------------------------------------*/
		
		protected function editSelected () : void
		{
			if( _editEnabled )
			{
				if( _selectedItems.length 	 )
				{
					if( _selectedItems[0] is Editable )
					  ( _selectedItems[0] as Editable ).startEdit();
				}
			}
		}
		
		public function ensureIndexIsVisible ( i : Number ) : void
		{
			if( isNaN( i ) || i < 0 )
				return;
			
			var p : Container = parentContainer;
			if( p is Viewport )
			{
				var vp : Viewport = p as Viewport;
				var scp : AbstractScrollContainer = p.parentContainer as AbstractScrollContainer;
				var pt : Point = listLayout.getLocationAt(i);				var d : Dimension = getItemPreferredSize(i);
				
				if( pt.y < scp.scrollV )
					scp.scrollV = pt.y;
				else if( pt.y + d.height > scp.scrollV + vp.height )
					scp.scrollV = pt.y + d.height - vp.height;
			}
			repaint();
		}

		override public function ensureRectIsVisible (r : Rectangle) : Component
		{
			var p : Container = parentContainer;
			if( p is Viewport )
			{
				var vp : Viewport = p as Viewport;
				var scp : AbstractScrollContainer = p.parentContainer as AbstractScrollContainer;
				
				if( r.y < scp.scrollV )
					scp.scrollV = r.y;
				else if( r.y + r.height > scp.scrollV + vp.height )
					scp.scrollV = r.y + r.height - vp.height;
				
				if( r.x < scp.scrollH )
					scp.scrollH = r.x;
				else if( r.x + r.width > scp.scrollH + vp.width )
					scp.scrollH = r.x + r.width - vp.width;
				
				return this;
			}
			else
				return super.ensureRectIsVisible( r );
		}

		public function ensureCellIsVisible ( o : ListCell ) : void
		{ 
			if( o )
				ensureIndexIsVisible( o.index );
		}
		protected function scrollDuringDrag () : void
		{
			var c : Container = parentContainer;
			if( c is Viewport )
			{
				var vp : Viewport = c as Viewport;
				var scb : ScrollPane = vp.parentContainer as ScrollPane;
				
				if( scb.vscrollbar.canScroll )
				{
					if( mouseY < scb.vscrollbar.scroll + 16 )
						scb.scrollUp();
					else if( mouseY > scb.vscrollbar.scroll + vp.height - 16 )
						scb.scrollDown();
				}
			}
		}
		protected function getListCellUnderPoint ( pt : Point ) : ListCell
		{
			return getComponentUnderPoint(pt) as ListCell;	
		}
/*--------------------------------------------------------------
 * 	EVENTS HANDLERS
 *-------------------------------------------------------------*/
		override public function addedToStage (e : Event) : void
		{
			super.addedToStage( e );
			var p : Container = parentContainer;
			if( p is Viewport )
			{
				var scp : AbstractScrollContainer = p.parentContainer as AbstractScrollContainer;
				scp.addEventListener(ComponentEvent.SCROLL, parentScrolled );
			}
		}
		
		private function parentScrolled (event : ComponentEvent) : void
		{
			_parentAsScrolled = true;
			//invalidate( true );
		}

		protected function dataChanged (event : ListEvent) : void
		{
			if( event )
			{
				switch( event.action )
				{
					 case ListEvent.ADD : 
					 	listLayout.addComponents( event.indices );
						_modelHasChanged = true;
					 	invalidatePreferredSizeCache();						break;					case ListEvent.REMOVE :
					 	listLayout.removeComponents( event.indices );						_modelHasChanged = true;
					 	invalidatePreferredSizeCache();
						break;
					 case ListEvent.CLEAR : 					 	listLayout.removeAll();
						_modelHasChanged = true;
					 	invalidatePreferredSizeCache();
					 	break;					 case ListEvent.SET : 					 case ListEvent.MOVE : 					 case ListEvent.SORT : 
					 	invalidate(true); 
						if( !listLayout.fixedHeight )
						{	
							_modelHasChanged = true;
							invalidatePreferredSizeCache();
						}
						break;
					 case ListEvent.REBUILD : 					 
					 default :
					 	_modelHasChanged = true;
					 	listLayout.clearEstimatedSize();
						invalidatePreferredSizeCache();
					 	break;
				}
			}
			else
			{
				_modelHasChanged = true;
				listLayout.clearEstimatedSize();
				invalidatePreferredSizeCache();
			}
			fireResizeEvent();
			//fireComponentEvent( ComponentEvent.DATA_CHANGE );
		}
		override public function focusOut ( e : FocusEvent ) : void
		{
			super.focusOut(e);
			var o : DisplayObject = e.relatedObject as DisplayObject;
			var p : Container = parentContainer;
			if( ( o && isDisplayObjectDescendant(o) ) || 
				( p && p is Viewport && stage && ( p.parentContainer as AbstractScrollContainer ).hitTestPoint( stage.mouseX , stage.mouseY ) ) )
				return;
			
			if( _loseSelectionOnFocusOut )
			{
				clearSelection ();
			}
		}
		
/*-----------------------------------------------------------------
 *  DND SUPPORT
 *----------------------------------------------------------------*/
		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		override public function get supportedFlavors () : Array { return [ ComponentsFlavors.LIST_ITEM ]; }
		
		override public function dragEnter (e : DropTargetDragEvent) : void
		{
			// cas spécial pour les 
			if( _model is DefaultListModel )
			{
				if( (_model as DefaultListModel).immutable )
				{
					e.rejectDrag( this );
					return;
				}
			}
						
			startScrollDuringDragInterval();	
			if( _enabled && ComponentsFlavors.LIST_ITEM.isSupported( e.flavors )  )
				e.acceptDrag( this );
			else
				e.rejectDrag( this );
		}
		
		protected function startScrollDuringDragInterval () : void
		{
			_scrollDuringDragTimeout = setInterval( scrollDuringDrag, 250 );
		}

		override public function dragOver ( e : DropTargetDragEvent ) : void
		{	
			_dropStatusShape.graphics.clear();
			var lc : ListCell = getListCellUnderPoint ( new Point( this.stage.mouseX, 
										   			 			this.stage.mouseY ) );
			if( lc )
			{
				if( lc.mouseY > lc.height / 2 )
					drawDropBelow( lc );
				else
					drawDropAbove( lc );
			}
		}
			
		override public function dragExit (e : DropTargetDragEvent) : void
		{
			clearInterval( _scrollDuringDragTimeout );
			_dropStatusShape.graphics.clear();
		}
		
		override public function drop (e : DropEvent) : void
		{
			clearInterval( _scrollDuringDragTimeout );
			_dropStatusShape.graphics.clear();
			
			var d : * ;
			var lc : ListCell = getListCellUnderPoint ( new Point( 	this.stage.mouseX, 
										   			 				this.stage.mouseY ) );
			
			var id : int;
			
			if( lc )
			{
				var index : int = lc.index;
				
				d = e.transferable.getData( ComponentsFlavors.LIST_ITEM );
				id = _model.indexOf( d );
				
				// when the new position is below the old one, we have to grow the index by 1
				if( index > id )
					index++;
				
				// we insert after the item under the mouse 
				if( mouseY > lc.y + lc.height / 2)
					index++;
				
				if( id == -1 )
				{
					e.transferable.transferPerformed();
					
					if( index < 0 )
						index = 0;
					
					_undoManager.add( new ListDnDInsertUndoableEdit( this, d, index ) );
					
					if( index >= _model.size )
						_model.addElement( d );
					else				
						_model.addElementAt( d, index );
				}
				else
				{
					if( id != -1 && id < index )
						index--;
							
					if( index < 0 )
						index = 0;
						
					_undoManager.add( new ListDnDMoveUndoableEdit( this, d, _model.indexOf(d), index ) );
					_model.setElementIndex( d, index );
				}
			}
			else
			{
				d = e.transferable.getData( ComponentsFlavors.LIST_ITEM );
				id = _model.indexOf( d );
				
				if( id == -1 )
				{
					_undoManager.add( new ListDnDInsertUndoableEdit( this, d, index ) );
					e.transferable.transferPerformed();
					_model.addElement( d );
				}
				else
				{
					_undoManager.add( new ListDnDMoveUndoableEdit( this, d, id, _model.size - 1) );
					_model.setElementIndex( d, _model.size );
				}
				
			}
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}

import aesia.com.patibility.lang._;
import aesia.com.ponents.history.AbstractUndoable;
import aesia.com.ponents.lists.List;

internal class ListDnDMoveUndoableEdit extends AbstractUndoable	
{
	private var _list : List;
	private var value : *;
	private var oldIndex : Number;	private var newIndex : Number;

	public function ListDnDMoveUndoableEdit ( list : List, value : *, oldIndex : Number, newIndex : Number )
	{
		this._label = _("Move List Item");
		this._list = list;
		this.value = value;
		this.oldIndex = oldIndex;		this.newIndex = newIndex;
	}
	override public function undo () : void
	{
		this._list.model.setElementIndex( value, oldIndex);		super.undo();
	}
	override public function redo () : void
	{
		this._list.model.setElementIndex( value, newIndex);
		super.redo();
	}
}
internal class ListDnDInsertUndoableEdit extends AbstractUndoable	
{
	private var _list : List;
	private var value : *;
	private var index : Number;

	public function ListDnDInsertUndoableEdit ( list : List, value : *, index : Number )
	{
		this._label = _("Insert List Item");
		this._list = list;
		this.value = value;
		this.index = index;
	}
	override public function undo () : void
	{
		this._list.model.removeElementAt(index);
		super.undo();
	}
	override public function redo () : void
	{
		if( index < this._list.length )
			this._list.model.addElementAt( value, index );
		else
			this._list.model.addElement( value );
		super.redo();
	}
}
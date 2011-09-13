package abe.com.ponents.tables
{
    import abe.com.mon.geom.Dimension;
    import abe.com.mon.utils.AllocatorInstance;
    import abe.com.ponents.containers.DropPanel;
    import abe.com.ponents.containers.ScrollPane;
    import abe.com.ponents.containers.Viewport;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.core.Container;
    import abe.com.ponents.dnd.*;
    import abe.com.ponents.layouts.components.BoxSettings;
    import abe.com.ponents.layouts.components.HBoxLayout;
    import abe.com.ponents.models.DefaultListModel;
    import abe.com.ponents.models.ListModel;
    import abe.com.ponents.skinning.decorations.GradientFill;
    import abe.com.ponents.transfer.*;

    import org.osflash.signals.Signal;

    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.utils.clearInterval;
    import flash.utils.setInterval;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="TableHeader")]
	[Skin(define="TableHeader",
			  inherit="DropPanel",

			  state__all__background="new deco::GradientFill(gradient([skin.overSelectedBackgroundColor,skin.selectedBackgroundColor,skin.overSelectedBackgroundColor],[.5,.5,1]),90)"
	)]
	public class TableHeader extends DropPanel
	{
		static private var SKIN_DEPENDENCIES : Array = [GradientFill];

		static public const COLUMN_RESIZE : String = "columnResize";
		static public const COLUMN_SORT : String = "columnSort";

		protected var _table : Table;
		protected var _headerResizers : Array;
		protected var _scrollDuringDragTimeout : Number;

		protected var _model : ListModel;
		protected var _locked : Boolean;

		protected var _resizerContainer : Sprite;
		protected var _oldSize : Number;
		
		protected var _dataChanged : Signal;

		public function TableHeader ()
		{
		    _dataChanged = new Signal();
			_childrenLayout = new HBoxLayout( this, 0 );
			_allowFocus = false;
			_model = new DefaultListModel();
			_resizerContainer = new Sprite();
			_headerResizers = [];
			_model.dataChanged.add( modelDataChanged );
			( _childrenLayout as HBoxLayout ).layoutDone.add( headerLayoutDone );
			super();
			addChildAt( _resizerContainer, numChildren-1 );
		}
		
		public function get dataChanged () : Signal { return _dataChanged; }

		public function get table () : Table { return _table; }

		override public function set enabled (b : Boolean) : void
		{
			super.enabled = b;
			for each( var c : ColumnHeaderResizer in _headerResizers )
				c.enabled = b;
		}

		public function set table (table : Table) : void
		{
			if( _table )
				unregisterFromTableListEvents( _table );

			_table = table;

			if( _table )
				registerToTableListEvents( _table );
		}

		protected function registerToTableListEvents (table : Table) : void
		{
			table.componentResized.add( tableResized );
		}
		protected function unregisterFromTableListEvents (table : Table) : void
		{
			table.componentResized.remove( tableResized );
		}
		protected function tableResized ( t : Table, d : Dimension ) : void
		{
			invalidatePreferredSizeCache();
		}

		/*
		 * MODEL CONTROL
		 */
		public function addColumn ( col : TableColumn ) : void
		{
			_oldSize = _model.size;
			_model.addElement( col );
		}
		public function addColumnAt ( col : TableColumn, index : Number = 0 ) : void
		{
			_oldSize = _model.size;
			_model.addElementAt( col, index );
		}
		public function addColumns ( ... columns ) : void
		{
			_oldSize = _model.size;
			_locked = true;
			for each( var c : TableColumn in columns )
				_model.addElement( c );
			_locked = false;
			modelDataChanged();
		}

		public function getColumnIndex( column : TableColumn ) : Number
		{
			return _model.indexOf( column );
		}

		public function setColumnIndex ( column : TableColumn, index : Number = 0 ) : void
		{
			_oldSize = _model.size;
			var id : Number = _model.indexOf( column );
			_locked = true;
			_model.removeElementAt(id);

			if( id < index )
				index--;
			_locked = false;
			_model.addElementAt( column, index );
		}
		public function setColumnSize (column : TableColumnHeader, max : Number) : void
		{
			_oldSize = _model.size;
			column.column.finalSize = max;
			modelDataChanged();
		}

		public function removeColumn ( col : TableColumn ) : void
		{
			_oldSize = _model.size;
			_model.removeElement( col );
		}
		public function removeColumnAt ( index : Number = 0 ) : void
		{
			_oldSize = _model.size;
			_model.removeElementAt( index );
		}
		public function removeColumns ( ... columns ) : void
		{
			_oldSize = _model.size;
			_locked = true;
			for each( var column : TableColumn in columns )
				_model.removeElement(column );
			_locked = false;
			modelDataChanged();
		}

		override public function invalidatePreferredSizeCache () : void
		{
			super.invalidatePreferredSizeCache();
			if( _table )
				_preferredSizeCache = new Dimension( Math.max(_table.width, _table.list.width), _preferredSizeCache.height );
		}

		public function get columns () : Array { return _model.toArray(); }

		/*
		 * STUFF
		 */
		public function buildChildren () : void
		{
			if( _model )
			{
				var l1 : Number = _model.size;
				var l2 : Number = _children.length;
				var l : Number = Math.max( l1, l2 );
				var i : Number;
				
				
				TARGET::FLASH_9 { var a : Array = []; }
				TARGET::FLASH_10 { var a : Vector.<Component> = new Vector.<Component>(); }
				TARGET::FLASH_10_1 { 
				var a : Vector.<Component> = new Vector.<Component>(); } 
				
				var b : Array = [];
				var item : TableColumnHeader;
				var column : TableColumn;
				var resizer : ColumnHeaderResizer;

				for( i = 0; i < l; i++ )
				{
					item = i < l2 ? _children[ i ] as TableColumnHeader : null;
					column = i < l1 ? _model.getElementAt(i) as TableColumn : null;
					resizer = _headerResizers[i];

					if( item && !(item is column.cellClass) )
					{
						if( containsComponent( item ) )
							removeComponent( item );

						_resizerContainer.removeChild( resizer );

						item = null;
					}

					if( i < l1 )
					{
						if( item == null)
						{
							item = getCell( column );
							addComponent( item );

							resizer = AllocatorInstance.get( ColumnHeaderResizer, { column:item,
																					header:this } ) as ColumnHeaderResizer;
							_resizerContainer.addChild( resizer );

							item.enabled = resizer.enabled = _enabled;
						}
						a.push( item );
						b.push( resizer );
					}
					else if( i < numChildren && item )
					{
						removeComponent( item );
						_resizerContainer.removeChild( resizer );
						AllocatorInstance.release( item );
						AllocatorInstance.release( resizer );
					}
				}
				_children = a;
				_headerResizers = b;
			}
		}
		public function updateColumnsSort() : void
		{
			var l : Number = _children.length;
			var i : Number;
			var column : TableColumn;
			var item : TableColumnHeader;

			for(i=0;i< l;i++)
			{
				item = _children[i] as TableColumnHeader;
				column = _model.getElementAt( i ) as TableColumn;
				item.sorted =  _table.currentSortingField == column.field &&
							   _table.currentSortingMethod == column.sortingMethod;
			}
		}

		public function updateColumns () : void
		{
			var l : Number = _children.length;
			var i : Number;
			var column : TableColumn;
			var item : TableColumnHeader;
			var cl : HBoxLayout = _childrenLayout as HBoxLayout;
			
			
			TARGET::FLASH_9 { cl.boxes = []; }
			TARGET::FLASH_10 { cl.boxes = new Vector.<BoxSettings>(); }
			TARGET::FLASH_10_1 { 
			cl.boxes = new Vector.<BoxSettings>();	} 

			for(i=0;i< l;i++)
			{
				column = _model.getElementAt(i) as TableColumn;
				item = _children[i] as TableColumnHeader;

				item.field = column.field;
				item.width = column.finalSize;
				item.value = column.name;
				item.column = column;
				cl.boxes.push( new BoxSettings( column.finalSize, "left", "center", item, true, true, false ) );
			}
		}
		public function getCell ( column : TableColumn ) : TableColumnHeader
		{
			var c : Class = column.headerClass;
			var item : TableColumnHeader = AllocatorInstance.get( c, { table:_table,
																	   enabled:_enabled } ) as TableColumnHeader;
			return item;
		}
		protected function headerLayoutDone ( ... args ) : void
		{
			var l : Number = _headerResizers.length;
			for(var i : Number = 0; i< l;i++)
			{
				var column : TableColumnHeader = _children[i] as TableColumnHeader;
				var resizer : ColumnHeaderResizer = _headerResizers[i] as ColumnHeaderResizer;

				resizer.x = column.x + column.width - resizer.width / 2;
				resizer.y = column.y;
				resizer.size = new Dimension( 6, column.height );
				resizer.repaint();
			}
		}

		protected function modelDataChanged ( action : uint=0, indices :Array = null, values : Array = null) : void
		{
			if( !_locked )
			{
				if( _model.size != _oldSize )
					buildChildren();

				updateColumns();
				invalidatePreferredSizeCache();
				fireDataChangedSignal();
			}
		}
		protected function fireDataChangedSignal () : void
		{
			_dataChanged.dispatch( this, _model );
		}
		FEATURES::DND { 
		    override public function get supportedFlavors () : Array
		    {
			    return [ ComponentsFlavors.TABLE_COLUMN ];
		    }
		    override public function dragEnter ( manager : DnDManager, transferable : Transferable, source : DragSource ) : void
		    {
			    _scrollDuringDragTimeout = setInterval( scrollDuringDrag, 250 );
			    if( _enabled && ComponentsFlavors.TABLE_COLUMN.isSupported( transferable.flavors ) && containsComponent( source as Component ) )
				    manager.acceptDrag( this );
			    else
				    manager.rejectDrag( this );
		    }
		    override public function dragOver ( manager : DnDManager, transferable : Transferable, source : DragSource ) : void
		    {
			    _dropStatusShape.graphics.clear();
			    var lc : Component = getComponentUnderPoint ( new Point( this.stage.mouseX,
										       			 				this.stage.mouseY ) );
			    if( lc )
			    {
				    if( lc.mouseX > lc.width / 2 )
					    drawDropRight( lc );
				    else
					    drawDropLeft( lc );
			    }
		    }
		    override public function dragExit ( manager : DnDManager, transferable : Transferable, source : DragSource ) : void
		    {
			    clearInterval( _scrollDuringDragTimeout );
			    _dropStatusShape.graphics.clear();
		    }

		    override public function drop ( manager : DnDManager, transferable : Transferable ) : void
		    {
			    clearInterval( _scrollDuringDragTimeout );
			    _dropStatusShape.graphics.clear();

			    var d : TableColumn = transferable.getData( ComponentsFlavors.TABLE_COLUMN ) as TableColumn;
			    var lc : Component = getComponentUnderPoint ( new Point( this.stage.mouseX,
										       			 				this.stage.mouseY ) );
			    if( lc )
			    {
				    var index : int = _children.indexOf( lc );

				    if( mouseX > lc.x + lc.width / 2)
					    index++;

				    setColumnIndex( d, index );
			    }
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
					    if( mouseX < scb.hscrollbar.scroll + 16 )
						    scb.scrollLeft();
					    else if( mouseX > scb.hscrollbar.scroll + vp.width - 16 )
						    scb.scrollRight();
				    }
			    }
		    }
		} 
	}
}

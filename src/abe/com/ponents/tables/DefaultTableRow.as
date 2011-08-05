/**
 * @license
 */
package abe.com.ponents.tables 
{
    import abe.com.mon.core.IDisplayObject;
    import abe.com.mon.core.IDisplayObjectContainer;
    import abe.com.mon.core.IInteractiveObject;
    import abe.com.mon.utils.*;
    import abe.com.ponents.actions.Action;
    import abe.com.ponents.containers.DraggablePanel;
    import abe.com.ponents.core.*;
    import abe.com.ponents.core.edit.Editable;
    import abe.com.ponents.core.edit.Editor;
    import abe.com.ponents.core.focus.Focusable;
    import abe.com.ponents.events.ComponentEvent;
    import abe.com.ponents.layouts.components.BoxSettings;
    import abe.com.ponents.layouts.components.HBoxLayout;
    import abe.com.ponents.lists.List;
    import abe.com.ponents.lists.ListCell;
    import abe.com.ponents.transfer.Transferable;

    import flash.events.Event;
    import flash.geom.Rectangle;
    
    import org.osflash.signals.Signal;

    [Skinable(skin="ListCell")]
    public class DefaultTableRow extends DraggablePanel implements ListCell, 
                                                                   TableRow, 
                                                                   Component, 
                                                                   IDisplayObject, 
                                                                   IInteractiveObject,
                                                                   IDisplayObjectContainer
    {
        protected var _owner : List;
        protected var _columns : Array;
        protected var _data : *;
        protected var _action : Action;
        protected var _index : uint;
        protected var _allowEdit : Boolean;
        protected var _table : Table;
        
        public var componentSelectedChanged : Signal;

        public function DefaultTableRow () 
        {
            componentSelectedChanged = new Signal();
            _columns = [];
            _action = new TableRowSelectAction( this );
            super();
            _childrenLayout = new HBoxLayout(this,0);
            _allowFocus = false;
            _allowChildrenFocus = false;
            _allowOver = true;
            _allowPressed = true;
            _allowSelected = true;
        }
        public function buildChildren () : void
        {    
            if( _data != null && _columns )
            {
                var l1 : Number = _columns.length;
                var l2 : Number = _children.length;
                var l : Number = Math.max( l1, l2 );
                var i : Number;
                
                
                TARGET::FLASH_9 { var a : Array = []; }
                TARGET::FLASH_10 { var a : Vector.<Component> = new Vector.<Component>(); }
                TARGET::FLASH_10_1 { 
                var a : Vector.<Component> = new Vector.<Component>(); } 
                
                var item : TableCell;
                var column : TableColumn;
                
                for( i = 0; i < l; i++ )
                {
                    item = i < l2 ? _children[ i ] as TableCell : null;
                    column = i < l1 ? _columns[ i ] as TableColumn : null;
                    
                    if( item && ( column && !(item is column.cellClass) ) )
                    {
                        if( containsComponent( item ) )
                            removeCell( item );
                            
                        item = null;
                    }
                    
                    if( i < _columns.length )
                    {
                        if( item == null)
                        {
                            item = getCell( column );
                            addComponent( item );
                        }
                        a.push( item );
                    }
                    else if( i < numChildren && item )
                    {
                        removeCell( item );
                    }                
                }
                _children = a;
            }
            
        }    
        protected function updateCells () : void
        {
            var l : Number = _children.length;
            var i : Number;
            var column : TableColumn;
            var item : TableCell;
            var cl : HBoxLayout = _childrenLayout as HBoxLayout;                
            
            
            TARGET::FLASH_9 { cl.boxes = []; }
            TARGET::FLASH_10 { cl.boxes = new Vector.<BoxSettings>(); }
            TARGET::FLASH_10_1 { cl.boxes = new Vector.<BoxSettings>(); } 
                
            for( i=0;i< l;i++ )
            {
                column = _columns[i] as TableColumn;
                item = _children[i] as TableCell;
                
                item.table = table;
                item.owner = owner;
                item.column = column;
                item.field = column.field;
                item.width = column.finalSize;
                var v : * = ( _data as Object ).hasOwnProperty( column.field ) ? _data[ column.field ] : "No Data";
                item.value = v;
                item.index = index;
                item.allowEdit = _allowEdit;
                cl.boxes.push( new BoxSettings( column.finalSize, "left", "center", item, true, true ) );
            }
        }
        public function getCell ( column : TableColumn ) : TableCell
        {
            var c : Class = column.cellClass;
            var item : TableCell = AllocatorInstance.get( c, 
                                                          { 'owner':_owner,
                                                            'table':_table,
                                                            'row':this,
                                                            'enabled':_enabled,
                                                            'column':column,
                                                            'focusParent':this } ) as TableCell;
            return item;
        }
        public function removeCell( c : TableCell ):void
        {
            AllocatorInstance.release( c );
            removeComponent( c );
        }
        public function childrenMouseWheelRolled ( c : Component, d : Number ):void
        {
            mouseWheelRolled.dispatch( this, d );
        }
        
        TARGET::FLASH_9
        public function get cells () : Array { return _children; }
        
        TARGET::FLASH_10
        public function get cells () : Vector.<Component> { return _children; }
        
        TARGET::FLASH_10_1 
        public function get cells () : Vector.<Component> { return _children; }
        
        public function set columns ( a : Array ) : void
        {
            var l : Number = _columns ? _columns.length : -1;
            
            _columns = a;
            
            if( !_columns || l != _columns.length )
                buildChildren();
            
            updateCells ();
            invalidatePreferredSizeCache();
        }
        public function updateColumSize () : void
        {
            updateCells ();
            invalidatePreferredSizeCache();
        }
        public function updateColumns () : void
        {
            updateCells ();
            invalidatePreferredSizeCache();
        }
        public function get columns () : Array
        {
            return _columns;
        }
        public function get value () : * { return _data; }
        public function set value (val : *) : void
        {
            _data = val;
            updateCells ();
            invalidatePreferredSizeCache();
        }
        public function get owner () : List { return _owner; }
        public function set owner (l : List) : void
        {
            _owner = l;
        }
        public function get index () : uint { return _index; }    
        public function set index (index : uint) : void
        {
            _index = index;
        }

        override public function ensureRectIsVisible (r : Rectangle) : Component
        {
            r.y += y;
            _owner.ensureRectIsVisible(r);
            
            return this;
        }
        FEATURES::DND 
        override public function get transferData () : Transferable
        {
            return new TableTransferable( _data, _owner, "move", _owner.children.indexOf(this) );
        }
        

        public function get firstEditableComponent() : Editable
        {
            var l : uint = _children.length;
            for(var i : uint = 0;i< l;i++)
            {
                var c : Component = _children[i];
                if( c is Editable && ( c as Editable ).allowEdit )
                    return c as Editable;
            }
            return null;
        }
        
        public function get lastEditableComponent() : Editable
        {
            var l : uint = _children.length;
            while(l--)
            {
                var c : Component = _children[l];
                if( c is Editable && ( c as Editable ).allowEdit )
                    return c as Editable;
            }
            return null;
        }
        override public function focusNextChild (child : Focusable) : void
        {
            
            var index : int = _children.indexOf( child );
            if( index == _children.length-1 )
            {
                var b : Boolean = false;
                var c : DefaultTableRow;
                if( child is Editable && (child as Editable).isEditing )
                {
                    (child as Editable).confirmEdit();
                    b = true;
                }
                var rindex : int = this.index+1;
                
                if( b )
                {
                    if( rindex < _owner.model.size )
                    {
                        _owner.ensureIndexIsVisible(rindex);
                        c = _owner.getListCellWithIndex(rindex) as DefaultTableRow;
                    }
                    else
                    {
                        _owner.ensureIndexIsVisible(0);
                        c = _owner.getListCellWithIndex(0) as DefaultTableRow;
                    }
                
                    _owner.ensureRectIsVisible( new Rectangle( c.x, c.y, c.width, c.height ) );
                    
                    if( c.firstEditableComponent )                
                        c.firstEditableComponent.startEdit();
                }
                else super.focusNextChild( child );
            }
            else
                super.focusNextChild( child );
        }

        override public function focusPreviousChild (child : Focusable) : void
        {
            /*
            var index : int = _children.indexOf( child );
            if( index == 0 )
            {
                var b : Boolean = false;
                var c : DefaultTableRow;
                if( child is Editable && (child as Editable).isEditing )
                {
                    (child as Editable).confirmEdit();
                    b = true;
                }
                var rindex : int = this.index-1;
                
                if( rindex >= 0 )
                {
                    _owner.ensureIndexIsVisible(rindex);
                    c = _owner.getListCellWithIndex(rindex) as DefaultTableRow;
                }
                else
                {
                    _owner.ensureIndexIsVisible( _owner.model.size-1 );
                    c = _owner.getListCellWithIndex( _owner.model.size-1 ) as DefaultTableRow;
                }
                
                _owner.ensureRectIsVisible( new Rectangle( c.lastChild.x, c.y, c.lastChild.width, c.height ) );
                
                if( c.lastChild is Editable && b )                
                    (c.lastChild as Editable).startEdit();
            }
            else*/
                super.focusPreviousChild( child );
        }

        public function init () : void
        {
        }
        public function dispose () : void
        {
        }
        
        public function get selected () : Boolean { return _selected; }        
        public function set selected (b : Boolean) : void
        {
            if( b != _selected )
            {
                _selected = b;
                invalidate();
                fireComponentChangedSignal();
                componentSelectedChanged.dispatch( this, _selected );
                
                for each( var c : ListCell in _children)
                    c.selected = b;
            }
        }

        override public function click ( context : UserActionContext ) : void
        {
            super.click(context);
            if( _action )
                _action.execute( context );
        }

        public function startEdit () : void {}        
        public function cancelEdit () : void {}        
        public function confirmEdit () : void {}        
        public function get allowEdit () : Boolean { return _allowEdit; }        
        public function get editor () : Editor { return null; }        
        public function get isEditing () : Boolean { return false; }        
        public function get supportEdit () : Boolean { return true; }        
        public function set allowEdit (b : Boolean) : void         
        {
            _allowEdit = b;
            for each( var c : ListCell in _children)
                    c.allowEdit = b;
        }
        
        public function get table () : Table { return _table; }        
        public function set table (table : Table) : void
        {
            _table = table;
        }
    }
}

import abe.com.ponents.core.*;
import abe.com.ponents.actions.AbstractAction;
import abe.com.ponents.lists.List;
import abe.com.ponents.tables.DefaultTableRow;

import flash.events.MouseEvent;

internal class TableRowSelectAction extends AbstractAction 
{
    protected var _row : DefaultTableRow;

    public function TableRowSelectAction ( row : DefaultTableRow )
    {
        _row = row;
    }
    
    override public function execute( ... args ) : void
    {
        var act : UserActionContext = args[0] as UserActionContext;
        var list : List = _row.owner;
        var evt : MouseEvent = args as MouseEvent;
        
        if( act.shiftPressed && list.allowMultiSelection )
        {
            list.expandSelectionTo( _row );
        }
        else if( act.ctrlPressed && list.allowMultiSelection )
        {
            if( _row.selected )
                list.removeFromSelection( _row );
            else
                list.addToSelection( _row );
        }
        else if( list.allowMultiSelection )
        {
            if( _row.selected )
                list.selectedIndices = [];
            else 
            {
                list.selectedIndices = [ _row.index ];
                list.ensureCellIsVisible( _row );
            }
        }
        else
        {
            if( list.selectedIndex == _row.index )
                list.selectedIndex = -1;
            else
                list.selectedIndex = _row.index;
        }
        
    }
}

package abe.com.ponents.lists 
{
	import flash.events.Event;

	import abe.com.mon.core.IDisplayObject;
	import abe.com.mon.core.IDisplayObjectContainer;
	import abe.com.mon.core.IInteractiveObject;
	import abe.com.mon.utils.Reflection;
	import abe.com.ponents.buttons.DraggableButton;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.edit.Editable;
	import abe.com.ponents.core.edit.Editor;
	import abe.com.ponents.core.edit.EditorFactoryInstance;
	import abe.com.ponents.dnd.DragSource;
	import abe.com.ponents.events.EditEvent;
	import abe.com.ponents.history.UndoManagerInstance;
	import abe.com.ponents.layouts.display.DOInlineLayout;
	import abe.com.ponents.models.DefaultListModel;
	import abe.com.ponents.transfer.ComponentsTransferModes;
	import abe.com.ponents.transfer.Transferable;
	import abe.com.ponents.utils.Alignments;

	import flash.display.DisplayObject;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	[Skinable(skin="ListCell")]
	[Skin( define="ListCell",
		   inherit="DefaultComponent",
		   preview="abe.com.ponents.lists::List.defaultListPreview",
		   previewAcceptStyleSetup="false",
		   
		   state__all__foreground="skin.noDecoration",
		   state__0_1__background="new deco::SimpleFill( skin.listBackgroundColor )",		   state__2_3_4_6_7__background="new deco::SimpleFill( skin.listOverBackgroundColor )",		   state__8_12__background="new deco::SimpleFill( skin.listSelectedBackgroundColor )",		   state__9__background="new deco::SimpleFill( skin.listDisabledSelectedBackgroundColor )",		   state__10_11_14_15__background="new deco::SimpleFill( skin.listOverSelectedBackgroundColor )"
	)]
	public class DefaultListCell extends DraggableButton implements Component, 
																	IDisplayObject, 
																	IDisplayObjectContainer, 
																	IInteractiveObject,
																	ListCell, 
																	Editable,
																	DragSource
	{

		protected var _owner : List;
		protected var _isEditing : Boolean;
		protected var _allowEdit : Boolean;
		protected var _editor : Editor;
		protected var _index : uint;
		protected var _value : *;
		
		public function get value () : * { return _value; }		
		public function set value (val : *) : void
		{
			_value = val;
			
			super.label = formatLabel( _value );
			
			firePropertyEvent( "value", _value );
		}		

		protected function formatLabel ( value : * ) : String 
		{
			return _owner && _owner.hasFormatingFunction ? _owner.itemFormatingFunction.call( _owner, value ) : String( value );
		}

		public function DefaultListCell ()
		{
			super( new DefaultListCellSelectAction() );
			( _childrenLayout as DOInlineLayout).horizontalAlign = Alignments.LEFT;
			_isEditing = false;
			_allowEdit = true;
			_allowFocus = false;
			_removeLabelOnEmptyString = false;
			_tooltipOverlayOnMouseOver = true;
			doubleClickEnabled = true;
			addEventListener( MouseEvent.DOUBLE_CLICK, dbleClick );
		}
		public function get index () : uint	{ return _index; }		
		public function set index (id : uint) : void
		{
			_index = id;
		}
		
		public function get owner () : List	{ return _owner; }
		public function set owner (l : List) : void
		{
			_owner = l;
		}

		override public function focusIn (e : FocusEvent) : void
		{
			super.focusIn( e );
			if( _owner )
				_owner.ensureCellIsVisible( this );
		}
				
		public function init () : void		{}
		public function dispose () : void
		{
			_owner = null;
			_value = null;
			_index = 0;
		}

		public function get supportEdit () : Boolean
		{
			if( _owner.model is DefaultListModel )
				return !( _owner.model as DefaultListModel ).immutable;
			
			return true;
		}		
		public function startEdit () : void
		{
			if( allowEdit )
			{
				_owner.ensureIndexIsVisible( _index );
				
				_isEditing = true;
				
				if( _owner.model.contentType != null )
					_editor = EditorFactoryInstance.getForType( _owner.model.contentType );
				else
					_editor = EditorFactoryInstance.getForType( Reflection.getClass( _value ) );
				
				_editor.initEditState( this , _value, _labelTextField as DisplayObject );
				
				fireComponentEvent( EditEvent.EDIT_START );
				
				/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
					hideToolTip();
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			}
		}

		public function cancelEdit () : void
		{
			if( allowEdit )
			{
				_isEditing = false;
				EditorFactoryInstance.release( _editor );
				_editor = null;
				grabFocus();
				fireComponentEvent( EditEvent.EDIT_CANCEL );
			}
		}
		override public function set enabled (b : Boolean) : void
		{
			super.enabled = b;
			doubleClickEnabled = b;
		}
		override protected function iconResized (event : Event) : void 
		{
			super.iconResized( event );
			if( _owner )
			{
				_owner.listLayout.clearEstimatedSize();
				_owner.invalidatePreferredSizeCache();
			}
		}
		public function confirmEdit () : void
		{
			if( allowEdit && isEditing && _editor )
			{
				_isEditing = false;
				
				var id : Number = _index;
				var old : * = _owner.model.getElementAt(id);
				var v : *;
				if( _owner.model.contentType )
				{
					var c : Class = _owner.model.contentType;
					v = c( _editor.value );
				}
				else
					v = _editor.value;
				
				if( v != old )
				{
					valueChanged ( old, v, id );
				}			
				
				EditorFactoryInstance.release( _editor );
				_editor = null;
				grabFocus();
				fireComponentEvent( EditEvent.EDIT_CONFIRM );
				affectLabelText();
			}
		}
		
		public function get allowEdit () : Boolean { return _allowEdit && supportEdit; }
		public function set allowEdit (b : Boolean) : void
		{
			doubleClickEnabled = _allowEdit = b;
			
		}
		protected function valueChanged ( old : *, nevv : *, id : Number ) : void
		{
			_owner.model.setElementAt(id, nevv);
			this.label = formatLabel( nevv );
			UndoManagerInstance.add( new DefaultListCellUndoadleEdit( _owner, old, nevv, id ) );
		}
		public function get editor () : Editor
		{
			return _editor;
		}
		
		public function get isEditing () : Boolean
		{
			return _isEditing;
		}
		
		protected function dbleClick ( e : MouseEvent ) : void
		{
			if( allowEdit )
			{
				startEdit();
			}
		}
		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		override public function get dragGeometry () : DisplayObject { return this;	}
		
		override public function get transferData () : Transferable
		{
			return new ListTransferable( _value, owner, ComponentsTransferModes.MOVE, index );
		}			
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}

import abe.com.patibility.lang._;
import abe.com.ponents.actions.AbstractAction;
import abe.com.ponents.history.AbstractUndoable;
import abe.com.ponents.history.Undoable;
import abe.com.ponents.lists.List;
import abe.com.ponents.lists.ListCell;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

internal class DefaultListCellSelectAction extends AbstractAction 
{
	override public function execute (e : Event = null) : void
	{
		if( e )
		{
			var cell : ListCell = e.target as ListCell;
			if( !cell )
				return;
			
			var list : List = cell.owner;
			if( !list )
				return;
			
			var evt : MouseEvent = e as MouseEvent;
			
			if( evt )
			{
				if( evt.shiftKey && list.allowMultiSelection )
				{
					/*
					if( cell.selected )
						list.removeFromSelection( cell );
					else*/
						list.expandSelectionTo( cell );
				}
				else if( evt.ctrlKey && list.allowMultiSelection )
				{
					if( cell.selected )
						list.removeFromSelection( cell );
					else
						list.addToSelection( cell );
				}
				else if( list.allowMultiSelection )
				{
					if( cell.selected )
						list.clearSelection();
					else 
					{
						list.selectedIndices = [ cell.index ];
						list.ensureCellIsVisible( cell );
					}
				}
				else
				{
					if( list.selectedIndex == cell.index )
						list.clearSelection();
					else
						list.selectedIndex = cell.index;
				}
			}
			else if( e is KeyboardEvent )
			{
				if( list.allowMultiSelection )
				{
					if( cell.selected )
						list.clearSelection();
					else 
					{
						list.selectedIndices = [ cell.index ];
						list.ensureCellIsVisible( cell );
					}
				}
				else
				{
					if( list.selectedIndex == cell.index )
						list.clearSelection();
					else
						list.selectedIndex = cell.index;
				}
			}
		}
		fireCommandEnd();
	}
}

internal class DefaultListCellUndoadleEdit extends AbstractUndoable implements Undoable
{	
	protected var _list : List;
	protected var _oldValue : *;
	protected var _newValue : *;
	protected var _index : Number;
	
	public function DefaultListCellUndoadleEdit ( list : List, oldValue : *, newValue : *, index : Number )
	{
		_label = _("Edit List Item");
		_list = list;
		_newValue = newValue;
		_oldValue = oldValue;
		_index = index;
	}
	override public function undo() : void
	{
		_list.model.setElementAt( _index, _oldValue );
		super.undo();
	}	
	override public function redo() : void
	{
		_list.model.setElementAt( _index, _newValue );
		super.redo();
	} 
}


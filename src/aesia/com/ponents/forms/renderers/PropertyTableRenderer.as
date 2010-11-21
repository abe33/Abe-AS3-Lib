package aesia.com.ponents.forms.renderers 
{
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.forms.FormCategory;
	import aesia.com.ponents.forms.FormField;
	import aesia.com.ponents.forms.FormObject;
	import aesia.com.ponents.layouts.components.OldListLayout;
	import aesia.com.ponents.models.DefaultListModel;
	import aesia.com.ponents.tables.Table;
	import aesia.com.ponents.tables.TableColumn;

	/**
	 * @author Cédric Néhémie
	 */
	public class PropertyTableRenderer implements FormRenderer 
	{
		static protected var _instance : PropertyTableRenderer;
		
		static public function get instance () : PropertyTableRenderer
		{
			if( !_instance )
				_instance = new PropertyTableRenderer();
			
			return _instance;
		}
		
		public function render (o : FormObject) : Component
		{
			var t : Table = new Table();
			t.list.childrenLayout = new OldListLayout( t.list, 0, false );
			t.list.allowChildrenFocus = true;
			t.dndEnabled = false;
			t.editEnabled = false;
			t.list.listCellClass = PropertyTableRow;
			t.model = new DefaultListModel( buildModel( o ) );
			t.header.addColumns(new TableColumn( _("Name"), "name", 150, null, null, !o.hasCategories ),
				 				new TableColumn( _("Value"), "component", 200, ComponentTableCell, null, false ) );
			
			return t;
		}
		
		protected function buildModel (o : FormObject) : Array
		{
			var a : Array = [];
			var l : int;			var m : int;
			var i : int;			var j : int;
			var c : Component;
			var cat : FormCategory;
			var f : FormField;
			
			if( o.hasCategories )
			{
				l = o.categories.length;
				for( i=0; i<l; i++ )
				{
					cat = o.categories[i];
					a.push( {obj:cat,name:cat.name,component:null} );
					m = cat.fields.length;
					for( j=0;j<m;j++)
					{
						f = cat.fields[j];
						a.push( {obj:f, name:f.name, component:f.component} );
					}
				}
			}
			else
			{
				l = o.fields.length;
				for( i=0; i<l; i++ )
				{
					f = o.fields[i];
					a.push( {obj:f,name:f.name,component:f.component} );
				}
			}
			
			return a;
		}
	}
}

import aesia.com.mon.logs.Log;
import aesia.com.ponents.core.AbstractContainer;
import aesia.com.ponents.core.Component;
import aesia.com.ponents.core.edit.Editor;
import aesia.com.ponents.core.focus.Focusable;
import aesia.com.ponents.layouts.components.GridLayout;
import aesia.com.ponents.lists.List;
import aesia.com.ponents.tables.Table;
import aesia.com.ponents.tables.TableCell;
import aesia.com.ponents.tables.TableColumn;
import aesia.com.ponents.tables.TableRow;

import flash.events.FocusEvent;

[Skinable(skin="TableCell")]
internal class ComponentTableCell extends AbstractContainer implements TableCell
{

	private var _row : TableRow;
	private var _table : Table;
	private var _column : TableColumn;
	private var _field : String;
	private var _owner : List;
	private var _index : uint;
	private var _component : Component;
	
	public function ComponentTableCell ()
	{
		_childrenLayout = new GridLayout(this );
		super();
		//allowFocus = false;
		allowChildrenFocus = true;
	}

	override public function focusNext () : void
	{
		Log.info( this +" focus next" );
		_focusParent.focusNextChild( this );
	}

	override public function focusPrevious () : void
	{
		Log.info( this +" focus previous" );
		_focusParent.focusPreviousChild( this );
	}

	override public function focusOut (e : FocusEvent) : void
	{
	}

	override public function focusPreviousChild (child : Focusable) : void
	{
		focusPrevious();
	}

	override public function focusNextChild (child : Focusable) : void
	{
		focusNext ();
	}

	override public function keyFocusChange (e : FocusEvent) : void
	{
		e.preventDefault();
		super.keyFocusChange( e );
	}

	public function get table () : Table { return _table; }
	
	public function get row () : TableRow
	{
		return _row;
	}
	public function get column () : TableColumn
	{
		return _column;
	}
	public function get field () : String
	{
		return _field;
	}
	public function set table (t : Table) : void
	{
		_table = t;
	}
	public function set row (r : TableRow) : void
	{
		_row = r;
	}
	public function set column (t : TableColumn) : void
	{
		_column = t;
	}
	public function set field (s : String) : void
	{
		_field = s;
	}
	public function get selected () : Boolean
	{
		return _selected;
	}
	
	public function get owner () : List
	{
		return _owner;
	}
	public function get value () : *
	{
		return _component;
	}
	public function get index () : uint
	{
		return _index;
	}
	public function set selected (b : Boolean) : void
	{
		_selected = true;
	}
	public function set owner (l : List) : void
	{
		_owner = l;
	}
	public function set value (val : *) : void
	{
		if( _component != val )
		{
			Log.debug( _component + " != " + val + ", " + _row.value.name );
			if( _component  )
				removeComponent( _component );
		
			_component = val as Component;
			
			if( _component )
				addComponent( _component );
		}
	}
	public function set index (id : uint) : void
	{
		_index = id;
	}
	public function get supportEdit () : Boolean
	{
		return false;
	}
	public function startEdit () : void
	{
	}
	public function cancelEdit () : void
	{
	}
	public function confirmEdit () : void
	{
	}
	public function get allowEdit () : Boolean
	{
		return false;
	}
	
	public function get editor () : Editor
	{
		return null;
	}
	
	public function get isEditing () : Boolean
	{
		return false;
	}
	
	public function set allowEdit (b : Boolean) : void
	{
	}
	
	public function init () : void
	{
	}
	
	public function dispose () : void
	{
		if( _component )
			removeComponent( _component );
		_component = null;
	}
}
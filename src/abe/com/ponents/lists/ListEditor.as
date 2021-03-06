package abe.com.ponents.lists 
{
	import abe.com.mands.ProxyCommand;
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.mon.utils.Keys;
	import abe.com.mon.utils.magicClone;
	import abe.com.patibility.lang._;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.containers.ScrollPane;
	import abe.com.ponents.containers.ToolBar;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.edit.Editable;
	import abe.com.ponents.core.edit.Editor;
	import abe.com.ponents.forms.FormComponent;
	import abe.com.ponents.menus.ComboBox;
	import abe.com.ponents.models.DefaultListModel;
	import abe.com.ponents.skinning.icons.magicIconBuild;
	import abe.com.ponents.text.TextInput;

	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;

	[Skinable(skin="ListEditor")]
	[Skin(define="ListEditor",
		  inherit="ScrollPane",
		  preview="abe.com.ponents.lists::ListEditor.defaultListEditorPreview",
		  
		  custom_contentHeight="60"
	)]
	/**
	 * @author cedric
	 */
	public class ListEditor extends ScrollPane implements FormComponent, Editor
	{
		FEATURES::BUILDER
		static public function defaultListEditorPreview () : ListEditor
		{
			var li : ListEditor = new ListEditor([_("Sample Item 1"),_("Sample Item 2"),_("Sample Item 3")] );
			return li;
		}
		
		[Embed(source="../skinning/icons/minus.png")]
		static public var REMOVE_ICON : Class;
			
		[Embed(source="../skinning/icons/add.png")]
		static public var ADD_ICON : Class;	
		
		protected var _list : List;
		protected var _caller : Editable;
		
		protected var _addButton : Button;
		protected var _removeButton : Button;
		protected var _toolBar : ToolBar;
		
		protected var _value : Array;
		protected var _disabledMode : uint;
		protected var _disabledValue : *;
		protected var _newValueProvider : Component;
		protected var _contentType : Class;
		
		protected var _dataChanged : Signal;
		public function get dataChanged () : Signal { return _dataChanged; }

		public function ListEditor ( initialData : Array = null, 
									 newValueProvider : Component = null, 
									 contentType : Class = null,
									 formatFunction : Function = null )
		{
			super();
			_dataChanged = new Signal();
			_value =  initialData ? initialData : [];
			_list = new List( _value );
			_list.allowMultiSelection = true;
			_list.model.contentType = contentType;
			_list.model.dataChanged.add( modelDataChanged );
			
			view = _list;
			rowHead = new ListLineRuler(_list, true );
			_contentType = contentType;
			
			_addButton = new Button("", magicIconBuild( ADD_ICON ) );
			_removeButton = new Button("", magicIconBuild( REMOVE_ICON ) );
			
			FEATURES::TOOLTIP { 
				_addButton.tooltip = _("Add to the list");
				_removeButton.tooltip = _("Remove selection from the list");
			} 
			
			_addButton.buttonClicked.add( addClicked );
			_removeButton.buttonClicked.add( removeClicked );
			
			_toolBar = new ToolBar( );
			FEATURES::DND { 
				_toolBar.dndEnabled = false;
			} 
			_toolBar.addComponent( _removeButton );
			_toolBar.addComponent( _addButton );
			
			_addButton.isComponentIndependent = false;
			_removeButton.isComponentIndependent = false;
			_list.isComponentIndependent = false;
			_viewport.isComponentIndependent = false;
			_toolBar.isComponentIndependent = false;

			colHead = _toolBar;
			
			this.newValueProvider = newValueProvider ? newValueProvider : new TextInput();
			
			if( formatFunction != null )
			{
				_list.itemFormatingFunction = formatFunction;
				if( _newValueProvider is ComboBox )
				  ( _newValueProvider as ComboBox ).itemFormatingFunction = formatFunction;
			}
			
			FEATURES::KEYBOARD_CONTEXT { 
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.DELETE ) ] = new ProxyCommand( removeClicked );
			} 
		}
		public function get toolBar () : ToolBar { return _toolBar; }	
		public function get addButton () : Button { return _addButton; }
		public function get removeButton () : Button { return _removeButton; }
		
		public function get newValueProvider () : Component { return _newValueProvider; }		
		public function set newValueProvider ( newValueProvider : Component ) : void
		{
			if( _newValueProvider )
			{
				_toolBar.removeComponent( _newValueProvider );
			}
			_newValueProvider = newValueProvider;
			if( _newValueProvider )
			{
				_toolBar.addComponent( _newValueProvider );
			}
			preferredSize = new Dimension(_toolBar.preferredWidth + 40, _toolBar.preferredHeight + _style.contentHeight );
		}

		public function get value () : * { return _value; }		
		public function set value (value : *) : void
		{
		    if( _list && _list.model )
		        _list.model.dataChanged.remove( modelDataChanged );
			_value = value as Array;
			_list.model = new DefaultListModel(_value);
			_list.model.contentType = _contentType;
			_list.model.dataChanged.add( modelDataChanged );
		}

		public function get disabledMode () : uint { return _disabledMode; }
		public function set disabledMode (b : uint) : void
		{
			_disabledMode = b;
			if( _newValueProvider is FormComponent )
			  ( _newValueProvider as FormComponent ).disabledMode = b;	
			 
			_list.model = new DefaultListModel([]);
			_list.model.contentType = _contentType;
		}

		public function get disabledValue () : * { return _disabledValue; }		
		public function set disabledValue (v : *) : void
		{
			_disabledValue = v;
		}
		
		public function get contentType () : Class { return _contentType; }		
		public function set contentType (contentType : Class) : void
		{
			_contentType = contentType;
			_list.model.contentType = _contentType;
		}
		
		public function get list () : List { return _list; }
		
		public function get caller () : Editable { return _caller; }	
		public function set caller (e : Editable) : void
		{
			_caller = e;
		}		
		
		public function reset() : void
		{
			value = [];
			
			if( (_newValueProvider as Object).hasOwnProperty( "reset" ) )
				_newValueProvider["reset"]();
		}
		
		protected function removeClicked ( ...args ) : void 
		{
			if( _list.allowMultiSelection )
			{
				var a : Array = _list.selectedIndices;
				a.sort();
				var l : int = a.length;
				
				while( l-- )
				{
					_list.model.removeElementAt( a[l] );
				}
				
				_list.clearSelection();
			}
			else
			{
				if( _list.selectedIndex != -1 )
					_list.model.removeElementAt( _list.selectedIndex );
				
				_list.clearSelection();
			}
		}

		protected function addClicked ( ...args ) : void 
		{
			if( _newValueProvider )
			{
				if( (_newValueProvider as Object).hasOwnProperty("value") )
				{
					_list.model.addElement( magicClone(_newValueProvider["value"]) );
					
					if( (_newValueProvider as Object).hasOwnProperty( "reset" ) )
						_newValueProvider["reset"]();
				}
			}
		}
		public function initEditState (caller : Editable, value : *, overlayTarget : DisplayObject = null) : void
		{
			this.caller = caller;
			this.value = value as Array;
		}
		
		protected function modelDataChanged ( a : uint = 0, i : Array = null, v : Array = null ) : void 
		{
			_value = _list.model.toArray();
			_dataChanged.dispatch( this, _value );
		}
	}
}

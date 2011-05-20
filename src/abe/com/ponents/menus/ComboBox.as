package abe.com.ponents.menus 
{
	import abe.com.mands.ProxyCommand;
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.logs.Log;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.mon.utils.Keys;
	import abe.com.mon.utils.StageUtils;
	import abe.com.patibility.lang._;
	import abe.com.ponents.buttons.AbstractFormButton;
	import abe.com.ponents.buttons.ButtonDisplayModes;
	import abe.com.ponents.core.*;
	import abe.com.ponents.core.edit.Editable;
	import abe.com.ponents.core.edit.Editor;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.events.PropertyEvent;
	import abe.com.ponents.forms.FormComponent;
	import abe.com.ponents.forms.FormComponentDisabledModes;
	import abe.com.ponents.layouts.display.DOBoxSettings;
	import abe.com.ponents.layouts.display.DOHBoxLayout;
	import abe.com.ponents.models.ComboBoxModel;
	import abe.com.ponents.models.DefaultComboBoxModel;
	import abe.com.ponents.models.DefaultListModel;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.utils.ToolKit;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;

	[Style(name="dropDownIcon",type="abe.com.ponents.skinning.icons.Icon")]
	[Style(name="popupIcon",type="abe.com.ponents.skinning.icons.Icon")]
	[Event(name="dataChange", type="abe.com.ponents.events.ComponentEvent")]
	[Skinable(skin="ComboBox")]
	[Skin(define="ComboBox",
		  inherit="Button",
		  preview="abe.com.ponents.menus::ComboBox.defaultComboBoxPreview",
		  custom_dropDownIcon="icon(abe.com.ponents.menus::ComboBox.DROP_DOWN_ICON)",
		  custom_popupIcon="icon(abe.com.ponents.menus::ComboBox.POPUP_ICON)"
	)]
	public class ComboBox extends AbstractFormButton implements FormComponent, Editor
	{
		FEATURES::BUILDER { 
		    static public function defaultComboBoxPreview() : Component
		    {
			    return new ComboBox( "Item 1", "Item 2" );
		    }
		} 
		
		[Embed(source="../skinning/icons/combobox.png")]
		static public var POPUP_ICON : Class;
		[Embed(source="../skinning/icons/scrolldown.png")]
		static public var DROP_DOWN_ICON : Class;
		
		protected var _model : ComboBoxModel;
		protected var _popupMenu : PopupMenu;
		protected var _popupAsDropDown : Boolean;
		protected var _popupAlignOnSelection : Boolean;
		protected var _menuItemClass : Class;
		
		protected var _dropDownIcon : Icon;
		protected var _dropDownIconIndex : int;
		protected var _value : *;
		protected var _caller : Editable;
		protected var _itemFormatingFunction : Function;
		protected var _itemDescriptionProvider : Function;
		
		public function ComboBox ( ... args )
		{
			super();
			_popupMenu = new PopupMenu();
			_popupMenu.menuList.itemFormatingFunction = formatLabel;
			_menuItemClass = _menuItemClass ? _menuItemClass : MenuItem;
				
			var layout : DOHBoxLayout = new DOHBoxLayout( _childrenContainer, 0, 
											new DOBoxSettings( _popupMenu.preferredWidth, "left", "center", null, true, true, true ), 
											new DOBoxSettings( 0, "center"),
											new DOBoxSettings( 16, "center")
											);
			
			layout.setObjectForBox( _labelTextField as DisplayObject, 0 );
			childrenLayout = layout;
			
			dropDownIcon = _popupAsDropDown || !_popupAlignOnSelection ? 
						_style.dropDownIcon.clone() :
						_style.popupIcon.clone();
						
			if( args.length > 1 )
				model = new DefaultComboBoxModel( args );
			else if( args.length == 1 )
			{
				if( args[0] is Array )
					model = new DefaultComboBoxModel( args[0] );
				else if( args[0] is ComboBoxModel )
					model = args[0];
				else
					model = new DefaultComboBoxModel();
			}
			else
				model = new DefaultComboBoxModel();
			
			FEATURES::KEYBOARD_CONTEXT { 
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.DOWN ) ] = new ProxyCommand( down );
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.UP ) ] = new ProxyCommand( up );
				addEventListener( KeyboardEvent.KEY_UP, listKeyUp );
			} 
		}
		
		public function get model () : ComboBoxModel { return _model; }	
		public function set model (model : ComboBoxModel) : void
		{
			if( !model )
				return;
			
			if( _model )
			{
				_model.dataChanged.remove( modelDataChanged );
				_model.selectionChanged.remove ( selectionChanged );
			}
			
			_model = model;
			modelDataChanged();
			
			if( _model )
			{
				_model.dataChanged.add( modelDataChanged );
				_model.selectionChanged.add( selectionChanged );
			}
		}
		public function get popupAsDropDown () : Boolean { return _popupAsDropDown;	}		
		public function set popupAsDropDown (popupAsDropDown : Boolean) : void
		{
			_popupAsDropDown = popupAsDropDown;
			dropDownIcon = _popupAsDropDown || !_popupAlignOnSelection ? 
						_style.dropDownIcon.clone() :
						_style.popupIcon.clone();
		}
		public function get popupAlignOnSelection () : Boolean { return _popupAlignOnSelection; }		
		public function set popupAlignOnSelection (popupAlignOnSelection : Boolean) : void
		{
			_popupAlignOnSelection = popupAlignOnSelection;
			
			dropDownIcon = _popupAsDropDown || !_popupAlignOnSelection ? 
						_style.dropDownIcon.clone() :
						_style.popupIcon.clone();
		}
		public function get dropDownIcon () : Icon	{ return _icon;	}
		public function set dropDownIcon (icon : Icon ) : void
		{
			if( _dropDownIcon && contains( _dropDownIcon ) )
			{
				_dropDownIcon.componentResized.add( iconResized );
				_childrenContainer.removeChild( _dropDownIcon );
			}
			
			if( _dropDownIcon )
				_dropDownIcon.dispose();
				
			_dropDownIcon = icon;
			
			if( _dropDownIcon )
			{
				_dropDownIcon.init();
				_dropDownIcon.invalidate();
				_dropDownIcon.componentResized.add( iconResized );
				//_childrenContainer.addChild
				if( _icon && containsComponentChild( _icon ) )
					addComponentChildAfter( _dropDownIcon, _icon );
				else if( _labelTextField && containsComponentChild( _labelTextField as DisplayObject ) )
					addComponentChildAfter( _dropDownIcon, _labelTextField as DisplayObject );
				else
					addComponentChildAt( _dropDownIcon, _dropDownIconIndex );
				
				( childrenLayout as DOHBoxLayout ).setObjectForBox( _dropDownIcon, 2 );
			}
			invalidatePreferredSizeCache();
		}
		override public function set buttonDisplayMode (displayMode : uint) : void
		{
			if( displayMode == ButtonDisplayModes.ICON_ONLY )
				displayMode = ButtonDisplayModes.TEXT_AND_ICON;
			
			super.buttonDisplayMode = displayMode;
		}

		override public function set icon ( icon : Icon ) : void
		{
			super.icon = icon;
			( childrenLayout as DOHBoxLayout ).setObjectForBox( _icon, 1 );
		}
				
		public function get caller () : Editable { return _caller; }		
		public function set caller (e : Editable) : void { _caller = e; }
		
		override public function get value () : * { return _value; }	
		override public function set value (val : *) : void
		{
			if( _model.contains( val ) )
				_value = val;
			else
				_value = _model.getElementAt(0);
			label = formatLabel( _value );
		}
		public function get itemDescriptionProvider () : Function { return _itemDescriptionProvider; }
		public function set itemDescriptionProvider (itemDescriptionProvider : Function) : void 
		{ 
			_itemDescriptionProvider = itemDescriptionProvider; 
			if( _itemDescriptionProvider != null )
			{
				var l : uint = _popupMenu.menuList.model.size;
				
				var item : MenuItem; 
				try
				{
					for( var i : Number = 0; i< l; i++ )
					{
						item = _popupMenu.menuList.model.getElementAt(i);
						(item.action as SelectAction).longDescription = _itemDescriptionProvider( _model.getElementAt(i) );
					}
				}
				catch( e : Error )
				{
					Log.error( e );
				}
			}
		}
		public function get itemFormatingFunction () : Function { return _itemFormatingFunction; }		
		public function set itemFormatingFunction ( itemFormatingFunction : Function ) : void
		{
			_size = null;
			_itemFormatingFunction = itemFormatingFunction;
			
			label = formatLabel( _value );
			var l : uint = _popupMenu.menuList.model.size;
			
			var item : MenuItem; 
			try
			{
				for( var i : Number = 0; i< l; i++ )
				{
					item = _popupMenu.menuList.model.getElementAt(i);
					(item.action as SelectAction).name = formatLabel( _model.getElementAt(i) );
				}
				_popupMenu.menuList.invalidatePreferredSizeCache();
				clearHBoxSize();
				invalidatePreferredSizeCache();
			}
			catch( e : Error )
			{
				Log.error( e );
			}
		}

		public function get hasFormatingFunction () : Boolean
		{
			return _itemFormatingFunction != null;
		}
		override public function set preferredSize (d : Dimension) : void
		{
			super.preferredSize = d;
			
			var w : Number = _labelTextField.height;
			_labelTextField.autoSize = "none";
			_labelTextField.height = w;
			
			var layout : DOHBoxLayout = _childrenLayout as DOHBoxLayout;
			layout.boxes[0].size = d.width - layout.gap - layout.boxes[1].size - _style.insets.horizontal;
			invalidatePreferredSizeCache();
		}
		override public function get preferredSize () : Dimension
		{
			var layout : DOHBoxLayout = _childrenLayout as DOHBoxLayout;

			return super.preferredSize;
		}
		
		public function get popupMenu () : PopupMenu { return _popupMenu; }
		
		public function get menuItemClass () : Class { return _menuItemClass; }		
		public function set menuItemClass (menuItemClass : Class) : void
		{
			_menuItemClass = menuItemClass;
			_popupMenu.removeAllItems();
			invalidatePreferredSizeCache();
			//buildChildren();
		}
		protected function clearHBoxSize () : void
		{
			var hbox : DOHBoxLayout = _childrenLayout as DOHBoxLayout;
			if( hbox )
			{
				if( hbox.boxes[0] )
					hbox.boxes[0].size = _popupMenu.menuList.width;
			}
		}
		public function initEditState (caller : Editable, value : *, overlayTarget : DisplayObject = null) : void
		{
			this.caller = caller;
			this.value = value;
			
			var bb : Rectangle = ( _caller ).getBounds( StageUtils.root );
			
			ToolKit.popupLevel.addChild( this );
			position = bb.topLeft;
			_preferredSizeCache = new Dimension( bb.width, bb.height );
		}

		protected function formatLabel (value : *) : String 
		{
			return hasFormatingFunction ? _itemFormatingFunction.call(null, value) : String( value );
		}
		protected function buildChildren () : void
		{
			var l : Number = _model.size;

			_popupMenu.size = null;
			_popupMenu.menuList.model = new DefaultListModel();
			
			loop:for( var i : Number = 0; i< l; i++ )
			{
				var item : MenuItem; 
				item = new _menuItemClass( new SelectAction( formatLabel(_model.getElementAt( i )), i, this ) );
				if( _itemDescriptionProvider != null )
					( item.action as SelectAction ).longDescription = _itemDescriptionProvider( _model.getElementAt( i ) );
				item.columnsSizes = [0,0,0,0];
				FEATURES::DND { 
				    item.allowDrag = false;
				} 
				(item.childrenLayout as DOHBoxLayout).gap = 0;
				
				_popupMenu.addMenuItem( item );
			}
			invalidatePreferredSizeCache();
			
			if( _model.selectedElement )
				this.value = _model.selectedElement;
			else
				this.value = null;
			
//			var l1 : Number = _model.size;
//			var l2 : Number = _popupMenu.numMenuItems;
//			var l : Number = Math.max( l1, l2 );
//			
//			
//			loop:for( var i : Number = 0; i<l; i++ )
//			{
//				var item : MenuItem; 
//				
//				if( i >= l2 )
//				{
//					item = new _menuItemClass( new SelectAction( formatLabel(_model.getElementAt( i )), i, this ) );
//					item.columnsSizes = [0,0,0,0];
//					FEATURES::DND { 
//					item.allowDrag = false;
//					} 
//					(item.childrenLayout as DOHBoxLayout).gap = 0;
//					
//					_popupMenu.addMenuItem( item );
//				}
//				else
//				{
//					item = _popupMenu.getItem(i);
//					
//					if( i >= l1 )
//					{
//						_popupMenu.removeMenuItem( item );
//						break;
//					}
//					
//					item.action = new SelectAction( formatLabel(_model.getElementAt( i )), i, this );
//				}
//			}	
//			
//			if( _model.selectedElement )
//				this.value = _model.selectedElement;
//			else
//				this.value = null;
			
		}
		
		public function fitPopupToCombo () : void
		{
			if( _childrenLayout is DOHBoxLayout && _popupMenu )
			{
				if( !_preferredSize && !_size )
				{
					
					var d : Dimension = _popupMenu.preferredSize;
					var layout : DOHBoxLayout = _childrenLayout as DOHBoxLayout;	
					layout.boxes[0].size = d.width;
						
					var d2 : Dimension = _preferredSizeCache = layout.preferredSize.grow( _style.insets.horizontal, _style.insets.vertical );
						
					_popupMenu.width = width;
				}
				else
				{
					_popupMenu.width = calculateComponentSize().width;
				}
			}
		}

		public function down () : void
		{
			var id : Number = _model.indexOf( _model.selectedElement );
			if( id + 1 < _model.size )
				_model.selectedElement = _model.getElementAt( id + 1 );
		}

		public function up () : void
		{
			var id : Number = _model.indexOf( _model.selectedElement );
			if( id - 1 < _model.size )
				_model.selectedElement = _model.getElementAt( id - 1 );
		}
		
		override public function click ( context : UserActionContext ) : void
		{
			if( !_popupMenu.stage )
			{
				var bb : Rectangle = this.getBounds( ToolKit.popupLevel );
				
				_popupMenu.invoker = this;
				var id : Number = _model.indexOf( _model.selectedElement );
				if( id != -1 )
					_popupMenu.selectedIndex = id;
				
				if( _popupAsDropDown )
				{
					_popupMenu.x = bb.x;
					_popupMenu.y = bb.bottom;
				}
				else
				{
					if( _popupAlignOnSelection )
					{
						var y : Number = (_popupMenu.selectedValue as MenuItem).y;
						_popupMenu.x = bb.x;
						_popupMenu.y = bb.y - y;
					}
					else
					{
						_popupMenu.x = bb.x;
						_popupMenu.y = bb.y;
					}
				}
				
				ToolKit.popupLevel.addChild( _popupMenu );				
				StageUtils.stage.focus = _popupMenu.menuList;
				fitPopupToCombo();
			}	
		}
		override public function removeFromStage (e : Event) : void 
		{
			super.removeFromStage( e );
			if( displayed && _popupMenu && _popupMenu.displayed )
				_popupMenu.hide(false);
		}
		protected function selectionChanged ( m : ComboBoxModel, i : uint, v : * ) : void
		{
			_popupMenu.selectedIndex = _model.indexOf( _model.selectedElement );
			this.value = _model.selectedElement;
			fireDataChangedSignal();
			
			if( _caller )
				_caller.confirmEdit();
		}

		protected function modelDataChanged ( a : uint = 0, i : Array = null, v : Array = null ) : void
		{
			buildChildren ();
			invalidatePreferredSizeCache();
			fitPopupToCombo ();
		}
		override protected function stylePropertyChanged ( propertyName : String, propertyValue : * ) : void
		{
			switch( propertyName )
			{
				case "dropDownIcon" : 
					if( _popupAsDropDown || !_popupAlignOnSelection ) 
						icon = _style.dropDownIcon.clone();
					break;
				case "popupIcon" :
					if( !_popupAsDropDown && _popupAlignOnSelection ) 
						icon = _style.popupIcon.clone();
					break; 
				default : 
					super.stylePropertyChanged( propertyName, propertyValue );
					break;
			}
		}
		FEATURES::KEYBOARD_CONTEXT { 
		protected function listKeyUp ( event : KeyboardEvent ) : void 
		{
			var s : String = String.fromCharCode( event.charCode ).toLowerCase();
			if( s.match( /[a-zA-Z0-9]/i ) != null )
				_popupMenu.menuList.listKeyUp( event );

		}
		} 
	}
}

import abe.com.ponents.actions.AbstractAction;
import abe.com.ponents.menus.ComboBox;

internal class SelectAction extends AbstractAction
{
	protected var _id : Number;
	protected var _caller : ComboBox;
	public function SelectAction( name : String, id : Number, owner : ComboBox )
	{
		super( name );
		_id = id;
		_caller = owner;
	}

	override public function execute( ... args ) : void
	{
		_caller.model.selectedElement = _caller.model.getElementAt( _id );
		commandEnded.dispatch( this );
	}
}

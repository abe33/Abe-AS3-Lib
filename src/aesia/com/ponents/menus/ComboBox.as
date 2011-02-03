package aesia.com.ponents.menus 
{
	import aesia.com.ponents.models.DefaultListModel;
	import aesia.com.mands.ProxyCommand;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Keys;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.buttons.AbstractButton;
	import aesia.com.ponents.buttons.ButtonDisplayModes;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.core.edit.Editable;
	import aesia.com.ponents.core.edit.Editor;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.events.PropertyEvent;
	import aesia.com.ponents.forms.FormComponent;
	import aesia.com.ponents.forms.FormComponentDisabledModes;
	import aesia.com.ponents.layouts.display.DOBoxSettings;
	import aesia.com.ponents.layouts.display.DOHBoxLayout;
	import aesia.com.ponents.models.ComboBoxModel;
	import aesia.com.ponents.models.DefaultComboBoxModel;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;

	[Style(name="dropDownIcon",type="aesia.com.ponents.skinning.icons.Icon")]	[Style(name="popupIcon",type="aesia.com.ponents.skinning.icons.Icon")]
	[Event(name="dataChange", type="aesia.com.ponents.events.ComponentEvent")]
	[Skinable(skin="ComboBox")]	[Skin(define="ComboBox",
		  inherit="Button",
		  preview="aesia.com.ponents.menus::ComboBox.defaultComboBoxPreview",
		  custom_dropDownIcon="icon(aesia.com.ponents.menus::ComboBox.DROP_DOWN_ICON)",		  custom_popupIcon="icon(aesia.com.ponents.menus::ComboBox.POPUP_ICON)"
	)]
	public class ComboBox extends AbstractButton implements FormComponent, Editor
	{
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		static public function defaultComboBoxPreview() : Component
		{
			return new ComboBox( "Item 1", "Item 2" );
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		[Embed(source="../skinning/icons/combobox.png")]
		static public var POPUP_ICON : Class;
		[Embed(source="../skinning/icons/scrolldown.png")]
		static public var DROP_DOWN_ICON : Class;
		
		protected var _model : ComboBoxModel;
		protected var _popupMenu : PopupMenu;
		protected var _popupAsDropDown : Boolean;
		protected var _popupAlignOnSelection : Boolean;		protected var _menuItemClass : Class;
		
		protected var _dropDownIcon : Icon;
		protected var _dropDownIconIndex : int;
		protected var _value : *;
		protected var _caller : Editable;
		protected var _itemFormatingFunction : Function;
		protected var _itemDescriptionProvider : Function;
		
		protected var _disabledMode : uint;
		protected var _disabledValue : *;
		
		public function ComboBox ( ... args )
		{
			super();
			_popupMenu = new PopupMenu( );
			_popupMenu.menuList.itemFormatingFunction = formatLabel;
			_menuItemClass = _menuItemClass ? _menuItemClass : MenuItem;
				
			var layout : DOHBoxLayout = new DOHBoxLayout( _childrenContainer, 0, 
											new DOBoxSettings( _popupMenu.preferredWidth, "left", "center", null, true, true, true ), 
											new DOBoxSettings( 0, "center"),											new DOBoxSettings( 16, "center")
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
			
			/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/	
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.DOWN ) ] = new ProxyCommand( down );				_keyboardContext[ KeyStroke.getKeyStroke( Keys.UP ) ] = new ProxyCommand( up );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/		}
		
		public function get model () : ComboBoxModel { return _model; }	
		public function set model (model : ComboBoxModel) : void
		{
			if( !model )
				return;
			
			if( _model )
			{
				_model.removeEventListener( ComponentEvent.DATA_CHANGE, dataChanged );				_model.removeEventListener( ComponentEvent.SELECTION_CHANGE, selectionChanged );
			}
			
			_model = model;
			dataChanged( null );
			
			if( _model )
			{
				_model.addEventListener( ComponentEvent.DATA_CHANGE, dataChanged );
				_model.addEventListener( ComponentEvent.SELECTION_CHANGE, selectionChanged );
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
				_dropDownIcon.removeEventListener( ComponentEvent.COMPONENT_RESIZE, iconResized );
				_childrenContainer.removeChild( _dropDownIcon );
			}
			
			if( _dropDownIcon )
				_dropDownIcon.dispose();
				
			_dropDownIcon = icon;
			
			if( _dropDownIcon )
			{
				_dropDownIcon.init();
				_dropDownIcon.invalidate();
				_dropDownIcon.addEventListener( ComponentEvent.COMPONENT_RESIZE, iconResized );
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
		
		public function get value () : * { return _value; }	
		public function set value (val : *) : void
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
					for( var i : Number = 0; i<l; i++ )
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
				for( var i : Number = 0; i<l; i++ )
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
		public function get disabledMode () : uint { return _disabledMode; }
		public function set disabledMode (b : uint) : void
		{
			_disabledMode = b;
			
			if( !_enabled )
				checkDisableMode();
		}

		public function get disabledValue () : * { return _disabledValue; }		
		public function set disabledValue (v : *) : void 
		{
			_disabledValue = v;
		}
		override public function set enabled (b : Boolean) : void 
		{
			super.enabled = b;
			checkDisableMode();
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
			
			loop:for( var i : Number = 0; i<l; i++ )
			{
				var item : MenuItem; 
				item = new _menuItemClass( new SelectAction( formatLabel(_model.getElementAt( i )), i, this ) );
				if( _itemDescriptionProvider != null )
					( item.action as SelectAction ).longDescription = _itemDescriptionProvider( _model.getElementAt( i ) );
				item.columnsSizes = [0,0,0,0];
				/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
				item.allowDrag = false;
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				(item.childrenLayout as DOHBoxLayout).gap = 0;
				
				_popupMenu.addMenuItem( item );
			}
			invalidatePreferredSizeCache();
			
			if( _model.selectedElement )
				this.value = _model.selectedElement;
			else
				this.value = null;
			
//			var l1 : Number = _model.size;//			var l2 : Number = _popupMenu.numMenuItems;//			var l : Number = Math.max( l1, l2 );
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
//					/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
//					item.allowDrag = false;
//					/*FDT_IGNORE*/ } /*FDT_IGNORE*/
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
		{			var id : Number = _model.indexOf( _model.selectedElement );
			if( id - 1 < _model.size )
				_model.selectedElement = _model.getElementAt( id - 1 );
		}
		
		override public function click (e : Event = null) : void
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
				StageUtils.stage.focus = _popupMenu;
				fitPopupToCombo();
			}	
		}
		override public function removeFromStage (e : Event) : void 
		{
			super.removeFromStage( e );
			if( _popupMenu && _popupMenu.displayed )
				_popupMenu.hide(false);
		}
		protected function selectionChanged (event : ComponentEvent) : void
		{
			_popupMenu.selectedIndex = _model.indexOf( _model.selectedElement );
			this.value = _model.selectedElement;
			fireDataChange();
			
			if( _caller )
				_caller.confirmEdit();
		}

		protected function dataChanged (event : ComponentEvent) : void
		{
			buildChildren ();
			invalidatePreferredSizeCache();
			fitPopupToCombo ();
		}
		override protected function stylePropertyChanged ( e : PropertyEvent ) : void
		{
			switch( e.propertyName )
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
					super.stylePropertyChanged( e );
					break;
			}
		}
		
		protected function checkDisableMode() : void
		{
			switch( _disabledMode )
			{
				case FormComponentDisabledModes.DIFFERENT_ACROSS_MANY : 
					disabledValue = _("different values across many");
					affectLabelText();
					break;
					
				case FormComponentDisabledModes.UNDEFINED : 
					disabledValue = _("not defined");
					break;
				
				case FormComponentDisabledModes.INHERITED : 
					break;
					
				case FormComponentDisabledModes.NORMAL :
				default : 
					disabledValue = value;
					break;
			}
		}
		override protected function affectLabelText () : void 
		{
			if( _enabled )
				super.affectLabelText();
			else
				_labelTextField.htmlText = String( _disabledValue );
		}
		protected function fireDataChange () : void 
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.DATA_CHANGE ) );
		}
	}
}

import aesia.com.ponents.actions.AbstractAction;
import aesia.com.ponents.menus.ComboBox;

import flash.events.Event;

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

	override public function execute (e : Event = null) : void
	{
		_caller.model.selectedElement = _caller.model.getElementAt( _id );
		fireCommandEnd();
	}
}

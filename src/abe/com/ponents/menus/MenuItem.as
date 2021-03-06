package abe.com.ponents.menus
{
	import abe.com.mon.utils.KeyStroke;
	import abe.com.mon.utils.Keys;
	import abe.com.mon.utils.StringUtils;
	import abe.com.ponents.actions.Action;
	import abe.com.ponents.core.*;
	import abe.com.ponents.layouts.display.DOBoxSettings;
	import abe.com.ponents.layouts.display.DOHBoxLayout;
	import abe.com.ponents.lists.DefaultListCell;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.transfer.ActionTransferable;
	import abe.com.ponents.transfer.Transferable;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="MenuItem")]
	[Skin(define="MenuItem",
		  inherit="EmptyComponent",

		  state__selected__background="skin.menuSelectedBackgroundColor",
		  state__all__insets="new cutils::Insets(1,0,1,0)"
	)]
	public class MenuItem extends DefaultListCell //DraggableButton
	{
		
		TARGET::FLASH_9
		protected var _subItems : Array;
		
		TARGET::FLASH_10
		protected var _subItems : Vector.<MenuItem>;
		
		TARGET::FLASH_10_1 
		protected var _subItems : Vector.<MenuItem>;
		
		protected var _menuContainer : MenuContainer;
		protected var _acceleratorLabel : TextField;
		protected var _mnemonic : KeyStroke;

		public function MenuItem ( actionOrLabel : * = null, icon : Icon = null )
		{
			super();
			_childrenLayout = new DOHBoxLayout( _childrenContainer, 3,
												new DOBoxSettings(20,"center"),
												new DOBoxSettings(0,"left","center",null,true,true),
												new DOBoxSettings(0,"left","center",null,true,true),
												new DOBoxSettings(20,"center") );

			if( actionOrLabel != null && actionOrLabel is Action  )
				this.action = actionOrLabel;
			else if( actionOrLabel != null && actionOrLabel is String )
			{
				this.action = null;
				this.label = actionOrLabel;
				if( icon )
					this.icon = icon;
			}
			else if( actionOrLabel != null )
			{
				this.action = null;
				this.value = actionOrLabel;
			}
			else
			{
				this.action = null;
				this.label = "MenuItem";
			}
			_allowFocus = false;
			//_allowDrag = false;
			_allowPressed = false;
			
			
			TARGET::FLASH_9 { _subItems = []; }
			TARGET::FLASH_10 { _subItems = new Vector.<MenuItem>(); }
			TARGET::FLASH_10_1 { _subItems = new Vector.<MenuItem>(); } 
			
			//(_labelTextField as TextField).border = true;
			( _childrenLayout as DOHBoxLayout ).setObjectForBox( _labelTextField as DisplayObject, 1 );
			invalidatePreferredSizeCache();
		}

		override public function set action (action : Action) : void
		{
			super.action = action;
			if( _action && _action.accelerator )
			{
				_acceleratorLabel = new TextField( );
				_acceleratorLabel.autoSize = "left";
				_acceleratorLabel.selectable = false;
				_acceleratorLabel.defaultTextFormat = _style.format;
				_acceleratorLabel.textColor = _style.textColor.hexa;
				_acceleratorLabel.text = _action.accelerator.toHumanString( );
				_childrenContainer.addChild( _acceleratorLabel );

				( _childrenLayout as DOHBoxLayout ).setObjectForBox( _acceleratorLabel, 2 );
				invalidatePreferredSizeCache();
			}
			else
			{
				if( _acceleratorLabel )
				{
					_childrenContainer.removeChild(_acceleratorLabel);
					_acceleratorLabel = null;
					( _childrenLayout as DOHBoxLayout ).setObjectForBox( null, 2 );
					invalidatePreferredSizeCache();
				}
			}
		}

		override public function set icon ( icon : Icon ) : void
		{
			super.icon = icon;
			( _childrenLayout as DOHBoxLayout ).setObjectForBox( _icon, 0 );
			invalidatePreferredSizeCache();
		}

		public function get itemSelected () : Boolean { return _selected; }
		public function set itemSelected ( b : Boolean ) : void
		{
			_selected = b;
			invalidate( true );
		}

		public function get mnemonic () : KeyStroke { return _mnemonic; }
		public function set mnemonic (mnemonic : KeyStroke) : void
		{
			_mnemonic = mnemonic;
			updateLabelText();
			invalidate ( true );
		}
		public function get menuContainer () : MenuContainer { return _menuContainer; }
		public function set menuContainer (menuContainer : MenuContainer) : void
		{
			_menuContainer = menuContainer;
		}
		public function get hasSubItems () : Boolean
		{
			return _subItems && _subItems.length > 0;
		}
		
		
		TARGET::FLASH_9 {
		    public function get subItems () : Array { return _subItems; }
		    public function set subItems ( o : Array ) : void { _subItems = o; }
		}
		TARGET::FLASH_10 {
		    public function get subItems () : Vector.<MenuItem> { return _subItems; }
		    public function set subItems ( o : Vector.<MenuItem> ) : void { _subItems = o; }
		}
		TARGET::FLASH_10_1 { 
		    public function get subItems () : Vector.<MenuItem> { return _subItems; }
		    public function set subItems ( o : Vector.<MenuItem> ) : void { _subItems = o; }
		}

		override public function mouseOver (e : MouseEvent) : void
		{
			super.mouseOver( e );
		}

		override public function click ( context : UserActionContext ) : void
		{
			super.click( context );
			if( menuContainer )
				menuContainer.done();
		}

		override public function mouseOut (e : MouseEvent) : void
		{
			super.mouseOut( e );
			FEATURES::DND { 
				if( _dragGesture && _dragGesture.isDragging && _menuContainer )
					_menuContainer.done();
			} 
		}
		override public function repaint () : void
		{
			if( _action && _action.accelerator )
			{
				_acceleratorLabel.defaultTextFormat = _style.format;
				_acceleratorLabel.textColor = _style.textColor.hexa;
				_acceleratorLabel.text = _action.accelerator.toHumanString();
			}
			super.repaint();
		}
		override protected function updateLabelText () : void
		{
			if( _labelTextField )
			{
				var s : String = String(_label);

				if( _mnemonic )
				{
					var c : RegExp = new RegExp( "("+Keys.getKeyName( _mnemonic.keyCode )+")", "i" );

					if( s.search( c ) != -1 )
						s = s.replace( c, "<u>$1</u>" );
				}
				if( _removeLabelOnEmptyString )
					_labelTextField.htmlText = s;
				else
					// even if the value is an empty string we display a space in order to have a correct height for the textfield
					_labelTextField.htmlText = s != "" ? s : " ";
			}
		}
		override protected function actionPropertyChanged (propertyName : String, propertyValue : *) : void 
		{
			var hbox : DOHBoxLayout = _childrenLayout as DOHBoxLayout;
			switch( propertyName )
			{
				case "accelerator" :
					if( hbox.boxes[2] )
						hbox.boxes[2].size = 0;
					super.actionPropertyChanged(propertyName, propertyValue);
					break;	
				case "name" :
					if( hbox.boxes[1] )
						hbox.boxes[1].size = 0;
					super.actionPropertyChanged(propertyName, propertyValue);
					if( _menuContainer )
						_menuContainer.itemContentChange( this );
					break;
				default :
					super.actionPropertyChanged(propertyName, propertyValue);
					break;
			}
		}
		public function get columnsSizes ( ) : Array { return ( _childrenLayout as DOHBoxLayout ).columnsSizes; }
		public function set columnsSizes ( a : Array ) : void
		{
			
			TARGET::FLASH_9 { var v : Array = ( _childrenLayout as DOHBoxLayout ).boxes; }
			TARGET::FLASH_10 { var v : Vector.<DOBoxSettings> = ( _childrenLayout as DOHBoxLayout ).boxes; }
			TARGET::FLASH_10_1 { var v : Vector.<DOBoxSettings> = ( _childrenLayout as DOHBoxLayout ).boxes; } 
			
			var l : Number = a.length;
			for( var i:Number = 0; i < l; i++ )
				v[ i ].size = a[ i ];
			
			invalidatePreferredSizeCache();
		}
		
		FEATURES::DND { 
		override public function get transferData () : Transferable
		{
			if( _action )
				return new ActionTransferable(_action);
			else
				return null;
		}
		} 

		override public function toString () : String
		{
			return StringUtils.stringify(this, {'label':_label});
		}
	}
}

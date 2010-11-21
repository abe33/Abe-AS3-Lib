package aesia.com.ponents.menus 
{
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.actions.Action;
	import aesia.com.ponents.events.PopupEvent;
	import aesia.com.ponents.events.PropertyEvent;
	import aesia.com.ponents.layouts.display.DOHBoxLayout;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.transfer.Transferable;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author Cédric Néhémie
	 */
	[Style(name="subMenuIcon",type="aesia.com.ponents.skinning.icons.Icon")]
	[Skinable(skin="Menu")]
	[Skin(define="Menu",
		  inherit="MenuItem",
		  custom_subMenuIcon="icon(aesia.com.ponents.menus::Menu.SUBITEMS_ICON)"
	)]
	public class Menu extends MenuItem 
	{
		[Embed(source="../skinning/icons/scrollright.png")]
		static public var SUBITEMS_ICON : Class;
		
		protected var _popupMenu : PopupMenu;
		protected var _showSubMenuIcon : Boolean;
		protected var _subMenuIcon : DisplayObject;		
		public function Menu ( name : String, icon : Icon = null )
		{
			super();
			label = name;
			if( icon )
				this.icon = icon;
			_showSubMenuIcon = true;
			_subMenuIcon = _style.subMenuIcon.clone();
		}
		public function get popupMenu () : PopupMenu { return _popupMenu; }		
		public function set popupMenu (popupMenu : PopupMenu) : void
		{
			_popupMenu = popupMenu;
		}
		public function addMenuItem ( m : MenuItem ) : void
		{
			_subItems.push( m );
			if( _subItems.length == 1 && _showSubMenuIcon )
			{
				_childrenContainer.addChild( _subMenuIcon );
				( _childrenLayout as DOHBoxLayout ).setObjectForBox( _subMenuIcon, 3 );
			}
			invalidatePreferredSizeCache();
		}

		public function addMenuItems ( ... args ) : void
		{
			for each ( var m : MenuItem in args )
				if( m )
					addMenuItem( m );
		}
		public function addMenuItemsVector ( args : Vector.<MenuItem> ) : void
		{
			for each ( var m : MenuItem in args )
				addMenuItem( m );
		}
		public function addAction ( a : Action ) : void
		{
			addMenuItem( new MenuItem( a ) );
		}
		
		public function removeMenuItem ( m : MenuItem ) : void
		{
			if( _subItems.indexOf( m ) != -1 )
				_subItems.splice( _subItems.indexOf( m ), 1);
			if( _subItems.length == 0 && _subMenuIcon )
			{
				_childrenContainer.removeChild( _subMenuIcon );
				( _childrenLayout as DOHBoxLayout ).setObjectForBox( null, 3 );
			}
			invalidatePreferredSizeCache();
		}

		override public function set itemSelected (b : Boolean) : void
		{
			super.itemSelected = b;
			
			if( b )
				click();
			else if( _popupMenu )
				_popupMenu.hide();
		}

		override public function click (e : Event = null) : void
		{
			var pt : Point;
			if( hasSubItems && !_popupMenu )
			{
				_popupMenu= new PopupMenu();
				_popupMenu.invoker = this;
				_popupMenu.addMenuItemsVector( _subItems );
				_popupMenu.addWeakEventListener( PopupEvent.CLOSE_ON_ACTION, popupHidden );
				
				pt = menuContainer.getPopupCoordinates( this );
				_popupMenu.x = pt.x;
				_popupMenu.y = pt.y;
				ToolKit.popupLevel.addChild( _popupMenu );
				
				if( !(menuContainer is PopupMenu) )
				{
					StageUtils.stage.focus = _popupMenu;
					_popupMenu.down();
				}
				_popupMenu.checkSize();
			}
			else if( hasSubItems && _popupMenu && !_popupMenu.stage )
			{
				ToolKit.popupLevel.addChild( _popupMenu );
				pt = menuContainer.getPopupCoordinates( this );
				_popupMenu.x = pt.x;
				_popupMenu.y = pt.y;
				
				if( !(menuContainer is PopupMenu) )
				{
					StageUtils.stage.focus = _popupMenu;
					_popupMenu.down();
				}
				_popupMenu.checkSize();
			}
			else if( _popupMenu && _popupMenu.stage )
				_popupMenu.hide();
		}

		public function popupHidden ( e : Event ) : void
		{
			if( menuContainer )
				menuContainer.done();
		}

		public function get showSubMenuIcon () : Boolean { return _showSubMenuIcon; }
		public function set showSubMenuIcon (showSubMenuIcon : Boolean) : void
		{
			_showSubMenuIcon = showSubMenuIcon;
			
			if( _showSubMenuIcon && !_subMenuIcon && _subItems.length > 0 )
			{
				_childrenContainer.addChild( _subMenuIcon );
				( _childrenLayout as DOHBoxLayout ).setObjectForBox( _subMenuIcon, 3 );
			}
			if( !_showSubMenuIcon && _subMenuIcon )
			{
				if( _childrenContainer.contains( _subMenuIcon ) )
					_childrenContainer.removeChild( _subMenuIcon );
				
				( _childrenLayout as DOHBoxLayout ).setObjectForBox( null, 3 );
			}
			invalidatePreferredSizeCache();
		}	

		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		override public function get transferData () : Transferable
		{
			return new MenuTransferable( this );
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		override protected function stylePropertyChanged ( e : PropertyEvent ) : void
		{
			switch( e.propertyName )
			{
				case "subMenuIcon" : 
					if( _showSubMenuIcon )
					{
						_childrenContainer.removeChild( _subMenuIcon );
						_subMenuIcon = e.propertyValue.clone();						showSubMenuIcon = true;
					}
					else
					{
						_subMenuIcon = e.propertyValue.clone();						
					}
					break;
				default : 
					super.stylePropertyChanged( e );
					break;
			}
		}
	}
}

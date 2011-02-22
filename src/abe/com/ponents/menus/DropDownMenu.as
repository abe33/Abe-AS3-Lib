package abe.com.ponents.menus 
{
	import abe.com.mon.utils.StageUtils;
	import abe.com.patibility.lang._;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.events.PopupEvent;
	import abe.com.ponents.events.PropertyEvent;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.utils.ToolKit;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	[Style(name="dropDownIcon",type="abe.com.ponents.skinning.icons.Icon")]
	[Skinable(skin="DropDownMenu")]
	[Skin(define="ToolBar_DropDownMenu",
		  inherit="DropDownMenu",
		  preview="abe.com.ponents.menus::DropDownMenu.defaultDropDownMenuPreview",
		  
		  state__0_1_4_5__foreground="skin.noDecoration",
		  state__0_1_4_5__background="skin.emptyDecoration"
	)]
	[Skin(define="DropDownMenu",
		  inherit="Button",
		  preview="abe.com.ponents.menus::DropDownMenu.defaultDropDownMenuPreview",
		  
		  custom_dropDownIcon="icon(abe.com.ponents.menus::DropDownMenu.DROPDOWN_ICON)"
	)]
	public class DropDownMenu extends Button
	{
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		static public function defaultDropDownMenuPreview(): DropDownMenu
		{
			var ddm : DropDownMenu = new DropDownMenu( _("Sample"), null, 
														new MenuItem( _("Sample MenuItem 1")),														new MenuItem( _("Sample MenuItem 2")),														new MenuItem( _("Sample MenuItem 3"))
														);	
			return ddm;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		[Embed(source="../skinning/icons/scrolldown.png")]
		static public var DROPDOWN_ICON : Class;
		
		protected var _popupMenu : PopupMenu;
		protected var _dropDownIcon : DisplayObject;
		
		public function DropDownMenu ( actionOrLabel : * = null, icon : Icon = null, ... menus )
		{
			super( actionOrLabel, icon  );
			styleKey = "DropDownMenu";
			_popupMenu = new PopupMenu();
			_popupMenu.invoker = this;
			_popupMenu.addEventListener( PopupEvent.CLOSE_ON_CANCEL, closeOnCancel );			_popupMenu.addEventListener( PopupEvent.CLOSE_ON_ACTION, closeOnAction );
			
			_dropDownIcon = _style.dropDownIcon.clone();
			_childrenContainer.addChild( _dropDownIcon );
			
			if( menus && menus.length > 0 )
			{
				var m : MenuItem;
				if( menus[0] is Array )
				{
					for each ( m in menus[0] )
						if ( m )
							_popupMenu.addMenuItem( m );
				}
				else
				{
					for each ( m in menus )
						if ( m )
							_popupMenu.addMenuItem( m );
				}
			}
		}

		private function closeOnCancel (event : PopupEvent) : void
		{
			selected = false;
		}

		private function closeOnAction (event : PopupEvent) : void
		{
			selected = false;
		}

		override public function repaint () : void
		{
			if( _childrenContainer.getChildIndex( _dropDownIcon ) != _childrenContainer.numChildren-1 )
				_childrenContainer.setChildIndex( _dropDownIcon, _childrenContainer.numChildren - 1 );
			super.repaint();
		}

		public function get popupMenu () : PopupMenu { return _popupMenu; }	
		public function set popupMenu (popupMenu : PopupMenu) : void
		{
			_popupMenu = popupMenu;
		}

		override public function focusOut (e : FocusEvent) : void
		{
			var t : PopupMenu = e.relatedObject as PopupMenu;
			if( !t )
				_popupMenu.hide();

			super.focusOut( e );
		}

		public function addMenuItem ( m : MenuItem ) : void
		{
			_popupMenu.addMenuItem(m);
		}
		public function removeMenuItem ( m : MenuItem ) : void
		{
			_popupMenu.removeMenuItem(m);
		}

		override public function click (e : Event = null) : void
		{
			if( !_popupMenu.stage )
			{
				var pt : Point = this.getPopupCoordinates();
				_popupMenu.x = pt.x;
				_popupMenu.y = pt.y;
				ToolKit.popupLevel.addChild( _popupMenu );
				StageUtils.stage.focus = _popupMenu;
				selected = true;
			}
			else
			{
				_popupMenu.hide();				selected = false;
			}
		}		
		public function getPopupCoordinates () : Point
		{
			var bb : Rectangle = this.getBounds( ToolKit.popupLevel );
			var x : Number = bb.x;
			var y : Number = bb.bottom;
			
			if( y + _popupMenu.height > StageUtils.stage.stageHeight )
				y = bb.y - _popupMenu.height;
			
			if( x + _popupMenu.width > StageUtils.stage.stageWidth )
				x = StageUtils.stage.stageWidth - _popupMenu.width;
			
			return new Point( x, y );
		}
		override protected function stylePropertyChanged ( e : PropertyEvent ) : void
		{
			switch( e.propertyName )
			{
				case "dropDownIcon" : 
					if( _dropDownIcon )						_childrenContainer.removeChild( _dropDownIcon );
	
					_dropDownIcon = _style.dropDownIcon.clone();
					
					if( _dropDownIcon )
						_childrenContainer.addChild( _dropDownIcon );
					break;
				default : 
					super.stylePropertyChanged( e );
					break;
			}
		}
	}
}

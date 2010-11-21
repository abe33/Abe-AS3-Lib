package aesia.com.ponents.containers
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.utils.Cookie;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.actions.Action;
	import aesia.com.ponents.buttons.AbstractButton;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.buttons.ButtonDisplayModes;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.dnd.DropEvent;
	import aesia.com.ponents.dnd.DropTargetDragEvent;
	import aesia.com.ponents.dnd.gestures.PressAndMoveGesture;
	import aesia.com.ponents.layouts.components.InlineLayout;
	import aesia.com.ponents.menus.DropDownMenu;
	import aesia.com.ponents.menus.Menu;
	import aesia.com.ponents.menus.MenuItem;
	import aesia.com.ponents.scrollbars.Scrollable;
	import aesia.com.ponents.skinning.SkinManagerInstance;
	import aesia.com.ponents.transfer.ComponentsFlavors;
	import aesia.com.ponents.transfer.DataFlavor;
	import aesia.com.ponents.utils.Alignments;
	import aesia.com.ponents.utils.ContextMenuItemUtils;
	import aesia.com.ponents.utils.Directions;
	import aesia.com.ponents.utils.ScrollUtils;
	import aesia.com.ponents.utils.SettingsMemoryChannels;

	import flash.events.ContextMenuEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	[Style(name="spacing",type="Number")]
	[Skinable(skin="ToolBar")]	[Skin(define="ToolBar",
		  inherit="DropPanel",

		  state__all__insets="new aesia.com.ponents.utils::Insets(2)",

		  custom_spacing="0"
	)]
	public class ToolBar extends DropPanel implements Scrollable
	{
		protected var _buttonDisplayMode : uint;

		/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
		protected var _settingsLoaded : Boolean = false;
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		public function ToolBar ( displayMode : uint = 0, dragEnabled : Boolean = true, spacing : Number = NaN, forceStretch : Boolean = true )
		{
			super( dragEnabled );

			childrenLayout = new InlineLayout(this, !isNaN( spacing ) ? spacing : _style.spacing, "left", "center", "leftToRight", forceStretch, true );
			_buttonDisplayMode = displayMode;

			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			createContextMenu();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}

		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
		protected function createContextMenu () : void
		{
			addNewContextMenuItemForGroup( ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Text and icon"), isDisplayModeSelected (0) ),
								   "textAndIcon", textAndIcon, "toolbar" );
			addNewContextMenuItemForGroup( ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Text only"), isDisplayModeSelected (1) ),
								   "textOnly", textOnly, "toolbar" );
			addNewContextMenuItemForGroup( ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Icon only"), isDisplayModeSelected (2) ),
								   "iconOnly", iconOnly, "toolbar" );
		}

		protected function isDisplayModeSelected (i : int) : Boolean
		{
			return i == _buttonDisplayMode;
		}
		protected function updateContextMenuItemCaption () : void
		{
			setContextMenuItemCaption( "textAndIcon", ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Text and icon"), isDisplayModeSelected (0) ) );			setContextMenuItemCaption( "textOnly", ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Text only"), isDisplayModeSelected (1) ) );			setContextMenuItemCaption( "iconOnly", ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Icon only"), isDisplayModeSelected (2) ) );
		}
		protected function iconOnly (event : ContextMenuEvent) : void
		{
			buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			updateContextMenuItemCaption();
		}
		protected function textOnly (event : ContextMenuEvent) : void
		{
			buttonDisplayMode = ButtonDisplayModes.TEXT_ONLY;
			updateContextMenuItemCaption();
		}
		protected function textAndIcon (event : ContextMenuEvent) : void
		{
			buttonDisplayMode = ButtonDisplayModes.TEXT_AND_ICON;
			updateContextMenuItemCaption();
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		public function get buttonDisplayMode () : uint { return _buttonDisplayMode; }
		public function set buttonDisplayMode (buttonDisplayMode : uint) : void
		{
			_buttonDisplayMode = buttonDisplayMode;
			var l : Number = childrenCount;

			for ( var i : Number = 0; i < l; i++ )
			{
				var bt : AbstractButton = _children[i] as AbstractButton;
				if( bt )
				{
					bt.size = null;
					bt.buttonDisplayMode = _buttonDisplayMode;
				}
			}

			invalidatePreferredSizeCache();

			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			updateContextMenuItemCaption ();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
			if( id && _settingsLoaded )
			{
				var cookie : Cookie = new Cookie( SettingsMemoryChannels.TOOLBARS );
				var o : Object = cookie[id];
				if( !o )
					o = {};

				o.buttonDisplayMode = _buttonDisplayMode;
			}
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}

		public function get direction () : String { return ( _childrenLayout as InlineLayout ).direction; }
		public function set direction ( s : String ) : void
		{
			var l : InlineLayout = ( _childrenLayout as InlineLayout );
			l.direction = s;
			switch( l.direction )
			{
				case Directions.TOP_TO_BOTTOM :
					l.verticalAlign = Alignments.TOP;
					break;				case Directions.BOTTOM_TO_TOP :
					l.verticalAlign = Alignments.BOTTOM;
					break;				case Directions.LEFT_TO_RIGHT :
					l.verticalAlign = Alignments.CENTER;
					l.horizontalAlign = Alignments.LEFT;
					break;
				case Directions.RIGHT_TO_LEFT :					l.verticalAlign = Alignments.CENTER;					l.horizontalAlign = Alignments.RIGHT;
					break;
			}
		}

		public function addSeparator () : void
		{
			addComponent( new ToolBarSeparator( this ) );
		}

		override public function addComponent ( c : Component ) : void
		{
			addComponentAt( c, _children.length );
		}
		override public function addComponentAt (c : Component, id : uint) : void
		{
			if( SkinManagerInstance.containsStyle( "ToolBar_" + c.styleKey ) )
				c.styleKey = "ToolBar_" + c.styleKey;

			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			if( _allowDrag )
			{
				c.gesture = new PressAndMoveGesture();
				c.allowDrag = _allowDrag;
			}
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			if( c is AbstractButton )
			  ( c as AbstractButton ).buttonDisplayMode = _buttonDisplayMode;

			super.addComponentAt( c, id );

			if( !c.id )
				c.id = "ToolBarComponent" + getComponentIndex(c);
		}

		override public function removeComponent (c : Component) : void
		{
			if( c.styleKey.indexOf( "ToolBar_" ) != -1 )
				c.styleKey = c.styleKey.replace( "ToolBar_", "" );
			super.removeComponent( c );
		}

		override public function invalidatePreferredSizeCache () : void
		{
			super.invalidatePreferredSizeCache();
			if( childrenCount == 0 && _childrenLayout is InlineLayout )
			{
				var s : String = ( _childrenLayout as InlineLayout ).direction;
				if( s ==  Directions.RIGHT_TO_LEFT || s ==  Directions.LEFT_TO_RIGHT )
					_preferredSizeCache.height = 20;
				else
					_preferredSizeCache.width = 20;
			}
		}

		public function getScrollableUnitIncrementV (r : Rectangle = null, direction : Number = 1) : Number
		{
			return direction * 10;
		}

		public function getScrollableUnitIncrementH (r : Rectangle = null, direction : Number = 1) : Number
		{
			return direction * 10;
		}

		public function getScrollableBlockIncrementV (r : Rectangle = null, direction : Number = 1) : Number
		{
			return direction * 50;
		}

		public function getScrollableBlockIncrementH (r : Rectangle = null, direction : Number = 1) : Number
		{
			return direction * 50;
		}

		public function get preferredViewportSize () : Dimension
		{
			return preferredSize;
		}
		public function get tracksViewportH () : Boolean
		{
			var l : InlineLayout = ( _childrenLayout as InlineLayout );
			switch( l.direction )
			{
				case  Directions.TOP_TO_BOTTOM :
				case  Directions.BOTTOM_TO_TOP :
					return true;
				case  Directions.LEFT_TO_RIGHT :
				case  Directions.RIGHT_TO_LEFT :
				default:
					return !ScrollUtils.isContentWidthExceedContainerWidth( this );
			}
		}

		public function get tracksViewportV () : Boolean
		{
			var l : InlineLayout = ( _childrenLayout as InlineLayout );
			switch( l.direction )
			{
				case  Directions.TOP_TO_BOTTOM :
				case  Directions.BOTTOM_TO_TOP :
					return !ScrollUtils.isContentHeightExceedContainerHeight( this );
				case  Directions.LEFT_TO_RIGHT :
				case  Directions.RIGHT_TO_LEFT :
				default:
					return true;
			}
		}

		override public function repaint () : void
		{
			/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
			if( id && !_settingsLoaded )
			{
				var cookie : Cookie = new Cookie( SettingsMemoryChannels.TOOLBARS );
				var o : Object = cookie[id];
				if( o )
				{
					var a : Array = o.order;
					if( a )
					{
						var l : uint = a.length;
						for ( var i:int=0;i<l;i++ )
							setComponentIndex( getComponentByID( a[i] ), i );
					}
					if( !isNaN(o.buttonDisplayMode) )
						this.buttonDisplayMode = o.buttonDisplayMode;
				}
				_settingsLoaded = true;
			}
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			super.repaint();
		}

		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		override public function get supportedFlavors () : Array { return [ ComponentsFlavors.ACTION,
																			ComponentsFlavors.MENU,
																			ComponentsFlavors.COMPONENT ]; }

		override public function dragEnter (e : DropTargetDragEvent) : void
		{
			if( _enabled &&
				supportedFlavors.some( function( item : DataFlavor, ...args ) : Boolean { return item.isSupported( e.transferable.flavors ); } )  )
				e.acceptDrag( this );
			else
				e.rejectDrag( this );
		}
		override public function dragOver (e : DropTargetDragEvent) : void
		{
			super.dragOver(e);

			var c : Component = getComponentUnderPoint( new Point( stage.mouseX, stage.mouseY ) );
			if( c )
			{
				switch( ( _childrenLayout as InlineLayout ).direction )
				{
					case Directions.TOP_TO_BOTTOM :
					case Directions.BOTTOM_TO_TOP :
						if( c.mouseY > c.height / 2 )
							drawDropBelow( c );
						else
							drawDropAbove( c );
						break;
					case Directions.LEFT_TO_RIGHT :
					case Directions.RIGHT_TO_LEFT :
						if( c.mouseX > c.width / 2 )
							drawDropRight( c );
						else
							drawDropLeft( c );
						break;
				}
			}
			else
			{
				if( childrenCount > 0 )
				{
					switch( ( _childrenLayout as InlineLayout ).direction )
					{
						case Directions.TOP_TO_BOTTOM :
							if( mouseY < firstChild.y )
								drawDropAbove( firstChild );
							else
								drawDropBelow( lastChild );
							break;

						case Directions.BOTTOM_TO_TOP :
							if( mouseY > firstChild.y )
								drawDropBelow( firstChild );
							else
								drawDropAbove( lastChild );
							break;

						case Directions.LEFT_TO_RIGHT :
							if( mouseX < firstChild.x )
								drawDropLeft( firstChild );
							else
								drawDropRight( lastChild );
							break;

						case Directions.RIGHT_TO_LEFT :
							if( mouseX > firstChild.x )
								drawDropRight( firstChild );
							else
								drawDropLeft( lastChild );
							break;
					}
				}
			}
		}
		override public function drop (e : DropEvent) : void
		{
			super.drop(e);
			var reorder : Boolean = false;
			if( ComponentsFlavors.ACTION.isSupported( e.transferable.flavors ) )
			{
				var act : Action = e.transferable.getData( ComponentsFlavors.ACTION );
				var bt : Button = new Button( act );

				e.transferable.transferPerformed();
				insertComponentAccordingToMousePosition( bt );
			}
			else if( ComponentsFlavors.MENU.isSupported( e.transferable.flavors ) )
			{
				var menu : Menu = e.transferable.getData( ComponentsFlavors.MENU ) as Menu;
				var dropDown : DropDownMenu = new DropDownMenu();
				dropDown.label = menu.label;
				dropDown.icon = menu.icon;

				e.transferable.transferPerformed();

				for each ( var mi : MenuItem in menu.subItems )
					dropDown.addMenuItem( mi );

				insertComponentAccordingToMousePosition( dropDown );
			}
			else if( ComponentsFlavors.COMPONENT.isSupported( e.transferable.flavors ) )
			{
				var c : Component = e.transferable.getData( ComponentsFlavors.COMPONENT ) as Component;
				if( isDescendant( c ) )
					reorder = true;

				e.transferable.transferPerformed();
				c.size = null;
				insertComponentAccordingToMousePosition( c );

				if( c is ToolBarSeparator )
				  ( c as ToolBarSeparator ).toolbar = this;
			}
			/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
			if( id && reorder )
			{
				var cookie : Cookie = new Cookie( SettingsMemoryChannels.TOOLBARS );
				var a : Array = [];
				_children.forEach( function( c : Component, ... args ) : void { a.push(c.id); });

				var o : Object = cookie[id];
				if(!o)
					o = {};
				o.order = a;
				cookie[id] = o;
			}
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}

		protected function insertComponentAccordingToMousePosition ( comp : Component ) : void
		{
			var c : Component = getComponentUnderPoint( new Point( stage.mouseX, stage.mouseY ) );
			if( c )
			{
				if( c != comp )
				{
					switch( ( _childrenLayout as InlineLayout ).direction )
					{
						case Directions.TOP_TO_BOTTOM :
							if( c.mouseY > c.height / 2 )
								addComponentAfter(comp, c);
							else
								addComponentBefore(comp, c);
							break;

						case Directions.BOTTOM_TO_TOP :
							if( c.mouseY < c.height / 2 )
								addComponentAfter(comp, c);
							else
								addComponentBefore(comp, c);
							break;

						case Directions.LEFT_TO_RIGHT :
							if( c.mouseX > c.width / 2 )
								addComponentAfter(comp, c);
							else
								addComponentBefore(comp, c);
							break;

						case Directions.RIGHT_TO_LEFT :
							if( c.mouseX < c.width / 2 )
								addComponentAfter(comp, c);
							else
								addComponentBefore(comp, c);
							break;
					}
				}
				else
				{
					addComponent( comp );
				}
			}
			else
			{
				if( childrenCount == 0 )
				{
					addComponent( comp );
				}
				else
				{
					switch( ( _childrenLayout as InlineLayout ).direction )
					{
						case Directions.TOP_TO_BOTTOM :
							if( mouseY < firstChild.y )
								addComponentBefore( comp, firstChild );
							else
								addComponentAfter( comp, lastChild );
							break;

						case Directions.BOTTOM_TO_TOP :
							if( mouseY > firstChild.y )
								addComponentBefore( comp, firstChild );
							else
								addComponentAfter( comp, lastChild );
							break;

						case Directions.LEFT_TO_RIGHT :
							if( mouseX < firstChild.x )
								addComponentBefore( comp, firstChild );
							else
								addComponentAfter( comp, lastChild );
							break;

						case Directions.RIGHT_TO_LEFT :
							if( mouseX > firstChild.x )
								addComponentBefore( comp, firstChild );
							else
								addComponentAfter( comp, lastChild );
							break;
					}
				}
			}
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}

package abe.com.ponents.tabs 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.patibility.lang._;
	import abe.com.patibility.settings.SettingsManagerInstance;
	import abe.com.ponents.buttons.ButtonDisplayModes;
	import abe.com.ponents.containers.DropPanel;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.dnd.DnDManagerInstance;
	import abe.com.ponents.dnd.DropEvent;
	import abe.com.ponents.dnd.DropTargetDragEvent;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.scrollbars.Scrollable;
	import abe.com.ponents.transfer.ComponentsFlavors;
	import abe.com.ponents.transfer.DataFlavor;
	import abe.com.ponents.utils.Alignments;
	import abe.com.ponents.utils.CardinalPoints;
	import abe.com.ponents.utils.ContextMenuItemUtils;
	import abe.com.ponents.utils.Directions;

	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="TabBar")]
	[Skin(define="TabBar_North",
		  inherit="TabBar",
		  preview="abe.com.ponents.tabs::TabbedPane.northTabbedPanePreview",
		  acceptStyleSetting="false",
		  
		   state__all__foreground="new deco::GradientFill( gradient([skin.borderColor.alphaClone(0),skin.borderColor],[.9,1]), 90 )",
		  state__all__insets="new cutils::Insets(0,3,0,0)",
		  state__all__borders="new cutils::Borders(0,0,0,1)"
	)]
	[Skin(define="TabBar_South",
		  inherit="TabBar",
		  preview="abe.com.ponents.tabs::TabbedPane.southTabbedPanePreview",
		  acceptStyleSetting="false",
		  
		   state__all__foreground="new deco::GradientFill( gradient([skin.borderColor.alphaClone(0),skin.borderColor],[.9,1] ), 270 )",
		  state__all__insets="new cutils::Insets(0,0,0,3)",
		  state__all__borders="new cutils::Borders(0,1,0,0)"
	)]
	[Skin(define="TabBar_East",
		  inherit="TabBar",
		  preview="abe.com.ponents.tabs::TabbedPane.eastTabbedPanePreview",
		  acceptStyleSetting="false",
		  
		  state__all__foreground="new deco::GradientFill( gradient([skin.borderColor.alphaClone(0),skin.borderColor],[.9,1]), 180 )",
		  state__all__insets="new cutils::Insets(0,0,3,0)",
		  state__all__borders="new cutils::Borders(1,0,0,0)"
	)]
	[Skin(define="TabBar_West",
		  inherit="TabBar",
		  preview="abe.com.ponents.tabs::TabbedPane.westTabbedPanePreview",
		  acceptStyleSetting="false",
		  
		  state__all__foreground="new deco::GradientFill( gradient([skin.borderColor.alphaClone(0),skin.borderColor],[.9,1]), 0 )",
		  state__all__insets="new cutils::Insets(3,0,0,0)",
		  state__all__borders="new cutils::Borders(0,0,1,0)"
	)]
	[Skin(define="TabBar",
		  inherit="DropPanel",
		  preview="abe.com.ponents.tabs::TabbedPane.defaultTabbedPanePreview",
		  acceptStyleSetting="false",
		  
		  state__all__foreground="new deco::SimpleBorders( skin.borderColor )",
		  
		  custom_tabsSpacing="3"
	)]
	public class TabBar extends DropPanel implements Scrollable
	{
		protected var _styleNamePrefix : String = "TabBar";
		
		protected var _placement : String;
		protected var _tabbedPane : TabbedPane;
		protected var _buttonDisplayMode : uint;
		protected var _allowSelectTabOnDnD : Boolean;

		/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
		protected var _settingsLoaded : Boolean = false;
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		public function TabBar ( dragEnabled : Boolean = true )
		{
			super( dragEnabled );
			_allowSelectTabOnDnD = true;
			childrenLayout = new InlineLayout( this, 
											   _style.tabsSpacing, 
											   "left", 
											   "bottom", 
											   "leftToRight", 
											   true, 
											   true );
			
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
			setContextMenuItemCaption( "textAndIcon", ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Text and icon"), isDisplayModeSelected (0) ) );
			setContextMenuItemCaption( "textOnly", ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Text only"), isDisplayModeSelected (1) ) );
			setContextMenuItemCaption( "iconOnly", ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Icon only"), isDisplayModeSelected (2) ) );
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
		
		public function get styleNamePrefix () : String { return _styleNamePrefix; }		
		public function set styleNamePrefix (styleNamePrefix : String) : void
		{
			_styleNamePrefix = styleNamePrefix;
			placement = placement;
		}
		public function get allowSelectTabOnDnD () : Boolean { return _allowSelectTabOnDnD; }		
		public function set allowSelectTabOnDnD (allowSelectTabOnDnD : Boolean) : void
		{
			_allowSelectTabOnDnD = allowSelectTabOnDnD;
		}
		public function get placement () : String { return _placement; }		
		public function set placement (placement : String) : void
		{
			_placement = placement;	
					
			var ilayout : InlineLayout = childrenLayout as InlineLayout;
			switch( _placement )
			{
				case  CardinalPoints.EAST : 
					ilayout.direction = Directions.TOP_TO_BOTTOM;
					ilayout.horizontalAlign = Alignments.LEFT;
					ilayout.verticalAlign = Alignments.TOP;
					styleKey = _styleNamePrefix+"_East";
					break;
				case  CardinalPoints.WEST : 
					ilayout.direction = Directions.TOP_TO_BOTTOM;
					ilayout.horizontalAlign = Alignments.RIGHT;
					ilayout.verticalAlign = Alignments.TOP;
					styleKey = _styleNamePrefix+"_West";
					break;
				case  CardinalPoints.NORTH : 
					ilayout.direction = Directions.LEFT_TO_RIGHT;
					ilayout.horizontalAlign = Alignments.LEFT;
					ilayout.verticalAlign = Alignments.BOTTOM;
					styleKey = _styleNamePrefix+"_North";
					break;
				case  CardinalPoints.SOUTH : 
					ilayout.direction = Directions.LEFT_TO_RIGHT;
					ilayout.horizontalAlign = Alignments.LEFT;
					ilayout.verticalAlign = Alignments.TOP;
					styleKey = _styleNamePrefix+"_South";
					break;		
			}
			for each( var c : SimpleTab in _children )
				c.placement = _placement;			
			
			invalidatePreferredSizeCache();
		}

		public function get tabbedPane () : TabbedPane { return _tabbedPane; }		
		public function set tabbedPane (tabbedPane : TabbedPane) : void 
		{	
			_tabbedPane = tabbedPane;
		}

		override public function addComponent (c : Component) : void 
		{
			(c as Tab).buttonDisplayMode = _buttonDisplayMode;
		}
		override public function addComponentAt (c : Component, id : uint) : void 
		{
			(c as Tab).buttonDisplayMode = _buttonDisplayMode;
			super.addComponentAt( c, id );
		}

		public function get buttonDisplayMode () : uint { return _buttonDisplayMode; }		
		public function set buttonDisplayMode (buttonDisplayMode : uint) : void
		{
			_buttonDisplayMode = buttonDisplayMode;
			var l : Number = childrenCount;
			
			for ( var i : Number = 0; i < l; i++ )
			{
				var bt : Tab = _children[i] as Tab;
				if( bt )
				{
					bt.buttonDisplayMode = _buttonDisplayMode;
				}
			}
			
			/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
			if( tabbedPane.id )
				SettingsManagerInstance.set( tabbedPane, "buttonDisplayMode", _buttonDisplayMode );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			updateContextMenuItemCaption();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			invalidatePreferredSizeCache();
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
			switch( _placement )
			{
				case  CardinalPoints.EAST : 
					return true;
				case  CardinalPoints.NORTH : 
				default:
					return preferredWidth < _tabbedPane.width;
			}
		}
		
		public function get tracksViewportV () : Boolean
		{
			switch( _placement )
			{
				case  CardinalPoints.EAST : 
				case  CardinalPoints.WEST :
					return preferredHeight < _tabbedPane.height;
				case  CardinalPoints.NORTH : 
				case  CardinalPoints.SOUTH : 
				default:
					return true;
			}
		}
		
		
		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		override public function get supportedFlavors () : Array { return [ ComponentsFlavors.TAB ]; }
		
		override public function mouseMove (e : MouseEvent) : void
		{
			super.mouseMove( e );
			if( _allowSelectTabOnDnD &&
				DnDManagerInstance.dragging && 
				DnDManagerInstance.allowedDropTargets.indexOf(this) == -1 )
			{
				var c : Component = getComponentUnderPoint( new Point( stage.mouseX, stage.mouseY ) );
				if( c && c != tabbedPane.selectedTab )
				{
					tabbedPane.selectedTab = c as Tab;
					var f : Function = function ( event : ComponentEvent ) : void
					{
						DnDManagerInstance.refreshDropTargets();
						event.target.removeEventListener( ComponentEvent.REPAINT, f );
					}
					tabbedPane.selectedTab.content.addEventListener( ComponentEvent.REPAINT, f );
				}
			}
		}
		
		override public function dragEnter (e : DropTargetDragEvent) : void
		{
			if( _enabled && 
				supportedFlavors.some( function( item : DataFlavor, ...args ) : Boolean 
				{ return item.isSupported( e.transferable.flavors ); } )  )
				e.acceptDrag( this );
			else
				e.rejectDrag( this );
			
			e = null;
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
				if( hasChildren )
				{
					switch( ( _childrenLayout as InlineLayout ).direction )
					{
						case Directions.TOP_TO_BOTTOM :
							if( this.mouseY < firstChild.y ) 		
								drawDropAbove( firstChild );
							else	
								drawDropBelow( lastChild );
							break;
							
						case Directions.BOTTOM_TO_TOP :
							if( this.mouseY > firstChild.y ) 		
								drawDropBelow( firstChild );
							else	
								drawDropAbove( lastChild );
							break; 	
							
						case Directions.LEFT_TO_RIGHT : 	
							if( this.mouseX < firstChild.x ) 		
								drawDropLeft( firstChild );
							else	
								drawDropRight( lastChild );		
							break;
							
						case Directions.RIGHT_TO_LEFT :
							if( this.mouseX > firstChild.x ) 		
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
			if( ComponentsFlavors.TAB.isSupported( e.transferable.flavors ) )
			{
				var tab : Tab = e.transferable.getData( ComponentsFlavors.TAB );
				
				var b : Boolean = tab.selected && tab.parentContainer == this;
				
				e.transferable.transferPerformed();
				insertComponentAccordingToMousePosition( tab );
				
				tabbedPane.setUpTab(tab);
				if( b )
					_tabbedPane.selectedTab = tab;
			}
		}
		override public function repaint () : void 
		{
			super.repaint( );
			/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
			if( tabbedPane.id && !_settingsLoaded )
			{
				var mode : Number = SettingsManagerInstance.get(tabbedPane, "buttonDisplayMode", _buttonDisplayMode ); 
				buttonDisplayMode = mode;
				_settingsLoaded = true;
			}
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		protected function insertComponentAccordingToMousePosition ( comp : Component ) : void
		{
			var c : Component = getComponentUnderPoint( new Point( stage.mouseX, stage.mouseY ) );
			if( c )
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
				if( hasChildren )
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
				else
				{
					addComponent( comp );
				}
			}
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}
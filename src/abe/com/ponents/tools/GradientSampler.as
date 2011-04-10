package abe.com.ponents.tools
{
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.colors.Color;
	import abe.com.mon.colors.Gradient;
	import abe.com.mon.utils.MathUtils;
	import abe.com.patibility.lang._;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.buttons.ButtonDisplayModes;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.layouts.components.BorderLayout;
	import abe.com.ponents.skinning.decorations.ArrowSideBorders;
	import abe.com.ponents.skinning.decorations.ArrowSideFill;
	import abe.com.ponents.skinning.icons.ColorIcon;
	import abe.com.ponents.skinning.icons.GradientIcon;
	import abe.com.ponents.utils.Insets;
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenuItem;

	/**
	 * @author Cédric Néhémie
	 */
	[Event(name="selectionChange", type="abe.com.ponents.events.ComponentEvent")]	[Event(name="dataChange", type="abe.com.ponents.events.ComponentEvent")]
	[Skinable(skin="GradientSampler")]
	[Skin(define="GradientSampler",
		  inherit="EmptyComponent"
	)]
	[Skin(define="GradientCursor",
		  inherit="DefaultComponent",

		  state__all__insets="new cutils::Insets(2,7,2,2)",		  state__all__corners="new cutils::Corners(3)",

		  state__0_3_4_7__background="new deco::ArrowSideFill( skin.backgroundColor )",
		  state__1_2_5_6__background="new deco::ArrowSideFill( skin.overBackgroundColor )",
		  state__8_12__background="new deco::ArrowSideFill( skin.selectedBackgroundColor )",
		  state__9__background="new deco::ArrowSideFill( skin.disabledSelectedBackgroundColor )",
		  state__10_14__background="new deco::ArrowSideFill( skin.overSelectedBackgroundColor )",
		  state__11_15__background="new deco::ArrowSideFill( skin.pressedSelectedBackgroundColor )",

		  state__0_3__foreground="new deco::ArrowSideBorders( skin.borderColor )",
		  state__2__foreground="new deco::ArrowSideBorders( skin.overBorderColor )",
		  state__focus_focusandselected__foreground="new deco::ArrowSideBorders( skin.focusBorderColor )",
		  state__selected__foreground="new deco::ArrowSideBorders( skin.selectedBorderColor )",
		  state__disabled__foreground="new deco::ArrowSideBorders( skin.disabledBorderColor )",
		  state_disabled_selected__foreground="new deco::ArrowSideBorders( skin.disabledSelectedBorderColor )"
	)]
	public class GradientSampler extends Panel
	{
		static private var DEPENDENCIES : Array = [ArrowSideFill, ArrowSideBorders];

		protected var _gradientIcon : GradientIcon;
		protected var _gradient : Gradient;
		protected var _cursorsPanel : Panel;
		protected var _selectedButton : Button;
		protected var _dragging : Boolean;
		protected var _oldStartIndex : Number;
		protected var _oldEndIndex : Number;

		public function GradientSampler ()
		{
			super( );

			_allowMask = false;
			style.setForAllStates("insets", new Insets(10,3,10,0));

			var l : BorderLayout;
			_childrenLayout = l = new BorderLayout(this );
			_gradientIcon = new GradientIcon();
			_gradientIcon.styleKey = "DefaultComponent";
			_gradientIcon.init( );
			_gradientIcon.preferredHeight = 60;

			_cursorsPanel = new Panel();
			_cursorsPanel.allowMask = false;
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
				addNewContextMenuItemForGroup(_("Add Color"), "addColor", addColor, "gradient" );			/*FDT_IGNORE*/ } /*FDT_IGNORE*/			l.center = _gradientIcon;
			l.south = _cursorsPanel;

			addComponents( _gradientIcon, _cursorsPanel );
			gradient = new Gradient([Color.Black, Color.White], [0,1])
			invalidatePreferredSizeCache();
		}

		protected function stopDragging (event : MouseEvent) : void
		{
			var w : Number = _gradientIcon.width;
			var p : Number = MathUtils.restrict( _gradientIcon.mouseX, 0, w ) / w;
			_dragging = false;
			_oldStartIndex = _gradient.getStartIndex(p);			_oldEndIndex = _gradient.getEndIndex(p);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragging);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragging );
		}

		protected function dragging (event : MouseEvent) : void
		{
			if( _dragging )
			{
				var w : Number = _gradientIcon.width;
				var p : Number = MathUtils.restrict( _gradientIcon.mouseX, 0, w ) / w;
				var index : Number = _gradient.colors.indexOf(selectedColor);				var pindex : Number = _gradient.getStartIndex(p);				var c : Color = selectedColor;

				_gradient.positions[index] = p;				_selectedButton.x = p*w - _selectedButton.width/2;

				invalidate(true);
			}
		}

		override public function repaint () : void
		{
			super.repaint( );
			updateCursorsPositions();
		}

		public function get gradient () : Gradient { return _gradient; }
		public function set gradient (gradient : Gradient) : void
		{
			_gradient = gradient;
			_gradientIcon.gradient = _gradient;
			updateCursors();
		}

		protected function updateCursors () : void
		{
			_cursorsPanel.removeAllComponents();

			var l : uint = _gradient.colors.length;
			for( var i : int = 0; i<l;i++ )
			{
				var c : Color = _gradient.colors[i];				var p : Number = _gradient.positions[i];
				var ico : ColorIcon = new ColorIcon(c);
				ico.preferredSize = new Dimension(8,8);
				var bt : Button = new Button( "", ico );
				bt.addWeakEventListener(MouseEvent.MOUSE_DOWN, buttonMouseDown );				bt.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
				bt.styleKey = "GradientCursor";
				bt.y = 2;

				/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
					var rc : ContextMenuItem = new ContextMenuItem( "Remove Color" );
					rc.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, removeColor );
					bt.menuContextGroups["gradient"] = [rc];					bt.menuContextOrder = ["gradient"];
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/

				_cursorsPanel.addComponent( bt );
				bt.x = p * _cursorsPanel.width - bt.width/2;
			}
			if( bt )
				_cursorsPanel.preferredHeight = bt.height+4;

			_selectedButton = _cursorsPanel.getComponentAt(0) as Button;
			if( _selectedButton )
				_selectedButton.selected = true;

			invalidatePreferredSizeCache();
		}

		protected function addColor (event : ContextMenuEvent) : void
		{
			var p : Number = MathUtils.restrict(_gradientIcon.mouseX, 0, _gradientIcon.width ) / _gradientIcon.width;
			var c : Color = _gradient.getColor(p).clone();

			var index : int = _gradient.getEndIndex( p );
			_gradient.colors.splice(index,0,c);			_gradient.positions.splice(index,0,p);

			updateCursors();

			fireDataChange();

			selectedButton = _cursorsPanel.getComponentAt(index) as Button;
		}

		protected function removeColor (event : ContextMenuEvent) : void
		{
			if( _gradient.colors.length <= 2)
			{
				return;
			}

			var bt : Button = event.mouseTarget as Button;
			var index : int = _cursorsPanel.getComponentIndex(bt);

			_gradient.colors.splice(index,1);			_gradient.positions.splice(index,1);

			updateCursors();
			fireDataChange();

			if( bt == _selectedButton )
				selectedButton = _cursorsPanel.getComponentAt(0) as Button;
		}

		public function get selectedColor () : Color
		{
			return _gradient.colors[ _cursorsPanel.getComponentIndex( _selectedButton ) ];
		}
		public function get selectedPosition () : Color
		{
			return _gradient.positions[ _cursorsPanel.getComponentIndex( _selectedButton ) ];
		}

		public function get selectedButton () : Button { return _selectedButton; }
		public function set selectedButton ( selectedButton : Button ) : void
		{
			if( _selectedButton )
				_selectedButton.selected = false;

			_selectedButton = selectedButton;

			if( _selectedButton && !_selectedButton.selected )
				_selectedButton.selected = true;

			fireComponentEvent( ComponentEvent.SELECTION_CHANGE );
		}

		protected function buttonMouseDown ( e : MouseEvent ) : void
		{
			selectedButton = e.target as Button;

			_dragging = true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, dragging);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragging );
		}

		public function updateCursorsIcons () : void
		{
			var l : uint = _gradient.colors.length;
			for( var i : int = 0; i<l;i++ )
			{
				var c : Button = _cursorsPanel.getComponentAt(i) as Button;
				c.icon.invalidate();
			}
		}
		public function updateCursorsPositions () : void
		{
			var l : uint = _gradient.colors.length;
			for( var i : int = 0; i<l;i++ )
			{
				var p : Number = _gradient.positions[i];
				var c : Button = _cursorsPanel.getComponentAt(i) as Button;

				c.x = p * _cursorsPanel.width - c.width/2;
			}
		}
		protected function fireDataChange () : void
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.DATA_CHANGE ) );
		}
	}
}

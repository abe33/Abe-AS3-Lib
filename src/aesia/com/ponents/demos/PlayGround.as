package aesia.com.ponents.demos
{
	import aesia.com.mon.geom.dm;
	import aesia.com.ponents.containers.Accordion;
	import aesia.com.ponents.containers.AccordionTab;
	import aesia.com.edia.text.fx.complex.TwinklingChar;
	import aesia.com.edia.text.fx.loop.TrembleEffect;
	import aesia.com.mands.Interval;
	import aesia.com.mands.ParallelCommand;
	import aesia.com.mands.ProxyCommand;
	import aesia.com.mands.ReversedQueue;
	import aesia.com.mands.Timeout;
	import aesia.com.mands.events.CommandEvent;
	import aesia.com.mon.geom.ColorMatrix;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.geom.Range;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.logs.LogEvent;
	import aesia.com.mon.utils.Color;
	import aesia.com.mon.utils.DateUtils;
	import aesia.com.mon.utils.Gradient;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Keys;
	import aesia.com.mon.utils.Reflection;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.mon.utils.StringUtils;
	import aesia.com.motion.Impulse;
	import aesia.com.motion.SingleTween;
	import aesia.com.motion.easing.Bounce;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.actions.ActionManagerInstance;
	import aesia.com.ponents.actions.ProxyAction;
	import aesia.com.ponents.actions.TerminalAction;
	import aesia.com.ponents.actions.builtin.BuiltInActionsList;
	import aesia.com.ponents.actions.builtin.CalendarAction;
	import aesia.com.ponents.actions.builtin.ForceGC;
	import aesia.com.ponents.actions.builtin.RedoAction;
	import aesia.com.ponents.actions.builtin.UndoAction;
	import aesia.com.ponents.allocators.EmbeddedBitmapAllocatorInstance;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.buttons.ButtonDisplayModes;
	import aesia.com.ponents.buttons.ButtonGroup;
	import aesia.com.ponents.buttons.CheckBox;
	import aesia.com.ponents.buttons.ColorPicker;
	import aesia.com.ponents.buttons.DraggableButton;
	import aesia.com.ponents.buttons.GradientPicker;
	import aesia.com.ponents.buttons.RadioButton;
	import aesia.com.ponents.buttons.ToggleButton;
	import aesia.com.ponents.completion.AutoCompletion;
	import aesia.com.ponents.completion.InputMemory;
	import aesia.com.ponents.containers.FieldSet;
	import aesia.com.ponents.containers.MultiSplitPane;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.containers.SlidePane;
	import aesia.com.ponents.containers.SplitPane;
	import aesia.com.ponents.containers.ToolBar;
	import aesia.com.ponents.containers.Window;
	import aesia.com.ponents.containers.WindowTitleBar;
	import aesia.com.ponents.core.AbstractComponent;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.core.ComponentStates;
	import aesia.com.ponents.core.Container;
	import aesia.com.ponents.dnd.DnDDragObjectRenderer;
	import aesia.com.ponents.dnd.DnDDropRenderer;
	import aesia.com.ponents.dnd.DnDManagerInstance;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.forms.FormObject;
	import aesia.com.ponents.forms.FormUtils;
	import aesia.com.ponents.forms.managers.SimpleFormManager;
	import aesia.com.ponents.forms.renderers.FieldSetFormRenderer;
	import aesia.com.ponents.layouts.components.BorderLayout;
	import aesia.com.ponents.layouts.components.GridLayout;
	import aesia.com.ponents.layouts.components.InlineLayout;
	import aesia.com.ponents.layouts.components.splits.Leaf;
	import aesia.com.ponents.layouts.components.splits.Split;
	import aesia.com.ponents.lists.List;
	import aesia.com.ponents.lists.ListEditor;
	import aesia.com.ponents.lists.ListLineRuler;
	import aesia.com.ponents.menus.CheckBoxMenuItem;
	import aesia.com.ponents.menus.ComboBox;
	import aesia.com.ponents.menus.DropDownMenu;
	import aesia.com.ponents.menus.FontListComboBox;
	import aesia.com.ponents.menus.Menu;
	import aesia.com.ponents.menus.MenuBar;
	import aesia.com.ponents.menus.MenuItem;
	import aesia.com.ponents.menus.MenuSeparator;
	import aesia.com.ponents.menus.RadioMenuItem;
	import aesia.com.ponents.models.DefaultBoundedRangeModel;
	import aesia.com.ponents.models.SpinnerDateModel;
	import aesia.com.ponents.models.SpinnerListModel;
	import aesia.com.ponents.models.SpinnerNumberModel;
	import aesia.com.ponents.models.TreeModel;
	import aesia.com.ponents.models.TreeNode;
	import aesia.com.ponents.monitors.GraphMonitor;
	import aesia.com.ponents.monitors.GraphMonitorCaption;
	import aesia.com.ponents.monitors.GraphMonitorRuler;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.monitors.PixelRuler;
	import aesia.com.ponents.monitors.Terminal;
	import aesia.com.ponents.monitors.TerminalActionProxy;
	import aesia.com.ponents.monitors.recorders.FPSRecorder;
	import aesia.com.ponents.monitors.recorders.ImpulseListenerRecorder;
	import aesia.com.ponents.monitors.recorders.MemRecorder;
	import aesia.com.ponents.progress.MinimalGradientProgressBar;
	import aesia.com.ponents.progress.MinimalProgressBar;
	import aesia.com.ponents.progress.ProgressBar;
	import aesia.com.ponents.skinning.ComponentStateStyle;
	import aesia.com.ponents.skinning.ComponentStyle;
	import aesia.com.ponents.skinning.SkinManagerInstance;
	import aesia.com.ponents.skinning.decorations.AdvancedSlicedBitmapFill;
	import aesia.com.ponents.skinning.decorations.ArrowSideBorders;
	import aesia.com.ponents.skinning.decorations.ArrowSideFill;
	import aesia.com.ponents.skinning.decorations.ArrowSideGradientBorders;
	import aesia.com.ponents.skinning.decorations.ArrowSideGradientFill;
	import aesia.com.ponents.skinning.decorations.BorderedGradientFill;
	import aesia.com.ponents.skinning.decorations.GradientBorders;
	import aesia.com.ponents.skinning.decorations.GradientFill;
	import aesia.com.ponents.skinning.decorations.PushButtonFill;
	import aesia.com.ponents.skinning.decorations.SimpleBorders;
	import aesia.com.ponents.skinning.decorations.SimpleFill;
	import aesia.com.ponents.skinning.decorations.SlicedBitmapFill;
	import aesia.com.ponents.skinning.decorations.StripFill;
	import aesia.com.ponents.skinning.icons.EmbeddedBitmapIcon;
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.ponents.sliders.HSlider;
	import aesia.com.ponents.sliders.VSlider;
	import aesia.com.ponents.spinners.DoubleSpinner;
	import aesia.com.ponents.spinners.QuadSpinner;
	import aesia.com.ponents.spinners.Spinner;
	import aesia.com.ponents.tables.Table;
	import aesia.com.ponents.tables.TableColumn;
	import aesia.com.ponents.tabs.ClosableTab;
	import aesia.com.ponents.tabs.SimpleTab;
	import aesia.com.ponents.tabs.Tab;
	import aesia.com.ponents.tabs.TabbedPane;
	import aesia.com.ponents.text.Label;
	import aesia.com.ponents.text.TextArea;
	import aesia.com.ponents.text.TextInput;
	import aesia.com.ponents.trees.Tree;
	import aesia.com.ponents.trees.TreeHeader;
	import aesia.com.ponents.utils.Alignments;
	import aesia.com.ponents.utils.Borders;
	import aesia.com.ponents.utils.CardinalPoints;
	import aesia.com.ponents.utils.Corners;
	import aesia.com.ponents.utils.Directions;
	import aesia.com.ponents.utils.Insets;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.Orientations;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	[SWF(width="550", height="500")]
	public class PlayGround extends Sprite
	{
		[Embed(source="../skinning/icons/calendar.png")]
		public var CALENDAR : Class;

		[Embed(source="add.png")]
		private var add : Class;

		[Embed(source="exclamation.png")]
		private var exclamation : Class;

		[Embed(source="error.png")]
		private var error : Class;

		[Embed(source="information.png")]
		private var information : Class;

		[Embed(source="lightbulb.png")]
		private var lightbulb : Class;

		[Embed(source="bgstretch.png")]
		private var bgStretchClass : Class;

		[Embed(source="bgtile.png")]
		private var bgTileClass : Class;

		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		private var dragRenderer : DnDDragObjectRenderer;
		private var dropRenderer : DnDDropRenderer;
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		protected var groups : Array;

		public function PlayGround ()
		{
			MemRecorder.registerMem();
			var lv : LogView;
			groups = [];
			var a : Array =[];
			var f : Function = function ( e : LogEvent):void
			{
				a.push( e.msg );
			};
			Log.getInstance().addEventListener( LogEvent.LOG_ADD, f );
			StageUtils.setup(this);
			StageUtils.flexibleStage();
			StageUtils.noMenu();
			ToolKit.initializeToolKit();
			Reflection.WARN_UNWRAPPED_STRING = false;

			try
			{
				/*
				lv = new LogView();
				lv.size = new Dimension(200,300);
				lv.x = 350;				lv.y = 100;
				ToolKit.mainLevel.addChild(lv);
				Log.debug(a);
				*/

				/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
				KeyboardControllerInstance.eventProvider = stage;
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/

				ActionManagerInstance.createBuiltInActions();

				/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
				StageUtils.addGlobalMenu( ( ActionManagerInstance.getAction( BuiltInActionsList.UNDO ) as UndoAction ).contextMenuItem );				StageUtils.addGlobalMenu( ( ActionManagerInstance.getAction( BuiltInActionsList.REDO ) as RedoAction ).contextMenuItem );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/

				/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
				dragRenderer = new DnDDragObjectRenderer( DnDManagerInstance );
				dropRenderer = new DnDDropRenderer( DnDManagerInstance );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/

				createMainPanel();

				/*FDT_IGNORE*/ CONFIG::RELEASE { /*FDT_IGNORE*/
					Log.debug( "CONFIG::RELEASE" );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/

				/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
					Log.debug( "CONFIG::DEBUG" );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			}
			catch( e : Error )
			{
				Log.error( e.message  + "\n" + e.getStackTrace() );
				var txt : TextField = new TextField();
				addChild( txt );
				txt.text = a.join("\n");
				StageUtils.lockToStage(txt);
			}
		}

		private function createMainPanel () : void
		{
			var p : Panel = new Panel();
			var l : BorderLayout = new BorderLayout();
			p.childrenLayout = l;

			var m : SlidePane = createMenuBar();
			p.addComponent(m);
			l.addComponent(m, CardinalPoints.NORTH );

			var t : TabbedPane = createTabbedPane();
			p.addComponent(t);
			l.addComponent( t, CardinalPoints.CENTER );

			ToolKit.mainLevel.addChild( p );
			StageUtils.lockToStage( p );
		}

		private function createTabbedPane () : TabbedPane
		{
			var tabbedPane : TabbedPane = new TabbedPane();

			tabbedPane.addTab( createStandardComponentTab() );			tabbedPane.addTab( createDataComponentTab() );			tabbedPane.addTab( createLayoutComponentTab() );			tabbedPane.addTab( createAdvancedToolsTab() );			tabbedPane.addTab( createSkinningTab() );
			return tabbedPane;
		}

		private function createSkinningTab () : Tab
		{
			var tabbedPane : TabbedPane = new TabbedPane( CardinalPoints.WEST );

			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
				tabbedPane.dndEnabled = false;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			tabbedPane.addTab( createBordersTab () );			tabbedPane.addTab( createFillTab () );			tabbedPane.addTab( createCustomTab () );

			var tab : SimpleTab = new SimpleTab( "Skinning", tabbedPane );
			return tab;
		}

		private function createCustomTab () : Tab
		{
			var p : Panel = createInlinePanel( "topToBottom", "left","top",true );
			p.style.setForAllStates("insets", new Insets(5) );

			p.addComponent( createPushButtonFieldSet() );
			return new SimpleTab("Customs", p );
		}

		private function createPushButtonFieldSet () : Component
		{
			var p : FieldSet = new FieldSet("Push Button Fill");
			p.childrenLayout = new GridLayout( p, 1, 6,5,5 );

			var m : ColorMatrix = new ColorMatrix();
			m.adjustSaturation( -100 );
			m.adjustAlpha( -100 );
			var innerEnabled : Array = [/* new BevelFilter(1,30, Color.DarkSlateGray.hexa, .5, Color.PaleTurquoise.hexa, .7, 0, 0, 1, 2, "outter" )*/ ];
			var innerDisabled : Array = [ /*new BevelFilter(1,30, Color.DimGray.hexa, .7, Color.White.hexa, .7, 0, 0, 1, 2, "outter" ),*/ new ColorMatrixFilter( m ) ];

			var pushButton : ComponentStyle = new ComponentStyle( "Button", "PushButton", Vector.<ComponentStateStyle> ( [
		 		// Normal
		 		new ComponentStateStyle(
		 			new PushButtonFill( 6, 10, Color.LightSeaGreen, Color.Teal,	Color.DarkSlateGray ),
		 			null, Color.Teal, null, new Insets(4, 7, 4, 13), new Borders(0), new Corners(4), null, innerEnabled ),
		 		new ComponentStateStyle(
		 			new PushButtonFill( 6, 10, Color.Gainsboro, Color.Silver, Color.DimGray ),
		 			null, Color.Silver, null, new Insets(4, 7, 4, 13), new Borders(0), new Corners(4), null, innerDisabled ),
		 		new ComponentStateStyle(
		 			new PushButtonFill( 8, 10, Color.MediumAquamarine, Color.LightSeaGreen,	Color.DarkSlateGray ),
		 			null, Color.LightSeaGreen, null, new Insets(4, 5, 4, 15), new Borders(0), new Corners(4), null, innerEnabled ),
		 		new ComponentStateStyle(
		 			new PushButtonFill( -1, 10, Color.MediumAquamarine, Color.LightSeaGreen,	Color.DarkSlateGray ),
		 			null, Color.LightSeaGreen, null, new Insets(4, 14, 4, 6), new Borders(0), new Corners(4), null, innerEnabled ),

		 		// Focus
		 		new ComponentStateStyle(
		 			new PushButtonFill( 6, 10, Color.MediumAquamarine, Color.DarkCyan,	Color.DarkSlateGray ),
		 			null, Color.DarkCyan, null, new Insets(4, 7, 4, 13), new Borders(0), new Corners(4), null, innerEnabled ),
		 		new ComponentStateStyle(),

		 		new ComponentStateStyle(
		 			new PushButtonFill( 8, 10, Color.MediumAquamarine, Color.LightSeaGreen,	Color.DarkSlateGray ),
		 			null, Color.LightSeaGreen, null, new Insets(4, 4, 4, 16), new Borders(0), new Corners(4), null, innerEnabled ),
		 		new ComponentStateStyle(
		 			new PushButtonFill( -1, 10, Color.MediumAquamarine, Color.LightSeaGreen,	Color.DarkSlateGray ),
		 			null, Color.LightSeaGreen, null, new Insets(4, 14, 4, 6), new Borders(0), new Corners(4), null, innerEnabled ),

		 		// Selected
		 		new ComponentStateStyle(
		 			new PushButtonFill( 1, 10, Color.LightSeaGreen, Color.Teal,	Color.DarkSlateGray ),
		 			null, Color.Teal, null, new Insets(4, 12, 4, 8), new Borders(0), new Corners(4), null, innerEnabled ),
		 		new ComponentStateStyle(
		 			new PushButtonFill( 1, 10, Color.Gainsboro, Color.Silver, Color.DimGray ),
		 			null, Color.Silver, null, new Insets(4, 12, 4, 8), new Borders(0), new Corners(4), null, innerDisabled ),
		 		new ComponentStateStyle(
		 			new PushButtonFill( 3, 10, Color.MediumAquamarine, Color.LightSeaGreen,	Color.DarkSlateGray ),
		 			null, Color.LightSeaGreen, null, new Insets(4, 11, 4, 9), new Borders(0), new Corners(4), null, innerEnabled ),
		 		new ComponentStateStyle(
		 			new PushButtonFill( -1, 10, Color.MediumAquamarine, Color.LightSeaGreen,	Color.DarkSlateGray ),
		 			null, Color.LightSeaGreen, null, new Insets(4, 14, 4, 6), new Borders(0), new Corners(4), null, innerEnabled ),

		 		// Focus & Selected
		 		new ComponentStateStyle(
		 			new PushButtonFill( 1, 10, Color.MediumAquamarine, Color.DarkCyan,	Color.DarkSlateGray ),
		 			null, Color.DarkCyan, null, new Insets(4, 12, 4, 8), new Borders(0), new Corners(4), null, innerEnabled ),
		 		new ComponentStateStyle(),
		 		new ComponentStateStyle(
		 			new PushButtonFill( 3, 10, Color.MediumAquamarine, Color.LightSeaGreen,	Color.DarkSlateGray ),
		 			null, Color.LightSeaGreen, null, new Insets(4, 11, 4, 9), new Borders(0), new Corners(4), null, innerEnabled ),
		 		new ComponentStateStyle(
		 			new PushButtonFill( -1, 10, Color.MediumAquamarine, Color.LightSeaGreen,	Color.DarkSlateGray ),
		 			null, Color.LightSeaGreen, null, new Insets(4, 14, 4, 6), new Borders(0), new Corners(4), null, innerEnabled )

		 	] ) ).setForAllStates( "format", new TextFormat( "Arial", 18, 0, false, false, false ) )
		 		.setForAllStates("textFx", "$0")
		 		.setStyleForStates(ComponentStates.allOver, "textFx", "<fx:effect type='new aesia.com.edia.text.fx.complex::TwinklingChar()'><fx:effect type='new aesia.com.edia.text.fx.loop::TrembleEffect()'>$0</fx:effect></fx:effect>" );

			SkinManagerInstance.currentSkin = { PushButton:pushButton };

			var a : Array = [TrembleEffect,TwinklingChar];

			var button3 : Button = new AdvancedButton();
			button3.styleKey = "PushButton";

			var button4 : ToggleButton = new ToggleButton();
			button4.styleKey = "PushButton";
			button4.selected = true;

			var button5 : Button = new Button();
			button5.styleKey = "PushButton";
			button5.enabled = false;

			var button6 : Button = new Button();
			button6.styleKey = "PushButton";
			button6.enabled = false;
			button6.selected = true;

			var button7 : ToggleButton = new ToggleButton();
			button7.icon = magicIconBuild(add);
			button7.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;			button7.styleKey = "PushButton";

			var button8 : ToggleButton = new ToggleButton();
			button8.icon = magicIconBuild(add);
			button8.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			button8.styleKey = "PushButton";
			button8.enabled = false;
			button8.selected = true;

			p.addComponent( button3 );
			p.addComponent( button4 );
			p.addComponent( button5 );
			p.addComponent( button6 );
			p.addComponent( button7 );
			p.addComponent( button8 );

			return p;
		}

		private function createFillTab () : Tab
		{
			var p : Panel = createInlinePanel( "topToBottom", "left","top",true );
			p.style.setForAllStates("insets", new Insets(5) );

			p.addComponent( createSimpleFillFieldSet() );			p.addComponent( createStripFillFieldSet() );			p.addComponent( createArrowFillFieldSet() );			p.addComponent( createGradientFillFieldSet() );			p.addComponent( createArrowGradientFillFieldSet() );			p.addComponent( createSlidedBitmapFillFieldSet() );			p.addComponent( createAdvancedSlidedBitmapFillFieldSet() );

			return new SimpleTab("Fills", p );
		}

		private function createStripFillFieldSet () : Component
		{
			var p : FieldSet = new FieldSet("Simple Fill");
			p.childrenLayout = new GridLayout( p, 1, 6,5,5 );
			var c : AbstractComponent;

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new StripFill([Color.Gray, Color.Silver ], [5,5], 45) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new StripFill([Color.Gray, Color.Silver ], [2,5], -45) )
				   .setForAllStates("corners",new Corners(5,10,15,25));
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new StripFill([Color.Gray, Color.Silver ], [1,8], 0) )
				   .setForAllStates("borders",new Borders(2,3,5,8) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new StripFill([Color.Gray, Color.Silver ], [4,2], 90) )
				   .setForAllStates("corners",new Corners(13) )
				   .setForAllStates("borders",new Borders(2,3,5,8) );
			p.addComponent(c);

			return p;
		}

		private function createArrowGradientFillFieldSet () : Component
		{
			var g : Gradient = new Gradient( [ Color.Silver, Color.Gray ], [0,1]);
			var p : FieldSet = new FieldSet("Arrow Gradient Borders");
			p.childrenLayout = new GridLayout( p, 1, 6,5,5 );
			var c : AbstractComponent;

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("foreground", new ArrowSideGradientFill( g, 0, "north", 10 ) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("foreground", new ArrowSideGradientFill( g, 90, "south", 15 ) )
				   .setForAllStates("corners",new Corners(5,10,15,25));
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("foreground", new ArrowSideGradientFill( g, 45, "west", 15 ) )
				   .setForAllStates("borders",new Borders(2,3,5,8) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("foreground", new ArrowSideGradientFill( g, 180, "east", 20 ) )
				   .setForAllStates("corners",new Corners(13) )
				   .setForAllStates("borders",new Borders(2,3,5,8) );
			p.addComponent(c);

			return p;
		}
		private function createArrowFillFieldSet () : Component
		{
			var p : FieldSet = new FieldSet("Arrow Fill");
			p.childrenLayout = new GridLayout( p, 1, 6,5,5 );
			var c : AbstractComponent;

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new ArrowSideFill(Color.Gray, "north", 15 ) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new ArrowSideFill(Color.Gray, "south", 15 ) )
				   .setForAllStates("corners",new Corners(5,10,15,25));
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new ArrowSideFill(Color.Gray, "west", 15 ) )
				   .setForAllStates("borders",new Borders(2,3,5,8) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new ArrowSideFill(Color.Gray, "east", 15 ) )
				   .setForAllStates("corners",new Corners(5) )
				   .setForAllStates("borders",new Borders(2,3,5,8) );
			p.addComponent(c);

			return p;
		}

		private function createSlidedBitmapFillFieldSet () : Component
		{
			var s9b : SlicedBitmapFill = new SlicedBitmapFill( EmbeddedBitmapAllocatorInstance.get(bgStretchClass).bitmapData,
												 new Rectangle( 8,8,24,24 ) );

			var p : FieldSet = new FieldSet("Sliced Bitmap Fill");
			p.childrenLayout = new GridLayout( p, 1, 6,5,5 );
			var c : AbstractComponent;

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", s9b );
			p.addComponent(c);

			return p;
		}

		private function createAdvancedSlidedBitmapFillFieldSet () : Component
		{
			var s9b : AdvancedSlicedBitmapFill = new AdvancedSlicedBitmapFill( EmbeddedBitmapAllocatorInstance.get(bgTileClass).bitmapData,
												 new Rectangle( 8,8,24,24 ),
			[ {h:'stretch', v:'stretch'}, {h:'tile', v:'stretch'}, {h:'stretch', v:'stretch'},
			  {h:'stretch', v:'tile'},	  {h:'tile', v:'tile'},    {h:'stretch', v:'tile'},
			  {h:'stretch', v:'stretch'}, {h:'tile', v:'stretch'}, {h:'stretch', v:'stretch'} ]);

			var p : FieldSet = new FieldSet("Advanced Sliced Bitmap Fill");
			p.childrenLayout = new GridLayout( p, 1, 6,5,5 );
			var c : AbstractComponent;

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", s9b );
			p.addComponent(c);

			return p;
		}

		private function createButtonFillFieldSet () : Component
		{
			var p : FieldSet = new FieldSet("Bordered Gradient Fill");
			p.childrenLayout = new GridLayout( p, 1, 6,5,5 );
			var c : AbstractComponent;

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new BorderedGradientFill( Color.DarkGray, Color.Gainsboro, Color.Silver, new Borders(5), 0 ) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new BorderedGradientFill( Color.DarkGray, Color.Gainsboro, Color.Silver, new Borders(2), 1 ) )
				   .setForAllStates("corners",new Corners(5,10,15,25));
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new BorderedGradientFill( Color.DarkGray, Color.Gainsboro, Color.Silver, new Borders(1,2,3,5), 0 ) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new BorderedGradientFill( Color.DarkGray, Color.Gainsboro, Color.Silver, new Borders(5), 1 ) )
				   .setForAllStates("corners",new Corners(13) );
			p.addComponent(c);

			return p;
		}

		private function createGradientFillFieldSet () : Component
		{
			var g : Gradient = new Gradient( [ Color.Silver, Color.Gray ], [0,1]);
			var p : FieldSet = new FieldSet("Gradient Fill");
			p.childrenLayout = new GridLayout( p, 1, 6,5,5 );
			var c : AbstractComponent;

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new GradientFill( g, 45 ) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new GradientFill( g, 90 ) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new GradientFill( g, 180 ) );			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new GradientFill( g, 0 ) )
				   .setForAllStates("corners",new Corners(13) );
			p.addComponent(c);

			return p;
		}
		private function createSimpleFillFieldSet () : Component
		{
			var p : FieldSet = new FieldSet("Simple Fill");
			p.childrenLayout = new GridLayout( p, 1, 6,5,5 );
			var c : AbstractComponent;

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new SimpleFill(Color.Gray) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new SimpleFill(Color.Gray) )
				   .setForAllStates("corners",new Corners(5,10,15,25));
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new SimpleFill(Color.Gray) )
				   .setForAllStates("borders",new Borders(2,3,5,8) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new SimpleFill(Color.Gray) )
				   .setForAllStates("corners",new Corners(13) )
				   .setForAllStates("borders",new Borders(2,3,5,8) );
			p.addComponent(c);

			return p;
		}

		private function createBordersTab () : Tab
		{
			var p : Panel = createInlinePanel( "topToBottom", "left","top",true );
			p.style.setForAllStates("insets", new Insets(5) );

			p.addComponent( createSimpleBordersFieldSet() );			p.addComponent( createArrowBordersFieldSet() );			p.addComponent( createGradientBordersFieldSet() );			p.addComponent( createArrowGradientBordersFieldSet() );
			return new SimpleTab("Borders", p );
		}
		private function createArrowGradientBordersFieldSet () : Component
		{
			var g : Gradient = new Gradient( [ Color.Silver, Color.Gray ], [0,1]);
			var p : FieldSet = new FieldSet("Arrow Gradient Borders");
			p.childrenLayout = new GridLayout( p, 1, 6,5,5 );
			var c : AbstractComponent;

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("foreground", new ArrowSideGradientBorders( g, 0, "north", 10 ) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("foreground", new ArrowSideGradientBorders( g, 45, "south", 15 ) )
				   .setForAllStates("corners",new Corners(5,10,15,25));
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("foreground", new ArrowSideGradientBorders( g, 90, "west", 15 ) )
				   .setForAllStates("borders",new Borders(2,3,5,8) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("foreground", new ArrowSideGradientBorders( g, 180, "east", 20 ) )
				   .setForAllStates("corners",new Corners(13) )
				   .setForAllStates("borders",new Borders(2,3,5,8) );
			p.addComponent(c);

			return p;
		}
		private function createArrowBordersFieldSet () : Component
		{
			var p : FieldSet = new FieldSet("Arrow Borders");
			p.childrenLayout = new GridLayout( p, 1, 6,5,5 );
			var c : AbstractComponent;

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new ArrowSideBorders(Color.Gray, "north", 10 ) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new ArrowSideBorders(Color.Gray, "south", 15 ) )
				   .setForAllStates("corners",new Corners(5,10,15,25));
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new ArrowSideBorders(Color.Gray, "west", 15 ) )
				   .setForAllStates("borders",new Borders(2,3,5,8) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("background", new ArrowSideBorders(Color.Gray, "east", 20 ) )
				   .setForAllStates("corners",new Corners(5) )
				   .setForAllStates("borders",new Borders(2,3,5,8) );
			p.addComponent(c);

			return p;
		}
		private function createGradientBordersFieldSet () : Component
		{
			var g : Gradient = new Gradient( [ Color.Silver, Color.Gray ], [0,1]);
			var p : FieldSet = new FieldSet("Gradient Borders");
			p.childrenLayout = new GridLayout( p, 1, 6,5,5 );
			var c : AbstractComponent;

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("foreground", new GradientBorders( g, 45 ) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("foreground", new GradientBorders( g, 90 ) )
				   .setForAllStates("corners",new Corners(5,10,15,25));
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("foreground", new GradientBorders( g, 180 ) )
				   .setForAllStates("borders",new Borders(2,3,5,8) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("foreground", new GradientBorders( g, 0 ) )
				   .setForAllStates("corners",new Corners(13) )
				   .setForAllStates("borders",new Borders(2,3,5,8) );
			p.addComponent(c);

			return p;
		}
		private function createSimpleBordersFieldSet () : Component
		{
			var p : FieldSet = new FieldSet("Simple Borders");
			p.childrenLayout = new GridLayout( p, 1, 6,5,5 );
			var c : AbstractComponent;

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("foreground", new SimpleBorders(Color.Gray) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("foreground", new SimpleBorders(Color.Gray) )
				   .setForAllStates("corners",new Corners(5,10,15,25));
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("foreground", new SimpleBorders(Color.Gray) )
				   .setForAllStates("borders",new Borders(2,3,5,8) );
			p.addComponent(c);

			c = new AbstractComponent ();
			c.styleKey = "EmptyComponent";
			c.preferredSize = new Dimension(50,50);
			c.style.setForAllStates("foreground", new SimpleBorders(Color.Gray) )
				   .setForAllStates("corners",new Corners(13) )
				   .setForAllStates("borders",new Borders(2,3,5,8) );
			p.addComponent(c);

			return p;
		}

		private function createAdvancedToolsTab () : Tab
		{
			var tabbedPane : TabbedPane = new TabbedPane( CardinalPoints.WEST );

			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
				tabbedPane.dndEnabled = false;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			tabbedPane.addTab( createLogViewTab () );			tabbedPane.addTab( createTerminalTab () );			tabbedPane.addTab( createMonitorsTab () );			tabbedPane.addTab( createFormTab () );

			var tab : SimpleTab = new SimpleTab( "Advanced Tools", tabbedPane );
			return tab;
		}

		private function createFormTab () : Tab
		{
			var u : User = new User();
			var f : FormObject = FormUtils.createFormFromMetas( u );
			var p : Container = FieldSetFormRenderer.instance.render(f) as Container;
			var m : SimpleFormManager = new SimpleFormManager( f );
			//p.x = 10;
			//p.y = 10;
			p.style.setForAllStates("insets", new Insets(5) );
			return new SimpleTab("Form Metadata", p);
		}

		private function createMonitorsTab () : Tab
		{
			var pc : Panel = new Panel();
			var bl : BorderLayout = new BorderLayout(pc);
			pc.childrenLayout = bl;

			var p : Panel = new Panel();
			p.childrenLayout = new GridLayout(p,2,1,3,3);

			var l1 : BorderLayout = new BorderLayout();
			var p1 : Panel = new Panel();
			p1.childrenLayout = l1;
			var monitor1 : GraphMonitor = new GraphMonitor();
			monitor1.addRecorder( new MemRecorder( new Range(0,100)) );
			monitor1.addRecorder( new MemRecorder( new Range(0,100), null, 0 ) );			monitor1.addRecorder( new MemRecorder( new Range(0,100), null, 1 ) );
			//monitor.addRecorder( new FPSRecorder() );
			var caption1 : GraphMonitorCaption = new GraphMonitorCaption( monitor1 );
			var ruler1 : GraphMonitorRuler = new GraphMonitorRuler( monitor1, monitor1.recorders[0] );
			var ruler2 : GraphMonitorRuler = new GraphMonitorRuler( monitor1, monitor1.recorders[0], "left" );

			l1.center = monitor1;
			l1.south = caption1;
			l1.west = ruler1;
			l1.east = ruler2;
			p1.addComponent( monitor1 );
			p1.addComponent( caption1 );
			p1.addComponent( ruler1 );
			p1.addComponent( ruler2 );

			var l2 : BorderLayout = new BorderLayout();
			var p2 : Panel = new Panel();
			p2.childrenLayout = l2;
			var monitor2 : GraphMonitor = new GraphMonitor();
			monitor2.addRecorder( new FPSRecorder() );			monitor2.addRecorder( new ImpulseListenerRecorder( Impulse ) );
			var caption2 : GraphMonitorCaption = new GraphMonitorCaption( monitor2 );
			var ruler3 : GraphMonitorRuler = new GraphMonitorRuler( monitor2, monitor2.recorders[0] );
			var ruler4 : GraphMonitorRuler = new GraphMonitorRuler( monitor2, monitor2.recorders[1], "left" );

			l2.center = monitor2;			l2.south = caption2;
			l2.west = ruler3;
			l2.east = ruler4;
			p2.addComponent( monitor2 );
			p2.addComponent( caption2 );
			p2.addComponent( ruler3 );
			p2.addComponent( ruler4 );

			p.addComponent(p1);			p.addComponent(p2);

			var t : ToolBar = new ToolBar();
			t.addComponent( new Button(new ForceGC("GC") ) );

			pc.addComponent( p );
			bl.center  = p;

			pc.addComponent( t );
			bl.north = t;

			var tab : SimpleTab = new SimpleTab( "Monitors", pc );
			return tab;
		}

		private function createTerminalTab () : Tab
		{
			var terminal : Terminal = new Terminal();

			var s : Shape = new Shape();
			s.graphics.beginFill( Color.YellowGreen.hexa );
			s.graphics.drawCircle( 0,0,10);
			s.graphics.endFill();


			function aC () : void
			{
				ToolKit.popupLevel.addChild( s );
				terminal.echo( s + " added" );
			}
			function rC () : void
			{
				ToolKit.popupLevel.removeChild( s );
				terminal.echo( s + " removed" );
			}
			function foo( s : String ) : void
			{
				terminal.echo( s );
			}
			function commandEnd ( e : Event ) : void
			{
				terminal.echo( "command ended" );
			}
			function commandFailed ( e : Event ) : void
			{
				terminal.echo( "command failed" );
			}

			var acc : ProxyCommand = new ProxyCommand( aC );			var rcc : ProxyCommand = new ProxyCommand( rC );
			var i1 : Interval = new Interval( foo, 1000, 5, "pouet" );
			var i2 : Timeout = new Timeout( foo, 2000, "plop" );
			//var l : LoopCommand = new LoopCommand( new Iteration( new StringIterator( "hello world !!!" ), terminal ), 10 );
			var t1 : SingleTween = new SingleTween( s, "x", StageUtils.stage.stageWidth, 2000 );
			var t2 : SingleTween = new SingleTween( s, "y", StageUtils.stage.stageHeight, 2000, 0, Bounce.easeOut );
			var b : ReversedQueue = new ReversedQueue();
			var p : ParallelCommand = new ParallelCommand();

			p.addCommand( t1 );			p.addCommand( t2 );
			b.addCommand( i1 );
			b.addCommand( i2 );
			//b.addCommand( l );
			b.addCommand( rcc );
			b.addCommand( p );
			b.addCommand( acc );

			b.addEventListener( CommandEvent.COMMAND_END, commandEnd );
			b.addEventListener( CommandEvent.COMMAND_FAIL, commandFailed );
			terminal.addCommand( ActionManagerInstance.getAction( BuiltInActionsList.UNDO ) as TerminalAction );			terminal.addCommand( ActionManagerInstance.getAction( BuiltInActionsList.REDO ) as TerminalAction );
			terminal.addCommand(
				new TerminalActionProxy( b,
										 _("Proxy Command"),
										 null,
										  _("A TerminalCommandProxy which launch a ReversedQueue with many sub-routines."),
										 "proxy",										 "proxy",
										 _("A TerminalCommandProxy which launch a ReversedQueue with many sub-routines.") ) );

			terminal.addCommand(
				new TerminalActionProxy(
						new Timeout( function(...args):void {}, 500 ),
						_("Timeout Command"),
						null,
						_("An action proxy demo"),
						"timeout",						"timeout",
						_("An action proxy demo.")
				));

			var tab : SimpleTab = new SimpleTab( "Terminal", terminal );
			return tab;
		}

		private function createLogViewTab () : Tab
		{
			var p : Panel = createBorderPanel();
			var t : ToolBar = new ToolBar();
			var l : LogView = new LogView();

			var i : TextInput = new TextInput();
			i.preferredWidth = 300;
			var bd : Button = new Button( new LogAction( "Debug This !", "debug", i, new EmbeddedBitmapIcon( lightbulb)  ) );			var id : Button = new Button( new LogAction( "Info This !", "info", i, new EmbeddedBitmapIcon( information ) ) );			var wd : Button = new Button( new LogAction( "Warn This !", "warn", i, new EmbeddedBitmapIcon( error ) ) );			var ed : Button = new Button( new LogAction( "Error This !", "error", i, new EmbeddedBitmapIcon( exclamation ) ) );			//var fd : Button = new Button( new LogAction( "Fatal This !", "fatal", i, exclamation ) );

			t.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			t.addComponent( i );			t.addComponent( bd );			t.addComponent( id );			t.addComponent( wd );			t.addComponent( ed );			//t.addComponent( fd );

			p.addComponent( t );
			p.addComponent( l );

			(p.childrenLayout as BorderLayout).north = t;			(p.childrenLayout as BorderLayout).center = l;

			Log.debug( "A debug message" );
			Log.info( "An info message" );
			Log.warn( "A warning message" );
			Log.error( "An error message" );
			Log.fatal( "A fatal message" );

			var tab : SimpleTab = new SimpleTab( "LogView", p );
			return tab;
		}

		private function createLayoutComponentTab () : Tab
		{
			var tabbedPane : TabbedPane = new TabbedPane( CardinalPoints.WEST );

			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
				tabbedPane.dndEnabled = false;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			tabbedPane.addTab( createWindowTab () );			tabbedPane.addTab( createToolBarTab () );			tabbedPane.addTab( createScrollPaneTab () );			tabbedPane.addTab( createSlidePaneTab () );			tabbedPane.addTab( createSplitPaneTab () );			tabbedPane.addTab( createMultiSplitPaneTab () );			tabbedPane.addTab( createTabbedPaneTab () );			tabbedPane.addTab( createAccordionTab () );

			var tab : SimpleTab = new SimpleTab( "Layout Components", tabbedPane );
			return tab;
		}
		private function createAccordionTab() : Tab
		{
			var pmain : Panel = createInlinePanel("leftToRight", "left", "top" );
			pmain.style.setForAllStates("insets", new Insets(5,0,5,0));

			var accordion2 : Accordion = new Accordion(
														new AccordionTab( "Tab #1" , new Button().setPreferredSize(dm(100,50) ), magicIconBuild(add) ),
														new AccordionTab( "Tab #2" , new TextArea().setPreferredSize(dm(150,150) ) ),
														new AccordionTab( "Tab #3" , new Spinner() )
													 );
			var scp1 : ScrollPane = new ScrollPane ();
			scp1.preferredSize = dm( 200, 300 );
			scp1.view = accordion2;

			var accordion3 : Accordion = new Accordion(
														new AccordionTab( "Tab #1" , new Button().setPreferredSize(dm(100,50) ), magicIconBuild(add) ),
														new AccordionTab( "Tab #2" , new TextArea().setPreferredSize(dm(150,150) ) ),
														new AccordionTab( "Tab #3" , new Spinner() )
													 );
			var scp2 : ScrollPane = new ScrollPane ();
			scp2.preferredSize = dm( 200, 100 );
			scp2.view = accordion3;

			pmain.addComponent(scp1);			pmain.addComponent(scp2);

			return new SimpleTab( "Accordion", pmain );
		}

		private function createWindowTab () : Tab
		{
			var p : Panel = createInlinePanel("topToBottom", "left", "top");
			p.style.setForAllStates("insets", new Insets(5,0));

			var pp : Panel = createInlineFieldSet("Minimized Window Container", "leftToRight", "left", "top" );

			p.addComponent( new Button(new ProxyAction(function():void
			{
				var w : Window = new Window();
				w.windowTitle = new WindowTitleBar("A window",magicIconBuild(add),15);
				w.x = 100;
				w.y = 100;
				w.resizable = true;
				w.preferredSize = new Dimension(250,250);
				w.open();
			},
			"Open a resizable window with title bar and buttons")) );

			p.addComponent( new Button(new ProxyAction(function():void
			{
				var w : Window = new Window();
				w.windowTitle = new WindowTitleBar("Another window",magicIconBuild(add),4);
				w.x = 100;
				w.y = 350;
				w.preferredSize = new Dimension(100,50);
				w.open();
			},
			"Open a simple closable window with title bar")) );

			p.addComponent( new Button(new ProxyAction(function():void
			{
				var w : Window = new Window();
				w.windowTitle = new WindowTitleBar("A window",magicIconBuild(add),15);
				w.x = 100;
				w.y = 100;
				w.resizable = true;
				w.preferredSize = new Dimension(250,250);
				w.minimizedContainer = pp;
				w.open();
			},
			"Open a window with a minimize container")) );

			p.addComponent( pp );

			var tab : SimpleTab = new SimpleTab( "Windows", p );
			return tab;
		}

		private function createTabbedPaneTab () : Tab
		{
			var p : Panel = createGridPanel( 2 );

			p.addComponent( createTabbedPane2( "north", true ) );
			p.addComponent( createTabbedPane2( "west", true, false ) );
			p.addComponent( createTabbedPane2( "south", true, false, true ) );
			p.addComponent( createTabbedPane2( "east", true, true, true ) );

			p.addComponent( createTabbedPane2( "north", false ) );
			p.addComponent( createTabbedPane2( "west", false, false, true ) );

			var tab : SimpleTab = new SimpleTab( "TabbedPane", p );
			return tab;
		}

		private function createMultiSplitPaneTab () : Tab
		{
			var msp : MultiSplitPane = new MultiSplitPane();

			var bt1 : DraggableButton = new DraggableButton();
			var bt2 : DraggableButton = new DraggableButton();
			var bt3 : DraggableButton = new DraggableButton();
			var bt4 : DraggableButton = new DraggableButton();
			var bt5 : DraggableButton = new DraggableButton();
			var bt6 : DraggableButton = new DraggableButton();

			var model : Split = new Split(false);
			var col : Split = new Split(false);
			var row : Split = new Split();

			msp.multiSplitLayout.modelRoot = model;

			msp.multiSplitLayout.addSplitChild(col, new Leaf(bt1));
			msp.multiSplitLayout.addSplitChild(col, new Leaf(bt2));
			msp.multiSplitLayout.addSplitChild(col, new Leaf(bt3));

			msp.multiSplitLayout.addSplitChild(row, new Leaf(bt4));
			msp.multiSplitLayout.addSplitChild(row, col);
			msp.multiSplitLayout.addSplitChild(row, new Leaf(bt5));

			msp.multiSplitLayout.addSplitChild(model, row);
			msp.multiSplitLayout.addSplitChild(model, new Leaf(bt6));

			msp.addComponent( bt1 );
			msp.addComponent( bt2 );
			msp.addComponent( bt3 );
			msp.addComponent( bt4 );
			msp.addComponent( bt5 );
			msp.addComponent( bt6 );

			var tab : SimpleTab = new SimpleTab( "MultiSplitPane", msp );
			return tab;
		}

		private function createSplitPaneTab () : Tab
		{

			var nest : SplitPane = new SplitPane( 0,
												  createSplitPane(1, .6, 75 ),
												  createSplitPane(1, .6, 50 ) );

			var tab : SimpleTab = new SimpleTab( "SplitPane", nest );
			return tab;
		}

		private function createSlidePaneTab () : Tab
		{
			var p : Panel = createGridPanel( 2 );

			var scp1 : SlidePane = new SlidePane();
			var scp2 : SlidePane = new SlidePane();
			var scp3 : SlidePane = new SlidePane();
			var scp4 : SlidePane = new SlidePane();
			var scp5 : SlidePane = new SlidePane();
			var scp6 : SlidePane = new SlidePane();
			scp2.view = new Panel();
			scp4.view = new Panel();
			scp3.view = new ToggleButton();
			scp5.view = new ToggleButton();
			(scp3.view as ToggleButton ).preferredSize = new Dimension( 100,600 );
			(scp5.view as ToggleButton ).preferredSize = new Dimension( 100,600 );

			var b : ToggleButton = new ToggleButton();
			b.preferredSize = new Dimension( 600,600 );

			scp1.view = b;

			scp6.view = new ToggleButton();
			(scp6.view as ToggleButton ).preferredSize = new Dimension( 600,600 );

			scp4.enabled = scp5.enabled = scp6.enabled = false;

			p.addComponent( scp2 );
			p.addComponent( scp3 );
			p.addComponent( scp1 );
			p.addComponent( scp4 );
			p.addComponent( scp5 );
			p.addComponent( scp6 );

			var tab : SimpleTab = new SimpleTab( "SlidePane", p );
			return tab;
		}
		private function createScrollPaneTab () : Tab
		{
			var p : Panel = createGridPanel( 2 );

			var scp1 : ScrollPane = new ScrollPane();			var scp2 : ScrollPane = new ScrollPane();			var scp3 : ScrollPane = new ScrollPane();
			var scp4 : ScrollPane = new ScrollPane();
			var scp5 : ScrollPane = new ScrollPane();
			var scp6 : ScrollPane = new ScrollPane();
			scp2.view = new Panel();			scp4.view = new Panel();			scp3.view = new ToggleButton();			scp5.view = new ToggleButton();
			(scp3.view as ToggleButton ).preferredSize = new Dimension( 600,600 );			(scp5.view as ToggleButton ).preferredSize = new Dimension( 600,600 );

			var b : ToggleButton = new ToggleButton();
			b.preferredSize = new Dimension( 600,600 );

			scp1.view = b;

			scp1.upperLeft = new ToggleButton();
			scp1.upperRight = new ToggleButton();
			scp1.lowerLeft = new ToggleButton();
			scp1.lowerRight = new ToggleButton();

			scp1.rowHead = new PixelRuler( scp1.view, Orientations.VERTICAL );
			scp1.colHead = new PixelRuler( scp1.view );

			scp6.rowHead = new ToggleButton();
			(scp6.rowHead as ToggleButton).preferredSize = new Dimension( 20,20 );
			scp6.colHead = new ToggleButton();
			(scp6.colHead as ToggleButton).preferredSize = new Dimension( 20,20 );

			scp6.upperLeft = new ToggleButton();
			scp6.upperRight = new ToggleButton();
			scp6.lowerLeft = new ToggleButton();
			scp6.lowerRight = new ToggleButton();

			scp6.view = new ToggleButton();
			(scp6.view as ToggleButton ).preferredSize = new Dimension( 600,600 );

			scp4.enabled = scp5.enabled = scp6.enabled = false;

			p.addComponent( scp2 );			p.addComponent( scp3 );			p.addComponent( scp1 );			p.addComponent( scp4 );			p.addComponent( scp5 );			p.addComponent( scp6 );

			var tab : SimpleTab = new SimpleTab( "ScrollPane", p );
			return tab;
		}

		private function createToolBarTab () : Tab
		{
			var p1 : Panel = createBorderPanel ();
			var l1 : BorderLayout = p1.childrenLayout as BorderLayout;
			var ht1 : SlidePane = createToolBar( 2, true );
			var ht2 : SlidePane = createToolBar( 2, false, Directions.RIGHT_TO_LEFT );

			var vt1 : SlidePane = createToolBar( 2, true, Directions.TOP_TO_BOTTOM );
			var vt2 : SlidePane = createToolBar( 2, false, Directions.BOTTOM_TO_TOP );

			var scp : ScrollPane = new ScrollPane();
			scp.view = new Panel();

			p1.addComponents(ht1 );			p1.addComponents(ht2 );
			p1.addComponent( vt1 );			p1.addComponent( vt2 );			p1.addComponent( scp );

			l1.addComponent( ht1, CardinalPoints.NORTH );			l1.addComponent( ht2, CardinalPoints.SOUTH );			l1.addComponent( vt1, CardinalPoints.WEST );			l1.addComponent( vt2, CardinalPoints.EAST );			l1.addComponent( scp );

			var tab : SimpleTab = new SimpleTab( "ToolBars", p1 );
			return tab;
		}

		private function createDataComponentTab () : Tab
		{

			var tabbedPane : TabbedPane = new TabbedPane( CardinalPoints.WEST );

			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
				tabbedPane.dndEnabled = false;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			tabbedPane.addTab( createListTab () );			tabbedPane.addTab( createListEditorTab () );			tabbedPane.addTab( createTreeTab () );			tabbedPane.addTab( createTableTab () );

			var tab : SimpleTab = new SimpleTab( "Data Components", tabbedPane );
			return tab;
		}

		private function createListEditorTab () : Tab
		{
			var p : Panel = createGridPanel();

			var l : ListEditor = new ListEditor( ["Item 1 of an editable & draggable list",
									 "Item 2",
									 "Item 3 with a longer text.",
									 "Item 4",
									 "Item 5",
									 "Item 6",
									 "Item 7",
									 "Item 8",
									 "Item 9",
									 "Item 10"],
									 new TextInput(),
									 String );
			l.list.allowMultiSelection = true;

			//scp.addEventListener( ComponentEvent.SCROLL, scroll );

			var l2 : ListEditor = new ListEditor( [ 0,1,2, 3,4,5 ], new Spinner( new SpinnerNumberModel(0, uint.MIN_VALUE, uint.MAX_VALUE, 1, true) ), uint );
			var l3 : ListEditor = new ListEditor( [], new ComboBox("Item 1", "Item 2", "Item 3", "Item 4", "Item 5"), String );


			p.addComponent( l );
			p.addComponent( l2 );			p.addComponent( l3 );

			var tab : SimpleTab = new SimpleTab( "List Editor", p );
			return tab;
		}

		private function createTableTab () : Tab
		{
			var p : Panel = createGridPanel();

			var printName : Function = function () : String
			{
				return this.name + " " + this.fname;
			}

			var table1 : Table = new Table(
										   {fname:"Ace", name:"Portgas D", age:"20", devil:true, toString:printName},
							 			   {fname:"Chopper", name:"Tony Tony", age:"15", devil:true, toString:printName},							 			   {fname:"Monkey", name:"Monkey D", age:"17", devil:true, toString:printName},							 			   {fname:"Nami", name:" ", age:"18", devil:false, toString:printName},							 			   {fname:"Nico", name:"Robin", age:"28", devil:true, toString:printName},							 			   {fname:"Sanji", name:" ", age:"19", devil:false, toString:printName},							 			   {fname:"Vivi", name:"Nefertari", age:"16", devil:false, toString:printName},							 			   {fname:"Usopp", name:" ", age:"17", devil:false, toString:printName},							 			   {fname:"Zoro", name:"Roronoa", age:"19", devil:false, toString:printName},							 			   {fname:"Franky", name:" ", age:"34", devil:false, toString:printName},
							 			   {fname:"Brook", name:" ", age:"88", devil:true, toString:printName}
							 			   );

			table1.rowHead = new ListLineRuler( table1.view as List );
			table1.header.addColumns(
				 					 new TableColumn( "Name", "name" ),
				 					 new TableColumn( "First Name", "fname" ),
				 					 new TableColumn( "Devil", "devil", 50 ),
				 					 new TableColumn( "Age", "age", 50 )
				 					 );

			var table2 : Table = new Table(										   {fname:"Naruto", name:"Uzumaki", age:"16", toString:printName},										   {fname:"Sasuke", name:"Uchiwa", age:"16", toString:printName},										   {fname:"Sakura", name:"Haruno", age:"16", toString:printName},										   {fname:"Kakashi", name:"Hatake", age:"29", toString:printName},										   {fname:"Minato", name:"Namikaze", age:"--", toString:printName},
										   {fname:"Jiraya", name:"", age:"--", toString:printName}
							 			   );

			table2.header.addColumns(
				 					 new TableColumn( "Name", "name" ),
				 					 new TableColumn( "First Name", "fname" ),
				 					 new TableColumn( "Age", "age", 50 )
				 					 );

			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
				table2.dndEnabled = false;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			table2.editEnabled = false;


			var table3 : Table = new Table(
										   {fname:"Ichigo", name:"Kurosaki", age:"16", toString:printName},
										   {fname:"Orihime", name:"Inoue", age:"16", toString:printName},
										   {fname:"Sado", name:"Yasutora", age:"16", toString:printName},
										   {fname:"Rukia", name:"Kuchiki", age:"?", toString:printName},
										   {fname:"Uryû", name:"Ishida", age:"16", toString:printName},
										   {fname:"Yoruichi", name:"Shihōin", age:"?", toString:printName}
							 			   );

			table3.header.addColumns(
				 					 new TableColumn( "Name", "name" ),
				 					 new TableColumn( "First Name", "fname" ),
				 					 new TableColumn( "Age", "age", 50 )
				 					 );
			table3.enabled = false;

			p.addComponent( table1 );			p.addComponent( table2 );			p.addComponent( table3 );

			var tab : SimpleTab = new SimpleTab( "Table", p );
			return tab;
		}

		private function createTreeTab () : Tab
		{
			var p : Panel = createGridPanel();

			var t : Tree = new Tree();
			(t.model as TreeModel).root.add( new TreeNode( "Child 1" ) );
			(t.model as TreeModel).root.add( new TreeNode( "Child 2" ) );
			(t.model as TreeModel).root.add( new TreeNode( "Child 3" ) );
			(t.model as TreeModel).root.add( new TreeNode( "Child 4" ) );
			(t.model as TreeModel).root.add( new TreeNode( "Child 5 with a longer text" ) );
			(t.model as TreeModel).root.add( new TreeNode( "Child 6" ) );
			(t.model as TreeModel).root.add( new TreeNode( "Child 7" ) );
			(t.model as TreeModel).root.add( new TreeNode( "Child 8" ) );
			t.allowMultiSelection = true;
			t.expandAll();

			var t2 : Tree = new Tree();
			t2.editEnabled = false;
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
				t2.dndEnabled = false;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			t2.showRoot = false;
			var t2n1 : TreeNode = new TreeNode( "Child 1" );
			var t2n2 : TreeNode = new TreeNode( "Child 2" );
			var t2n3 : TreeNode = new TreeNode( "Child 3" );
			var t2n4 : TreeNode = new TreeNode( "Child 4" );
			var t2n5 : TreeNode = new TreeNode( "Child 5" );
			(t2.model as TreeModel).root.add( t2n1 );
			t2n1.add( t2n2 );
			t2n2.add( t2n3 );
			t2n3.add( t2n4 );
			t2n4.add( t2n5 );
			t2.expandAll();

			var t3 : Tree = new Tree();
			var t3n1 : TreeNode = new TreeNode( "Child 1" );
			var t3n2 : TreeNode = new TreeNode( "Child 2" );
			var t3n3 : TreeNode = new TreeNode( "Child 3" );
			var t3n4 : TreeNode = new TreeNode( "Child 4" );
			var t3n5 : TreeNode = new TreeNode( "Child 5" );
			(t3.model as TreeModel).root.add( t3n1 );
			t3n1.add( t3n2 );
			t3n2.add( t3n3 );
			t3n3.add( t3n4 );
			t3n4.add( t3n5 );
			t3.expandAll();

			var scp1 : ScrollPane = new ScrollPane();
			scp1.view = t;
			scp1.rowHead = new ListLineRuler(t);
			scp1.colHead = new TreeHeader( t, ButtonDisplayModes.ICON_ONLY );

			var scp2 : ScrollPane = new ScrollPane();
			scp2.view = t2;

			var scp3 : ScrollPane = new ScrollPane();
			scp3.view = t3;
			scp3.enabled = false;

			p.addComponent( scp1 );
			p.addComponent( scp2 );
			p.addComponent( scp3 );

			var tab : SimpleTab = new SimpleTab( "Tree", p );
			return tab;
		}

		private function createListTab () : Tab
		{
			var p : Panel = createGridPanel();

			var l : List = new List( "Item 1 of an editable & draggable list",
									 "Item 2",
									 "Item 3 with a longer text.",
									 "Item 4",
									 "Item 5",
									 "Item 6",
									 "Item 7",
									 "Item 8",
									 "Item 9",
									 "Item 10" );
			l.allowMultiSelection = true;

			//scp.addEventListener( ComponentEvent.SCROLL, scroll );

			var l2 : List = new List( [ "Item 1 of a simple list",
										"Item 2",
										"Item 3 with a longer text.",
										"Item 4",
										"Item 5",
										"Item 6" ] );
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
				l2.dndEnabled = false;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			l2.editEnabled = false;

			var l3 : List = new List( [ "Item 1 of a disabled list",
										"Item 2",
										"Item 3 with a longer text.",
										"Item 4",
										"Item 5",
										"Item 6" ] );

			var scp1 : ScrollPane = new ScrollPane();
			scp1.view = l;
			scp1.rowHead = new ListLineRuler(l);

			var scp2 : ScrollPane = new ScrollPane();
			scp2.view = l2;

			var scp3 : ScrollPane = new ScrollPane();
			scp3.view = l3;
			scp3.enabled = false;

			p.addComponent( scp1 );
			p.addComponent( scp2 );
			p.addComponent( scp3 );

			var tab : SimpleTab = new SimpleTab( "List", p );
			return tab;
		}



		private function createStandardComponentTab () : Tab
		{
			var tabbedPane : TabbedPane = new TabbedPane( CardinalPoints.WEST );

			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
				tabbedPane.dndEnabled = false;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			tabbedPane.addTab( createButtonTab () );			tabbedPane.addTab( createTextTab () );			tabbedPane.addTab( createSpinnerTab () );			tabbedPane.addTab( createSliderTab () );			tabbedPane.addTab( createComboBoxTab () );			tabbedPane.addTab( createProgressTab () );

			var tab : SimpleTab = new SimpleTab( "Standard Components", tabbedPane );
			return tab;		}

		private function createProgressTab () : Tab
		{
			var p : Panel = createInlinePanel( Directions.TOP_TO_BOTTOM, Alignments.LEFT, Alignments.TOP, true );
			p.style.setForAllStates( "insets", new Insets(5,0,5,0) );

			var pp1 : FieldSet = createInlineFieldSet(_("ProgressBar"),"topToBottom");
			var p1 :ProgressBar = new ProgressBar();			var p2 :ProgressBar = new ProgressBar();			var p3 :ProgressBar = new ProgressBar();

			p1.addEventListener( Event.ENTER_FRAME, function(e : Event):void{ p1.value = ((getTimer()/10000)*100)%100; });
			p1.addEventListener( MouseEvent.CLICK, function( e: Event):void{ p1.determinate = !p1.determinate; } );
			p1.displayLabel = true;

			/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
				p1.tooltip = "Click to toggle determinate mode.";
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			p2.determinate = false;

			p3.value = 35;
			p3.enabled = false;
			pp1.addComponents( p1 );			pp1.addComponents( p2 );			pp1.addComponents( p3 );

			var pp2 : FieldSet = createInlineFieldSet(_("MinimalProgressBar"),"topToBottom");
			var mp1 :MinimalProgressBar = new MinimalProgressBar(25, Color.Red );
			var mp2 :MinimalProgressBar = new MinimalProgressBar(50, Color.Green);
			var mp3 :MinimalProgressBar = new MinimalProgressBar(75, Color.Blue);
			pp2.addComponents( mp1 );
			pp2.addComponents( mp2 );
			pp2.addComponents( mp3 );

			var pp3 : FieldSet = createInlineFieldSet(_("MinimalGradientProgressBar"),"topToBottom");
			var gmp1 :MinimalProgressBar = new MinimalGradientProgressBar(25);
			var gmp2 :MinimalProgressBar = new MinimalGradientProgressBar(50);
			var gmp3 :MinimalProgressBar = new MinimalGradientProgressBar(75);
			pp3.addComponents( gmp1 );
			pp3.addComponents( gmp2 );
			pp3.addComponents( gmp3 );

			p.addComponent(pp1);			p.addComponent(pp2);			p.addComponent(pp3);
			var tab : SimpleTab = new SimpleTab( "Progress", p );
			return tab;
		}

		private function createComboBoxTab () : Tab
		{
			var p : Panel = createInlinePanel( Directions.TOP_TO_BOTTOM, Alignments.LEFT, Alignments.TOP );
			p.style.setForAllStates( "insets", new Insets(5,0,5,0) );

			var combobox1 : ComboBox = new ComboBox(  "Item 1",
													  "Item 2",
													  "Item 3",
													  "Item 4",
													  "Item 5 with a longer text",
													  "Item 6",
													  "Item 7" );

			combobox1.popupAsDropDown = true;
			combobox1.icon = magicIconBuild( add );
			var combobox2 : ComboBox = new ComboBox(  "Item 1",
													  "Item 2",
													  "Item 3",
													  "Item 4",
													  "Item 5 with a longer text",
													  "Item 6",
													  "Item 7" );

			combobox2.preferredSize = new Dimension( 150, 50 );

			var combobox3 : ComboBox = new ComboBox( "Item 1",
													  "Item 2",
													  "Item 3",
													  "Item 4",
													  "Item 5 with a longer text",
													  "Item 6",
													  "Item 7" );

			combobox3.popupAlignOnSelection = true;
			combobox3.icon = magicIconBuild( add );
			var combobox4 : ComboBox = new ComboBox( "Item 1",
													  "Item 2",
													  "Item 3",
													  "Item 4",
													  "Item 5 with a longer text",
													  "Item 6",
													  "Item 7" );

			combobox4.enabled = false;


			var combobox5 : ComboBox = new FontListComboBox();


			p.addComponent( combobox1 );
			p.addComponent( combobox2 );
			p.addComponent( combobox3 );
			p.addComponent( combobox4 );
			p.addComponent( combobox5 );

			var tab : SimpleTab = new SimpleTab( "ComboBox", p );
			return tab;
		}

		private function createSliderTab () : Tab
		{
			var p : Panel = createInlinePanel( Directions.TOP_TO_BOTTOM, Alignments.LEFT, Alignments.TOP, true );
			p.style.setForAllStates( "insets", new Insets(5,0,5,0) );

			p.addComponent( createHorizontalSliderPanel() );			p.addComponent( createVerticalSliderPanel() );

			var tab : SimpleTab = new SimpleTab( "Sliders", p );
			return tab;

		}
		private function createHorizontalSliderPanel() : Panel
		{
			var p : Panel = createInlineFieldSet( "Horizontal Sliders", Directions.TOP_TO_BOTTOM, Alignments.LEFT, Alignments.TOP );
			( p.childrenLayout as InlineLayout ).spacingAtExtremity = false;

			var slider1 : HSlider = new HSlider( new DefaultBoundedRangeModel( 10 ) );

			var slider2 : HSlider = new HSlider( new DefaultBoundedRangeModel( 20 ) );
			slider2.snapToTicks = true;

			var slider3 : HSlider = new HSlider( new DefaultBoundedRangeModel( 30, 0, 50 ), 10, 1 );
			slider3.displayTicks = true;
			slider3.preferredWidth = 300;
			slider3.displayInput = false;

			var slider4 : HSlider = new HSlider( new DefaultBoundedRangeModel( 40 ) );
			slider4.displayTicks = true;
			slider4.snapToTicks = true;
			slider4.preComponent = new Label( "min" );
			slider4.postComponent = new Label( "max" );
			slider4.preferredWidth = 300;

			var slider5 : HSlider = new HSlider( new DefaultBoundedRangeModel( 50 ) );
			slider5.preComponent = new Label( "min" );
			slider5.postComponent = new Label( "max" );
			slider5.displayInput = false;
			slider5.enabled = false;

			p.addComponent( slider1 );
			p.addComponent( slider2 );
			p.addComponent( slider4 );
			p.addComponent( slider3 );
			p.addComponent( slider5 );

			return p;
		}
		private function createVerticalSliderPanel() : Panel
		{
			var p : Panel = createInlineFieldSet( "Vertical Sliders", Directions.LEFT_TO_RIGHT, Alignments.LEFT, Alignments.TOP);

			var slider1 : VSlider = new VSlider( new DefaultBoundedRangeModel( 20 ) );

			var slider2 : VSlider = new VSlider( new DefaultBoundedRangeModel( 30, 0, 50 ), 10, 2 );
			slider2.displayTicks = true;
			slider2.snapToTicks = true;
			slider2.preComponent = new Label( "min" );
			slider2.postComponent = new Label( "max" );

			var slider3 : VSlider = new VSlider( new DefaultBoundedRangeModel( 50 ) );
			slider3.displayTicks = true;
			slider3.displayInput = false;
			slider3.snapToTicks = true;
			slider3.preComponent = new Label( "min" );
			slider3.postComponent = new Label( "max" );			slider3.enabled = false;

			p.addComponent( slider1 );
			p.addComponent( slider2 );
			p.addComponent( slider3 );

			return p;
		}
		private function createSpinnerTab () : Tab
		{
			var p : Panel = createInlinePanel( Directions.TOP_TO_BOTTOM, Alignments.LEFT, Alignments.TOP, true );
			p.style.setForAllStates( "insets", new Insets(5,0,5,0) );

			var p1 : FieldSet = createInlineFieldSet( "Number Model", Directions.TOP_TO_BOTTOM );			var p2 : FieldSet = createInlineFieldSet( "List Model", Directions.TOP_TO_BOTTOM );			var p3 : FieldSet = createInlineFieldSet( "Date Model", Directions.TOP_TO_BOTTOM );			var p4 : FieldSet = createInlineFieldSet( "DoubleSpinner", Directions.TOP_TO_BOTTOM );			var p5 : FieldSet = createInlineFieldSet( "QuadSpinner", Directions.TOP_TO_BOTTOM );

			var spinner1 : Spinner = new Spinner( new SpinnerNumberModel( 1 ) );

			var spinner2 : Spinner = new Spinner( new SpinnerNumberModel( 5, 0, 10, 1, true ) );
			spinner2.enabled = false;

			var spinner3 : Spinner = new Spinner( new SpinnerListModel( "Item 1 ",
																		"Item 2",
																		"Item 3 with a longer text",
																		"Item 4",
																		"Item 5" ) );
			spinner3.preferredSize = new Dimension( 150, 50 );

			var spinner4 : Spinner = new Spinner( new SpinnerListModel( "Item 1 ",
																		"Item 2",
																		"Item 3 with a longer text",
																		"Item 4",
																		"Item 5" ) );
			spinner4.model.value = "Item 3";
			spinner4.enabled = false;

			var sdm : SpinnerDateModel = new SpinnerDateModel();
			sdm.formatFunction = function ( d : Date ) : String
			{
				return DateUtils.format( d, "F Y, l \\t\\h\\e jS" );
			};

			var spinner5 : Spinner = new Spinner( sdm );
			var tf : TextFormat = new TextFormat( "Verdana", 11 );
			tf.align = "left";
			spinner5.input.style.setForAllStates( "format" , tf );
			spinner5.allowInput = false;
			spinner5.preferredWidth = 250;

			var d1 : Dimension = new Dimension(120,85);			var d2 : Dimension = new Dimension(210,123);

			var i1 : Insets = new Insets(4,5);			var i2 : Insets = new Insets(0,1,2,3);

			var ds1 : DoubleSpinner = new DoubleSpinner(d1,"width","height", 0, uint.MAX_VALUE, 1, true);			var ds2 : DoubleSpinner = new DoubleSpinner(d2,"width","height", 0, uint.MAX_VALUE, 1, true);
			ds2.enabled = false;

			var qs1 : QuadSpinner = new QuadSpinner( i1, "top", "bottom", "left", "right", 0, uint.MAX_VALUE, 1, true );			var qs2 : QuadSpinner = new QuadSpinner( i2, "top", "bottom", "left", "right", 0, uint.MAX_VALUE, 1, true );
			qs2.enabled = false;

			p1.addComponent( spinner1 );
			p1.addComponent( spinner2 );
			p2.addComponent( spinner3 );
			p2.addComponent( spinner4 );
			p3.addComponent( spinner5 );			p4.addComponent( ds1 );			p4.addComponent( ds2 );			p5.addComponent( qs1 );			p5.addComponent( qs2 );

			p.addComponent(p1);			p.addComponent(p2);			p.addComponent(p3);			p.addComponent(p4);			p.addComponent(p5);

			var tab : SimpleTab = new SimpleTab( "Spinners", p );
			return tab;
		}

		private function createTextTab () : Tab
		{
			var p : Panel = createInlinePanel( Directions.TOP_TO_BOTTOM, Alignments.LEFT, Alignments.TOP, true );
			p.style.setForAllStates("insets", new Insets(5,0,5,0));

			var p2 : Panel = createInlineFieldSet( "Label & TextInput", Directions.TOP_TO_BOTTOM, Alignments.LEFT, Alignments.TOP );

			p2.addComponent( createTextInputPanel( "Login : ", 	  "abe" ) );			p2.addComponent( createTextInputPanel( "Password : ", "abe", true, true ) );			p2.addComponent( createTextInputPanel( "Disabled : ", "disabled", false ) );

			p.addComponent( p2 );			p.addComponent( createTextAreaPanel() );			p.addComponent( createAutoCompletionInputPanel() );			p.addComponent( createSpellCheckPanel() );

			var tab : SimpleTab = new SimpleTab( "Text", p );
			return tab;
		}
		private function createTextInputPanel ( label : String = "Label", value : String = "", enabled : Boolean = true, password : Boolean = false, lw : Number = 100 ) : Panel
		{
 			var p : Panel = createInlinePanel();
			var t : TextInput = new TextInput( 20, password );
			var l : Label = new Label( label, t );
			l.preferredWidth = 100;
			t.enabled = enabled;
			t.value = value;			l.enabled = enabled;
			p.addComponent( l );			p.addComponent( t );

			return p;
		}
		private function createTextAreaPanel () : Panel
		{
			var p : Panel = createInlineFieldSet( "TextAreas" );
			var t1 : TextArea = new TextArea();
			var t2 : TextArea = new TextArea();

			p.addComponent( t1 );
			p.addComponent( t2 );
			t1.preferredSize = new Dimension( 150, 70 );

			t2.value = "disabled";
			t2.preferredSize = new Dimension( 150, 70 );
			t2.enabled = false;
			return p;
		}

		private function createSpellCheckPanel() : Panel
		{
			var p : Panel = createInlineFieldSet( "Spell Check" );

			var t : TextArea = new TextArea();
			t.preferredSize = new Dimension( 150, 70 );
			t.value = "thiis is a wrongly spelled word in TextArea, use context menu to see suggestions.\n\n\n\n<font size='20'>A big text</font>\n<u>miiispelled</u> waurd.";

			/*FDT_IGNORE*/ FEATURES::SPELLING { /*FDT_IGNORE*/
			t.spellCheckerId = "usa.zwl";
			t.spellCheckEnabled = true;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			p.addComponent( t );

			return p;
		}

		private function createAutoCompletionInputPanel () : Panel
		{
			var p : Panel = createInlineFieldSet( "Autocompletion & Input Memory" );

			var input1 : TextInput = new TextInput();
			var input2 : TextInput = new TextInput();

			/*FDT_IGNORE*/ FEATURES::AUTOCOMPLETION { /*FDT_IGNORE*/
			var c1 : AutoCompletion = new AutoCompletion( input1 );
			c1.collection = [ "Abe", "Fred", "Gate", "Mel", "Mounir",
							 "Marie", "Maria", "Marius", "Marcel", "Martine", "Marco", "Marcus", "Marion", "Marbella", "Maurice" ];
			c1.charactersCountBeforeSuggest = 1;
			input1.autoComplete = c1;

			var c2 : InputMemory = new InputMemory( input2, "demo", true );
			c2.charactersCountBeforeSuggest = 1;
			var bt : Button = new Button( new ProxyAction( c2.registerCurrent, "Register Current" ) );
			input2.autoComplete = c2;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			p.addComponent( input1 );
			p.addComponent( input2 );

			/*FDT_IGNORE*/ FEATURES::AUTOCOMPLETION { /*FDT_IGNORE*/
			p.addComponent( bt );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			return p;
		}
		private function createButtonTab () : Tab
		{
			var p : Panel = createInlinePanel( Directions.TOP_TO_BOTTOM, Alignments.LEFT, Alignments.TOP, true );
			//( p.childrenLayout as InlineLayout ).spacing = 0;
			p.style.setForAllStates( "insets" , new Insets (5,0) );

			p.addComponent( createButtonPanel() );			p.addComponent( createToggleButtonPanel() );			p.addComponent( createRadioButtonPanel() );			p.addComponent( createCheckBoxPanel() );			p.addComponent( createColorPickerPanel() );			p.addComponent( createGradientPickerPanel() );			p.addComponent( createCalendarActionPanel() );

			var tab : SimpleTab = new SimpleTab( "Buttons", p );
			return tab;
		}

		protected function createCalendarActionPanel () : Panel
		{
			var p : Panel = createInlineFieldSet( _Bb("Calendar Action"), "topToBottom" );

			var ca1 : CalendarAction = new CalendarAction(new Date(), "d/m/Y", magicIconBuild(CALENDAR));			var ca2 : CalendarAction = new CalendarAction(new Date(1956,4,22), "Y M d", magicIconBuild(CALENDAR));
			var b1 : Button = new Button(ca1);			var b2 : Button = new Button(ca2);
			b2.enabled = false;

			p.addComponent(b1);			p.addComponent(b2);

			return p;
		}

		private function createButtonPanel () : Panel
		{
			var p : Panel = createInlineFieldSet(  _Bb( "Buttons") );

			var bt1 : Button = new Button( new AbstractAction(  _Bb( "Button" ), new EmbeddedBitmapIcon( add ), "Button with display mode to <b>ButtonDisplayModes.TEXT_AND_ICON</b>." ) );
			var bt2 : Button = new Button( new AbstractAction( "<b>Button</b>", new EmbeddedBitmapIcon( add ), "Disabled Button with display mode to <b>ButtonDisplayModes.TEXT_ONLY</b>." ) );
			bt2.buttonDisplayMode = ButtonDisplayModes.TEXT_ONLY;
			bt2.enabled = false;

			var bt3 : Button = new Button( new AbstractAction( "Button", new EmbeddedBitmapIcon( add ), "Disabled Button with display mode to <b>ButtonDisplayModes.ICON_ONLY</b>." ) );
			bt3.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			bt3.enabled = false;

			p.addComponent( bt1 );			p.addComponent( bt2 );			p.addComponent( bt3 );
			return p;
		}

		protected function _Bb (string : String) : String
		{
			return StringUtils.smartCapitalize(string,"<b>$0</b>");
		}
		protected function _Ii (string : String) : String
		{
			return StringUtils.smartCapitalize(string,"<i>$0</i>");
		}
		private function createToggleButtonPanel () : Panel
		{
			var p : Panel = createInlineFieldSet( _Bb("Toggle Buttons") );

			var tbt1 : ToggleButton = new ToggleButton( new AbstractAction( "Button 1", magicIconBuild(add), "Short description") );
			var tbt2 : ToggleButton = new ToggleButton( new AbstractAction( "", magicIconBuild(add)) );
			var tbt3 : ToggleButton = new ToggleButton( new AbstractAction( _Bb("Button 3") ) );
			tbt3.enabled = false;
			var btg1 : ButtonGroup = new ButtonGroup();
			btg1.add( tbt1 );
			btg1.add( tbt2 );
			btg1.add( tbt3 );
			tbt3.selected = true;
			groups.push(btg1);

			p.addComponent( tbt1 );
			p.addComponent( tbt2 );
			p.addComponent( tbt3 );

			return p;
		}
		private function createRadioButtonPanel () : Panel
		{
			var p : Panel = createInlineFieldSet( _Bb("Radio Buttons") );

			var rbt1 : RadioButton = new RadioButton( new AbstractAction( "Radio 1", magicIconBuild(add)) );
			var rbt2 : RadioButton = new RadioButton( new AbstractAction( "", magicIconBuild(add)) );
			var rbt3 : RadioButton = new RadioButton( new AbstractAction( _Ii( "Radio 3" ) ) );			var rbt4 : RadioButton = new RadioButton( new AbstractAction( "") );
			rbt3.enabled = false;
			var btg2 : ButtonGroup = new ButtonGroup();
			btg2.add( rbt1 );
			btg2.add( rbt2 );
			btg2.add( rbt3 );			btg2.add( rbt4 );
			rbt3.selected = true;
			groups.push(btg2);
			p.addComponent( rbt1 );
			p.addComponent( rbt2 );
			p.addComponent( rbt3 );			p.addComponent( rbt4 );

			return p;
		}
		private function createCheckBoxPanel () : Panel
		{
			var p : Panel = createInlineFieldSet( _Bb( "CheckBoxes" ) );

			var cbt1 : CheckBox = new CheckBox("Checkbox 1",magicIconBuild(add));
			var cbt2 : CheckBox = new CheckBox("",magicIconBuild(add));			var cbt3 : CheckBox = new CheckBox("Checkbox 3");			var cbt4 : CheckBox = new CheckBox("");
			cbt3.enabled = false;
			cbt3.selected = true;

			p.addComponent( cbt1 );
			p.addComponent( cbt2 );			p.addComponent( cbt3 );			p.addComponent( cbt4 );

			return p;
		}
		private function createColorPickerPanel () : Panel
		{
			var p : Panel = createInlineFieldSet( _Bb("Edit Color Action"), "topToBottom" );

			var cbt1 : ColorPicker = new ColorPicker( Color.YellowGreen.alphaClone(0x66) );
			var cbt2 : ColorPicker = new ColorPicker( Color.Green );
			cbt2.enabled = false;
			cbt1.preferredWidth = cbt2.preferredWidth = 100;
			p.addComponent( cbt1 );
			p.addComponent( cbt2 );

			return p;
		}
		private function createGradientPickerPanel () : Panel
		{
			var p : Panel = createInlineFieldSet( _Bb("Edit Gradient Action"), "topToBottom" );

			var cbt1 : GradientPicker = new GradientPicker( new Gradient([Color.CornflowerBlue, Color.Navy, Color.LightCyan.alphaClone(0x66)],[0,.25,1]) );
			var cbt2 : GradientPicker = new GradientPicker( new Gradient([Color.CornflowerBlue, Color.Navy, Color.LightCyan.alphaClone(0x66)],[0,.25,1]) );
			cbt2.enabled = false;

			cbt1.preferredWidth = cbt2.preferredWidth = 100;

			p.addComponent( cbt1 );
			p.addComponent( cbt2 );

			return p;
		}
		private function createMenuBar () : SlidePane
		{
			var menubar : MenuBar = new MenuBar();
			var menu1 : Menu = new Menu( "File", new EmbeddedBitmapIcon( add ) );
			menu1.mnemonic = KeyStroke.getKeyStroke( Keys.F );
			var menu2 : Menu = new Menu( "SubMenus" );
			menu2.mnemonic = KeyStroke.getKeyStroke( Keys.B );
			var menu3 : Menu = new Menu( "Edit" );
			menu3.mnemonic = KeyStroke.getKeyStroke( Keys.E );
			menu1.addMenuItem( new MenuItem( new AbstractAction( "Drag me", new EmbeddedBitmapIcon( add ) ) ) );
			var dm : MenuItem = new MenuItem( new AbstractAction( "Disabled menu", new EmbeddedBitmapIcon( add ) ) );
			var menu4 : Menu = new Menu( "A menu" );			var menu5 : Menu = new Menu( "Another menu" );			var menu6 : Menu = new Menu( "Foo" );			var menu7 : Menu = new Menu( "Nothing" );			var menu8 : Menu = new Menu( "Really Nothing" );			var menu9 : Menu = new Menu( "Anything" );			var menu10 : Menu = new Menu( "Help" );
			dm.enabled = false;			menu1.addMenuItem( dm );

			var cmenu : CheckBoxMenuItem = new CheckBoxMenuItem( "CheckBox Menu" );
			cmenu.mnemonic = KeyStroke.getKeyStroke( Keys.C );
			menu1.addMenuItem( new MenuSeparator() );
			menu1.addMenuItem( cmenu );
			menu1.addMenuItem( new MenuSeparator() );

			var bg : ButtonGroup = new ButtonGroup();
			var rmenu1 : RadioMenuItem = new RadioMenuItem( "Radio Menu 1" );
			var rmenu2 : RadioMenuItem = new RadioMenuItem( "Radio Menu 2" );
			var rmenu3 : RadioMenuItem = new RadioMenuItem( "Radio Menu 3" );
			groups.push(bg);
			bg.add( rmenu1 );
			bg.add( rmenu2 );
			bg.add( rmenu3 );
			rmenu1.selected = true;

			menu1.addMenuItem(rmenu1 );
			menu1.addMenuItem(rmenu2 );
			menu1.addMenuItem(rmenu3 );

			menu1.addMenuItem( new MenuSeparator() );
			menu1.addMenuItem( menu2 );

			menu2.addMenuItem( new MenuItem( new AbstractAction( "A long menu label" ) ) );
			menu2.addMenuItem( new MenuItem() );
			menu2.addMenuItem( new MenuItem() );
			menu2.addMenuItem( new MenuItem() );

			menu3.addMenuItem( new MenuItem( ActionManagerInstance.getAction("undo") ) );			menu3.addMenuItem( new MenuItem( ActionManagerInstance.getAction("redo") ) );
			menu3.addMenuItem( new MenuItem( new AbstractAction( "Copy" ) ) );
			menu3.addMenuItem( new MenuItem( new AbstractAction( "Cut" ) ) );
			menu3.addMenuItem( new MenuItem( new AbstractAction( "Paste" ) ) );

			menubar.addMenu( menu1 );
			menubar.addMenu( menu3 );			menubar.addMenu( menu4 );			menubar.addMenu( menu5 );			menubar.addMenu( menu6 );			menubar.addMenu( menu7 );			menubar.addMenu( menu8 );			menubar.addMenu( menu9 );			menubar.addMenu( menu10 );
			menubar.preferredWidth = 550;

			var sp : SlidePane = new SlidePane();
			sp.styleKey = "EmptyComponent";			sp.viewport.styleKey = "EmptyComponent";
			sp.view = menubar;

			return sp;
		}

		private function createInlinePanel ( dir : String = "leftToRight", halign : String = "left", valign : String = "center", fixedSize : Boolean = false  ) : Panel
		{
			var p : Panel = new Panel();
			p.childrenLayout = new InlineLayout( p, 5, halign, valign, dir, fixedSize, true );
			return p;
		}
		private function createGridPanel ( row : int = 1, col : int = 3  ) : Panel
		{
			var p : Panel = new Panel();
			p.childrenLayout = new GridLayout( p,row, col, 5, 5 );
			return p;
		}
		private function createBorderPanel () : Panel
		{
			var p : Panel = new Panel();
			p.childrenLayout = new BorderLayout( p );
			return p;
		}
		private function createInlineFieldSet ( label : String = null, dir : String = "leftToRight", halign : String = "left", valign : String = "center"  ) : FieldSet
		{
			var p : FieldSet = new FieldSet( label );
			p.childrenLayout = new InlineLayout( p, 5, halign, valign, dir, false );
			return p;
		}
		private function createToolBar( displayMode : uint, enabled : Boolean = true, o : String = 'leftToRight' ) : SlidePane
		{
			var toolbar : ToolBar = new ToolBar( displayMode );
			toolbar.direction = o;

			var button1 : DraggableButton = new DraggableButton( new AbstractAction( "Drag me", new EmbeddedBitmapIcon( add ) ) );
			var button2 : DraggableButton = new DraggableButton( new AbstractAction( "Drag me" ) );
			var button3 : DraggableButton = new DraggableButton( new AbstractAction( "", new EmbeddedBitmapIcon( add ) ) );

			toolbar.addComponent( button1 );
			toolbar.addComponent( button2 );
			toolbar.addSeparator();			toolbar.addComponent( button3 );
			toolbar.addComponent( new CheckBox( "CheckBox", magicIconBuild( add )) );			toolbar.addSeparator();
			var bg : ButtonGroup = new ButtonGroup();
			var rb : RadioButton;
			rb = new RadioButton( "Radio 1", magicIconBuild( add ));			bg.add( rb );			toolbar.addComponent( rb );

			rb = new RadioButton( "Radio 2" );
			bg.add( rb );			toolbar.addComponent( rb );

			rb = new RadioButton( "", magicIconBuild( add ));
			bg.add( rb );
			toolbar.addComponent( rb );

			groups.push(bg);

			toolbar.addSeparator();			toolbar.addComponent( new DropDownMenu( "DropDownMenu", magicIconBuild( add ),														new MenuItem( "Menu 1", magicIconBuild( add ) ),
														new MenuItem( "Menu 2" ),														new MenuItem( "Menu 3" )												  ) );
			toolbar.addSeparator();
			var c : ComboBox = new ComboBox( "Item 1", "Item 2", "Item 3", "Item 4" );
			c.icon = magicIconBuild( add );
			toolbar.addComponent( c );

			toolbar.enabled = enabled;

			var sp : SlidePane = new SlidePane();
			sp.styleKey = "EmptyComponent";			sp.viewport.styleKey = "EmptyComponent";
			sp.view = toolbar;

			return sp;
		}
		protected function createSplitPane ( dir : uint,
											 weight : Number = .5,
											 dividerLoc : Number = NaN,
											 enabled : Boolean = true ) : SplitPane
		{
			var bt : Button = new Button();
			var txt : TextArea = new TextArea();

			var splitPane : SplitPane = new SplitPane( dir, bt, txt );

			splitPane.resizeWeight = weight;
			splitPane.enabled = enabled;

			if( !isNaN( dividerLoc ) )
				splitPane.dividerLocation = dividerLoc;

			return splitPane;
		}
		protected function createTabbedPane2( pos : String,
											  enabled : Boolean,
											  dragEnabled : Boolean = true,
											  closable : Boolean = false ) : TabbedPane
		{
			var tabbedPane : TabbedPane = new TabbedPane ( pos );

			var tabClass : Class = closable ? ClosableTab : SimpleTab;

			var txt : TextArea = new TextArea();
			var tab1 : Tab = new tabClass( "Tab 1", txt );

			var bt : Button = new Button();
			var tab2 : Tab = new tabClass( "Tab 2", bt, magicIconBuild( add ) );

			var bt2 : Button = new Button();
			var scp : ScrollPane = new ScrollPane();
			scp.viewport.view = bt2;
			bt2.preferredSize = new Dimension(250,250);
			var tab3 : Tab = new tabClass( "Tab 3", scp );

			var tab4 : Tab = new tabClass( "Tab 4" );

			tabbedPane.addTab( tab1 );
			tabbedPane.addTab( tab2 );
			tabbedPane.addTab( tab3 );
			tabbedPane.addTab( tab4 );

			if( closable )
				tabbedPane.addEventListener( ComponentEvent.CLOSE, function ( e : Event ) : void {
					Log.debug( e.target + " was closed" );
			} );

			tabbedPane.enabled = enabled;
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
				tabbedPane.dndEnabled = dragEnabled;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			return tabbedPane;
		}
	}
}

import aesia.com.edia.text.AdvancedTextField;
import aesia.com.edia.text.builds.BasicBuild;
import aesia.com.edia.text.layouts.BasicLayout;
import aesia.com.mands.AbstractCommand;
import aesia.com.mands.IterationCommand;
import aesia.com.mands.events.IterationEvent;
import aesia.com.mon.core.Iterator;
import aesia.com.mon.logs.Log;
import aesia.com.mon.utils.Color;
import aesia.com.mon.utils.Gradient;
import aesia.com.mon.utils.KeyStroke;
import aesia.com.patibility.lang._$;
import aesia.com.ponents.actions.AbstractAction;
import aesia.com.ponents.actions.Action;
import aesia.com.ponents.buttons.Button;
import aesia.com.ponents.menus.MenuItem;
import aesia.com.ponents.monitors.Terminal;
import aesia.com.ponents.skinning.SkinManagerInstance;
import aesia.com.ponents.skinning.icons.Icon;
import aesia.com.ponents.text.AbstractTextComponent;

import flash.events.Event;
import flash.text.TextFormat;

internal class FontMenuItem extends MenuItem
{
	public function FontMenuItem ( action : Action = null )
	{
		//Log.debug( 'in FontMenuItem constructor' );
		super(action);
		cacheAsBitmap= true;
		var tf : TextFormat = new TextFormat();
		tf.tabStops = [ 170 ];
		style.setForAllStates( "format" , tf );

		_labelTextField.defaultTextFormat = style.format;
		_labelTextField.textColor = style.textColor.hexa;
		updateLabelText();

		//Log.debug( _label.defaultTextFormat.tabStops );
	}
}
internal class LogAction extends AbstractAction
{
	protected var _level : String;
	protected var _input : AbstractTextComponent;
	public function LogAction ( name : String = "", level : String = "debug", input : AbstractTextComponent = null, icon : Icon = null, longDescription : String = null, accelerator : KeyStroke = null )
	{
		super(name,icon,longDescription,accelerator );
		_level = level;
		_input = input;
	}

	override public function execute (e : Event = null) : void
	{
		Log[_level]( _input.value );
		_input.value = "";
	}
}


internal class Iteration extends AbstractCommand implements IterationCommand
{
	protected var _iterator : Iterator;
	protected var _terminal : Terminal;

	public function Iteration ( i : Iterator, t : Terminal )
	{
		_iterator = i;
		_terminal = t;
	}

	override public function execute(e : Event = null ) : void
	{
		_terminal.echo( ( e as IterationEvent ).iteration + " : " + ( e as IterationEvent ).value );
	}
	public function iterator() : Iterator
	{
		return _iterator;
	}
}

internal class User
{
	public function User()
	{
		this.name = "Smith";
		this.firstName = "John";
		this.birthdate = new Date(1920,11,02);
		this.married = true;
		this.sex = "male";
		this.weight = 82.4;
		this.size = 1.73;
		this.password = "foo";
		this.login = "jnsm";

		this.preferredColor = Color.YellowGreen.alphaClone(0x88);
		this.gradient = new Gradient([ Color.OrangeRed.alphaClone(0x66),
									   Color.Bisque,
									   Color.Red.alphaClone(0x33)
									 ],
									 [0,.25,1]
									);

	}

	[Form(type="string",
				 category="Civil Identities",
				 categoryOrder="2",
				 order="1")]
	public var name : String;

	[Form(type="string",
				 label="first name",
				 category="Civil Identities",
				 order="0")]
	public var firstName : String;

	[Form(type="dateCalendar",
				 category="Civil Identities",
				 order="2")]
	public var birthdate : Date;

	[Form(type="string",
				 category="Civil Identities",
				 order="3")]
	public function get age () : int
	{
		return (new Date()).getFullYear() - birthdate.getFullYear();
	}

	[Form(type="string",
				 length="20",
				 category="Identifiers",
				 categoryOrder="1",
				 order="0")]
	public var login : String;

	[Form(type="password",
				 length="20",
				 category="Identifiers",
				 order="1")]
	public var password : String;

	[Form(type="floatSlider",
				 range="0,500",
				 category="Physical Details")]
	public var weight : Number;

	[Form(type="floatSlider",
				 range="0,3",
				 step="0.1",
				 category="Physical Details")]
	public var size : Number;

	[Form(type="color",
				 label="preferred color",
				 defaultValue="color(0xff000000)",
				 enumeration="color(0xffff0000),color(0xff00ff00),color(0xff0000ff)",
				 order="0")]
	public var preferredColor : Color;

	[Form(type="gradient",
			     order="1",
			     defaultValue="gradient([color(0xff000000),color(0xffffffff)], [0,1])")]
	public var gradient : Gradient;

	[Form(type="string",
				 defaultValue="male",
				 enumeration="male,female,no gender",
				 category="Civil Identities",
				 order="5")]
	public var sex : String;

	[Form(category="Civil Identities",
				 order="4")]
	public var married : Boolean;

	[Form(order="2",type="text", defaultValue="")]
	public var description : String;
}
[Skinable(skin="AdvancedButton")]
[Skin( 	define="AdvancedButton",
	 	inherit="Button",

	 	state__all__custom_textFx="$0")]
internal class AdvancedButton extends Button
{
	public function AdvancedButton (actionOrLabel : * = null, icon : Icon = null)
	{
		_style = SkinManagerInstance.getComponentStyle(this);
		var l : AdvancedTextField = new AdvancedTextField( new BasicBuild(_style.format,false,_style.embedFonts), new BasicLayout() );
		_labelTextField = l;
		l.allowMask = false;
		super( actionOrLabel, icon );
		allowMask = false;
		invalidatePreferredSizeCache( );
	}
	override protected function updateLabelText () : void
	{
		var valueNotEmpty : Boolean = isEmpty();

		_labelTextField.defaultTextFormat = _style.format;
		_labelTextField.textColor = _style.textColor.hexa;
		if( _labelTextField && valueNotEmpty )
		{
			if( _removeLabelOnEmptyString )
				_labelTextField.htmlText = _$( _style.textFx, String(_label) );
			else
				// even if the value is an empty string we display a space in order to have a correct height for the textfield
				_labelTextField.htmlText = _$( _style.textFx, String(_label) ) != "" ? _$( _style.textFx, String(_label) ) : " ";
		}
	}
}

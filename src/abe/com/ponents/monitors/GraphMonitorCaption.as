package abe.com.ponents.monitors
{
	import abe.com.mon.core.Suspendable;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;
	import abe.com.motion.ImpulseListener;
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.patibility.settings.SettingsManagerInstance;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.events.MonitorEvent;
	import abe.com.ponents.layouts.components.ComponentLayout;
	import abe.com.ponents.layouts.components.FlowLayout;
	import abe.com.ponents.layouts.components.GridLayout;
	import abe.com.ponents.monitors.recorders.Recorder;
	import abe.com.ponents.skinning.icons.ColorIcon;
	import abe.com.ponents.text.CaptionLabel;
	import abe.com.ponents.utils.ContextMenuItemUtils;

	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenuItem;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="GraphMonitorCaption")]
	[Skin(define="GraphMonitorCaption",
		  inherit="EmptyComponent",

		  state__all__insets="new cutils::Insets(3)"
	)]
	public class GraphMonitorCaption extends Panel implements Suspendable, ImpulseListener
	{
		static public const LONG_LABEL_MODE : uint = 0;
		static public const SHORT_LABEL_MODE : uint = 1;

		static public const FLOW_LAYOUT_MODE : uint = 0;		static public const COLUMN_1_LAYOUT_MODE : uint = 1;		static public const COLUMN_2_LAYOUT_MODE : uint = 2;		static public const COLUMN_3_LAYOUT_MODE : uint = 3;		static public const COLUMN_4_LAYOUT_MODE : uint = 4;		static public const COLUMN_5_LAYOUT_MODE : uint = 5;

		protected var _captionMode : int = -1;		protected var _layoutMode : int = -1;

		protected var _monitor : GraphMonitor;
		protected var _playing : Boolean;
		
		/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
		protected var _settingsLoaded : Boolean = false;
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		public function GraphMonitorCaption ( monitor : GraphMonitor, captionMode : uint = 0, layoutMode : uint = 0 )
		{
			super();
			_monitor = monitor;
			_captionMode = captionMode;
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { var rcd : Array = _monitor.recorders; }
			TARGET::FLASH_10 { var rcd : Vector.<Recorder> = _monitor.recorders; }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			var rcd : Vector.<Recorder> = _monitor.recorders; /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			var l : uint = rcd.length;

			for( var i : uint = 0; i<l;i++ )
			{
				var rec : Recorder = rcd[i];
				var cl : CaptionLabel = new CaptionLabel( formatLabel( rec ), new ColorIcon( rec.curveSettings.color ) ) ;
				cl.tooltip = rec.curveSettings.name;
				addComponent( cl );
			}
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
				createContextMenuItems();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			this.layoutMode = layoutMode;
			mouseChildren = false;
			start();
			
			registerToMonitorEvents( _monitor );
		}
		public function get captionMode () : uint { return _captionMode; }
		public function set captionMode (captionMode : uint) : void
		{
			_captionMode = captionMode;

			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
				setContextMenuItemCaption( "captionMode", getContextMenuItemCaption (_captionMode) );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
			if( id )
				SettingsManagerInstance.set( this, "captionMode", _captionMode );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			invalidatePreferredSizeCache();
		}
		public function get layoutMode () : uint { return _layoutMode; }
		public function set layoutMode ( layoutMode : uint ) : void
		{
			if( _layoutMode == layoutMode )
				return;

			_layoutMode = layoutMode;

			for each ( var c : Component in _children )
				c.size = null;

			switch( _layoutMode )
			{
				case COLUMN_1_LAYOUT_MODE :
					childrenLayout = getGridLayout( 1 );
					break;
				case COLUMN_2_LAYOUT_MODE :
					childrenLayout = getGridLayout( 2 );
					break;
				case COLUMN_3_LAYOUT_MODE :
					childrenLayout = getGridLayout( 3 );
					break;
				case COLUMN_4_LAYOUT_MODE :
					childrenLayout = getGridLayout( 4 );
					break;
				case COLUMN_5_LAYOUT_MODE :
					childrenLayout = getGridLayout( 5 );
					break;
				case FLOW_LAYOUT_MODE :
				default :
					childrenLayout = new FlowLayout( this, 3, 3 );
			}
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
				updateLayoutCaptions();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
			if( id )
				SettingsManagerInstance.set( this, "layoutMode", _layoutMode );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			invalidatePreferredSizeCache();
		}
		/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
		override public function set id (id : String) : void 
		{
			super.id = id;
			if( id && !_settingsLoaded )
			{
				captionMode = SettingsManagerInstance.get(this, "captionMode", _captionMode );
				layoutMode = SettingsManagerInstance.get(this, "layoutMode", _layoutMode );
				_settingsLoaded = true;
			}
		}
		override public function repaint () : void
		{
			if( id && !_settingsLoaded )
			{
				captionMode = SettingsManagerInstance.get(this, "captionMode", _captionMode );				layoutMode = SettingsManagerInstance.get(this, "layoutMode", _layoutMode );
				_settingsLoaded = true;
				tick(null);
			}
			super.repaint();
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		protected function getGridLayout ( col : int) : ComponentLayout
		{
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { var rcd : Array = _monitor.recorders; }
			TARGET::FLASH_10 { var rcd : Vector.<Recorder> = _monitor.recorders; }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			var rcd : Vector.<Recorder> = _monitor.recorders; /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			var l : uint = rcd.length;
			var rest : uint = l%col;
			var r : uint = (l-rest)/col;

			if( rest )
				r++;

			return new GridLayout(this,r,col,3,3);
		}

		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
		protected var _cmis : Array;

		protected function switchCaptionMode (event : ContextMenuEvent) : void
		{
			if( _captionMode == LONG_LABEL_MODE )
				captionMode = SHORT_LABEL_MODE;
			else
				captionMode = LONG_LABEL_MODE;
		}
		protected function switchLayoutMode (event : ContextMenuEvent) : void
		{
			var i : uint = _cmis.indexOf( event.target );
			layoutMode = i;
		}
		protected function getContextMenuItemCaption (captionMode : uint) : String
		{
			var s : String;

			switch( captionMode )
			{
				case SHORT_LABEL_MODE :
					s = _("Long caption label");
					break;
				case LONG_LABEL_MODE :
				default :
					s = _("Short caption label");
					break;
			}

			return s;
		}
		protected function createContextMenuItems () : void
		{
			_cmis = [];

			addNewContextMenuItemForGroup( getContextMenuItemCaption(_captionMode), "captionMode", switchCaptionMode, "captionModes" );

			var c : ContextMenuItem;

			_cmis.push( addNewContextMenuItemForGroup( ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Flow layout"), isLayoutModeSelected( 0 ) ),
									   "flowLayout", switchLayoutMode, "layoutModes" ) );

			_cmis.push( addNewContextMenuItemForGroup( ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("1 column layout"), isLayoutModeSelected( 1 ) ),
									   "1columnLayout", switchLayoutMode, "layoutModes" ) );

			_cmis.push( addNewContextMenuItemForGroup( ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("2 column layout"), isLayoutModeSelected( 2 ) ),
									   "2columnLayout", switchLayoutMode, "layoutModes" ) );

			_cmis.push( addNewContextMenuItemForGroup( ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("3 column layout"), isLayoutModeSelected( 3 ) ),
									   "3columnLayout", switchLayoutMode, "layoutModes" ) );

			_cmis.push( addNewContextMenuItemForGroup( ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("4 column layout"), isLayoutModeSelected( 4 ) ),
									   "4columnLayout", switchLayoutMode, "layoutModes" ) );

			_cmis.push( addNewContextMenuItemForGroup( ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("5 column layout"), isLayoutModeSelected( 5 ) ),
									   "5columnLayout", switchLayoutMode, "layoutModes" ) );
		}		protected function updateLayoutCaptions () : void
		{
			_cmis[ 0 ].caption = ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Flow layout"),  	 isLayoutModeSelected( 0 ) );			_cmis[ 1 ].caption = ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("1 column layout"), isLayoutModeSelected( 1 ) );			_cmis[ 2 ].caption = ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("2 column layout"), isLayoutModeSelected( 2 ) );			_cmis[ 3 ].caption = ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("3 column layout"), isLayoutModeSelected( 3 ) );			_cmis[ 4 ].caption = ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("4 column layout"), isLayoutModeSelected( 4 ) );			_cmis[ 5 ].caption = ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("5 column layout"), isLayoutModeSelected( 5 ) );
		}

		protected function isLayoutModeSelected (i : int) : Boolean
		{
			return i == _layoutMode;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		public function isRunning () : Boolean { return _playing; }
		public function start () : void
		{
			if( !_playing )
			{
				_playing = true;
				if( _displayed )
					Impulse.register(tick);
			}
		}
		public function stop () : void
		{
			if( _playing )
			{
				_playing = false;
				if( _displayed )
					Impulse.unregister(tick);
			}
		}
		override public function addedToStage ( e : Event ) : void
		{
			super.addedToStage(e);
			if( _playing )
				Impulse.register(tick);
		}
		override public function removeFromStage ( e : Event ) : void
		{
			super.removeFromStage(e);
			if( _playing )
				Impulse.unregister(tick );
		}
		protected function registerToMonitorEvents (monitor : GraphMonitor) : void 
		{
			monitor.addEventListener(  MonitorEvent.RECORDER_ADD, recorderAdd );
			monitor.addEventListener(  MonitorEvent.RECORDER_REMOVE, recorderRemove );
		}
		protected function unregisterFromMonitorEvents (monitor : GraphMonitor) : void 
		{
			monitor.removeEventListener(  MonitorEvent.RECORDER_ADD, recorderAdd );
			monitor.removeEventListener(  MonitorEvent.RECORDER_REMOVE, recorderRemove );
		}
		protected function recorderAdd (event : MonitorEvent) : void 
		{
			var rec : Recorder = event.recorder;
			var cl : CaptionLabel = new CaptionLabel( formatLabel( rec ), new ColorIcon( rec.curveSettings.color ) ) ;
			cl.tooltip = rec.curveSettings.name;
			addComponent( cl );
		}
		protected function recorderRemove (event : MonitorEvent) : void 
		{
			var index : uint = _monitor.recorders.indexOf( event.recorder );
			removeComponentAt(index);
		}
		public function tick (e : ImpulseEvent) : void
		{
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { var rcd : Array = _monitor.recorders; }
			TARGET::FLASH_10 { var rcd : Vector.<Recorder> = _monitor.recorders; }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			var rcd : Vector.<Recorder> = _monitor.recorders; /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			var l : uint = rcd.length;
			for( var i : uint = 0; i<l;i++ )
			{
				var rec : Recorder = rcd[i];
				if( i < childrenCount )
					(getComponentAt( i ) as CaptionLabel).value = formatLabel( rec );
			}
		}
		protected function formatLabel( rec : Recorder ) : String
		{
			var s : String;
			switch( _captionMode )
			{
				case SHORT_LABEL_MODE :
					s = _$(_("$0 $1"), rec.currentValue, rec.unit );
					break;
				case LONG_LABEL_MODE :
				default :
					s = _$(_("$0 : $1 $2"), rec.curveSettings.name, rec.currentValue, rec.unit );
					break;
			}
			return s;
		}
	}
}

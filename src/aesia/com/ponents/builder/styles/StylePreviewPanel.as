package aesia.com.ponents.builder.styles 
{
	import aesia.com.ponents.skinning.ComponentStyle;
	import flash.events.Event;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.builder.events.StyleSelectionEvent;
	import aesia.com.ponents.buttons.CheckBox;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.containers.ToolBar;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.layouts.components.BorderLayout;
	import aesia.com.ponents.layouts.components.InlineLayout;
	/**
	 * @author cedric
	 */
	public class StylePreviewPanel extends Panel 
	{
		protected var _previewToolBar : ToolBar;
		protected var _previewEnabled : CheckBox;
		protected var _previewSelected : CheckBox;
		protected var _preview : Panel;
		protected var _component : Component;
		protected var _currentStyle : ComponentStyle;

		public function StylePreviewPanel ()
		{
			super();
			var l : BorderLayout = new BorderLayout( this, true );
			childrenLayout = l;
			
			_preview = new Panel();
			_preview.childrenLayout = new InlineLayout( _preview );
			_preview.preferredSize = new Dimension(100, 75);
			_preview.allowFocus = false;
			_previewToolBar = new ToolBar();

			_previewEnabled = new CheckBox( _("Enabled") );
			_previewEnabled.value = true;
			_previewEnabled.addEventListener( ComponentEvent.DATA_CHANGE, previewEnabledChange );
			_previewSelected = new CheckBox( _("Selected") );
			_previewSelected.addEventListener( ComponentEvent.DATA_CHANGE, previewSelectedChange );
			_previewSelected.enabled = false;

			_previewToolBar.addComponent(_previewEnabled);
			_previewToolBar.addComponent(_previewSelected);

			addComponent(_previewToolBar);
			l.north = _previewToolBar;

			addComponent(_preview);
			l.center = _preview;
			
			invalidatePreferredSizeCache();
		}
		public function get currentStyle () : ComponentStyle { return _currentStyle; }
		public function set currentStyle (currentStyle : ComponentStyle) : void
		{
			if( _currentStyle )
				_currentStyle.removeEventListener(Event.CHANGE, styleChange );
			
			_currentStyle = currentStyle;
			if( _currentStyle )
			{
				var comp : Component = _currentStyle.previewProvider() as Component;
				// prevent style affectation to the preview
				if( _currentStyle.previewAcceptStyleSetup )
					comp.styleKey = _currentStyle.fullStyleName;
				
				componentPreview = comp;
				_currentStyle.addEventListener(Event.CHANGE, styleChange );
			}
			else componentPreview = null;
		}
		public function get componentPreview () : Component { return _component; }
		public function set componentPreview ( c : Component ) : void 
		{
			if( _component )
				_preview.removeComponent( _component );
			
			_component = c;
			
			if( _component )
			{
				_preview.addComponent( _component );
				_component.enabled = _previewEnabled.value;
				
				if( ( _component as Object ).hasOwnProperty( "selected" ) ) 
				{
					_component["selected"] = _previewSelected.value;
					 _previewSelected.enabled = true;
				}
				else
					 _previewSelected.enabled = false;
			}
		}
		
		public function styleSelectionChange ( e : StyleSelectionEvent ) : void
		{
			currentStyle = e.style;
		}
		protected function styleChange (event : Event) : void 
		{
			_preview.invalidatePreferredSizeCache();
		}
		protected function previewSelectedChange (event : ComponentEvent) : void 
		{
			if( _component && ( _component as Object ).hasOwnProperty( "selected" ) ) 
				_component["selected"] = event.target.value;
		}
		protected function previewEnabledChange (event : ComponentEvent) : void 
		{
			if( _component )
				_component.enabled = event.target.value;
		}
	}
}

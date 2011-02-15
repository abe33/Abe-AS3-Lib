package aesia.com.ponents.builder.models 
{
	import aesia.com.ponents.builder.events.StyleSelectionEvent;
	import aesia.com.ponents.skinning.ComponentStyle;
	import aesia.com.ponents.skinning.SkinManagerInstance;

	import flash.events.EventDispatcher;
	/**
	 * @author cedric
	 */
	public class StyleSelectionModel extends EventDispatcher 
	{
		protected var _selectedSkin : Object;
		protected var _selectedStyle : ComponentStyle;
		
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		protected var _selectedStates : Array;
		
		TARGET::FLASH_10
		protected var _selectedStates : Vector.<uint>;
		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		protected var _selectedStates : Vector.<uint>;		
		public function StyleSelectionModel ()
		{
			super( this );
		}
		public function get selectedStyle () : ComponentStyle { return _selectedStyle; }
		public function set selectedStyle (selectedStyle : ComponentStyle) : void
		{
			_selectedStyle = selectedStyle;
			fireSelectStyle( _selectedStyle );
			
			selectedStates = null;
		}
		/*FDT_IGNORE*/
		TARGET::FLASH_9 {
		public function get selectedStates () : Array { return _selectedStates; }
		public function set selectedStates ( o : Array ) : void { _selectedStates = o; fireSelectStates( _selectedStyle, _selectedStates ); }
		}
		TARGET::FLASH_10 {
		public function get selectedStates () : Vector.<uint> { return _selectedStates; }
		public function set selectedStates ( o : Vector.<uint> ) : void { _selectedStates = o; fireSelectStates( _selectedStyle, _selectedStates ); }
		}
		TARGET::FLASH_10_1 { /*FDT_IGNORE*/
		public function get selectedStates () : Vector.<uint> { return _selectedStates; }
		public function set selectedStates ( o : Vector.<uint> ) : void { _selectedStates = o; fireSelectStates( _selectedStyle, _selectedStates ); }
		/*FDT_IGNORE*/}/*FDT_IGNORE*/
		
		public function get selectedSkin () : Object { return _selectedSkin; }
		public function set selectedSkin (selectedSkin : Object) : void
		{
			_selectedSkin = selectedSkin;
			fireSelectSKin( _selectedSkin );
		}
		
		protected function fireSelectSKin ( skin : Object ) : void 
		{
			dispatchEvent( new StyleSelectionEvent( StyleSelectionEvent.SKIN_SELECT, skin ) );
		}
		protected function fireSelectStyle ( style : ComponentStyle ) : void 
		{
			dispatchEvent( new StyleSelectionEvent( StyleSelectionEvent.STYLE_SELECT, style ? SkinManagerInstance.getSkin( style.skinName ) : null, style ) );
		}
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		protected function fireSelectStates ( style : ComponentStyle, states : Array ) : void 
		{
			dispatchEvent( new StyleSelectionEvent( StyleSelectionEvent.STATES_SELECT, style ? SkinManagerInstance.getSkin( style.skinName ) : null, style, states ) );
		}
		TARGET::FLASH_10
		protected function fireSelectStates ( style : ComponentStyle, states : Vector.<uint> ) : void 
		{
			dispatchEvent( new StyleSelectionEvent( StyleSelectionEvent.STATES_SELECT, style ? SkinManagerInstance.getSkin( style.skinName ) : null, style, states ) );
		}
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		protected function fireSelectStates ( style : ComponentStyle, states : Vector.<uint> ) : void 
		{
			dispatchEvent( new StyleSelectionEvent( StyleSelectionEvent.STATES_SELECT, style ? SkinManagerInstance.getSkin( style.skinName ) : null, style, states ) );
		}
	}
}

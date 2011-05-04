package abe.com.ponents.builder.events 
{
	import abe.com.ponents.skinning.ComponentStyle;

	import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class StyleSelectionEvent extends Event 
	{
		static public const SKIN_SELECT : String = "skinSelect";		static public const STYLE_SELECT : String = "styleSelect";		static public const STATES_SELECT : String = "statesSelect";
		
		public var skin : Object;
		public var style : ComponentStyle;
		
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		public var states : Array;
		TARGET::FLASH_10
		public var states : Vector.<uint>;
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		public var states : Vector.<uint>;
		
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		public function StyleSelectionEvent ( type : String, 
											  skin : Object,
											  style : ComponentStyle = null, 
											  states : Array = null, 
											  bubbles : Boolean = false, 
											  cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
			this.skin = skin;
			this.style = style;
			this.states = states;
		}
		TARGET::FLASH_10
		public function StyleSelectionEvent ( type : String, 
											  skin : Object,
											  style : ComponentStyle = null, 
											  states : Vector.<uint> = null, 
											  bubbles : Boolean = false, 
											  cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
			this.skin = skin;
			this.style = style;
			this.states = states;
		}
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		public function StyleSelectionEvent ( type : String, 
											  skin : Object,
											  style : ComponentStyle = null, 
											  states : Vector.<uint> = null, 
											  bubbles : Boolean = false, 
											  cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
			this.skin = skin;
			this.style = style;
			this.states = states;
		}
	}
}

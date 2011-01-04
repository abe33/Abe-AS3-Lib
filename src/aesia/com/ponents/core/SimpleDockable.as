package aesia.com.ponents.core 
{
	import aesia.com.ponents.skinning.icons.Icon;
	/**
	 * @author cedric
	 */
	public class SimpleDockable implements Dockable
	{
		protected var _label : *;
		protected var _icon : Icon;
		protected var _content : Component;
		protected var _id : String;

		public function SimpleDockable ( content : Component, id : String, label : * = null, icon : Icon = null) 
		{
			_id = id;
			_label = label;
			_content = content;
			_icon = icon;			
		}	
		public function get label () : * { return _label; }
		public function set label (s : *) : void { _label = s; }
		
		public function get icon () : Icon { return _icon; }
		public function set icon (icon : Icon) : void { _icon = icon; }
		
		public function get content () : Component { return _content; }
		public function set content (c : Component) : void { _content = c; }
		
		public function get id () : String { return _id; }
		public function set id (s : String) : void { _id = s; }
	}
}

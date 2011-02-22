package abe.com.ponents.tools.canvas.core 
{
	import abe.com.ponents.events.ToolEvent;
	import abe.com.ponents.skinning.cursors.Cursor;
	import abe.com.ponents.tools.canvas.Tool;

	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	/**
	 * @author Cédric Néhémie
	 */
	public class NullTool implements Tool 
	{
		public function actionStarted (e : ToolEvent) : void {}		
		public function actionFinished (e : ToolEvent) : void {}		
		public function actionPaused (e : ToolEvent) : void {}		
		public function actionResumed (e : ToolEvent) : void {}		
		public function actionAborted (e : ToolEvent) : void {}		
		public function mousePositionChanged (e : ToolEvent) : void	{}		
		public function objectUnderTheMouseChanged (e : ToolEvent) : void {}
		public function setAsAlternateTool (b : Boolean) : void	{}
		public function toolSelected ( e : ToolEvent ) : void {}
		public function toolUnselected ( e : ToolEvent ) : void {}
		public function mouseMove (e : ToolEvent) : void {}
		
		public function hasCustomCursor () : Boolean
		{
			return false;
		}
		public function get cursor () : Cursor
		{
			return null;
		}
		public function hasAlternateTools () : Boolean
		{
			return false;
		}
		public function get alterternateTools () : Dictionary
		{
			return null;
		}
		
		public function toString() : String 
		{
			return getQualifiedClassName( this );
		}
		
		
	}
}

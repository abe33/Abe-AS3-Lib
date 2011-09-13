package abe.com.ponents.tools.canvas.core 
{
    import abe.com.ponents.skinning.cursors.Cursor;
    import abe.com.ponents.tools.canvas.Tool;
    import abe.com.ponents.tools.canvas.ToolGestureData;

    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;

	/**
	 * @author Cédric Néhémie
	 */
	public class NullTool implements Tool 
	{
		public function actionStarted (e : ToolGestureData) : void {}		
		public function actionFinished (e : ToolGestureData) : void {}		
		public function actionPaused (e : ToolGestureData) : void {}		
		public function actionResumed (e : ToolGestureData) : void {}		
		public function actionAborted (e : ToolGestureData) : void {}		
		public function mousePositionChanged (e : ToolGestureData) : void	{}		
		public function objectUnderTheMouseChanged (e : ToolGestureData) : void {}
		public function setAsAlternateTool (b : Boolean) : void	{}
		public function toolSelected ( e : ToolGestureData ) : void {}
		public function toolUnselected ( e : ToolGestureData ) : void {}
		public function mouseMove (e : ToolGestureData) : void {}
		
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

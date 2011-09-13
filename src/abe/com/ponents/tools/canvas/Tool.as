package abe.com.ponents.tools.canvas 
{
    import abe.com.ponents.skinning.cursors.Cursor;

    import flash.utils.Dictionary;
	/**
	 * 
	 */
	public interface Tool 
	{
		function toolSelected ( e : ToolGestureData ) : void;		function toolUnselected ( e : ToolGestureData ) : void;
		function actionStarted ( e : ToolGestureData ) : void;
		function actionFinished ( e : ToolGestureData ) : void;
		function actionPaused ( e : ToolGestureData ) : void;
		function actionResumed ( e : ToolGestureData ) : void;
		function actionAborted ( e : ToolGestureData ) : void;
		function mousePositionChanged ( e : ToolGestureData ) : void;		function mouseMove ( e : ToolGestureData ) : void;
		function objectUnderTheMouseChanged ( e : ToolGestureData ) : void;
		function setAsAlternateTool ( b : Boolean ) : void;
		function hasAlternateTools () : Boolean;
		function get alterternateTools () : Dictionary;
		function hasCustomCursor () : Boolean;
		function get cursor () : Cursor;
	}
}

package abe.com.ponents.tools.canvas 
{
	import abe.com.ponents.events.ToolEvent;
	import abe.com.ponents.skinning.cursors.Cursor;

	import flash.utils.Dictionary;

	/**
	 * 
	 */
	public interface Tool 
	{
		function toolSelected ( e : ToolEvent ) : void;
		function actionStarted ( e : ToolEvent ) : void;
		function actionFinished ( e : ToolEvent ) : void;
		function actionPaused ( e : ToolEvent ) : void;
		function actionResumed ( e : ToolEvent ) : void;
		function actionAborted ( e : ToolEvent ) : void;
		function mousePositionChanged ( e : ToolEvent ) : void;
		function objectUnderTheMouseChanged ( e : ToolEvent ) : void;
		function setAsAlternateTool ( b : Boolean ) : void;
		function hasAlternateTools () : Boolean;
		function get alterternateTools () : Dictionary;
		function hasCustomCursor () : Boolean;
		function get cursor () : Cursor;
	}
}
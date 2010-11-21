package aesia.com.ponents.tools 
{
	import aesia.com.ponents.events.ToolEvent;
	import aesia.com.ponents.skinning.cursors.Cursor;

	import flash.utils.Dictionary;

	/**
	 * 
	 */
	public interface Tool 
	{
		function toolSelected ( e : ToolEvent ) : void;		function toolUnselected ( e : ToolEvent ) : void;
		function actionStarted ( e : ToolEvent ) : void;
		function actionFinished ( e : ToolEvent ) : void;
		function actionPaused ( e : ToolEvent ) : void;
		function actionResumed ( e : ToolEvent ) : void;
		function actionAborted ( e : ToolEvent ) : void;
		function mousePositionChanged ( e : ToolEvent ) : void;		function mouseMove ( e : ToolEvent ) : void;
		function objectUnderTheMouseChanged ( e : ToolEvent ) : void;
		function setAsAlternateTool ( b : Boolean ) : void;
		function hasAlternateTools () : Boolean;
		function get alterternateTools () : Dictionary;
		function hasCustomCursor () : Boolean;
		function get cursor () : Cursor;
	}
}

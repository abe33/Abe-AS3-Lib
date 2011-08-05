package abe.com.ponents.tools.canvas.core 
{
	import abe.com.mon.utils.KeyStroke;
	import abe.com.ponents.skinning.cursors.Cursor;
	import abe.com.ponents.tools.canvas.Tool;
	import abe.com.ponents.tools.canvas.ToolGestureData;
	
	import flash.utils.Dictionary;

	/**
	 * @author Cédric Néhémie
	 */
	public class AbstractTool implements Tool 
	{
		private var _alternateTools : Dictionary;
		private var _numAlternateTools : Number;
		
		protected var _cursor : Cursor;
		
		protected var _bIsAlternateTool : Boolean;

		public function AbstractTool ( cursor : Cursor = null )
		{
			_alternateTools = new Dictionary ();
			_numAlternateTools = 0;
			
			_cursor = cursor;
			_bIsAlternateTool = false;
		}

		public function actionStarted (e : ToolGestureData) : void {}
		public function actionFinished (e : ToolGestureData) : void {}
		public function actionPaused (e : ToolGestureData) : void {}
		public function actionResumed (e : ToolGestureData) : void {}
		public function actionAborted (e : ToolGestureData) : void {}
		public function mousePositionChanged (e : ToolGestureData) : void {}
		public function objectUnderTheMouseChanged (e : ToolGestureData) : void {}
		public function toolSelected ( e : ToolGestureData ) : void {}
		public function toolUnselected ( e : ToolGestureData ) : void {}
		public function mouseMove (e : ToolGestureData) : void {}
		
		public function setAsAlternateTool (b : Boolean) : void
		{
			_bIsAlternateTool = b;
		}
		
		public function hasAlternateTools () : Boolean
		{
			return _numAlternateTools != 0;
		}

		public function hasCustomCursor () : Boolean
		{
			return _cursor != null;
		}

		public function get alterternateTools () : Dictionary
		{
			return _alternateTools;
		}

		public function get cursor () : Cursor
		{
			return _cursor;
		}

		public function addAlternateTool ( keyStroke : KeyStroke, tool : Tool) : void
		{
			if( _alternateTools[ keyStroke ] == null )
				_numAlternateTools++;
				
			_alternateTools[ keyStroke ] = tool;
		}
		public function removeAlternateTool ( keyStroke : KeyStroke ) : void
		{
			if( _alternateTools[ keyStroke ] != null )
			{
				_numAlternateTools--;
				delete _alternateTools[ keyStroke ];
			}
		}
	}
}

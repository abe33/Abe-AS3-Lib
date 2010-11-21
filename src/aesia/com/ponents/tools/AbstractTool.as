package aesia.com.ponents.tools 
{
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.ponents.events.ToolEvent;
	import aesia.com.ponents.skinning.cursors.Cursor;

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

		public function actionStarted (e : ToolEvent) : void {}
		public function actionFinished (e : ToolEvent) : void {}
		public function actionPaused (e : ToolEvent) : void {}
		public function actionResumed (e : ToolEvent) : void {}
		public function actionAborted (e : ToolEvent) : void {}
		public function mousePositionChanged (e : ToolEvent) : void {}
		public function objectUnderTheMouseChanged (e : ToolEvent) : void {}
		public function toolSelected ( e : ToolEvent ) : void {}
		public function toolUnselected ( e : ToolEvent ) : void {}
		public function mouseMove (e : ToolEvent) : void {}
		
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

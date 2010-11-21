package aesia.com.ponents.tools 
{
	import aesia.com.edia.camera.Camera;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.events.ToolEvent;
	import aesia.com.ponents.skinning.cursors.Cursor;

	import flash.display.StageQuality;
	import flash.geom.Point;

	/**
	 * @author Cédric Néhémie
	 */
	public class Pan extends AbstractTool implements Tool 
	{
		protected var _camera : Camera;
		
		protected var _startPoint : Point;
		protected var _changeQualityDuringPan : Boolean;

		public function Pan ( camera : Camera, cursor : Cursor = null, changeQualityDuringPan : Boolean = false )
		{    
			super( cursor );
			this._camera = camera;
			this._changeQualityDuringPan = changeQualityDuringPan;
		}

		override public function actionStarted (e : ToolEvent) : void
		{
			_startPoint = new Point( e.canvas.stage.mouseX, e.canvas.stage.mouseY );
			
			if( _changeQualityDuringPan )
				StageUtils.stage.quality = StageQuality.LOW;
		}

		override public function mousePositionChanged (e : ToolEvent) : void
		{
			var pt : Point = new Point( e.canvas.stage.mouseX, e.canvas.stage.mouseY );
			
			var dif : Point = _startPoint.subtract( pt );			
			dif.normalize( dif.length / _camera.zoom );			
			_camera.translate( dif );
						
			_startPoint = pt;
		}

		override public function actionFinished (e : ToolEvent) : void
		{
			super.actionFinished( e );
			
			if( _changeQualityDuringPan )
				StageUtils.stage.quality = StageQuality.BEST;
		}
	}
}

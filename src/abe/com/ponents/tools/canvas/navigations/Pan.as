package abe.com.ponents.tools.canvas.navigations 
{
    import abe.com.edia.camera.Camera;
    import abe.com.mon.utils.StageUtils;
    import abe.com.ponents.skinning.cursors.Cursor;
    import abe.com.ponents.tools.canvas.Tool;
    import abe.com.ponents.tools.canvas.ToolGestureData;
    import abe.com.ponents.tools.canvas.core.AbstractTool;

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

		override public function actionStarted (e : ToolGestureData) : void
		{
			_startPoint = new Point( e.canvas.stage.mouseX, e.canvas.stage.mouseY );
			
			if( _changeQualityDuringPan )
				StageUtils.stage.quality = StageQuality.LOW;
		}

		override public function mousePositionChanged (e : ToolGestureData) : void
		{
			var pt : Point = new Point( e.canvas.stage.mouseX, e.canvas.stage.mouseY );
			
			var dif : Point = _startPoint.subtract( pt );			
			dif.normalize( dif.length / _camera.zoom );			
			_camera.translate( dif );
						
			_startPoint = pt;
		}

		override public function actionFinished (e : ToolGestureData) : void
		{
			super.actionFinished( e );
			
			if( _changeQualityDuringPan )
				StageUtils.stage.quality = StageQuality.BEST;
		}
	}
}

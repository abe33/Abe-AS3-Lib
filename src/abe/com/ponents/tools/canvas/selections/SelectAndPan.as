package abe.com.ponents.tools.canvas.selections
{
    import abe.com.edia.camera.Camera;
    import abe.com.mon.logs.Log;
    import abe.com.mon.utils.StageUtils;
    import abe.com.ponents.skinning.cursors.Cursor;
    import abe.com.ponents.tools.CameraCanvas;
    import abe.com.ponents.tools.ObjectSelection;
    import abe.com.ponents.tools.canvas.ToolGestureData;

    import flash.display.StageQuality;
    import flash.geom.Point;
    import flash.ui.MouseCursor;

	/**
	 * @author cedric
	 */
	public class SelectAndPan extends SelectAndMove
	{
		static protected const PAN : Number = 3;
		
		protected var _camera : Camera;
		protected var _changeQualityDuringPan : Boolean;
		protected var _panCursor : Cursor;

		public function SelectAndPan ( canvas : CameraCanvas, 
									  selection : ObjectSelection, 
									  cursor : Cursor = null, 
									  panCursor : Cursor = null, 
									  changeQualityDuringPan : Boolean = false, 
									  allowMoves : Boolean = true )
		{
			super( canvas, selection, cursor, allowMoves );
			_panCursor = panCursor ? panCursor : Cursor.get(MouseCursor.HAND );
			this._camera = canvas.camera;
			this._changeQualityDuringPan = changeQualityDuringPan;
		}

		override public function mousePositionChanged (e : ToolGestureData) : void
		{
            try
            {
				var pt : Point = new Point( e.canvas.stage.mouseX, e.canvas.stage.mouseY );
				var dif : Point = stagePressPoint.subtract( pt );
	
				if( dif.length > 10 && mode != PAN && mode != MOVE )
				{
					mode = PAN;
					
					clearDrag();
					
					if( _changeQualityDuringPan )
						StageUtils.stage.quality = StageQuality.LOW;
				}
	
				if( mode == PAN )
				{
					dif.normalize( dif.length / _camera.zoom );
					_camera.translate( dif );
					stagePressPoint = pt;
					Cursor.setCursor( _panCursor );
				}
				else 
				{
					super.mousePositionChanged(e);
				}                
            }
            catch(e : Error)
            {
                Log.error(e);
                Log.info(pt);
                Log.info(stagePressPoint);
                Log.info(dif);
            }
		}

		override public function actionFinished (e : ToolGestureData) : void
		{
			if( mode == PAN )
			{
				if( _changeQualityDuringPan )
					StageUtils.stage.quality = StageQuality.BEST;
				Cursor.setCursor( _cursor );
				mode = NONE;
			}
			else
			{
				super.actionFinished( e );
			}
		}
	}
}
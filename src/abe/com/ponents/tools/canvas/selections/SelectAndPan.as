package abe.com.ponents.tools.canvas.selections
{
	import abe.com.edia.camera.Camera;
	import abe.com.mon.utils.StageUtils;
	import abe.com.ponents.events.ToolEvent;
	import abe.com.ponents.skinning.cursors.Cursor;
	import abe.com.ponents.tools.ObjectSelection;
	import abe.com.ponents.utils.ToolKit;

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

		public function SelectAndPan ( camera : Camera, 
									  selection : ObjectSelection, 
									  cursor : Cursor = null, 
									  panCursor : Cursor = null, 
									  changeQualityDuringPan : Boolean = false, 
									  allowMoves : Boolean = true )
		{
			super( selection, cursor, allowMoves );
			_panCursor = panCursor ? panCursor : Cursor.get(MouseCursor.HAND );
			this._camera = camera;
			this._changeQualityDuringPan = changeQualityDuringPan;
		}

		override public function mousePositionChanged (e : ToolEvent) : void
		{
			var pt : Point = new Point( e.canvas.stage.mouseX, e.canvas.stage.mouseY );
			var dif : Point = stagePressPoint.subtract( pt );

			if( dif.length > 10 && mode != PAN && mode != MOVE )
			{
				mode = PAN;
				
				ToolKit.toolLevel.removeChild( selectionShape );
				selectionShape.graphics.clear();
				
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

		override public function actionFinished (e : ToolEvent) : void
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
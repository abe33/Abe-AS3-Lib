/**
 * @license
 */
package abe.com.edia.commands
{
	import abe.com.mands.ParallelCommand;
	import abe.com.mon.utils.StageUtils;
	import abe.com.motion.SingleTween;
	import abe.com.ponents.utils.ToolKit;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	/**
	 * @author Cédric Néhémie
	 */
	public class BlurScreen extends ParallelCommand
	{
		protected var msk : Shape;
		protected var target : DisplayObject;

		public function BlurScreen ( target : DisplayObject )
		{
			this.target = target;
			// on prépare le masque pour le fondu au noir
			msk = new Shape();
			var t : SingleTween = new SingleTween( msk, "alpha", 0.3, 300, 0 );
			msk.graphics.beginFill(0);
			msk.graphics.drawRect( 0, 0, StageUtils.stage.stageWidth, StageUtils.stage.stageHeight );
			msk.graphics.endFill();

			super( new BlurFade( target, 8, 300 ), t );
		}

		override public function execute ( ... args ) : void
		{
			ToolKit.mainLevel.addChild( msk );
			super.execute.apply(this,args);
		}

		public function clean () : void
		{
			if( _isRunning )
				stop();

			if( ToolKit.mainLevel.contains( msk ) )
				ToolKit.mainLevel.removeChild( msk );
			target.filters = [];
		}
	}
}

package abe.com.edia.text.fx.simple 
{
    import abe.com.edia.text.core.Char;
    import abe.com.edia.text.fx.AbstractCharEffect;
    import abe.com.mon.utils.MathUtils;
    import abe.com.mon.utils.MatrixUtils;

    import flash.display.DisplayObject;
    import flash.geom.Matrix;
	/**
	 * @author cedric
	 */
	public class CharRotate extends AbstractCharEffect 
	{
		static public const BASELINE : String = "baseline";		static public const CENTER : String = "center";		static public const TOP_LEFT : String = "topLeft";		static public const TOP_RIGHT : String = "topRight";		static public const BOTTOM_LEFT : String = "bottomLeft";		static public const BOTTOM_RIGHT : String = "bottomRight";
		
		
		protected var angle : Number;
		protected var ref : String;

		public function CharRotate ( angle : Number, ref : String = "topLeft" )
		{
			this.angle = angle;	
			this.ref = ref;
			super(false);
		}
		override public function init () : void 
		{
			var a : Number = MathUtils.deg2rad(angle);
			var m : Matrix;
			for each( var c : Char in chars )
				if( c.charContent )
				{
					var d : DisplayObject = c.charContent;
					m = d.transform.matrix;
					switch( ref )
					{
						case BASELINE : 
							MatrixUtils.rotateAroundExternalPoint(m, d.x + d.width/2, d.y + d.height, a );
							break;
						case CENTER : 
							MatrixUtils.rotateAroundExternalPoint(m, d.x + d.width/2, d.y + d.height / 2 , a );
							break;
						case BOTTOM_RIGHT : 
							MatrixUtils.rotateAroundExternalPoint(m, d.x + d.width, d.y + d.height, a );
							break;
						case BOTTOM_LEFT : 
							MatrixUtils.rotateAroundExternalPoint(m, d.x, d.y + d.height, a );
							break;
						case TOP_RIGHT : 
							MatrixUtils.rotateAroundExternalPoint(m, d.x + d.width, d.y, a );
							break;
						case TOP_LEFT : 
						default :
							MatrixUtils.rotateAroundExternalPoint(m, d.x, d.y , a );
							break;
					}
					d.transform.matrix = m;
				}
		}
		override public function dispose () : void 
		{
			for each( var c : Char in chars )
				if( c.charContent )
				  	c.charContent.rotation = 0;
		}
		override public function start () : void 
		{}
		override public function stop () : void 
		{}
		
		override public function isRunning () : Boolean 
		{
			return false;
		}
	}
}

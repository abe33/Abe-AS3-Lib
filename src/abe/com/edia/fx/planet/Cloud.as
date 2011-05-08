package abe.com.edia.fx.planet 
{
	import abe.com.mon.colors.Color;

	import flash.display.Shape;
	/**
	 * @author Cédric Néhémie
	 */
	public class Cloud extends Shape 
	{
		public var long : Number = 0;
		public var lat : Number = 0;
		public var latSpeed : Number = 0;
		public var longSpeed : Number = 0;
		public var isBack : Boolean;
	
		public function Cloud ( size : Number = 10, color : Color = null )
		{
			
			this.graphics.beginFill( color.hexa, 1 );
			this.graphics.drawCircle(0, 0, size );
			this.graphics.endFill();
			/*
			for(var i : Number = 0; i<5; i++)
			{
				var x : Number = RandomUtils.sbalance(size*2);				var y : Number = RandomUtils.sbalance(size*2);				var _size : Number = size/2 + RandomUtils.srandom(size);
				
				this.graphics.beginFill( color.hexa, 1 );
				this.graphics.drawCircle(x, y, _size );
				this.graphics.endFill();
			}
			*/
		}
	}
}

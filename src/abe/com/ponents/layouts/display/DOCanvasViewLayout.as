package abe.com.ponents.layouts.display 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.geom.dm;
	import abe.com.ponents.utils.Insets;

	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	/**
	 * @author cedric
	 */
	public class DOCanvasViewLayout extends AbstractDisplayObjectLayout 
	{
		protected var _snapshot : Bitmap;
		protected var _screen : Shape;
		protected var _margins : Insets;
		
		public function DOCanvasViewLayout ( container : DisplayObjectContainer = null, margins : Insets = null )
		{
			super( container );
			_margins = margins ? margins : new Insets(20);
		}
		public function get snapshot () : Bitmap { return _snapshot; }
		public function set snapshot (snapshot : Bitmap) : void { _snapshot = snapshot; }
		
		public function get screen () : Shape { return _screen; }
		public function set screen (screen : Shape) : void { _screen = screen; }
		
		public function get margins () : Insets { return _margins; }
		public function set margins (margins : Insets) : void { _margins = margins; }
		
		override public function get preferredSize () : Dimension { return estimateSize(); }
		
		override public function layout (preferredSize : Dimension = null, insets : Insets = null) : void 
		{
			insets = insets ? insets : new Insets();
			
			var innerPref : Dimension = estimateSize();
			var prefDim : Dimension = preferredSize ? preferredSize : innerPref.grow( insets.horizontal, insets.vertical );
			
			var r : Number;
			
			if( innerPref.width > prefDim.width - _margins.horizontal )
			 	r = ( prefDim.width - _margins.horizontal ) / innerPref.width;
			else if( innerPref.height > prefDim.height - _margins.vertical )
				r = ( prefDim.height - _margins.vertical ) / innerPref.height;
			else
			{
				var isHorizontal : Boolean = innerPref.width > innerPref.height;
				r = Math.min(1, isHorizontal ? 
												( prefDim.width - _margins.horizontal ) / innerPref.width : 
												( prefDim.height - _margins.vertical ) / innerPref.height );
			}
			var ratio : Number = r;
			snapshot.scaleX = ratio;			snapshot.scaleY = ratio;
			screen.scaleX = ratio;			screen.scaleY = ratio;
			
			snapshot.x = ( prefDim.width - snapshot.width ) / 2;			snapshot.y = ( prefDim.height - snapshot.height ) / 2;
			
			screen.x = snapshot.x;			screen.y = snapshot.y;
		}
		protected function estimateSize() : Dimension
		{
			if( snapshot && snapshot.width != 0 )
			{				var w : Number = snapshot.width / snapshot.scaleX;
				var h : Number = snapshot.height / snapshot.scaleY;
				return dm(w,h);
			}
			else return dm(1,1); 
		}
	}
}

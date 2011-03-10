package abe.com.ponents.flexunit 
{
	import abe.com.mon.utils.Color;
	import abe.com.ponents.trees.DefaultTreeCell;

	import org.flexunit.runner.IDescription;

	[Skinable(skin="TestTreeCell")]
	[Skin(define="TestTreeCell",
			  inherit="TreeCell",

			  custom_leafIcon="icon(abe.com.ponents.flexunit::TestTreeCell.TEST_ICON)",
			  custom_nodeIcon="icon(abe.com.ponents.flexunit::TestTreeCell.SUITE_ICON)"
	)]
	public class TestTreeCell extends DefaultTreeCell 
	{
		[Embed(source="../skinning/icons/brick.png")]
		static public var TEST_ICON : Class;

		[Embed(source="../skinning/icons/package.png")]
		static public var SUITE_ICON : Class;
		
		public function TestTreeCell ()	
		{ 
			_allowOver = false;
			super(); 
		}
		
		public function get testTree () : TestTree { return _owner as TestTree; }
		
		override public function repaint () : void 
		{
			super.repaint();
			if( value && value.userObject is IDescription )
			{
				var c : Color;
				var d : IDescription = value.userObject as IDescription;
				if ( d && d.isTest )
				{
					var failures : Array = testTree.getFailuresFor( d );
					if( failures.length > 0 )
					{
						if( _selected )
							c = Color.Tomato.interpolate( Color.White, 1 - ( Math.min( 1 + failures.length, 5 ) / 5 ) );						else
							c = Color.Tomato.interpolate( Color.White, 1 - ( Math.min( failures.length, 5 ) / 5 ) );
					
						_background.graphics.clear();
						_background.graphics.beginFill( c.hexa, 1 );						_background.graphics.drawRect(0, 0, width, height );
						_background.graphics.endFill();
					}
				}
			}
		}
	}
}

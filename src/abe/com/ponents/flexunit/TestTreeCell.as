package abe.com.ponents.flexunit 
{
	import abe.com.patibility.humanize.plural;
	import abe.com.mon.utils.Color;
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.trees.DefaultTreeCell;

	import org.flexunit.runner.IDescription;

	[Skinable(skin="TestTreeCell")]
	[Skin(define="TestTreeCell",
			  inherit="EmptyComponent",
			  preview="abe.com.ponents.trees::Tree.defaultTreePreview",
			  previewAcceptStyleSetup="false",
	
			  custom_indentLineColor="skin.treeIndentLineColor",
			  custom_expandIcon="icon(abe.com.ponents.trees::DefaultTreeCell.TREE_NODE_EXPAND_ICON)",
			  custom_collapseIcon="icon(abe.com.ponents.trees::DefaultTreeCell.TREE_NODE_COLLAPSE_ICON)",
			  custom_leafIcon="icon(abe.com.ponents.flexunit::TestTreeCell.TEST_ICON)",
			  custom_nodeIcon="icon(abe.com.ponents.flexunit::TestTreeCell.SUITE_ICON)",
			  
			  state__selected__foreground="new deco::SimpleBorders(skin.overSelectedBorderColor)"
	)]
	public class TestTreeCell extends DefaultTreeCell 
	{
		[Embed(source="../skinning/icons/brick.png")]
		static public var TEST_ICON : Class;

		[Embed(source="../skinning/icons/package.png")]
		static public var SUITE_ICON : Class;
		
		protected var _lastRepaintedValue : *;		protected var _failureCount : uint;
		
		public function TestTreeCell ()	
		{ 
			_allowOver = false;
			_failureCount = 0;
			super(); 
		}
		
		public function get testTree () : TestTree { return _owner as TestTree; }
		
		override protected function formatLabel (value : *) : String 
		{
			return super.formatLabel( value ) + ( _failureCount > 0 ? _$(_(" <b>($0 $1)</b>"),
																		_failureCount, 
																		plural( _failureCount, 
																				_("failure"),
																				_("failures") ) ) 
																	: "" );
		}
		override public function repaint () : void 
		{
			super.repaint();
			
			if( value && value.userObject is IDescription )
			{
				var d : IDescription = value.userObject as IDescription;
				if( _lastRepaintedValue != d )
				{
					_lastRepaintedValue = d;
					
					var c : Color;
					var failures : Array;
					if ( d )
					{
						failures = testTree.getFailuresFor( d );
						_failureCount = failures.length;
					}
				}
				if( _failureCount > 0 )
				{
					c = Color.Tomato.interpolate( Color.White, 1 - ( Math.min( _failureCount, 10 ) / 10 ) );
				
					_background.graphics.clear();
					_background.graphics.beginFill( c.hexa, 1 );
					_background.graphics.drawRect(0, 0, width, height );
					_background.graphics.endFill();
				}
			}
		}
	}
}

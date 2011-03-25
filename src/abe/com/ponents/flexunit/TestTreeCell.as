package abe.com.ponents.flexunit 
{
	import abe.com.ponents.utils.Inspect;
	import abe.com.mon.logs.Log;
	import abe.com.ponents.models.TreeNode;
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
		
		protected var _lastRepaintedValue : *;		protected var _failureCount : uint;		protected var _ignoredCount : uint;

		public function TestTreeCell ()	
		{ 
			_allowOver = false;
			_failureCount = 0;			_ignoredCount = 0;
			super(); 
		}
		
		public function get testTree () : TestTree { return _owner as TestTree; }
		
		override protected function formatLabel (value : *) : String 
		{
			if( value && value is IDescription )
			{
				var d : IDescription = value as IDescription;
				if( d.isSuite )
				{
					var a : Array = [];
					if( _failureCount > 0 )
						a.push(  _$( "$0 $1", 
									 _failureCount, 
									 plural( _failureCount, 
											 _("failure"),
											 _("failures") ) ) );
					if( _ignoredCount > 0 )
						a.push(  _$( "$0 $1", 
									 _ignoredCount, 
									 _("ignored") ) );
					
					return formatDisplayName( d ) + ( ( _failureCount > 0 || _ignoredCount > 0 ) ? _$(_(" <b>($0)</b>"), a.join(", ") ) : "" );
				}
				else
				{
					var s : String = "";
					if( _failureCount > 0 )
						s = _$(" <font color='$0'>$1</font>", Color.Tomato.html, _("failed") );
					else if( _ignoredCount > 0 )
						s =  _$(" <font color='$0'>$1</font>", Color.CornflowerBlue.html, _("ignored") );
					
					return formatDisplayName( d ) + s;
				}
			}
			else return super.formatLabel( value );
		}
		protected function formatDisplayName( v : IDescription ) : String
		{
			if( v.isSuite )
				return v.displayName;
			else
				return v.displayName.split("::")[1];
		}
		
		override public function set value (val : *) : void 
		{
			updateTestData ( val );
			super.value = val;
		}
		public function updateTestData ( val : * = null ) : void
		{
			if( !val )
				val = value;
			
			if( val && val.userObject is IDescription )
			{
				var d : IDescription = val.userObject as IDescription;

				var failures : Array;
				var ignored : Array;
				if ( d )
				{
					failures = testTree.getFailuresFor( d );
					ignored = testTree.getIgnoredFor(d);
					_failureCount = failures.length;
					_ignoredCount = ignored.length;
				}
			}
		}
		override public function repaint () : void 
		{
			super.repaint();
			
			var c : Color = Color.White;			var c2 : Color;
			if( _failureCount > 0 && _ignoredCount > 0 )
			{
				if( _failureCount > _ignoredCount )
					c2 = Color.Tomato.interpolate( Color.CornflowerBlue, _ignoredCount / _failureCount );				else
					c2 = Color.CornflowerBlue.interpolate( Color.Tomato, _failureCount / _ignoredCount );
				
				c = c.interpolate( c2, ( Math.min( _failureCount + _ignoredCount, 20 ) / 20 ) );
			}
			else if( _failureCount > 0 )				c = c.interpolate( Color.Tomato, ( Math.min( _failureCount, 10 ) / 10 ) );
			else if( _ignoredCount > 0 )
				c = c.interpolate( Color.CornflowerBlue, ( Math.min( _ignoredCount, 10 ) / 10 ) );
			
			_background.graphics.clear();
			_background.graphics.beginFill( c.hexa, 1 );
			_background.graphics.drawRect(0, 0, width, height );
			_background.graphics.endFill();
		}
	}
}

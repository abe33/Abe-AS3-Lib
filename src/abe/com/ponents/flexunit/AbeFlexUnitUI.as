package abe.com.ponents.flexunit
{
	import abe.com.mon.closures.objects.hasProperty;
	import abe.com.mon.colors.Color;
	import abe.com.mon.utils.StringUtils;
	import abe.com.patibility.humanize.capitalize;
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.buttons.ButtonDisplayModes;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.containers.ScrollPane;
	import abe.com.ponents.containers.SplitPane;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.Dockable;
	import abe.com.ponents.layouts.components.BorderLayout;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.models.DefaultBoundedRangeModel;
	import abe.com.ponents.models.TreeModel;
	import abe.com.ponents.models.TreeNode;
	import abe.com.ponents.progress.ProgressBar;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.text.Label;
	import abe.com.ponents.text.TextArea;
	import abe.com.ponents.trees.TreeHeader;
	import abe.com.ponents.utils.Insets;

	import flex.lang.reflect.metadata.MetaDataAnnotation;
	import flex.lang.reflect.metadata.MetaDataArgument;

	import org.flexunit.runner.IDescription;
	import org.flexunit.runner.Result;
	import org.flexunit.runner.notification.Failure;
	import org.flexunit.runner.notification.IRunListener;

	import flash.text.TextFormat;
	/**
	 * @author cedric
	 */
	public class AbeFlexUnitUI extends Panel implements IRunListener, Dockable
	{
		static private const ERROR_LABEL : String = _("$0\n<b>Failure : </b>$1\n<b>Exception Name : </b>$2\n$4");
		static private const PROGRESS_LABEL : String = _("Current Test : <i>$5</i>\nTotal Tests : <b>$0/$1</b>\tIgnored : <b>$3</b>\tFailures : <b>$2</b>\t$4");
		
		protected var _label : String;
		protected var _icon : Icon;
		
		protected var _testCount : Number;
		protected var _testPerformed : Number;
		protected var _failureCount : Number;
		protected var _ignoredCount : Number;
		protected var _result : String;
		protected var _currentTest : IDescription;
		
		protected var _testTree : TestTree;
		protected var _progressBar : ProgressBar;
		protected var _progressLabel : Label;
		protected var _testDetails : TextArea;

		public function AbeFlexUnitUI ( label : String = "Tests", icon : Icon = null ) 
		{
			_label = label;
			_icon = icon;
			
			_testCount = 0;
			_testPerformed = 0;
			_failureCount = 0;
			_ignoredCount = 0;
			_result = "";
			
			super();
			
			var l : BorderLayout = new BorderLayout();
			var p1 : Panel = createProgressPanel();
			var p2 : SplitPane = createResultsPanel();
			
			addComponent( p1 );
			l.north = p1;	
				
			addComponent( p2 );
			l.center = p2;		
			
			childrenLayout = l;
		}
/*----------------------------------------------------------------------*
 * 	GETTER/SETTER
 *----------------------------------------------------------------------*/
		public function get label () : * { return _label; }
		public function set label (s : *) : void { _label = s; }
		
		public function get icon () : Icon { return _icon; }
		public function set icon (icon : Icon) : void { _icon = icon; }
		
		public function get content () : Component { return this; }
		public function set content (c : Component) : void {}
		
/*----------------------------------------------------------------------*
 *  TESTS LISTENERS
 *----------------------------------------------------------------------*/
		public function testRunStarted (description : IDescription) : void
		{
			_currentTest = description;
			_testCount = description.testCount;
			_progressBar.model = new DefaultBoundedRangeModel( 0, 0, _testCount, 1 );
			_progressBar.determinate = true;
			_progressBar.labelUnit = "/" + _testCount;			
			buildTestTree( description );
			
			
			updateProgressDisplay();
		}
		public function testRunFinished (result : Result) : void
		{
			if( _failureCount > 0 )
				recursiveFailureExpand( _testTree.treeModel.root );
			
			_testTree.testsEnded();
			
			if( _failureCount > 0 )
				_result = _$(_("<font color='$0'><b><i>Failed</i></b></font>"), Color.Tomato.html );
			else
				_result = _$(_("<font color='$0'><b><i>Success</i></b></font>"), Color.ForestGreen.html );
			
			updateProgressDisplay();
				
		}
		protected function recursiveFailureExpand ( n : TreeNode ) : void
		{
			var desc : IDescription = n.userObject as IDescription;
			if( desc.isSuite )
			{
				var failures : Array =  _testTree.getFailuresFor( desc );
				if( failures.length > 0 && !desc.children.every( hasProperty( "isTest", true ) ) )
				{
					n.expanded = true;
					for each( var child : TreeNode in n.children )
						recursiveFailureExpand(child);
				}
			}
		}
		public function testStarted (description : IDescription) : void
		{
			_currentTest = description;
		}
		public function testFinished (description : IDescription) : void
		{
			_testPerformed++;
			updateProgressDisplay ();
		}
		public function testFailure (failure : Failure) : void
		{
			_failureCount++;
			_testTree.failures.addElement( failure );
			updateProgressDisplay ();
		}
		public function testAssumptionFailure (failure : Failure) : void
		{
		}
		public function testIgnored (description : IDescription) : void
		{
			_testTree.ignored.addElement( description );
			_ignoredCount++;
		}
/*----------------------------------------------------------------------*
 * 	PROTECTED METHODS
 *----------------------------------------------------------------------*/
		protected function updateProgressDisplay () : void 
		{
			_progressLabel.value = getProgressLabel();
			_progressBar.value = _testPerformed;
		}
		protected function buildTestTree (description : IDescription) : void 
		{
			var r : TreeNode = new TreeNode( description, true );
			r.expanded = true;
			fillNode( description, r );
			
			r.sort( function ( a:TreeNode, b:TreeNode ):int 
			{
				var aa : IDescription = a.userObject;
				var bb : IDescription = b.userObject;
				if( !aa || !bb )
					return 0;
				else if( aa.displayName > bb.displayName )
					return 1;
				else if( aa.displayName < bb.displayName )
					return -1;
				else return 0;
			} );
			
			var m : TreeModel = new TreeModel( r );
			m.showRoot = false;
			_testTree.model = m;
		}
		protected function fillNode (description : IDescription, r : TreeNode) : void 
		{ 
			if( description.isSuite && description.children.length > 0 )
			{
				for each( var d : IDescription in description.children )
				{
					var  n : TreeNode = new TreeNode( d, d.isSuite );
					fillNode( d, n );
					r.add( n );
				}
			}
		}
		protected function createResultsPanel () : SplitPane 
		{
			_testTree = new TestTree();
			_testTree.selectionChanged.add( treeSelectionChanged );
			_testTree.itemFormatingFunction = formatTreeNode;
			var header : TreeHeader = new TreeHeader( _testTree, ButtonDisplayModes.ICON_ONLY, false );
			var sp : ScrollPane = new ScrollPane();
			_testDetails = new TextArea();
			_testDetails.allowHTML = true;
			
			sp.colHead = header;
			sp.view = _testTree;
			
			var p : SplitPane = new SplitPane( SplitPane.HORIZONTAL_SPLIT, sp, _testDetails );
			p.oneTouchExpandFirstComponent = false;
			p.style.insets = new Insets(5);
			return p;
		}
		protected function treeSelectionChanged ( i : uint ) : void 
		{
			var v : * = _testTree.selectedValue;
			if( v && v.userObject is IDescription )
			{
				var d : IDescription = v.userObject;
				var f : Array = _testTree.getFailuresFor(d);
				if( f.length > 0 )
				{
					var failure : Failure = f[0];
					_testDetails.value = _$( ERROR_LABEL,
											formatTestHeader(d),
											StringUtils.escapeTags(failure.message),
											StringUtils.escapeTags(failure.exception.name),
											StringUtils.escapeTags(failure.exception.message), 
											StringUtils.escapeTags(failure.stackTrace) );	
				}
				else
				{
					_testDetails.value = formatTestHeader(d);
				}
			}
			else
				_testDetails.value = "";
		}
		protected function formatTestHeader( d : IDescription ) : String
		{
			var a : Array = d.getAllMetadata();
			if( a.length > 0 )
				return _$(	"<b>$0</b>\n$1", 
							d.displayName, 
							formatMetaDataAnnotation( a ) );
			else
				return _$( "<b>$0</b>", d.displayName );
		}
		protected function formatMetaDataAnnotation ( a : Array ) : String
		{
			var l : uint = a.length;
			var b : Array = [];
			for(var i : uint = 0;i<l;i++)
			{
				var m : MetaDataAnnotation = a[i];
				switch( m.name )
				{
					case "Suite" : 
					case "Test" : 
					case "TestCase" : 
						var l2 : uint = m.arguments.length;
						for( var j:uint = 0;j<l2;j++)
						{
							var ma : MetaDataArgument = m.arguments[j];
							switch( ma.key )
							{
								case "description" : 
								case "expects" : 
								case "order" : 
									b.push( _$("<i>$0 : </i>$1", capitalize( ma.key ), ma.value) );
									break;
								case "timeout" :
									b.push( _$("<i>$0 : </i>$1ms", capitalize( ma.key ), ma.value) );
									break;
								case "async" : 
									b.push( _("<i>Asynchronous : </i>Yes") );
									break;
							}
						}
						break;
					case "RunWith" : 
						b.push( _$("<i>$0 : </i>$1", capitalize( m.name ), m.arguments[0].key ) );
						break;
					
				}
				
			}
			
			return b.join("\n");
		}
		protected function formatMetaDataArgument ( a : MetaDataArgument, ... args ) : String
		{
			return _$( "$0:$1", 
						a.key, 
						a.value );
		}
		protected function formatTreeNode ( d : * ) : String 
		{
			if( d is IDescription )
				return d.displayName;
			else 
				return d;
		}
		protected function createProgressPanel () : Panel 
		{
			var p : Panel = new Panel();
			p.childrenLayout = new InlineLayout(p, 3, "left", "top", "topToBottom", true );
			p.style.insets = new Insets(5);
			
			_progressBar = new ProgressBar();
			_progressBar.determinate = false;
			_progressLabel = new Label( getProgressLabel () );
			var tf : TextFormat = new TextFormat("Verdana", 11, 0, null, null, null, null );
			tf.tabStops = [ 150, 300, 450];
			
			_progressLabel.style.format = tf;
			p.addComponents( _progressBar, _progressLabel );
			
			return p;
		}
		protected function getProgressLabel () : String
		{
			return _$(  PROGRESS_LABEL, 
						_testPerformed, 
						_testCount, 
						_failureCount, 
						_ignoredCount,
						_result, 
						_currentTest ? _currentTest.displayName : _("None") );
		}
	}
}

package abe.com.ponents.flexunit
{
	import abe.com.mon.utils.StringUtils;
	import abe.com.mon.logs.Log;
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.containers.ScrollPane;
	import abe.com.ponents.containers.SplitPane;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.Dockable;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.layouts.components.BorderLayout;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.models.DefaultBoundedRangeModel;
	import abe.com.ponents.models.TreeModel;
	import abe.com.ponents.models.TreeNode;
	import abe.com.ponents.progress.ProgressBar;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.text.Label;
	import abe.com.ponents.text.TextArea;
	import abe.com.ponents.utils.Insets;

	import org.flexunit.runner.IDescription;
	import org.flexunit.runner.Result;
	import org.flexunit.runner.notification.Failure;
	import org.flexunit.runner.notification.IRunListener;
	/**
	 * @author cedric
	 */
	public class AbeFlexUnitUI extends Panel implements IRunListener, Dockable
	{
		protected var _label : String;
		protected var _icon : Icon;
		
		protected var _testCount : Number;		protected var _testPerformed : Number;		protected var _failureCount : Number;
		
		protected var _testTree : TestTree;		protected var _progressBar : ProgressBar;
		protected var _progressLabel : Label;
		protected var _testDetails : TextArea;

		public function AbeFlexUnitUI ( label : String = "Tests", icon : Icon = null ) 
		{
			_label = label;
			_icon = icon;
			
			_testCount = 0;
			_testPerformed = 0;			_failureCount = 0;
			
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
			_testCount = description.testCount;
			_progressBar.model = new DefaultBoundedRangeModel( 0, 0, _testCount, 1 );
			_progressBar.determinate = true;
			_progressBar.labelUnit = "/" + _testCount;			
			buildTestTree( description );
			
			updateProgressDisplay( );
		}
		public function testRunFinished (result : Result) : void
		{
			Log.debug( "test run finished : " + result.successful );
		}
		public function testStarted (description : IDescription) : void
		{
			Log.debug( "test started : " + description.displayName );
		}
		public function testFinished (description : IDescription) : void
		{
			Log.debug( "test finished : " + description.displayName );
			_testPerformed++;
			updateProgressDisplay ();
		}
		public function testFailure (failure : Failure) : void
		{
			Log.debug( "test failure : " + failure.message );
			_failureCount++;
			_testTree.failures.addElement( failure );
			updateProgressDisplay ();
		}
		public function testAssumptionFailure (failure : Failure) : void
		{
			Log.debug( "test assumption failure : " + failure.message );
		}
		public function testIgnored (description : IDescription) : void
		{
			Log.debug( "test ignored : " + description.displayName );
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
					n.expanded = true;
					fillNode( d, n );
					r.add( n );
				}
			}
		}
		protected function createResultsPanel () : SplitPane 
		{
			_testTree = new TestTree();
			_testTree.addEventListener(ComponentEvent.SELECTION_CHANGE, treeSelectionChange );
			_testTree.itemFormatingFunction = formatTreeNode;
			var sp : ScrollPane = new ScrollPane();			_testDetails = new TextArea();
			_testDetails.allowHTML = true;
			
			sp.view = _testTree;
			
			var p : SplitPane = new SplitPane( SplitPane.HORIZONTAL_SPLIT, sp, _testDetails );
			p.style.insets = new Insets(5);
			return p;
		}
		protected function treeSelectionChange (event : ComponentEvent) : void 
		{
			var v : * = _testTree.selectedValue;
			if( v && v.userObject is IDescription )
			{
				var d : IDescription = v.userObject;
				var f : Array = _testTree.getFailuresFor(d);
				if( f.length > 0 )
				{
					var failure : Failure = f[0];
					_testDetails.value = _$(_("<b>Error : </b>$0\n<b>Stack Trace :</b>$1"),
											failure.exception.message, 
											StringUtils.escapeTags(failure.stackTrace)
											);	
				}
				else
				{
					_testDetails.value = _$(_("$0"), d.displayName );
				}
			}
			else
				_testDetails.value = "";
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
			p.childrenLayout = new InlineLayout(p, 3, "left", "top", "topToBottom", true );			p.style.insets = new Insets(5);
			
			_progressBar = new ProgressBar();
			_progressBar.determinate = false;
			_progressLabel = new Label( getProgressLabel () );

			p.addComponents( _progressBar, _progressLabel );
			
			return p;
		}
		protected function getProgressLabel () : String
		{
			return _$(_( "Test\t\t\t$0/$1\nFailures\t\t\t$2" ), 
						_testPerformed, 
						_testCount, 
						_failureCount );
		}
	}
}

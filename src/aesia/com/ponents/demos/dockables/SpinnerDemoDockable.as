package aesia.com.ponents.demos.dockables 
{
	import aesia.com.mon.geom.dm;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.containers.FieldSet;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.containers.ScrollablePanel;
	import aesia.com.ponents.factory.ComponentFactory;
	import aesia.com.ponents.layouts.components.InlineLayout;
	import aesia.com.ponents.models.SpinnerDateModel;
	import aesia.com.ponents.models.SpinnerListModel;
	import aesia.com.ponents.models.SpinnerNumberModel;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.spinners.DoubleSpinner;
	import aesia.com.ponents.spinners.QuadSpinner;
	import aesia.com.ponents.spinners.Spinner;
	import aesia.com.ponents.utils.Insets;
	/**
	 * @author cedric
	 */
	public class SpinnerDemoDockable extends DemoDockable 
	{
		public function SpinnerDemoDockable (id : String, label : * = null, icon : Icon = null)
		{
			super( id, null, label, icon );
		}
		override public function build (factory : ComponentFactory) : void
		{
			/*
			 * TEXT INPUT
			 */
			buildBatch( factory, Spinner, 
						4, 
						"spinnersDemoSpinner",
						[ // args
							[new SpinnerNumberModel(0, 0, 100, 1, true)],
							[new SpinnerNumberModel(0, 0, 100, 1, true)],
							[new SpinnerDateModel( new Date(2010,6,15),new Date(2010,1,1), new Date(2010,12,31))],
							[new SpinnerListModel("Item 1", "Item 2", "Item 3", "Item 4 ", "Item 5", "Item 6")]
						],
						[ // kwargs
							{},
							{enabled:false},
							{},
							{}
						], // container
						FieldSet, 
						"spinnersDemoSpinnerFieldset", 
						[_("Spinner")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "leftToRight" ) },
						null
			);
			buildBatch(  factory,DoubleSpinner, 
						2, 
						"spinnersDemoDoubleSpinner",
						[ // args
							[dm(50,75),"width","height",0,100,1],
							[dm(50,75),"width","height",0,100,1],
						],
						[ // kwargs
							{},
							{enabled:false},
						], // container
						FieldSet, 
						"spinnersDemoDoubleSpinnerFieldset", 
						[_("DoubleSpinner")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "topToBottom" ) },
						null
			);
			
			buildBatch(  factory,QuadSpinner, 
						2, 
						"spinnersDemoQuadSpinner",
						[ // args
							[new Insets(5),"left","right","top","bottom",0,10,1],
							[new Insets(5),"left","right","top","bottom",0,10,1],
						],
						[ // kwargs
							{},
							{enabled:false},
						], // container
						FieldSet, 
						"spinnersDemoQuadSpinnerFieldset", 
						[_("QuadSpinner")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "topToBottom" ) },
						null
			);
			
			fillBatch(  factory,ScrollablePanel, 
			   		   "spinnersDemoPanel",
			   		    null,
			   			{ 'childrenLayout':new InlineLayout(null, 3, "left", "top", "topToBottom", true ) },
			    		[
			    			"spinnersDemoSpinnerFieldset",			    			"spinnersDemoDoubleSpinnerFieldset",			    			"spinnersDemoQuadSpinnerFieldset"
			    		],			    		
			   			onBuildComplete );
		}
		protected function onBuildComplete ( p : ScrollPane, ctx : Object, objs : Array ) : void 
		{
			ctx["spinnersDemoPanel"].style.setForAllStates("insets", new Insets(4));
			_content = p;
		}
	}
}

package abe.com.prehension.examples.dockables 
{
    import abe.com.mon.geom.dm;
    import abe.com.patibility.lang._;
    import abe.com.ponents.containers.FieldSet;
    import abe.com.ponents.containers.ScrollPane;
    import abe.com.ponents.containers.ScrollablePanel;
    import abe.com.ponents.factory.ComponentFactory;
    import abe.com.ponents.layouts.components.InlineLayout;
    import abe.com.ponents.models.SpinnerDateModel;
    import abe.com.ponents.models.SpinnerListModel;
    import abe.com.ponents.models.SpinnerNumberModel;
    import abe.com.ponents.skinning.icons.Icon;
    import abe.com.ponents.spinners.DoubleSpinner;
    import abe.com.ponents.spinners.QuadSpinner;
    import abe.com.ponents.spinners.Spinner;
    import abe.com.ponents.utils.Insets;
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
			    			"spinnersDemoSpinnerFieldset",
			    			"spinnersDemoDoubleSpinnerFieldset",
			    			"spinnersDemoQuadSpinnerFieldset"
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

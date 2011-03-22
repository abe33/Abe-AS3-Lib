package abe.com.ponents.demos.dockables 
{
	import abe.com.ponents.progress.GradientProgressBar;
	import abe.com.patibility.lang._;
	import abe.com.ponents.containers.FieldSet;
	import abe.com.ponents.containers.ScrollPane;
	import abe.com.ponents.containers.ScrollablePanel;
	import abe.com.ponents.factory.ComponentFactory;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.models.DefaultBoundedRangeModel;
	import abe.com.ponents.progress.MinimalGradientProgressBar;
	import abe.com.ponents.progress.MinimalProgressBar;
	import abe.com.ponents.progress.ProgressBar;
	import abe.com.ponents.skinning.DefaultSkin;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.utils.Insets;
	/**
	 * @author cedric
	 */
	public class ProgressDemoDockable extends DemoDockable 
	{
		public function ProgressDemoDockable (id : String, label : * = null, icon : Icon = null)
		{
			super( id, null, label, icon );
		}
		override public function build (factory : ComponentFactory) : void
		{
			buildBatch( factory, ProgressBar, 
						4, 
						"progressDemoProgressBar",
						[ // args
							[new DefaultBoundedRangeModel(12, 0, 100, 1 ), true ],
							[new DefaultBoundedRangeModel(33, 0, 100, 1 ), false],
							[new DefaultBoundedRangeModel(68, 0, 100, 1 ), false],
							[new DefaultBoundedRangeModel(87, 0, 100, 1 ), true ],
						],
						[ // kwargs
							{},
							{enabled:false},
							{determinate:false},
							{enabled:false},
						], // container
						FieldSet, 
						"progressDemoProgressBarFieldset", 
						[_("ProgressBar")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "topToBottom" ) },
						null
			);
			buildBatch( factory, GradientProgressBar, 
						4, 
						"progressDemoGradientProgressBar",
						[ // args
							[new DefaultBoundedRangeModel(12, 0, 100, 1 ), null, true ],
							[new DefaultBoundedRangeModel(33, 0, 100, 1 ), null, false],
							[new DefaultBoundedRangeModel(68, 0, 100, 1 ), null, false],
							[new DefaultBoundedRangeModel(87, 0, 100, 1 ), null, true ],
						],
						[ // kwargs
							{},
							{},
							{},
							{enabled:false},
						], // container
						FieldSet, 
						"progressDemoGradientProgressBarFieldset", 
						[_("GradientProgressBar")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "topToBottom" ) },
						null
			);
			
			buildBatch( factory, MinimalProgressBar, 
						4, 
						"progressDemoMinimalProgressBar",
						[ // args
							[16, DefaultSkin.SelectionBlue ],
							[43, DefaultSkin.SelectionLightCyan],
							[78, DefaultSkin.SelectionGreen],
							[93, DefaultSkin.SelectionYellow],
						],
						null, // container
						FieldSet, 
						"progressDemoMinimalProgressBarFieldset", 
						[_("Minimal ProgressBar")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "topToBottom" ) },
						null
			);
			buildBatch( factory, MinimalGradientProgressBar, 
						4, 
						"progressDemoMinimalGradientProgressBar",
						[ // args
							[16],
							[43],
							[78],
							[93],
						],
						null, // container
						FieldSet, 
						"progressDemoMinimalGradientProgressBarFieldset", 
						[_("Minimal Gradient ProgressBar")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "topToBottom" ) },
						null
			);
			
			fillBatch( factory, ScrollablePanel, 
			   		   "progressDemoPanel",
			   		    null,
			   			{ 'childrenLayout':new InlineLayout(null, 3, "left", "top", "topToBottom", true ) },
			    		[
			    			"progressDemoProgressBarFieldset",			    			"progressDemoGradientProgressBarFieldset",			    			"progressDemoMinimalProgressBarFieldset",			    			"progressDemoMinimalGradientProgressBarFieldset"
			    		],			    		
			   			onBuildComplete );
		}
		protected function onBuildComplete ( p : ScrollPane, ctx : Object, objs : Array ) : void 
		{
			ctx["progressDemoPanel"].style.setForAllStates("insets", new Insets(4));
			_content = p;
		}
	}
}

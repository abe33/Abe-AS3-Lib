package aesia.com.ponents.demos.dockables 
{
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.containers.FieldSet;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.containers.ScrollablePanel;
	import aesia.com.ponents.factory.ComponentFactory;
	import aesia.com.ponents.layouts.components.InlineLayout;
	import aesia.com.ponents.models.DefaultBoundedRangeModel;
	import aesia.com.ponents.progress.MinimalGradientProgressBar;
	import aesia.com.ponents.progress.MinimalProgressBar;
	import aesia.com.ponents.progress.ProgressBar;
	import aesia.com.ponents.skinning.DefaultSkin;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.utils.Insets;
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
			    			"progressDemoProgressBarFieldset",			    			"progressDemoMinimalProgressBarFieldset",			    			"progressDemoMinimalGradientProgressBarFieldset"
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

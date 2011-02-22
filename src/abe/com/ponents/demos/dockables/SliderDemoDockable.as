package abe.com.ponents.demos.dockables 
{
	import abe.com.patibility.lang._;
	import abe.com.ponents.containers.FieldSet;
	import abe.com.ponents.containers.ScrollPane;
	import abe.com.ponents.containers.ScrollablePanel;
	import abe.com.ponents.factory.ComponentFactory;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.models.DefaultBoundedRangeModel;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.sliders.HSlider;
	import abe.com.ponents.sliders.VSlider;
	import abe.com.ponents.text.Label;
	import abe.com.ponents.utils.Insets;
	/**
	 * @author cedric
	 */
	public class SliderDemoDockable extends DemoDockable 
	{
		public function SliderDemoDockable (id : String, label : * = null, icon : Icon = null)
		{
			super( id, null, label, icon );
		}
		override public function build (factory : ComponentFactory) : void
		{
			buildBatch( factory, HSlider, 
						5, 
						"slidersDemoHSlider",
						[ // args
							[new DefaultBoundedRangeModel( 10 )],
							[new DefaultBoundedRangeModel( 20 )],							[new DefaultBoundedRangeModel( 30, 0, 50 ), 10, 1],							[new DefaultBoundedRangeModel( 30 )],							[new DefaultBoundedRangeModel( 30 )]
						],
						[ // kwargs
							{},
							{snapToTicks:true},
							{displayTicks:true,preferredWidth:300,displayInput:true},							{displayTicks:true,preferredWidth:300,displayInput:true,preComponent:new Label( "min" ),postComponent:new Label( "max" )},
							{displayTicks:true,preferredWidth:300,displayInput:true,preComponent:new Label( "min" ),postComponent:new Label( "max" ), enabled:false}
						], // container
						FieldSet, 
						"slidersDemoHSliderFieldset", 
						[_("Horizontal Sliders")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "topToBottom" ) },
						null
			);
			
			buildBatch( factory,VSlider, 
						5, 
						"slidersDemoVSlider",
						[ // args
							[new DefaultBoundedRangeModel( 10 )],
							[new DefaultBoundedRangeModel( 20 )],
							[new DefaultBoundedRangeModel( 30, 0, 50 ), 10, 1],
							[new DefaultBoundedRangeModel( 30 )],
							[new DefaultBoundedRangeModel( 30 )]
						],
						[ // kwargs
							{},
							{snapToTicks:true},
							{displayTicks:true,preferredHeight:300,displayInput:true},
							{displayTicks:true,preferredHeight:300,displayInput:true,preComponent:new Label( "min" ),postComponent:new Label( "max" )},
							{displayTicks:true,preferredHeight:300,displayInput:true,preComponent:new Label( "min" ),postComponent:new Label( "max" ), enabled:false}
						], // container
						FieldSet, 
						"slidersDemoVSliderFieldset", 
						[_("Vertical Sliders")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "leftToRight" ) },
						null
			);
			
			fillBatch( factory,ScrollablePanel, 
			   		   "slidersDemoPanel",
			   		    null,
			   			{ 'childrenLayout':new InlineLayout(null, 3, "left", "top", "topToBottom", true ) },
			    		[
			    			"slidersDemoHSliderFieldset",			    			"slidersDemoVSliderFieldset"
			    		],			    		
			   			onBuildComplete );
		}
		protected function onBuildComplete ( p : ScrollPane, ctx : Object, objs : Array ) : void 
		{
			ctx["slidersDemoPanel"].style.setForAllStates("insets", new Insets(4));
			_content = p;
		}
	}
}

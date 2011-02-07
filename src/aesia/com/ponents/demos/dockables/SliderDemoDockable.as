package aesia.com.ponents.demos.dockables 
{
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.containers.FieldSet;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.containers.ScrollablePanel;
	import aesia.com.ponents.factory.ComponentFactory;
	import aesia.com.ponents.layouts.components.InlineLayout;
	import aesia.com.ponents.models.DefaultBoundedRangeModel;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.sliders.HSlider;
	import aesia.com.ponents.sliders.VSlider;
	import aesia.com.ponents.text.Label;
	import aesia.com.ponents.utils.Insets;
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
							[new DefaultBoundedRangeModel( 20 )],
						],
						[ // kwargs
							{},
							{snapToTicks:true},
							{displayTicks:true,preferredWidth:300,displayInput:true},
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
			    			"slidersDemoHSliderFieldset",
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
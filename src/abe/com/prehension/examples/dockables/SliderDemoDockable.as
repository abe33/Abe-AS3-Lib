package abe.com.prehension.examples.dockables 
{
    import abe.com.mon.geom.Range;
    import abe.com.patibility.lang._;
    import abe.com.ponents.containers.FieldSet;
    import abe.com.ponents.containers.Panel;
    import abe.com.ponents.containers.ScrollPane;
    import abe.com.ponents.containers.ScrollablePanel;
    import abe.com.ponents.factory.ComponentFactory;
    import abe.com.ponents.layouts.components.GridLayout;
    import abe.com.ponents.layouts.components.InlineLayout;
    import abe.com.ponents.models.DefaultBoundedRangeModel;
    import abe.com.ponents.models.RangeBoundedRangeModel;
    import abe.com.ponents.skinning.icons.Icon;
    import abe.com.ponents.sliders.HLogarithmicSlider;
    import abe.com.ponents.sliders.HRangeSlider;
    import abe.com.ponents.sliders.HSlider;
    import abe.com.ponents.sliders.VLogarithmicSlider;
    import abe.com.ponents.sliders.VRangeSlider;
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
							[new DefaultBoundedRangeModel( 20 )],
							[new DefaultBoundedRangeModel( 30, 0, 50 ), 10, 1],
							[new DefaultBoundedRangeModel( 30 )],
							[new DefaultBoundedRangeModel( 30 )]
						],
						[ // kwargs
							{},
							{snapToTicks:true},
							{displayTicks:true,preferredWidth:300,displayInput:false},
							{displayTicks:true,preferredWidth:300,displayInput:true,preComponent:new Label( "min" ),postComponent:new Label( "max" )},
							{displayTicks:true,preferredWidth:300,displayInput:true,preComponent:new Label( "min" ),postComponent:new Label( "max" ), enabled:false}
						], // container
						FieldSet, 
						"slidersDemoHSliderFieldset", 
						[_("Horizontal Sliders")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "topToBottom" ) },
						null
			);
			buildBatch( factory, HRangeSlider, 
						5, 
						"slidersDemoHRangeSlider",
						[ // args
							[new RangeBoundedRangeModel(new Range(5,20), 0, 100)],
							[new RangeBoundedRangeModel(new Range(15,45), 0, 100)],
							[new RangeBoundedRangeModel(new Range(10,90), 0, 100), 10, 1],
							[new RangeBoundedRangeModel(new Range(45,55), 0, 100)],
							[new RangeBoundedRangeModel(new Range(60,85), 0, 100)]
						],
						[ // kwargs
							{},
							{snapToTicks:true},
							{displayTicks:true,preferredWidth:300,displayInput:false},
							{displayTicks:true,preferredWidth:300,displayInput:true,preComponent:new Label( "min" ),postComponent:new Label( "max" )},
							{displayTicks:true,preferredWidth:300,displayInput:true,preComponent:new Label( "min" ),postComponent:new Label( "max" ), enabled:false}
						], // container
						FieldSet, 
						"slidersDemoHRangeSliderFieldset", 
						[_("Horizontal Range Sliders")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "topToBottom" ) },
						null
			);
			buildBatch( factory, HLogarithmicSlider, 
						3, 
						"slidersDemoHLogarithmicSlider",
						[ // args
							[new DefaultBoundedRangeModel( 10, 0.1 )],
							[new DefaultBoundedRangeModel( 30, 0.1 )],
							[new DefaultBoundedRangeModel( 70, 0.1 )]
						],
						[ // kwargs
							{},
							{displayTicks:true,preferredWidth:300,displayInput:false},
							{displayTicks:true,preferredWidth:300,displayInput:true,enabled:false},
						], // container
						FieldSet, 
						"slidersDemoHLogarithmicSliderFieldset", 
						[_("Hrizontal Logarithmic Sliders")], 
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
							{displayTicks:true,preferredHeight:300,displayInput:false},
							{displayTicks:true,preferredHeight:300,displayInput:true,preComponent:new Label( "min" ),postComponent:new Label( "max" )},
							{displayTicks:true,preferredHeight:300,displayInput:true,preComponent:new Label( "min" ),postComponent:new Label( "max" ), enabled:false}
						], // container
						FieldSet, 
						"slidersDemoVSliderFieldset", 
						[_("Vertical Sliders")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "leftToRight" ) },
						null
			);
			
			buildBatch( factory, VRangeSlider, 
						5, 
						"slidersDemoVRangeSlider",
						[ // args
							[new RangeBoundedRangeModel(new Range(5,20), 0, 100)],
							[new RangeBoundedRangeModel(new Range(15,45), 0, 100)],
							[new RangeBoundedRangeModel(new Range(10,90), 0, 100), 10, 1],
							[new RangeBoundedRangeModel(new Range(45,55), 0, 100)],
							[new RangeBoundedRangeModel(new Range(60,85), 0, 100)]
						],
						[ // kwargs
							{},
							{snapToTicks:true},
							{displayTicks:true,preferredHeight:300,displayInput:false},
							{displayTicks:true,preferredHeight:300,displayInput:true,preComponent:new Label( "min" ),postComponent:new Label( "max" )},
							{displayTicks:true,preferredHeight:300,displayInput:true,preComponent:new Label( "min" ),postComponent:new Label( "max" ), enabled:false}
						], // container
						FieldSet, 
						"slidersDemoVRangeSliderFieldset", 
						[_("Vertical Range Sliders")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "leftToRight" ) },
						null
			);
			
			buildBatch( factory, VLogarithmicSlider, 
						3, 
						"slidersDemoVLogarithmicSlider",
						[ // args
							[new DefaultBoundedRangeModel( 10, 0.1 )],
							[new DefaultBoundedRangeModel( 30, 0.1, 50 )],
							[new DefaultBoundedRangeModel( 30, 0.1 )],
						],
						[ // kwargs
							{},
							{displayTicks:true,preferredHeight:300,displayInput:false},
							{displayTicks:true,preferredHeight:300,displayInput:true,enabled:false}
						], // container
						FieldSet, 
						"slidersDemoVLogarithmicSliderFieldset", 
						[_("Vertical Logarithmic Sliders")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "leftToRight" ) },
						null
			);
			fillBatch( factory,Panel, 
			   		   "hslidersDemoPanel",
			   		    null,
			   			{ 'childrenLayout':new GridLayout(null, 1, 3, 10, 3) },
			    		[
			    			"slidersDemoHSliderFieldset",
			    			"slidersDemoHRangeSliderFieldset",
			    			"slidersDemoHLogarithmicSliderFieldset"
			    		] );
			 
			fillBatch( factory,Panel, 
			   		   "vslidersDemoPanel",
			   		    null,
			   			{ 'childrenLayout':new GridLayout(null, 1, 3, 10, 3) },
			    		[
			    			"slidersDemoVSliderFieldset",
			    			"slidersDemoVRangeSliderFieldset",
			    			"slidersDemoVLogarithmicSliderFieldset"
			    		] );
			   			
			fillBatch( factory,ScrollablePanel, 
			   		   "slidersDemoPanel",
			   		    null,
			   			{ 'childrenLayout':new InlineLayout(null, 3, "left", "top", "topToBottom", true ) },
			    		[
			    			"hslidersDemoPanel",
			    			"vslidersDemoPanel"
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

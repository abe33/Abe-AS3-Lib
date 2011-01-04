package aesia.com.ponents.demos.dockables 
{
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.containers.FieldSet;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.containers.ScrollablePanel;
	import aesia.com.ponents.factory.ComponentFactory;
	import aesia.com.ponents.layouts.components.InlineLayout;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.text.TextArea;
	import aesia.com.ponents.text.TextInput;
	import aesia.com.ponents.utils.Insets;
	/**
	 * @author cedric
	 */
	public class TextDemoDockable extends DemoDockable 
	{
		public function TextDemoDockable (id : String, label : * = null, icon : Icon = null)
		{
			super( id, null, label, icon );
		}
		override public function build (factory : ComponentFactory) : void
		{
			/*
			 * TEXT INPUT
			 */
			buildBatch( factory, TextInput, 
						4, 
						"textDemoInput",
						[ // args
							[50],
							[20,true],
							[],
							[20,true]
						],
						[ // kwargs
							{value:"TextInput"},
							{value:"password"},
							{enabled:false, value:"Disabled TextInput"},
							{enabled:false, value:"password"}
						], // container
						FieldSet, 
						"textDemoInputFieldset", 
						[_("TextInput")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "leftToRight" ) },
						null
			);
			/*
			 * TEXT INPUT
			 */
			buildBatch( factory, TextArea, 
						2, 
						"textDemoTextArea",
						null,
						[ // kwargs
							{value:"A text area"},
							{enabled:false, value:"A disabled text area"},
						], // container
						FieldSet, 
						"textDemoTextAreaFieldset", 
						[_("TextArea")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "leftToRight" ) },
						null
			);
			
			fillBatch( factory, ScrollablePanel, 
			   		   "textDemoPanel",
			   		    null,
			   			{ 'childrenLayout':new InlineLayout(null, 3, "left", "top", "topToBottom", true ) },
			    		[
			    			"textDemoInputFieldset",			    			"textDemoTextAreaFieldset"
			    		],			    		
			   			onBuildComplete );
		}
		protected function onBuildComplete ( p : ScrollPane, ctx : Object, objs : Array ) : void 
		{
			ctx["textDemoPanel"].style.setForAllStates("insets", new Insets(4));
			_content = p;
		}
	}
}

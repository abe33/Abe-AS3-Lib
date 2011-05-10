package abe.com.prehension.examples.dockables 
{
	import abe.com.patibility.lang._;
	import abe.com.ponents.containers.FieldSet;
	import abe.com.ponents.containers.ScrollPane;
	import abe.com.ponents.containers.ScrollablePanel;
	import abe.com.ponents.factory.ComponentFactory;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.text.TextArea;
	import abe.com.ponents.text.TextInput;
	import abe.com.ponents.utils.Insets;
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
			buildBatch( factory, TextArea, 
						1, 
						"textAreaSpellingDemo", 
						null, 
						[
							{ 
								'allowHTML':true,
								'value':"thiis is a wrongly spelled word in TextArea, use context menu to see suggestions.\n\n\n\n<font size='20'>A big text</font>\n<u>miiispelled</u> waurd.",
								'setSpellCheckerDictionnary':["../res/en_US.aff", "../res/en_US.dic"],
								'spellCheckEnabled':true
							}
						], 
						FieldSet, 
						"textAreaSpellingFieldSet", 
						[_(" TextArea Spelling")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "leftToRight" ) }, 
						null 
			);
			buildBatch( factory, TextInput, 
						1, 
						"textInputSpellingDemo", 
						null, 
						[
							{ 
								'value':"I Can't wriite wel",
								'setSpellCheckerDictionnary':["../res/en_US.aff", "../res/en_US.dic"],
								'spellCheckEnabled':true
							}
						], 
						FieldSet, 
						"textInputSpellingFieldSet", 
						[_(" TextInput Spelling")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "leftToRight" ) }, 
						null 
			);
			
			fillBatch( factory, ScrollablePanel, 
			   		   "textDemoPanel",
			   		    null,
			   			{ 'childrenLayout':new InlineLayout(null, 3, "left", "top", "topToBottom", true ) },
			    		[
			    			"textDemoInputFieldset",
			    			"textDemoTextAreaFieldset",
			    			"textAreaSpellingFieldSet",
			    			"textInputSpellingFieldSet"
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

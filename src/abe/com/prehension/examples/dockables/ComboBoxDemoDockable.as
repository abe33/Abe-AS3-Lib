package abe.com.prehension.examples.dockables 
{
	import abe.com.patibility.lang._;
	import abe.com.ponents.containers.FieldSet;
	import abe.com.ponents.containers.ScrollPane;
	import abe.com.ponents.containers.ScrollablePanel;
	import abe.com.ponents.factory.ComponentFactory;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.menus.ComboBox;
	import abe.com.ponents.menus.FontListComboBox;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.skinning.icons.magicIconBuild;
	import abe.com.ponents.utils.Insets;
	/**
	 * @author cedric
	 */
	public class ComboBoxDemoDockable extends DemoDockable 
	{
		public function ComboBoxDemoDockable (id : String, label : * = null, icon : Icon = null)
		{
			super( id, null, label, icon );
		}
		override public function build (factory : ComponentFactory) : void
		{
			buildBatch( factory,
						ComboBox, 
						4, 
						"comboBoxesDemoComboBox",
						[ // args
							["Item 1", "Item 2", "Item 3", "Item 4", "Item 5 with a longer text", "Item 6", "Item 7"],
							["Item 1", "Item 2", "Item 3", "Item 4", "Item 5 with a longer text", "Item 6", "Item 7"],
							["Item 1", "Item 2", "Item 3", "Item 4", "Item 5 with a longer text", "Item 6", "Item 7"],
							["Item 1", "Item 2", "Item 3", "Item 4", "Item 5 with a longer text", "Item 6", "Item 7"],
						],
						[ // kwargs
							{icon:magicIconBuild("../res/icons/control_play_blue.png")},
							{enabled:false,icon:magicIconBuild("../res/icons/control_play_blue.png")},
							{popupAsDropDown:true,icon:magicIconBuild("../res/icons/control_play_blue.png")},
							{popupAlignOnSelection:true}
						], // container
						FieldSet, 
						"comboBoxesDemoComboBoxFieldset", 
						[_("ComboBox")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "topToBottom" ) },
						null
			);
			
			factory.group("movables").build(FontListComboBox, "fontListComboBox", [true] );
			
			fillBatch( factory, ScrollablePanel, 
			   		   "comboBoxesDemoPanel",
			   		    null,
			   			{ 'childrenLayout':new InlineLayout(null, 3, "left", "top", "topToBottom", true ) },
			    		[
			    			"comboBoxesDemoComboBoxFieldset",
			    		],			    		
			   			onBuildComplete );
		}
		protected function onBuildComplete ( p : ScrollPane, ctx : Object, objs : Array ) : void 
		{
			ctx["comboBoxesDemoComboBoxFieldset"].addComponent( ctx["fontListComboBox"] );
			ctx["comboBoxesDemoPanel"].style.setForAllStates("insets", new Insets(4));
			_content = p;
		}
	}
}

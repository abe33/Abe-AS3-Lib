package aesia.com.ponents.demos.dockables 
{
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.containers.FieldSet;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.containers.ScrollablePanel;
	import aesia.com.ponents.factory.ComponentFactory;
	import aesia.com.ponents.layouts.components.InlineLayout;
	import aesia.com.ponents.menus.ComboBox;
	import aesia.com.ponents.menus.FontListComboBox;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.ponents.utils.Insets;
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
							["Item 1", "Item 2", "Item 3", "Item 4", "Item 5 with a longer text", "Item 6", "Item 7"],							["Item 1", "Item 2", "Item 3", "Item 4", "Item 5 with a longer text", "Item 6", "Item 7"],							["Item 1", "Item 2", "Item 3", "Item 4", "Item 5 with a longer text", "Item 6", "Item 7"],							["Item 1", "Item 2", "Item 3", "Item 4", "Item 5 with a longer text", "Item 6", "Item 7"],
						],
						[ // kwargs
							{icon:magicIconBuild("icons/control_play_blue.png")},
							{enabled:false,icon:magicIconBuild("icons/control_play_blue.png")},
							{popupAsDropDown:true,icon:magicIconBuild("icons/control_play_blue.png")},
							{popupAlignOnSelection:true}
						], // container
						FieldSet, 
						"comboBoxesDemoComboBoxFieldset", 
						[_("ComboBox")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "topToBottom" ) },
						null
			);
			
			factory.group("movables").build(FontListComboBox, "fontListComboBox");
			
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

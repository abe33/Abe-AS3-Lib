package aesia.com.ponents.demos.dockables 
{
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.factory.ComponentFactory;
	import aesia.com.ponents.layouts.components.GridLayout;
	import aesia.com.ponents.lists.List;
	import aesia.com.ponents.lists.ListLineRuler;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.utils.Insets;
	/**
	 * @author cedric
	 */
	public class ListDemoDockable extends DemoDockable 
	{
		public function ListDemoDockable (id : String, label : * = null, icon : Icon = null)
		{
			super( id, null, label, icon );
		}
		override public function build (factory : ComponentFactory) : void
		{
			factory.group("movables"
								   ).build( List, 
								   			"listsDemoMultiSelectionList", 
								   			[
								   			 "Item 1 of an editable & draggable list",
											 "Item 2",
											 "Item 3 with a longer text.",
											 "Item 4",
											 "Item 5",
											 "Item 6",
											 "Item 7",
											 "Item 8",
											 "Item 9",
											 "Item 10"
								   			], 
								   			{allowMultiSelection:true}
								   ).build( List, 
								   			"listsDemoStaticList", 
								   			[
								   			 "Item 1 of a static list",
											 "Item 2",
											 "Item 3 with a longer text.",
											 "Item 4",
											 "Item 5",
											 "Item 6",
											 "Item 7",
											 "Item 8",
											 "Item 9",
											 "Item 10"
								   			], 
								   			{editEnabled:false, allowMultiSelection:false, dragEnabled:false, dropEnabled:false}
								   ).build( List, 
								   			"listsDemoDisabledStaticList", 
								   			[
								   			 "Item 1 of a disabled list",
											 "Item 2",
											 "Item 3 with a longer text.",
											 "Item 4",
											 "Item 5",
											 "Item 6",
											 "Item 7",
											 "Item 8",
											 "Item 9",
											 "Item 10"
								   			], 
								   			{editEnabled:false, allowMultiSelection:false, dragEnabled:false, dropEnabled:false, enabled:false});
			
			factory.group("containers"
								   ).build(	ScrollPane, 
								   			"listsDemoMultiSelectionListPane", 
								   			null, 
								   			function( sp : ScrollPane, ctx:Object ):Object
								   			{
								   				return { view:ctx["listsDemoMultiSelectionList"], rowHead:new ListLineRuler(ctx["listsDemoMultiSelectionList"])};					   			
								   			}
								   ).build(	ScrollPane, 
								   			"listsDemoStaticListPane", 
								   			null, 
								   			function( sp : ScrollPane, ctx:Object ):Object
								   			{
								   				return { view:ctx["listsDemoStaticList"], rowHead:new ListLineRuler(ctx["listsDemoStaticList"])};					   			
								   			}
								   ).build(	ScrollPane, 
								   			"listsDemoDisabledStaticListPane", 
								   			null, 
								   			function( sp : ScrollPane, ctx:Object ):Object
								   			{
								   				return { view:ctx["listsDemoDisabledStaticList"], rowHead:new ListLineRuler(ctx["listsDemoDisabledStaticList"])};					   			
								   			}
								   ).build( Panel, 
							   		   "listsDemoPanel",
							   		    null,
							   			{ 'childrenLayout':new GridLayout(null, 1, 3, 3, 3) },
							   			onBuildComplete
							   	   );
			
		}
		protected function onBuildComplete ( p : Panel, ctx : Object ) : void 
		{
			ctx["listsDemoPanel"].addComponent(ctx["listsDemoMultiSelectionListPane"]);
			
			ctx["listsDemoPanel"].style.setForAllStates("insets", new Insets(4));
			_content = p;
		}
	}
}
package aesia.com.ponents.demos.dockables 
{
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.factory.ComponentFactory;
	import aesia.com.ponents.layouts.components.GridLayout;
	import aesia.com.ponents.lists.ListLineRuler;
	import aesia.com.ponents.models.TreeModel;
	import aesia.com.ponents.models.TreeNode;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.trees.Tree;
	import aesia.com.ponents.utils.Insets;
	/**
	 * @author cedric
	 */
	public class TreeDemoDockable extends DemoDockable 
	{
		public function TreeDemoDockable (id : String, label : * = null, icon : Icon = null)
		{
			super( id, null, label, icon );
		}
		override public function build (factory : ComponentFactory) : void
		{
			factory.group("movables"
								   ).build( Tree, 
								   			"treesDemoMultiSelectionTree", 
								   			function( ctx : Object ) : Array 
								   			{
								   			
								   				var r : TreeNode = new TreeNode("Root");
								   				for(var i:uint=0;i<10;i++)
								   				{
								   					r.add( new TreeNode( "Item "+ ( i+1 ) ) );
								   				}
								   				var m : TreeModel = new TreeModel(r);
								   				return [m];
								   			}, 
								   			{allowMultiSelection:true}
								   ).build( Tree, 
								   			"treesDemoStaticTree", 
								   			function( ctx : Object ) : Array 
								   			{
								   			
								   				var r : TreeNode = new TreeNode("Root");
								   				for(var i:uint=0;i<10;i++)
								   				{
								   					r.add( new TreeNode( "Item "+ ( i+1 ) ) );
								   				}
								   				var m : TreeModel = new TreeModel(r);
								   				return [m];
								   			}, 
								   			{allowMultiSelection:false,dragEnabled:false,dropEnabled:false,editEnabled:false}
								   ).build( Tree, 
								   			"treesDemoDisabledStaticTree", 
								   			function( ctx : Object ) : Array 
								   			{
								   				var r : TreeNode = new TreeNode("Root");
								   				for(var i:uint=0;i<10;i++)
								   				{
								   					r.add( new TreeNode( "Item "+ ( i+1 ) ) );
								   				}
								   				var m : TreeModel = new TreeModel(r);
								   				return [m];
								   			}, 
								   			{allowMultiSelection:false,dragEnabled:false,dropEnabled:false,editEnabled:false,enabled:false}
								   );
			
			factory.group("containers"
								   ).build(	ScrollPane, 
								   			"treesDemoMultiSelectionTreePane", 
								   			null, 
								   			function( sp : ScrollPane, ctx:Object ):Object
								   			{
								   				return { view:ctx["treesDemoMultiSelectionTree"], rowHead:new ListLineRuler(ctx["treesDemoMultiSelectionTree"])};					   			
								   			}
								   ).build(	ScrollPane, 
								   			"treesDemoStaticTreePane", 
								   			null, 
								   			function( sp : ScrollPane, ctx:Object ):Object
								   			{
								   				return { view:ctx["treesDemoStaticTree"], rowHead:new ListLineRuler(ctx["treesDemoStaticTree"])};					   			
								   			}
								   ).build(	ScrollPane, 
								   			"treesDemoDisabledStaticTreePane", 
								   			null, 
								   			function( sp : ScrollPane, ctx:Object ):Object
								   			{
								   				return { view:ctx["treesDemoDisabledStaticTree"], rowHead:new ListLineRuler(ctx["treesDemoDisabledStaticTree"])};					   			
								   			}
								   ).build( Panel, 
							   		   "treesDemoPanel",
							   		    null,
							   			{ 'childrenLayout':new GridLayout(null, 1, 3, 3, 3) },
							   			onBuildComplete
							   	   );
			
		}
		protected function onBuildComplete ( p : Panel, ctx : Object ) : void 
		{
			ctx["treesDemoPanel"].addComponents(ctx["treesDemoMultiSelectionTreePane"], 
												ctx["treesDemoStaticTreePane"], 
												ctx["treesDemoDisabledStaticTreePane"]);
			
			ctx["treesDemoPanel"].style.setForAllStates("insets", new Insets(4));
			_content = p;
		}
	}
}

package aesia.com.ponents.trees 
{
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.actions.ProxyAction;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.buttons.ButtonDisplayModes;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.containers.ToolBar;
	import aesia.com.ponents.skinning.icons.magicIconBuild;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="TreeHeader")]
	[Skin(define="TreeHeader",
		  inherit="ToolBar",
		  preview="aesia.com.ponents.trees::TreeHeader.defaultTreeHeaderPreview",
		  previewAcceptStyleSetup="false"
	)]
	public class TreeHeader extends ToolBar
	{
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		static public function defaultTreeHeaderPreview () : ScrollPane
		{
			var scp : ScrollPane = new ScrollPane();
			scp.view = Tree.defaultTreePreview();
			scp.colHead = new TreeHeader(scp.view as Tree, ButtonDisplayModes.ICON_ONLY, false);
			
			return scp;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		protected var _tree : Tree;
		
		public function TreeHeader ( tree : Tree, displayMode : uint = 0, dragEnabled : Boolean = true)
		{			
			super( displayMode, dragEnabled );
			this._tree = tree;
			this.
			
			addComponent( new Button( new ProxyAction(_tree.collapseAll, _("Collapse All"), magicIconBuild( DefaultTreeCell.TREE_NODE_COLLAPSE_ICON ) ) ) );						addComponent( new Button( new ProxyAction(_tree.expandAll, _("Expand All"), magicIconBuild( DefaultTreeCell.TREE_NODE_EXPAND_ICON ) ) ) );			
		}
	}
}

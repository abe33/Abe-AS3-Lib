package abe.com.ponents.trees 
{
    import abe.com.patibility.lang._;
    import abe.com.ponents.actions.ProxyAction;
    import abe.com.ponents.buttons.Button;
    import abe.com.ponents.buttons.ButtonDisplayModes;
    import abe.com.ponents.containers.ScrollPane;
    import abe.com.ponents.containers.ToolBar;
    import abe.com.ponents.skinning.icons.magicIconBuild;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="TreeHeader")]
	[Skin(define="TreeHeader",
		  inherit="ToolBar",
		  preview="abe.com.ponents.trees::TreeHeader.defaultTreeHeaderPreview",
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

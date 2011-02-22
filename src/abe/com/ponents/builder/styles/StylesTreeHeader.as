package abe.com.ponents.builder.styles 
{
	import abe.com.ponents.buttons.ButtonDisplayModes;
	import abe.com.patibility.lang._;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.text.TextInput;
	import abe.com.ponents.trees.Tree;
	import abe.com.ponents.trees.TreeHeader;
	/**
	 * @author cedric
	 */
	public class StylesTreeHeader extends TreeHeader 
	{
		protected var _searchInput : TextInput;

		public function StylesTreeHeader (tree : Tree, displayMode : uint = 0, dragEnabled : Boolean = true)
		{
			super( tree, displayMode, dragEnabled );
			
			buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			_searchInput = new TextInput(0,false,"styleSearch", false);
			_searchInput.tooltip = _("Search in the tree structure.");
			addSeparator();
			addComponent( _searchInput );
			_searchInput.addEventListener(ComponentEvent.DATA_CHANGE, searchDataChange );
		}
		protected function searchDataChange (event : ComponentEvent) : void
		{
			( _tree as StylesTree ).searchStyle( _searchInput.value );
		}
	}
}

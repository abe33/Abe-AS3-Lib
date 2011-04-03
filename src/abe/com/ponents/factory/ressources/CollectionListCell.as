package abe.com.ponents.factory.ressources 
{
	import abe.com.ponents.skinning.icons.magicIconBuild;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.layouts.display.DOInlineLayout;
	import abe.com.ponents.lists.DefaultListCell;
	import abe.com.ponents.utils.Directions;
	/**
	 * @author cedric
	 */
	public class CollectionListCell extends DefaultListCell 
	{
		[Embed(source="../../skinning/icons/package.png")]
		static public var packageIcon : Class;
		
		public function CollectionListCell ()
		{
			super();
			( _childrenLayout as DOInlineLayout).direction = Directions.RIGHT_TO_LEFT;
			( _childrenLayout as DOInlineLayout).spacing = 5;
			( _childrenLayout as DOInlineLayout).spacingAtExtremity = true;
			this.icon = magicIconBuild( packageIcon );
		}
		
		override protected function formatLabel (value : *) : String 
		{
			var c : ClassCollection = value as ClassCollection;
			if( c )
				return _$("$0\n<font size='9' color='#666666'><i>$1\n$2</i></font>", c.collectionName, c.collectionURL, c.collectionType );
			else
				return super.formatLabel( value );
		}
	}
}

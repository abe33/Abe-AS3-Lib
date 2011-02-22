package abe.com.ponents.lists 
{
	import abe.com.mon.utils.StringUtils;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="ListLineRuler")]
	[Skin(define="ListLineRuler",
			  inherit="NoDecorationComponent",
			  state__all__textColor="skin.rulerTextColor"
	)]
	public class ListLineRulerCell extends DefaultListCell
	{
		protected var _indexStartAt0 : Boolean;
		
		public function ListLineRulerCell ()
		{
			super( );
			_indexStartAt0 = false;
		}

		override public function set value (val : *) : void
		{}
	
		override public function set index (id : uint) : void
		{
			super.index = id;
			indexStartAt0 = indexStartAt0;
		}

		override public function invalidatePreferredSizeCache () : void
		{
			super.invalidatePreferredSizeCache( );
			if( _owner )
				_preferredSizeCache.height = (_owner as ListLineRuler).list.listLayout.lastPreferredCellHeight;
		}

		public function get indexStartAt0 () : Boolean { return _indexStartAt0; }		
		public function set indexStartAt0 (indexStartAt0 : Boolean) : void
		{
			_indexStartAt0 = indexStartAt0;
			super.label = StringUtils.fill( String( _index + (_indexStartAt0 ? 0 : 1 ) ), String( _owner.model.size ).length );
		}
	}
}

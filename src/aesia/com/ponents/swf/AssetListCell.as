package aesia.com.ponents.swf
{
	import aesia.com.mon.logs.Log;
	import aesia.com.ponents.layouts.display.DOInlineLayout;
	import aesia.com.ponents.lists.DefaultListCell;
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.ponents.utils.Directions;

	/**
	 * @author Cédric Néhémie
	 */
	public class AssetListCell extends DefaultListCell
	{
		public function AssetListCell () 
		{
			super();
			( _childrenLayout as DOInlineLayout).direction = Directions.RIGHT_TO_LEFT;
			( _childrenLayout as DOInlineLayout).spacing = 5;
			( _childrenLayout as DOInlineLayout).spacingAtExtremity = true;
		}

		override public function set value ( val : * ) : void
		{
			try
			{
				var a : LibraryAsset = val as LibraryAsset;
				if( a )
					this.icon = magicIconBuild( a.type );
				
				super.value = a;
			}
			catch( e : Error ) 
			{
				Log.error( val + " seems to be not valid\n" + e.message + "\n" + e.getStackTrace() );
			}
			//label = getQualifiedClassName( val );
		}

		override protected function formatLabel (value : *) : String 
		{
			return "<b>" + value.packagePath + "</b>\n" +
					"Type : " + this.icon.contentType;
		}
	}
}
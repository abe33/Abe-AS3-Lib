package abe.com.ponents.ressources
{
	import abe.com.mon.geom.dm;
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.layouts.display.DOInlineLayout;
	import abe.com.ponents.layouts.display.DOStretchLayout;
	import abe.com.ponents.lists.DefaultListCell;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.skinning.icons.magicIconBuild;
	import abe.com.ponents.utils.Directions;
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
			if( val == _value )
				return;
			
			var a : LibraryAsset = val as LibraryAsset;
			try
			{
				if( a )
				{
					var f : Function = ClassCollectionViewer.getTypeHandler( a ).getIconHandler();
					var i  : Icon;
					
					if( f != null )
						i = f( a );
					else
						i = magicIconBuild( a.type );
					
					( i.childrenLayout as DOStretchLayout ).keepRatio = true;
					i.preferredSize = dm(40,40);
					this.icon = i;
				}
			}
			catch( e : Error ) 
			{
				this.icon = null;
			}
			super.value = a;
		}

		override protected function formatLabel (value : *) : String 
		{
			if( value is LibraryAsset )
			{
				var la : LibraryAsset = value as LibraryAsset;
				return _$( "$0\n<font size='9' color='#666666'>In : <i>$1</i>\nType : <i>$2</i></font>", la.name, la.packagePath, icon ? icon.contentType : _("Unknown") );
			}
			else
				return super.formatLabel(value);
		}
	}
}
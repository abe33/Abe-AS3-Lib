package abe.com.ponents.demos.editors 
{
	import abe.com.ponents.ressources.ClassCollection;
	import abe.com.ponents.skinning.icons.DOIcon;
	import abe.com.ponents.skinning.icons.EmbeddedBitmapIcon;
	import abe.com.ponents.skinning.icons.ExternalBitmapIcon;
	import abe.com.ponents.skinning.icons.FontIcon;
	import abe.com.ponents.skinning.icons.SWFIcon;
	/**
	 * @author cedric
	 */
	public class CoreIcons extends ClassCollection 
	{
		public function CoreIcons ()
		{
			super( );
			collectionName = "Core Icons";
			collectionType = "icons";
			classes = [ EmbeddedBitmapIcon, 
						ExternalBitmapIcon,
						DOIcon,
						SWFIcon, 
						FontIcon ];
		}
	}
}

package abe.com.prehension.tools
{
	import abe.com.ponents.ressources.ClassCollection;
	import abe.com.ponents.skinning.icons.*;

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

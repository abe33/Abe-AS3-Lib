package abe.com.ponents.buttons 
{
    import abe.com.mands.*;
    import abe.com.mon.utils.KeyStroke;
    import abe.com.mon.utils.Reflection;
    import abe.com.patibility.lang._;
    import abe.com.ponents.forms.FormComponent;
    import abe.com.ponents.ressources.CollectionsLoader;
    import abe.com.ponents.ressources.LibraryAsset;
    import abe.com.ponents.ressources.actions.BrowseRessources;
    import abe.com.ponents.skinning.icons.Icon;

    import flash.system.ApplicationDomain;
	/**
	 * @author cedric
	 */
	public class RessourcePicker extends AbstractFormButton implements FormComponent
	{
		public function RessourcePicker ( collectionsLoader : CollectionsLoader, 
										  ressourceType : String = null, 
										  ressource : * = null,
										  icon : Icon = null, 
										  accelerator : KeyStroke = null )
		{
			var act : BrowseRessources = new BrowseRessources(collectionsLoader, ressourceType, _("No ressource"), icon, null, accelerator)
			super( act );
			if( ressource )
			{
				act.ressource = new LibraryAsset( Reflection.getClass( ressource ), "null", ApplicationDomain.currentDomain );
				act.name = act.ressource.name;
			}
		}
		override protected function commandEnd ( c : Command ) : void 
		{
			var act : BrowseRessources = _action as BrowseRessources;
			if( act.ressource )
				act.name = act.ressource.name;
			else
				act.name = _("No ressource");
			
			super.commandEnded( c );
		}
		
		override public function get value () : * 
		{ 
			var res : LibraryAsset = (_action as BrowseRessources).ressource;
			return res ? res.type : null; 
		}
		override public function set value (v : *) : void
		{
			if( v && !(v is LibraryAsset) )
			{
				if( v is Class )
					v = new LibraryAsset( v, "null", ApplicationDomain.currentDomain );
				else
					v = new LibraryAsset( Reflection.getClass( v ), "null", ApplicationDomain.currentDomain );
			}
			(_action as BrowseRessources).ressource = v;
		}
	}
}

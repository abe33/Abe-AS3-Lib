package abe.com.ponents.buttons 
{
	import abe.com.mands.events.CommandEvent;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.mon.utils.Reflection;
	import abe.com.patibility.lang._;
	import abe.com.ponents.forms.FormComponent;
	import abe.com.ponents.forms.FormComponentDisabledModes;
	import abe.com.ponents.ressources.CollectionsLoader;
	import abe.com.ponents.ressources.LibraryAsset;
	import abe.com.ponents.ressources.actions.BrowseRessources;
	import abe.com.ponents.skinning.icons.Icon;

	import flash.system.ApplicationDomain;
	/**
	 * @author cedric
	 */
	public class RessourcePicker extends Button implements FormComponent
	{
		protected var _disabledMode : uint;
		protected var _disabledValue : *;

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
		override protected function commandEnd (event : CommandEvent) : void 
		{
			var act : BrowseRessources = _action as BrowseRessources;
			if( act.ressource )
				act.name = act.ressource.name;
			else
				act.name = _("No ressource");
			
			super.commandEnded( event );
		}
		public function get disabledMode () : uint { return _disabledMode; }
		public function set disabledMode (b : uint) : void
		{
			_disabledMode = b;
			if( !_enabled )
				checkDisableMode( );
		}
		public function get disabledValue () : * { return _disabledValue; }
		public function set disabledValue (v : *) : void
		{
			_disabledValue = v;

		}
		public function get value () : * 
		{ 
			var res : LibraryAsset = (_action as BrowseRessources).ressource;
			return res ? res.type : null; 
		}
		public function set value (v : *) : void
		{
			if( v && !(v is LibraryAsset) )
			{
				if( v is Class )
					v = new LibraryAsset( v, "null", ApplicationDomain.currentDomain );
				else					v = new LibraryAsset( Reflection.getClass( v ), "null", ApplicationDomain.currentDomain );
			}
			(_action as BrowseRessources).ressource = v;
		}
		protected function checkDisableMode () : void 
		{
			switch( _disabledMode )
			{
				case FormComponentDisabledModes.DIFFERENT_ACROSS_MANY :
					disabledValue = _("different values across many");
					( _action as BrowseRessources ).name = _disabledValue;
					break;

				case FormComponentDisabledModes.UNDEFINED :
					disabledValue = _("not defined");
					( _action as BrowseRessources ).name = _disabledValue;
					break;

				case FormComponentDisabledModes.NORMAL :
				case FormComponentDisabledModes.INHERITED :
				default :
					( _action as BrowseRessources ).name = value ? value.name : _("No ressource");
					break;
			}
		}
	}
}

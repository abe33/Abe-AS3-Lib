package abe.com.ponents.buttons 
{
	import abe.com.mands.events.CommandEvent;
	import abe.com.mon.utils.StageUtils;
	import abe.com.mon.utils.TimeDelta;
	import abe.com.mon.utils.magicCopy;
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.actions.builtin.EditObjectPropertiesAction;
	import abe.com.ponents.containers.Window;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.forms.FormComponent;
	import abe.com.ponents.forms.FormComponentDisabledModes;
	import abe.com.ponents.forms.FormObject;
	import abe.com.ponents.forms.managers.SimpleFormManager;
	import abe.com.ponents.skinning.icons.Icon;
	/**
	 * @author cedric
	 */
	public class TimeDeltaPicker extends AbstractButton implements FormComponent 
	{
		/**
		 * Un entier représentant le mode de désactivation courant de ce composant.
		 */
		protected var _disabledMode : uint;
		/**
		 * La valeur de ce composant durant son mode de désactivation.
		 */
		protected var _disabledValue : *;
		
		public function TimeDeltaPicker ( delta : TimeDelta = null, icon : Icon = null)
		{
			var d : TimeDelta = delta ? delta : new TimeDelta();
			super( new EditObjectPropertiesAction( d, save, format(d), null, null, null, true ), icon );
		}
		protected function save (o : Object, 
							     form : FormObject, 
							     manager : SimpleFormManager,
							     window : Window) : void 
		{
			manager.save();
			magicCopy( form.target, o );
			( _action as EditObjectPropertiesAction ).name = format( o as TimeDelta ); 
			window.close();
			StageUtils.stage.focus = null;
		}
		public function get value () : * { return ( _action as EditObjectPropertiesAction ).object; }
		public function set value (v : *) : void 
		{ 
			( _action as EditObjectPropertiesAction ).object = v; 			( _action as EditObjectPropertiesAction ).name = format( v ); 
		}
		
		/**
		 * Un entier représentant le mode de désactivation courant de ce composant.
		 */
		public function get disabledMode () : uint { return _disabledMode; }
		public function set disabledMode (b : uint) : void
		{
			_disabledMode = b;
			
			if( !_enabled )
				checkDisableMode();
		}
		/**
		 * La valeur de ce composant durant son mode de désactivation.
		 */
		public function get disabledValue () : * { return _disabledValue; }		
		public function set disabledValue (v : *) : void 
		{
			_disabledValue = v;
		}
		/**
		 * @inheritDoc
		 */
		override public function set enabled (b : Boolean) : void 
		{
			super.enabled = b;
			checkDisableMode();
		}
		/**
		 * @inheritDoc
		 */
		override protected function commandEnded (e : CommandEvent) : void
		{
			super.commandEnded( e );
			fireDataChange();
		}
		/**
		 * Définie l'état du composant lorsque celuici est désactivé.
		 */
		protected function checkDisableMode() : void
		{
			switch( _disabledMode )
			{
				case FormComponentDisabledModes.DIFFERENT_ACROSS_MANY : 
					disabledValue = _("different values across many");
					affectLabelText();
					break;
					
				case FormComponentDisabledModes.UNDEFINED : 
					disabledValue = _("not defined");
					affectLabelText();
					break;
				
				case FormComponentDisabledModes.NORMAL :
				case FormComponentDisabledModes.INHERITED : 
				default : 
					break;
			}
		}
		/**
		 * @inheritDoc
		 */
		override protected function affectLabelText () : void 
		{
			if( _enabled )
				super.affectLabelText();
			else
				_labelTextField.htmlText = String( _disabledValue );
		}
		/**
		 * Diffuse un évènement de type <code>ComponentEvent.DATA_CHANGE</code> aux écouteurs
		 * de ce composant.
		 */
		protected function fireDataChange () : void 
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.DATA_CHANGE ) );
		}
		protected function format ( d : TimeDelta) : String 
		{
			return _$(_("$0 Day$1, $2 hour$3, $4 minute$5 and $6 second$7"),
					  d.days, 
					  d.days > 1 ? "s" : " ",
					  d.hours, 
					  d.hours > 1 ? "s" : " ",
					  d.minutes, 
					  d.minutes > 1 ? "s" : " ",
					  d.seconds, 
					  d.seconds > 1 ? "s" : " "
					  );
		}
	}
}

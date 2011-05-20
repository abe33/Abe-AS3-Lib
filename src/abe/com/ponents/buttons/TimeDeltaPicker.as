package abe.com.ponents.buttons 
{
	import abe.com.mands.*;
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
	
	import org.osflash.signals.Signal;
	/**
	 * @author cedric
	 */
	public class TimeDeltaPicker extends AbstractFormButton implements FormComponent 
	{
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
		override public function get value () : * { return ( _action as EditObjectPropertiesAction ).object; }
		override public function set value (v : *) : void 
		{ 
			( _action as EditObjectPropertiesAction ).object = v; 
			( _action as EditObjectPropertiesAction ).name = format( v ); 
		}
		protected function format ( d : TimeDelta) : String 
		{
			return _$(_("$0 day$1, $2 hour$3, $4 minute$5 and $6 second$7"),
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

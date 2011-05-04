package abe.com.ponents.forms.renderers 
{
	import abe.com.mon.colors.Color;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.focus.Focusable;
	import abe.com.ponents.forms.FormCategory;
	import abe.com.ponents.skinning.decorations.SimpleFill;
	import abe.com.ponents.tables.DefaultTableRow;
	/**
	 * @author Cédric Néhémie
	 */
	public class PropertyTableRow extends DefaultTableRow
	{
 		public function PropertyTableRow ()
		{
			super();
			_action = null;
		}

		override public function focusFirstChild () : void
		{
			if( _data["obj"] is FormCategory )
				_focusParent.focusNextChild( this );
			else
				(_data["component"] as Component).grabFocus();
		}

		override public function focusLastChild () : void
		{
			if( _data["obj"] is FormCategory )
				_focusParent.focusPreviousChild( this );
			else
				(_data["component"] as Component).grabFocus();
		}

		override public function focusNextChild (child : Focusable) : void
		{
			_focusParent.focusNextChild( this );
		}

		override public function focusPreviousChild (child : Focusable) : void
		{
			_focusParent.focusPreviousChild( this );
		}

		override public function set value (val : *) : void
		{
			super.value = val;
			
			if( _data["obj"] is FormCategory )
			{
				_style.setForAllStates("background", new SimpleFill( Color.Gainsboro ) );
			}
			else
			{
				_style.setForAllStates("background", null );
			}
		}
		
	}
}

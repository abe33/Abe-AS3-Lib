package abe.com.ponents.menus 
{
	import abe.com.ponents.core.*;
	import abe.com.ponents.skinning.icons.CheckBoxCheckedIcon;
	import abe.com.ponents.skinning.icons.CheckBoxUncheckedIcon;
	import abe.com.ponents.skinning.icons.Icon;

	import org.osflash.signals.Signal;

	/**
	 * @author Cédric Néhémie
	 */
	[Style(name="checkedIcon",type="abe.com.ponents.skinning.icons.Icon")]
	[Style(name="uncheckedIcon",type="abe.com.ponents.skinning.icons.Icon")]
	[Skinable(skin="CheckBoxMenuItem")]
	[Skin(define="CheckBoxMenuItem",
		  inherit="MenuItem",
		  
		  custom_checkedIcon="icon(abe.com.ponents.skinning.icons::CheckBoxCheckedIcon)",
		  custom_uncheckedIcon="icon(abe.com.ponents.skinning.icons::CheckBoxUncheckedIcon)"
	)]
	public class CheckBoxMenuItem extends MenuItem 
	{
		static private const DEPENDENCIES : Array = [ CheckBoxCheckedIcon, CheckBoxUncheckedIcon ];
		
		protected var _checked : Boolean;
		protected var _checkedIcon : Icon;
		protected var _uncheckedIcon : Icon;
		
		public var selectedChanged : Signal;
		public var valueChanged : Signal;
		
		public function CheckBoxMenuItem ( label : String, checked : Boolean = false )
		{
			super( action );
			
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			allowDrag = false;
			gesture = null;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			_checkedIcon = _checkedIcon ? _checkedIcon : _style.checkedIcon.clone();
			_uncheckedIcon = _uncheckedIcon ? _uncheckedIcon : _style.uncheckedIcon.clone();
			
			this.label = label;
			this.checked = checked;
		}
		public function get checkedIcon () : Icon {	return _checkedIcon; }		
		public function set checkedIcon (checkedIcon : Icon) : void
		{
			_checkedIcon = checkedIcon;
			super.icon = _checked ? _checkedIcon : _uncheckedIcon;
		}
		
		public function get uncheckedIcon () : Icon { return _uncheckedIcon; }		
		public function set uncheckedIcon (uncheckedIcon : Icon) : void
		{
			_uncheckedIcon = uncheckedIcon;
			super.icon = _checked ? _checkedIcon : _uncheckedIcon;
		}
		
		override public function set icon (icon : Icon) : void
		{
		}
		
		public function get checked () : Boolean { return selected; }
		public function set checked ( b : Boolean ) : void 
		{ 
			selected = b; 
		}
		override public function get selected () : Boolean { return _checked; }
		override public function set selected ( b : Boolean ) : void 
		{
			if( b != _checked )
			{
				_checked = b; 
				invalidate();
				fireComponentChangedSignal();
				selectedChanged.dispatch( this, _checked );
				valueChanged.dispatch( this, _checked );
			}
			super.icon = _checked ? _checkedIcon : _uncheckedIcon;
		}
		
		override public function click (context : UserActionContext ) : void
		{
			swapSelect( !selected );
		}

		protected function swapSelect ( b : Boolean ) : void
		{
			selected = b;
			super.click( new UserActionContext( this, UserActionContext.PROGRAM_ACTION ) );
		}
		
		override protected function stylePropertyChanged ( propertyName : String, propertyValue : * ) : void
		{
			switch( propertyName )
			{
				case "checkedIcon" :
				 	checkedIcon = propertyValue.clone();
					break	
				case "uncheckedIcon" :
				 	uncheckedIcon = propertyValue.clone();
					break	
				default : 
					super.stylePropertyChanged( propertyName, propertyValue );
					break;
			}
		}

	}
}

package abe.com.ponents.tools 
{
	import abe.com.mon.colors.Color;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.core.Container;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.events.PropertyEvent;
	import abe.com.ponents.forms.FormObject;
	import abe.com.ponents.forms.FormUtils;
	import abe.com.ponents.forms.managers.SimpleFormManager;
	import abe.com.ponents.forms.renderers.FieldSetFormRenderer;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.skinning.icons.ColorIcon;

	import flash.events.MouseEvent;

	/**
	 * @author Cédric Néhémie
	 */
	[Event(name="dataChange",type="abe.com.ponents.events.ComponentEvent")]
	[Skinable(skin="RGBColorEditor")]
	[Skin(define="RGBColorEditor",
			  inherit="EmptyComponent",
			  state__all__insets="new cutils::Insets(5)"
	)]
	public class RGBColorEditor extends Panel 
	{
		protected var _target : Color;
		protected var _colorIcon : ColorIcon;
		protected var _colorIconSave : ColorIcon;
		protected var _sampler : ColorSampler;
		protected var _formObject : FormObject;
		protected var _formManager : SimpleFormManager;
		protected var _formPanel : Container;
		
		public function RGBColorEditor ()
		{
			super( );
			_childrenLayout = new InlineLayout(this);
			_target = new Color();
			_colorIcon = new ColorIcon( _target );
			_colorIconSave = new ColorIcon( _target.clone() );
			
			_sampler = new ColorSampler();
			_formObject = FormUtils.createFormFromMetas( _target );
			_formManager = new SimpleFormManager( _formObject );
			_formPanel = FieldSetFormRenderer.instance.render( _formObject ) as Container;
			
			_formManager.addEventListener(PropertyEvent.PROPERTY_CHANGE, formPropertyChanged );
			_sampler.addEventListener(ComponentEvent.DATA_CHANGE, samplerDataChange );
			_colorIconSave.addEventListener(MouseEvent.CLICK, iconSaveClick );
			
			_colorIcon.init();
			_colorIconSave.init();
			
			_formPanel.addComponents( _sampler, _colorIcon, _colorIconSave );

			addComponent( _formPanel );
			invalidatePreferredSizeCache();
		}

		public function get target () : Color { return _target; }	
		public function set target (target : Color) : void
		{
			_target = target;
			_colorIcon.color = _target;
			_sampler.value = _target;
			_formObject.target = _target;
			_formManager.updateFieldsWithTarget();
		}
		public function get safeTarget( ) : Color { return _colorIconSave.color; }
		public function set safeTarget( target : Color ) : void
		{
			_colorIconSave.color = target.clone(); 
		}
		
		public function get formPanel () : Container { return _formPanel; }
		
		public function formPropertyChanged( e : PropertyEvent ) : void 
		{
			_colorIcon.invalidate();
			if( e.propertyName != "name" && 
				e.propertyName != "alpha" )
			{
				_sampler.value = _target;
			}
			fireDataChange( );
		}

		public function samplerDataChange ( e : ComponentEvent ) : void
		{
			var c2 : Color = _sampler.value;
			_target.red = c2.red;
			_target.green = c2.green;
			_target.blue = c2.blue;
			//c.alpha = c2.alpha;
			_colorIcon.invalidate();
			_formManager.updateFieldsWithTarget();
			fireDataChange();
		}
		protected function iconSaveClick (event : MouseEvent) : void
		{
			var c2 : Color = _colorIconSave.color;
			_target.red = c2.red;
			_target.green = c2.green;
			_target.blue = c2.blue;
			_target.alpha = c2.alpha;
			_sampler.value = _target;
			_colorIcon.invalidate();
			_formManager.updateFieldsWithTarget();
			fireDataChange();
		}
		
		protected function fireDataChange () : void 
		{
			dispatchEvent(new ComponentEvent(ComponentEvent.DATA_CHANGE));
		}
		
		public function get formManager () : SimpleFormManager { return _formManager;}
	}
}

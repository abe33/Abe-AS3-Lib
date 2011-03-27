package abe.com.ponents.tools 
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.colors.Gradient;
	import abe.com.patibility.lang._;
	import abe.com.ponents.containers.FieldSet;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.forms.FormObject;
	import abe.com.ponents.forms.managers.SimpleFormManager;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.utils.Insets;

	import flash.events.Event;

	/**
	 * @author Cédric Néhémie
	 */
	public class GradientEditor extends Panel 
	{
		protected var _target : Gradient;
		protected var _gradientSampler : GradientSampler;
		
		protected var _colorEditor : ColorEditor;
		protected var _formObject : FormObject;
		protected var _formManager : SimpleFormManager;
		
		protected var _currentSelectedColor : Color;
		
		protected var _colorCursors : Array;
		
		public function GradientEditor ()
		{
			super();
			_childrenLayout = new InlineLayout(this, 4, "left","top","topToBottom", true );
			
			_gradientSampler = new GradientSampler();
			_colorEditor = new ColorEditor();
			_colorEditor.addEventListener( ComponentEvent.DATA_CHANGE, colorDataChanged);
			
			var fs : FieldSet = new FieldSet(_("Edit Selected Color"));
			fs.childrenLayout = new InlineLayout(this, 0, "left","top","topToBottom", true );
			fs.addComponent( _colorEditor );
			fs.insidePanel.style.insets = new Insets(0);
			
			target = new Gradient([Color.Black.clone(),Color.White.clone()],
								  [0,1]);
								  
			_gradientSampler.addEventListener( ComponentEvent.SELECTION_CHANGE, samplerSelectionChange );			_gradientSampler.addEventListener( ComponentEvent.DATA_CHANGE, samplerDataChange );
			
			addComponents(_gradientSampler, fs );
			currentSelectedColor = _target.colors[0];
		}
		
		protected function samplerDataChange (event : ComponentEvent) : void
		{
			currentSelectedColor = _gradientSampler.selectedColor;
		}
		protected function samplerSelectionChange (event : ComponentEvent) : void
		{
			currentSelectedColor = _gradientSampler.selectedColor;
		}

		public function get target () : Gradient { return _target; }	
		public function set target (target : Gradient) : void
		{
			_target = target.clone();
			_gradientSampler.gradient = _target;
			currentSelectedColor = _target.colors[0];
			//_sampler.clearMarkers();
			//_formObject.target = _target;
			//_formManager.updateFieldsWithTarget();
		}		
		public function get currentSelectedColor () : Color { return _currentSelectedColor;	}		
		public function set currentSelectedColor (currentSelectedColor : Color) : void
		{
			_currentSelectedColor = currentSelectedColor;
			_colorEditor.target = _currentSelectedColor;
		}

		protected function colorDataChanged (event : Event) : void
		{
			_currentSelectedColor.red = _colorEditor.target.red;			_currentSelectedColor.green = _colorEditor.target.green;			_currentSelectedColor.blue = _colorEditor.target.blue;			_currentSelectedColor.alpha = _colorEditor.target.alpha;
			_gradientSampler.updateCursorsIcons();
			invalidate();
		}
	}
}
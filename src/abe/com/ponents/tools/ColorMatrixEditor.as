package abe.com.ponents.tools 
{
	import abe.com.mon.geom.ColorMatrix;
	import abe.com.patibility.lang._;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.core.AbstractContainer;
	import abe.com.ponents.core.*;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.forms.FormComponent;
	import abe.com.ponents.layouts.components.BoxSettings;
	import abe.com.ponents.layouts.components.HBoxLayout;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.models.DefaultBoundedRangeModel;
	import abe.com.ponents.sliders.HSlider;
	import abe.com.ponents.text.Label;

	import flash.filters.ColorMatrixFilter;

    import org.osflash.signals.Signal;
	/**
	 * @author cedric
	 */
	[Skinable(skin="NoDecorationComponent")]
	public class ColorMatrixEditor extends AbstractContainer implements FormComponent
	{
		protected var _tintSlider : HSlider;
		protected var _filter : ColorMatrixFilter;
		protected var _saturationSlider : HSlider;
		protected var _contrastSlider : HSlider;
		protected var _brightnessSlider : HSlider;
		protected var _alphaSlider : HSlider;
		protected var _matrix : ColorMatrix;
		
		protected var _dataChanged : Signal;
		public function get dataChanged () : Signal { return _dataChanged; }

		public function ColorMatrixEditor ( colorMatrixFilter : ColorMatrixFilter )
		{
			_filter = colorMatrixFilter;
			_dataChanged = new Signal();
			super( );
			childrenLayout = new InlineLayout(this, 5, "left", "top", "topToBottom", true );
			
			_tintSlider = new HSlider( new DefaultBoundedRangeModel ( 0, -180, 180, 1 ), 10, 1, false, true );
			_alphaSlider = new HSlider( new DefaultBoundedRangeModel ( 0, -100, 100, 1 ), 10, 1, false, true );
			_saturationSlider = new HSlider( new DefaultBoundedRangeModel ( 0, -100, 100, 1 ), 10, 1, false, true );
			_contrastSlider = new HSlider( new DefaultBoundedRangeModel ( 0, -100, 100, 1 ), 10, 1, false, true );
			_brightnessSlider = new HSlider( new DefaultBoundedRangeModel ( 0, -100, 100, 1 ), 10, 1, false, true );
			
			addComponent( createInlinePanel( _("Hue") ,_tintSlider ) );
			addComponent( createInlinePanel( _("Saturation") ,_saturationSlider ) );
			addComponent( createInlinePanel( _("Contrast") ,_contrastSlider ) );
			addComponent( createInlinePanel( _("Brightness") ,_brightnessSlider ) );
			addComponent( createInlinePanel( _("Alpha") ,_alphaSlider ) );
		}

		override protected function registerToOnStageEvents () : void 
		{
			super.registerToOnStageEvents( );
			
			_alphaSlider.dataChanged.add( alphaDataChanged );
			_tintSlider.dataChanged.add( tintDataChanged );
			_saturationSlider.dataChanged.add( saturationDataChanged );
			_contrastSlider.dataChanged.add( contrastDataChanged );
			_brightnessSlider.dataChanged.add( brightnessDataChanged );
		}

		override protected function unregisterFromOnStageEvents () : void 
		{
			super.unregisterFromOnStageEvents( );
			
			_alphaSlider.dataChanged.remove( alphaDataChanged );
			_tintSlider.dataChanged.remove( tintDataChanged );
			_saturationSlider.dataChanged.remove( saturationDataChanged );
			_contrastSlider.dataChanged.remove( contrastDataChanged );
			_brightnessSlider.dataChanged.remove( brightnessDataChanged );
		}

		protected function createInlinePanel ( label : String, component : Component ) : Panel 
		{
			var p : Panel = new Panel();
			var l : Label = new Label(label);
			
			p.childrenLayout = new HBoxLayout( p, 3, 
													new BoxSettings( 75, "right", "center", l ),
													new BoxSettings( 150, "left", "center", component, true )													
													 );
			
			p.addComponent( l );
			p.addComponent( component );
			
			return p;	
		}

		protected function alphaDataChanged ( c : Component, v : *) : void 
		{
			buildMatrix();
		}

		protected function brightnessDataChanged ( c : Component, v : *) : void 
		{
			buildMatrix();
		}

		protected function contrastDataChanged ( c : Component, v : *) : void 
		{
			buildMatrix();
		}

		protected function saturationDataChanged ( c : Component, v : *) : void 
		{
			buildMatrix();
		}

		protected function tintDataChanged ( c : Component, v : *) : void 
		{
			buildMatrix();
		}

		protected function buildMatrix () : void 
		{
			_matrix = new ColorMatrix();
			_matrix.adjustHue( _tintSlider.value );
			_matrix.adjustBrightness( _brightnessSlider.value );
			_matrix.adjustContrast( _contrastSlider.value );
			_matrix.adjustSaturation( _saturationSlider.value );
			_matrix.adjustAlpha( _alphaSlider.value );
			
			fireDataChangedSignal();
		}

		protected function fireDataChangedSignal () : void 
		{
			_dataChanged.dispatch( this, _matrix );
		}

		public function get disabledMode () : uint { return 0; }
		public function set disabledMode (b : uint) : void
		{
			
		}
		
		public function get value () : * { return _matrix; }
		public function set value (v : *) : void
		{
		}
		
		public function get disabledValue () : * {}		
		public function set disabledValue (v : *) : void
		{
		}
	}
}

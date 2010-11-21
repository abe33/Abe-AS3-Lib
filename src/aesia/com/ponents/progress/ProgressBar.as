package aesia.com.ponents.progress 
{
	import aesia.com.mon.core.IDisplayObject;
	import aesia.com.mon.core.IDisplayObjectContainer;
	import aesia.com.mon.core.IInteractiveObject;
	import aesia.com.mon.core.ITextField;
	import aesia.com.mon.core.Suspendable;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.motion.Impulse;
	import aesia.com.motion.ImpulseEvent;
	import aesia.com.motion.ImpulseListener;
	import aesia.com.ponents.core.AbstractComponent;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.models.BoundedRangeModel;
	import aesia.com.ponents.models.DefaultBoundedRangeModel;
	import aesia.com.ponents.skinning.decorations.GradientFill;
	import aesia.com.ponents.text.TextFieldImpl;
	import aesia.com.ponents.utils.Alignments;

	import flash.display.BlendMode;
	import flash.display.DisplayObject;

	[Skinable(skin="ProgressBar")]
	[Skin(define="ProgressBar",
		  inherit="DefaultComponent",
		  preview="aesia.com.ponents.progress::ProgressBar.defaultProgressBarPreview",
		  
		  state__all__background="new aesia.com.ponents.skinning.decorations::GradientFill(gradient([color(0xff333333),color(0xff555555)],[0,1]),90)",
		  state__disabled__background="new aesia.com.ponents.skinning.decorations::GradientFill(gradient([color(0xff555555),color(0xff777777)],[0,1]),90)"	)]
	/**
	 * @author Cédric Néhémie
	 */
	public class ProgressBar extends AbstractComponent implements Component, 
																  IDisplayObject, 
																  IInteractiveObject, 
																  IDisplayObjectContainer,
																  ImpulseListener,
																  Suspendable
	{
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		static public function defaultProgressBarPreview () : ProgressBar
		{
			return new ProgressBar(new DefaultBoundedRangeModel(33, 0, 100, 1 ));
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		static private const SKIN_DEPENDENCIES : Array = [GradientFill];
		
		
		protected var _model : BoundedRangeModel;
		protected var _determinate : Boolean;
		protected var _bar : Bar;
		protected var _isRunning : Boolean;
		
		protected var _t : Number;
		
		protected var _displayLabel : Boolean;
		protected var _label : ITextField;
		protected var _labelUnit : String;
		protected var _labelPlacement : String;
		protected var _forcePercentageInLabel : Boolean;
		
		public function ProgressBar ( model : BoundedRangeModel = null, displayLabel : Boolean = true )
		{
			super();
			_bar = new Bar();
			_isRunning = false;
			_determinate = true;
			_labelUnit = "%";
			_labelPlacement = Alignments.CENTER;
			
			allowFocus = false;
			mouseChildren = false;
			
			invalidatePreferredSizeCache();
			
			_childrenContainer.addChild(_bar);
			this.model = model ? model : new DefaultBoundedRangeModel(0,0,100,1);
			this.displayLabel = displayLabel;
		}
		public function get displayLabel () : Boolean { return _displayLabel; }		
		public function set displayLabel (displayLabel : Boolean) : void
		{
			_displayLabel = displayLabel;
			if( _displayLabel && !_label )
			{
				_label = new TextFieldImpl();
				_label.autoSize = "left";
				(_label as DisplayObject).blendMode = BlendMode.INVERT;
				
				_childrenContainer.addChild(_label as DisplayObject );
				placeLabel ();
			}
			else if( _displayLabel && _label )
			{
				_childrenContainer.removeChild(_label as DisplayObject );
				_label = null;
			}
		}
		public function get labelUnit () : String { return _labelUnit; }		
		public function set labelUnit (labelUnit : String) : void 
		{	
			_labelUnit = labelUnit;
		}
		public function get model () : BoundedRangeModel { return _model; }		
		public function set model ( model : BoundedRangeModel) : void
		{
			if( !model )
				return;
			
			if( _model )
				_model.removeEventListener( ComponentEvent.DATA_CHANGE, dataChanged );
			
			_model = model;
			if( _model )
			{
				_model.addEventListener( ComponentEvent.DATA_CHANGE, dataChanged );
				dataChanged(null);
			}
		}
		public function get labelPlacement () : String { return _labelPlacement; }		
		public function set labelPlacement (labelPlacement : String) : void
		{
			_labelPlacement = labelPlacement;
			invalidate(true);
		}
		public function get determinate () : Boolean { return _determinate; }		
		public function set determinate (determinate : Boolean) : void
		{
			if( _determinate != determinate )
			{
				_determinate = determinate;
				
				if( _determinate )
					stop();
				else
				{
					_t = 0;
					start();
				}
					
				updateBar();
			}
		}
		
		public function get value () : Number { return _model.value; }
		public function set value ( n : Number ) : void
		{
			_model.value = n;
		}

		override public function invalidatePreferredSizeCache () : void
		{
			_preferredSizeCache = new Dimension(150,16);
			invalidate();
		}
		
		public function start () : void
		{
			if( !_isRunning )
			{
				_isRunning = true;
				Impulse.register( tick );
			}
		}		
		public function stop () : void
		{
			if( _isRunning )
			{
				_isRunning = false;
				Impulse.unregister( tick );
			}
		}
		public function isRunning () : Boolean { return _isRunning; }
		
		protected function updateBar () : void
		{
			var size : Dimension = calculateComponentSize();
			_bar.height = size.height;
			if( _determinate )
			{
				_bar.x = 0;
				_bar.width = _model.valuePositionInRange * size.width;
			}
			else
			{
				_bar.width = 40;
				_bar.x = ( ( 1 + Math.sin( _t ) ) / 2 ) * ( size.width - 40 );
				
				_t += 0.1;
			}
			placeLabel (); 
		}

		protected function dataChanged (event : ComponentEvent) : void
		{			
			if( _determinate )
				updateBar();
			fireDataChange();
		}
		
		public function tick (e : ImpulseEvent) : void
		{
			updateBar();
		}
		protected function updateTextFormat () : void 
		{
			if( _label )
			{
				var lastScroll : Number = _label.scrollV;
				_label.defaultTextFormat = _style.format;
				_label.textColor = _style.textColor.hexa;
				affectTextValue();
			}
		}

		protected function affectTextValue () : void 
		{
			if( _determinate )
			{
				if( _forcePercentageInLabel )
					_label.text = Math.round(_model.valuePositionInRange * 100 ) + "%";
				else
					_label.text = Math.round( _model.value ) + _labelUnit;
			}
			else
				_label.text = "";
		}

		override public function repaint () : void
		{
			super.repaint();
			updateBar();
			_bar.repaint();
			
			placeLabel();
		}

		protected function placeLabel () : void 
		{
			if( _displayLabel && _label )
			{
				updateTextFormat();
				switch( _labelPlacement )
				{
					case Alignments.LEFT : 
						_label.x = 0;
						break;
					case Alignments.RIGHT : 
						_label.x = width - _label.width;
						break;
					case Alignments.CENTER : 
						_label.x = ( width - _label.width ) / 2;
				}
				_label.y = ( height - _label.height ) / 2;
			}
		}

		public function get forcePercentageInLabel () : Boolean
		{
			return _forcePercentageInLabel;
		}
		
		public function set forcePercentageInLabel (forcePercentageInLabel : Boolean) : void
		{
			_forcePercentageInLabel = forcePercentageInLabel;
		}
		protected function fireDataChange () : void 
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.DATA_CHANGE ) );
		}
		
		public function get bar () : Bar {
			return _bar;
		}
	}
}

import aesia.com.mon.geom.Dimension;
import aesia.com.ponents.core.AbstractComponent;

[Skinable(skin="ProgressDisplay")]
[Skin(define="ProgressDisplay",
	  inherit="DefaultComponent",
	  preview="aesia.com.ponents.progress::ProgressBar.defaultProgressBarPreview",
	  previewAcceptStyleSetup="false",
	  state__all__background="new aesia.com.ponents.skinning.decorations::GradientFill(gradient([color(Gainsboro),color(LightGrey),color(Gainsboro)],[.45,.5,1]),90)"
)]
internal class Bar extends AbstractComponent
{
	public function Bar ()
	{
		super();
		allowOver = false;
		allowFocus = false;
		allowPressed = false;
		allowSelected = false;
		invalidatePreferredSizeCache();
	}

	override public function invalidatePreferredSizeCache () : void
	{
		_preferredSizeCache = new Dimension(16,16);
		invalidate();
	}
}


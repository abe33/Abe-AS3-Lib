package abe.com.ponents.sliders 
{
	import abe.com.mon.utils.MathUtils;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.models.BoundedRangeModel;
	import abe.com.ponents.utils.Alignments;

	import flash.events.MouseEvent;
	/**
	 * @author cedric
	 */
	public class VLogarithmicSlider extends VSlider
	{
		public function VLogarithmicSlider ( model : BoundedRangeModel, 
											 majorTickSpacing : Number = 10, 
											 minorTickSpacing : Number = 5, 
											 displayTicks : Boolean = false, 
											 displayInput : Boolean = true,
											 preComp : Component = null,
											 postComp : Component = null ) 
		{
			super( model, majorTickSpacing, minorTickSpacing, displayTicks, false, displayInput, preComp, postComp );
		}
		override public function set snapToTicks (snapToTicks : Boolean) : void {}
		
		override protected function getTransformedValue (n : Number) : Number { return n; }
		
		override protected function placeSlider () : void
		{
			var valOut : Number = Math.log( _model.value );
			var minOut : Number = Math.log( _model.minimum );
			var maxOut : Number = Math.log( _model.maximum );
			
			_knob.y = _track.y + MathUtils.map( valOut , minOut, maxOut, _track.height - _knob.height, 0 );
			_knob.x = Alignments.alignHorizontal( _knob.width , width, _style.insets, "center" );
		}
		override protected function drag ( e : MouseEvent ) : void
		{
			if( _dragging )
			{
				var minIn: Number = _knob.height/2;
				var maxIn: Number = _track.height - _knob.height/2;
				
				var minOut : Number = Math.log( _model.minimum );
				var maxOut : Number = Math.log( _model.maximum );
				
				var v : Number = MathUtils.map(_track.mouseY - _pressedY, maxIn, minIn, minOut, maxOut );
								
				_model.value = getTransformedValue( Math.exp( v ) );
			}
		}
		override protected function up () : void
		{
			if( _enabled )
			{
				var minIn: Number = _track.y + _knob.height/2;
				var maxIn: Number = _track.y + _track.height - _knob.height/2;
				
				var minOut : Number = Math.log( _model.minimum );
				var maxOut : Number = Math.log( _model.maximum );
				var v : Number = MathUtils.map( _knob.y + _knob.height/2 - _model.extent, maxIn, minIn, minOut, maxOut );
				_model.value = getTransformedValue( Math.exp( v ) );
			}
		}
		override protected function down () : void
		{
			if( _enabled )
			{
				var minIn: Number = _track.y + _knob.height/2;
				var maxIn: Number = _track.y + _track.height - _knob.height/2;
				
				var minOut : Number = Math.log( _model.minimum );
				var maxOut : Number = Math.log( _model.maximum );
				
				var v : Number = MathUtils.map( _knob.y + _knob.height/2 + _model.extent, maxIn, minIn, minOut, maxOut );
				_model.value = getTransformedValue( Math.exp( v ) );
			}
		}
		override protected function paintTicks () : void
		{
			var y : Number;
			var i : Number;
			var w : Number = _style.tickSize;
			var x : Number = _track.x + _track.width/2 - _style.tickMargin;
			_background.graphics.lineStyle( 0, _tickColor.hexa, _tickColor.alpha / 255 );
			for( i = _model.minimum; i <= _model.maximum; i += _majorTickSpacing )
			{
				y = _track.y + _knob.height/2 + MathUtils.map( Math.log( i ), Math.log( _model.minimum ), Math.log( _model.maximum ), _track.height - _knob.height, 0 );
				_background.graphics.moveTo( x - w, y );
				_background.graphics.lineTo( x, y );
			}
			
			_background.graphics.lineStyle( 0, _tickColor.hexa, _tickColor.alpha / 500 );
			for( i = _model.minimum; i <= _model.maximum; i += _minorTickSpacing )
			{
				y = _track.y + _knob.height/2 + MathUtils.map( Math.log( i ) , Math.log( _model.minimum ), Math.log( _model.maximum ), _track.height - _knob.height, 0 );
				_background.graphics.moveTo( x - w/4, y );
				_background.graphics.lineTo( x - w*0.75, y );
			}
			_background.graphics.lineStyle();
		}
	}
}

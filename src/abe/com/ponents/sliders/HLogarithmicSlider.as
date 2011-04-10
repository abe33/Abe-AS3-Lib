package abe.com.ponents.sliders 
{
	import abe.com.mon.logs.Log;
	import abe.com.mon.utils.MathUtils;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.models.BoundedRangeModel;
	import abe.com.ponents.utils.Alignments;

	import flash.events.MouseEvent;
	/**
	 * @author cedric
	 */
	public class HLogarithmicSlider extends HSlider 
	{
		public function HLogarithmicSlider ( model : BoundedRangeModel, 
											 majorTickSpacing : Number = 10, 
											 minorTickSpacing : Number = 5, 
											 displayTicks : Boolean = false, 
											 displayInput : Boolean = true, 
											 preComp : Component = null, 
											 postComp : Component = null)
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
			
			_knob.x = _track.x + MathUtils.map( valOut , minOut, maxOut, 0, _track.width - _knob.width );
			_knob.y = Alignments.alignHorizontal( _knob.height , height, _style.insets, "center" );
		}
		override protected function drag ( e : MouseEvent ) : void
		{
			if( _dragging )
			{
				var minIn: Number = _knob.width/2;
				var maxIn: Number = _track.width - _knob.width/2;
				
				var minOut : Number = Math.log( _model.minimum );
				var maxOut : Number = Math.log( _model.maximum );
				
				var v : Number = MathUtils.map( _track.mouseX - _pressedX, minIn, maxIn, minOut, maxOut );
								
				_model.value = getTransformedValue( Math.exp( v ) );
			}
		}
		override protected function up () : void
		{
			if( _enabled )
			{
				var minIn: Number = _track.x + _knob.width/2;
				var maxIn: Number = _track.x + _track.width - _knob.width/2;
				
				var minOut : Number = Math.log( _model.minimum );
				var maxOut : Number = Math.log( _model.maximum );
				var v : Number = MathUtils.map( _knob.x + _model.extent + _knob.width/2, minIn, maxIn, minOut, maxOut );
				_model.value = getTransformedValue( Math.exp( v ) );
			}
		}
		override protected function down () : void
		{
			if( _enabled )
			{
				var minIn: Number = _track.x + _knob.width/2;
				var maxIn: Number = _track.x + _track.width - _knob.width/2;
				
				var minOut : Number = Math.log( _model.minimum );
				var maxOut : Number = Math.log( _model.maximum );
				
				var v : Number = MathUtils.map( _knob.x - _model.extent + _knob.width/2, minIn, maxIn, minOut, maxOut );				_model.value = getTransformedValue( Math.exp( v ) );
			}
		}
		override protected function paintTicks () : void
		{
			var x : Number;
			var i : Number;
			var h : Number = _style.tickSize;
			var y : Number = _track.y + _track.height/2 - _style.tickMargin;
			_background.graphics.lineStyle( 0, _tickColor.hexa, _tickColor.alpha / 255 );
			for( i = _model.minimum; i <= _model.maximum; i += _majorTickSpacing )
			{
				x = _track.x + _knob.width/2 + MathUtils.map( Math.log( i ), Math.log( _model.minimum ), Math.log( _model.maximum ), 
																0, _track.width - _knob.width );
				_background.graphics.moveTo( x, y - h );
				_background.graphics.lineTo( x, y );
			}
			
			_background.graphics.lineStyle( 0, _tickColor.hexa, _tickColor.alpha / 500 );
			for( i = _model.minimum; i <= _model.maximum; i += _minorTickSpacing )
			{
				x = _track.x + _knob.width/2 + MathUtils.map( Math.log( i ) , Math.log( _model.minimum ), Math.log( _model.maximum ), 
																0, _track.width - _knob.width );
				_background.graphics.moveTo( x, y - h/4 );
				_background.graphics.lineTo( x, y - h*0.75 );
			}
			_background.graphics.lineStyle();
		}
	}
}

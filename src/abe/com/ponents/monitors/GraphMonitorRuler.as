package abe.com.ponents.monitors 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.monitors.recorders.Recorder;
	import abe.com.ponents.utils.Alignments;
	import abe.com.ponents.utils.Insets;

	import flash.text.TextField;

	/**
	 * 
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="GraphMonitorRuler")]
	[Skin(define="GraphMonitorRuler",
			  inherit="Ruler",
			  
			  state__all__background="skin.noDecoration",
			  state__all__insets="new cutils::Insets(4,0)"
	)]
	public class GraphMonitorRuler extends AbstractRuler 
	{
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		protected var _textFields : Array;
		TARGET::FLASH_10
		protected var _textFields : Vector.<TextField>;
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		protected var _textFields : Vector.<TextField>;
		
		protected var _targetRecorder : Recorder;
		protected var _preferredWidth : Number;
		protected var _align : String;

		public function GraphMonitorRuler ( target : Component, targetRecorder : Recorder, align : String = "right" )
		{
			super( target, direction );
			/*FDT_IGNORE*/ FEATURES::CURSOR { /*FDT_IGNORE*/
				cursor = null;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { _textFields = []; }
			TARGET::FLASH_10 { _textFields = new Vector.<TextField>(); }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			_textFields = new Vector.<TextField>(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			_targetRecorder = targetRecorder;
			_align = align;
			
			var max : Number = targetRecorder.valuesRange.max;
			_preferredWidth = 0;
			for( var i:uint=0;i<5;i++ )
			{
				var n : Number = max - max * (i/4);
                
				var txt : TextField = new TextField();
				txt.autoSize = "left";
				txt.defaultTextFormat = _style.format;
				txt.selectable = false;
				txt.htmlText = _$(_("<font color='$2'>$0</font> $1"), n.toString(), targetRecorder.unit, targetRecorder.curveSettings.color.html );
				_textFields.push(txt );
				_childrenContainer.addChild(txt );
				_preferredWidth = Math.max( txt.width, _preferredWidth );
			}
		}
		override public function repaint () : void
		{
			var size : Dimension = calculateComponentSize();
			super.repaint();
			
			var insets : Insets = _style.insets;
			for( var i:uint=0; i < 5;i++ )
			{
				var txt : TextField = _textFields[i] as TextField;
				txt.x = Alignments.alignHorizontal( txt.width, size.width, insets, _align );
				if( i == 0 )
					txt.y = insets.top - 4;
				else if( i == 4 )
					txt.y = size.height - insets.bottom - txt.height + 4;
				else
					txt.y = size.height * (i/4) - txt.height/2;
			}
		}

		override public function invalidatePreferredSizeCache () : void
		{
			if( _target)
				_preferredSizeCache = new Dimension( _preferredWidth + _style.insets.horizontal, _target.preferredSize.height );
		}
	}
}

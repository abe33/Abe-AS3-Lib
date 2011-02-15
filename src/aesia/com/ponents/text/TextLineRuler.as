package aesia.com.ponents.text
{
	import flash.display.DisplayObject;
	import aesia.com.mon.core.ITextField;
	import aesia.com.mon.geom.dm;
	import aesia.com.mon.utils.StringUtils;
	import aesia.com.ponents.core.SimpleDOContainer;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.layouts.display.DOStretchLayout;

	import flash.events.Event;
	import flash.text.TextField;

	[Skinable(skin="TextLineRuler")]
	[Skin(define="TextLineRuler",
			  inherit="DefaultComponent",
			  state__all__foreground="skin.noDecoration",
			  state__all__background="new deco::SimpleFill( skin.rulerBackgroundColor )",			  state__all__textColor="skin.textColor"
	)]
	/**
	 * @author Cédric Néhémie
	 */
	public class TextLineRuler extends SimpleDOContainer
	{
		protected var _target : ITextField;
		protected var _innerText : ITextField;
		protected var _textComp : AbstractTextComponent;

		public function TextLineRuler ( target : ITextField, textComp : AbstractTextComponent )
		{
			_target = target;
			_textComp = textComp;
			_innerText = new TextFieldImpl();
			_innerText.selectable = false;
			_innerText.multiline = true;

			super ();

			_allowOver = false;
			_allowFocus = false;
			_allowPressed = false;

			_textComp.addEventListener ( ComponentEvent.TEXT_CONTENT_CHANGE, textChange );
			_target.addEventListener ( Event.SCROLL, textScroll );

			addComponentChild( _innerText as DisplayObject );
			childrenLayout = new DOStretchLayout ( _childrenContainer );
			invalidatePreferredSizeCache();
		}

		protected function textScroll ( event : Event ) : void
		{
			_innerText.scrollV = _target.scrollV;
		}
		protected function textChange ( event : Event ) : void
		{
			var s : String = "";
			var i : uint;
			var l : uint = _target.numLines;

			for(i=0;i<l;i++)
			{
				s += "<p>"+StringUtils.fill( (i+1), String(l).length ) + "</p>";
			}
			_innerText.defaultTextFormat = _target.defaultTextFormat;
			_innerText.textColor = _style.textColor.hexa;
			
			if( _target is TextField && _innerText is TextField )
			{
				var tf : TextField = _target as TextField;	
				var itf : TextField = _innerText as TextField;	
				if( tf.styleSheet && !itf.styleSheet )
					itf.styleSheet = tf.styleSheet;
			}
			
			
			_innerText.htmlText = s;
			invalidatePreferredSizeCache();
		}
		override public function repaint () : void
		{
			super.repaint ();
			_innerText.scrollV = _target.scrollV;
		}

		override public function invalidatePreferredSizeCache () : void
		{
			_size = null;
			if( _innerText )
				_preferredSizeCache = dm ( _innerText.textWidth + 5, _target.height );

			if( _textComp )
				_textComp.invalidatePreferredSizeCache();
		}
	}
}

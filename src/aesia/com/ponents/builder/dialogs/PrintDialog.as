package aesia.com.ponents.builder.dialogs 
{
	import aesia.com.mon.logs.Log;
	import flash.text.TextFieldType;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.actions.ProxyAction;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.containers.Window;
	import aesia.com.ponents.containers.WindowTitleBar;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.layouts.components.InlineLayout;
	import aesia.com.ponents.layouts.display.DOBoxSettings;
	import aesia.com.ponents.layouts.display.DOHBoxLayout;
	import aesia.com.ponents.text.TextArea;
	import aesia.com.ponents.text.TextFieldImpl;
	import aesia.com.ponents.text.TextLineRuler;
	import aesia.com.ponents.tools.prettify.GPrettify;
	import aesia.com.ponents.utils.Insets;

	import flash.system.System;
	import flash.text.StyleSheet;
	/**
	 * @author cedric
	 */
	public class PrintDialog extends Window 
	{
		protected var _textArea : TextArea;
		protected var _lineRuler : TextLineRuler;

		public function PrintDialog ( text : String, title : String )
		{
			var css : StyleSheet = new StyleSheet();
			css.parseCSS("p { color:#000000; font-family:Monospace; font-size:10px; } " +
						 "h1 { font-weight:bold; font-style:italic; } " +
						 "h2 { font-weight:bold; text-decoration:underline; } " +
						 "code { color:#660066; display:inline; } " +
						 ".str { color:#008800; } " +
						 ".kwd { color:#000088; } " +
						 ".com { color:#880000; } " +
						 ".typ { color:#660066; } " +
						 ".lit { color:#006666; } " +
						 ".pun { color:#666600; } " +
						 ".pln { color:#000000; } " +
						 ".tag { color:#000088; } " +
						 ".atn { color:#660066; } " +
						 ".atv { color:#008800; } " +
						 ".dec { color:#660066; }" );
			
			_textArea = new TextArea();
			(_textArea.textfield as TextFieldImpl).styleSheet = css;
			_textArea.allowHTML = true;
			_textArea.textfield.type = TextFieldType.DYNAMIC;
			
			_lineRuler = new TextLineRuler( _textArea.textfield, _textArea );
			_textArea.addComponentChild(_lineRuler );
			( _textArea.childrenLayout as DOHBoxLayout ).boxes.unshift( new DOBoxSettings(0, "left", "center", _lineRuler, false, true, false ) );
			_textArea.addEventListener(ComponentEvent.REPAINT, textRepaint );
			_textArea.invalidatePreferredSizeCache();
		
			preferredSize = new Dimension( StageUtils.stage.stageWidth - 400 , 
										   StageUtils.stage.stageHeight - 200 );
			
			windowTitle = new WindowTitleBar(title);
			windowContent = _textArea;
			
			var p : Panel = new Panel();
			p.childrenLayout = new InlineLayout( p, 3, "right", "center", "leftToRight" );
			p.addComponent( new Button(new ProxyAction(copyToClipboard, _("Copy To Clipboard") ) ) );			p.addComponent( new Button(new ProxyAction(close, _("Close") ) ) );
			p.style.setForAllStates("insets", new Insets(5));
			windowStatus = p;
			
			resizable = true;
			
			var s: String = new GPrettify().prettyPrintOne( text, "default", true );	
			_textArea.value = "<p>"+s+"</p>";
		}
		protected function textRepaint (event : ComponentEvent) : void 
		{
			_lineRuler.repaint();
		}
		override public function open (closePolicy : String = null) : void 
		{
			super.open( closePolicy );
			x = ( StageUtils.stage.stageWidth - width ) / 2;			y = ( StageUtils.stage.stageHeight - height ) / 2;
		}

		public function copyToClipboard() : void
		{
			System.setClipboard( _textArea.text );
		}
	}
}

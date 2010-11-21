package aesia.com.ponents.builder.dialogs 
{
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.actions.ProxyAction;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.containers.Window;
	import aesia.com.ponents.containers.WindowTitleBar;
	import aesia.com.ponents.layouts.components.InlineLayout;
	import aesia.com.ponents.text.TextArea;
	import aesia.com.ponents.utils.Insets;

	import flash.system.System;

	/**
	 * @author cedric
	 */
	public class PrintDialog extends Window 
	{
		protected var _textArea : TextArea;

		public function PrintDialog ( text : String, title : String )
		{
			_textArea = new TextArea();
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
			
			_textArea.value = text;
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

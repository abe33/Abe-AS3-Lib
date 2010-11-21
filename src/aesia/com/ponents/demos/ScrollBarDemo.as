package aesia.com.ponents.demos 
{
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author Cédric Néhémie
	 */
	public class ScrollBarDemo extends Sprite 
	{
		public function ScrollBarDemo ()
		{
			StageUtils.setup( this );
			ToolKit.initializeToolKit();

			KeyboardControllerInstance.eventProvider = stage;
			
			var txtF : TextField = new TextField();
			txtF.multiline = true;
			txtF.wordWrap = true;
			txtF.type = "input";
			txtF.width = 200;			txtF.height = 150;
			txtF.x = 5;			txtF.y = 5;
			txtF.defaultTextFormat = new TextFormat( "Arial", 12 );
			txtF.border = true;
			txtF.text = "Nec minus feminae quoque calamitatum participes fuere similium. nam ex hoc quoque sexu peremptae sunt originis altae conplures, adulteriorum flagitiis obnoxiae vel stuprorum. inter quas notiores fuere Claritas et Flaviana, quarum altera cum duceretur ad mortem, indumento, quo vestita erat, abrepto, ne velemen quidem secreto membrorum sufficiens retinere permissa est. ideoque carnifex nefas admisisse convictus inmane, vivus exustus est.\n\n" +
			"Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat.";
			/*
			var scb : VScrollBar = new VScrollBar( new VTextFieldHandler( txtF ) );
			scb.x = 205;
			scb.y = 5;
			
			var hscb : HScrollBar = new HScrollBar( new HTextFieldHandler( txtF ) );
			hscb.x = 5;
			hscb.y = 155;
			
			ToolKit.mainLevel.addChild( txtF );			ToolKit.mainLevel.addChild( scb );			ToolKit.mainLevel.addChild( hscb );*/
		}
	}
}

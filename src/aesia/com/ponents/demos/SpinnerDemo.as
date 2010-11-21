package aesia.com.ponents.demos 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.DateUtils;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.models.SpinnerDateModel;
	import aesia.com.ponents.models.SpinnerListModel;
	import aesia.com.ponents.models.SpinnerNumberModel;
	import aesia.com.ponents.spinners.Spinner;
	import aesia.com.ponents.tools.DebugPanel;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;
	import flash.text.TextFormat;
	/**
	 * @author Cédric Néhémie
	 */
	public class SpinnerDemo extends Sprite 
	{
		public function SpinnerDemo ()
		{
			StageUtils.setup(this);
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();
			
			var p : DebugPanel = new DebugPanel();
			ToolKit.popupLevel.addChild(p);
			
			KeyboardControllerInstance.eventProvider = stage;
			
			try
			{
				var spinner1 : Spinner = new Spinner( new SpinnerNumberModel( 1, 0, 10, 1, true ) );
				spinner1.x = 10;
				spinner1.y = 10;
				
				var spinner2 : Spinner = new Spinner( new SpinnerNumberModel( 5, 0, 10, 1, true ) );
				spinner2.x = 10;
				spinner2.y = 40;
				spinner2.enabled = false;
				
				var spinner3 : Spinner = new Spinner( new SpinnerListModel( "Item 1 ", 
																			"Item 2", 
																			"Item 3 with a longer text", 
																			"Item 4", 
																			"Item 5" ) );
				spinner3.x = 10;
				spinner3.y = 70;
				spinner3.preferredSize = new Dimension( 150, 50 );
				
				var spinner4 : Spinner = new Spinner( new SpinnerListModel( "Item 1 ", 
																			"Item 2", 
																			"Item 3 with a longer text", 
																			"Item 4", 
																			"Item 5" ) );
				spinner4.x = 10;
				spinner4.y = 130;
				spinner4.model.value = "Item 3";
				spinner4.enabled = false;
				
				var sdm : SpinnerDateModel = new SpinnerDateModel();
				sdm.formatFunction = function ( d : Date ) : String
				{
					return DateUtils.format( d, "F Y, l \\t\\h\\e jS" );
				};
				
				var spinner5 : Spinner = new Spinner( sdm );
				spinner5.x = 10;
				spinner5.y = 160;
				var tf : TextFormat = new TextFormat( "Verdana", 11 );
				tf.align = "left";
				spinner5.input.style.setForAllStates( "format" , tf );
				spinner5.allowInput = false;
				spinner5.preferredWidth = 250;
				
				ToolKit.mainLevel.addChild( spinner1 );
				ToolKit.mainLevel.addChild( spinner2 );
				ToolKit.mainLevel.addChild( spinner3 );
				ToolKit.mainLevel.addChild( spinner4 );
				ToolKit.mainLevel.addChild( spinner5 );
			}
			catch( e : Error ) 
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
		
	}
}

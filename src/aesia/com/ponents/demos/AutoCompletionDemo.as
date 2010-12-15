package aesia.com.ponents.demos 
{
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.actions.ProxyAction;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.completion.AutoCompletion;
	import aesia.com.ponents.completion.InputMemory;
	import aesia.com.ponents.text.TextArea;
	import aesia.com.ponents.text.TextInput;
	import aesia.com.ponents.tools.DebugPanel;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;
	/**
	 * @author Cédric Néhémie
	 */
	public class AutoCompletionDemo extends Sprite 
	{
		public function AutoCompletionDemo ()
		{
			StageUtils.setup(this);
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();
			
			var p : DebugPanel = new DebugPanel();
			ToolKit.popupLevel.addChild(p);
			
			KeyboardControllerInstance.eventProvider = stage;
			
			try
			{
				var input1 : TextInput = new TextInput();
				input1.x = 10;
				input1.y = 10;
				
				var input2 : TextInput = new TextInput();
				input2.x = 10;
				input2.y = 40;
				
				var tarea : TextArea = new TextArea();
				tarea.x = 10;
				tarea.y = 80;
				
				/*FDT_IGNORE*/ FEATURES::AUTOCOMPLETION { /*FDT_IGNORE*/
					
					var c1 : AutoCompletion = new AutoCompletion( input1 );
					c1.collection = [ "Abe", "Fred", "Gate", "Mel", "Mounir", 
									 "Marie", "Maria", "Marius", "Marcel", "Martine", "Marco", "Marcus", "Marion", "Marbella", "Maurice" ];
					c1.charactersCountBeforeSuggest = 1;
					input1.autoComplete = c1;
					
					var c2 : InputMemory = new InputMemory( input2, "demo", true );
					c2.charactersCountBeforeSuggest = 1;
					var bt : Button = new Button( new ProxyAction( c2.registerCurrent, "Register Current" ) );
					ToolKit.mainLevel.addChild( bt );		
					input2.autoComplete = c2;
					
					var c3 : AutoCompletion = new AutoCompletion( tarea );
					c3.collection = [ "Abe", "Fred", "Gate", "Mel", "Mounir", 
									 "Marie", "Maria", "Marius", "Marcel", "Martine", "Marco", "Marcus", "Marion", "Marbella", "Maurice" ];
					c3.charactersCountBeforeSuggest = 3;
					c3.checkWordAtCaret = true;
					tarea.autoComplete = c3;
				
					bt.x = 120;
					bt.y = 40;
					
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				ToolKit.mainLevel.addChild( input1 );		
				ToolKit.mainLevel.addChild( input2 );		
				ToolKit.mainLevel.addChild( tarea );
			}
			catch( e : Error ) 
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
	}
}

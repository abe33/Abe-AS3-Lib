package aesia.com.ponents.demos 
{
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.containers.FieldSet;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.layouts.components.GridLayout;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	public class FieldSetDemo extends Sprite 
	{
		
		public function FieldSetDemo ()
		{
			StageUtils.setup( this );
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();

			KeyboardControllerInstance.eventProvider = stage;
			
			var p : Panel = new Panel();
			p.childrenLayout = new GridLayout( p, 1, 2, 5 );
			
			var fieldset1 : FieldSet = new FieldSet();
			fieldset1.x = 10;			fieldset1.y = 10;
			fieldset1.childrenLayout = new GridLayout( null, 1, 1 );
			fieldset1.addComponent( new Button() );
						var fieldset2 : FieldSet = new FieldSet( "FieldSet" );
			fieldset2.x = 220;
			fieldset2.y = 10;
			fieldset2.childrenLayout = new GridLayout( null, 1, 1 );
			fieldset2.addComponent( new Button() );
			
			p.addComponent( fieldset1 );						p.addComponent( fieldset2 );			
			StageUtils.lockToStage( p );
			ToolKit.mainLevel.addChild( p );		}
	}
}

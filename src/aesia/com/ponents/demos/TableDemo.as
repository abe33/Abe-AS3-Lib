package aesia.com.ponents.demos 
{
	import aesia.com.mands.ProxyCommand;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Keys;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.dnd.DnDDragObjectRenderer;
	import aesia.com.ponents.dnd.DnDDropRenderer;
	import aesia.com.ponents.dnd.DnDManagerInstance;
	import aesia.com.ponents.history.UndoManagerInstance;
	import aesia.com.ponents.lists.List;
	import aesia.com.ponents.lists.ListLineRuler;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.tables.Table;
	import aesia.com.ponents.tables.TableColumn;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.Orientations;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	public class TableDemo extends Sprite 
	{
		private var dragRenderer : DnDDragObjectRenderer;
		private var dropRenderer : DnDDropRenderer;
		
		public function TableDemo ()
		{
			StageUtils.setup( this );
			ToolKit.initializeToolKit();
			
			KeyboardControllerInstance.eventProvider = stage;
			KeyboardControllerInstance.addGlobalKeyStroke( KeyStroke.getKeyStroke( Keys.Z, KeyStroke.getModifiers( true ) ), 
											  new ProxyCommand( UndoManagerInstance.undo ) );
			KeyboardControllerInstance.addGlobalKeyStroke( KeyStroke.getKeyStroke( Keys.Y, KeyStroke.getModifiers( true ) ), 
											  new ProxyCommand( UndoManagerInstance.redo ) );
											  
			var lv : LogView = new LogView();
			lv.size = new Dimension(200,200);
			lv.x = 320;
			lv.y = 10;
			ToolKit.mainLevel.addChild( lv );
			
			var table : Table = new Table( {prenom:"Jean", nom:"Travequedal", age:"45", fired:false},
							 			   {prenom:"Jenny", nom:"Kaymakaiss", age:"27", fired:true},
							 			   {prenom:"Harry", nom:"Cot", age:"22", fired:true},
							 			   {prenom:"Jean", nom:"Travequedal", age:"45", fired:false},
							 			   {prenom:"Jenny", nom:"Kaymakaiss", age:"27", fired:true},
							 			   /*{prenom:"Harry", nom:"Cot", age:"22", fired:true},
							 			   {prenom:"Jean", nom:"Travequedal", age:"45", fired:false},
							 			   {prenom:"Jenny", nom:"Kaymakaiss", age:"27", fired:true},
							 			   {prenom:"Harry", nom:"Cot", age:"22", fired:true},
							 			   {prenom:"Jean", nom:"Travequedal", age:"45", fired:false},
							 			   {prenom:"Jenny", nom:"Kaymakaiss", age:"27", fired:true},
							 			   {prenom:"Harry", nom:"Cot", age:"22", fired:true},
							 			   {prenom:"Jean", nom:"Travequedal", age:"45", fired:false},
							 			   {prenom:"Jenny", nom:"Kaymakaiss", age:"27", fired:true},
							 			   {prenom:"Harry", nom:"Cot", age:"22", fired:true},
							 			   {prenom:"Jean", nom:"Travequedal", age:"45", fired:false},
							 			   {prenom:"Jenny", nom:"Kaymakaiss", age:"27", fired:true},
							 			   {prenom:"Harry", nom:"Cot", age:"22", fired:true},
							 			   {prenom:"Jean", nom:"Travequedal", age:"45", fired:false},
							 			   {prenom:"Jenny", nom:"Kaymakaiss", age:"27", fired:true},
							 			   {prenom:"Harry", nom:"Cot", age:"22", fired:true},
							 			   {prenom:"Jean", nom:"Travequedal", age:"45", fired:false},
							 			   {prenom:"Jenny", nom:"Kaymakaiss", age:"27", fired:true},*/
							 			   {prenom:"Harry", nom:"Cot", age:"22", fired:true}
							 			   );
			table.x = 10;			table.y = 10;
			table.rowHead = new ListLineRuler( table.view as List );
			table.header.addColumns( new TableColumn( "Viré", "fired", 50 ),
				 					 new TableColumn( "Prénom", "prenom" ),
				 					 new TableColumn( "Nom", "nom" ),
				 					 new TableColumn( "Age", "age", 50 ) );
			
			table.size = new Dimension(300,200);
			
			dragRenderer = new DnDDragObjectRenderer( DnDManagerInstance );
			dropRenderer = new DnDDropRenderer( DnDManagerInstance );
			
			ToolKit.mainLevel.addChild( table );
		}
	}
}

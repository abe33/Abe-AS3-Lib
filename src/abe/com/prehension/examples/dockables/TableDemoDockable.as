package abe.com.prehension.examples.dockables 
{
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.factory.ComponentFactory;
	import abe.com.ponents.layouts.components.GridLayout;
	import abe.com.ponents.lists.List;
	import abe.com.ponents.lists.ListLineRuler;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.tables.Table;
	import abe.com.ponents.tables.TableColumn;
	import abe.com.ponents.utils.Insets;
	/**
	 * @author cedric
	 */
	public class TableDemoDockable extends DemoDockable 
	{
		public function TableDemoDockable (id : String, label : * = null, icon : Icon = null)
		{
			super( id, null, label, icon );
		}
		override public function build (factory : ComponentFactory) : void
		{
			var printName : Function = function () : String
			{
				return this.name + " " + this.fname;
			}
			
			factory.group("movables"
								   ).build( Table, 
								   			"tablesDemoMultiSelectionTable", 
								   			[
								   			   {fname:"Ace", 		name:"Portgas D", 	age:"20", devil:true, 	toString:printName},
								 			   {fname:"Chopper", 	name:"Tony Tony", 	age:"15", devil:true, 	toString:printName},
								 			   {fname:"Monkey", 	name:"Monkey D", 	age:"17", devil:true, 	toString:printName},
								 			   {fname:"Nami", 		name:" ", 			age:"18", devil:false, 	toString:printName},
								 			   {fname:"Nico", 		name:"Robin", 		age:"28", devil:true, 	toString:printName},
								 			   {fname:"Sanji", 		name:" ", 			age:"19", devil:false, 	toString:printName},
								 			   {fname:"Vivi", 		name:"Nefertari", 	age:"16", devil:false, 	toString:printName},
								 			   {fname:"Usopp", 		name:" ", 			age:"17", devil:false, 	toString:printName},
								 			   {fname:"Zoro", 		name:"Roronoa", 	age:"19", devil:false, 	toString:printName},
								 			   {fname:"Franky", 	name:" ", 			age:"34", devil:false, 	toString:printName},
								 			   {fname:"Brook", 		name:" ", 			age:"88", devil:true, 	toString:printName}
								   			], 
								   			{allowMultiSelection:true},
								   			function( t : Table, ctx : Object ) : void
								   			{
								   				t.rowHead = new ListLineRuler( t.view as List );
								   				t.header.addColumns(
												 					 new TableColumn( "Name", "name" ),
												 					 new TableColumn( "First Name", "fname" ),
												 					 new TableColumn( "Devil", "devil", 50 ),
												 					 new TableColumn( "Age", "age", 50 )
				 					 			);
								   			}
								   ).build( Table, 
								   			"tablesDemoStaticTable", 
								   			[
								   			   {fname:"Naruto",  name:"Uzumaki", 	age:"16", toString:printName},
											   {fname:"Sasuke",  name:"Uchiwa", 	age:"16", toString:printName},
											   {fname:"Sakura",  name:"Haruno",	 	age:"16", toString:printName},
											   {fname:"Kakashi", name:"Hatake", 	age:"29", toString:printName},
											   {fname:"Minato",  name:"Namikaze", 	age:"--", toString:printName},
											   {fname:"Jiraya",  name:"", 			age:"--", toString:printName}
								   			], 
								   			{allowMultiSelection:false, dragEnabled:false, dropEnabled:false, editEnabled:false },
								   			function( t : Table, ctx : Object ) : void
								   			{
								   				t.rowHead = new ListLineRuler( t.view as List );
								   				t.header.addColumns(
												 					 new TableColumn( "Name", "name" ),
												 					 new TableColumn( "First Name", "fname" ),
												 					 new TableColumn( "Age", "age", 50 )
				 					 			);
								   			}
								   ).build( Table, 
								   			"tablesDemoDisabledStaticTable", 
								   			[
								   			   {fname:"Ichigo", 	name:"Kurosaki", 	age:"16", 	toString:printName},
											   {fname:"Orihime", 	name:"Inoue", 		age:"16", 	toString:printName},
											   {fname:"Sado", 		name:"Yasutora", 	age:"16", 	toString:printName},
											   {fname:"Rukia", 		name:"Kuchiki", 	age:"?", 	toString:printName},
											   {fname:"Uryû", 		name:"Ishida", 		age:"16", 	toString:printName},
											   {fname:"Yoruichi", 	name:"Shihōin", 	age:"?", 	toString:printName}
								   			], 
								   			{allowMultiSelection:false, dragEnabled:false, dropEnabled:false, editEnabled:false, enabled:false},
								   			function( t : Table, ctx : Object ) : void
								   			{
								   				t.rowHead = new ListLineRuler( t.view as List );
								   				t.header.addColumns(
												 					 new TableColumn( "Name", "name" ),
												 					 new TableColumn( "First Name", "fname" ),
												 					 new TableColumn( "Age", "age", 50 )
				 					 			);
								   			}
								   );
			
			factory.group("containers"
								   ).build( Panel, 
							   		   "tablesDemoPanel",
							   		    null,
							   			{ 'childrenLayout':new GridLayout(null, 1, 3, 3, 3) },
							   			onBuildComplete
							   	   );
			
		}
		protected function onBuildComplete ( p : Panel, ctx : Object ) : void 
		{
			ctx["tablesDemoPanel"].addComponents( ctx["tablesDemoMultiSelectionTable"],
												  ctx["tablesDemoStaticTable"],
												  ctx["tablesDemoDisabledStaticTable"]);
			
			ctx["tablesDemoPanel"].style.setForAllStates("insets", new Insets(4));
			_content = p;
		}
	}
}

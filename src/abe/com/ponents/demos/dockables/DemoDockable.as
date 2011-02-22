package abe.com.ponents.demos.dockables 
{
	import abe.com.ponents.containers.ScrollPane;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.Container;
	import abe.com.ponents.core.SimpleDockable;
	import abe.com.ponents.factory.ComponentBuildUnit;
	import abe.com.ponents.factory.ComponentFactory;
	import abe.com.ponents.skinning.icons.Icon;
	/**
	 * @author cedric
	 */
	public class DemoDockable extends SimpleDockable implements ComponentBuildUnit
	{
		public function DemoDockable ( id : String, content : Component = null, label : * = null, icon : Icon = null)
		{
			super( content, id, label, icon );
		}
		protected function fillBatch ( f : ComponentFactory,
									   cls : Class, 
									   id : String, 
									   args : Array, 
									   kwargs : Object, 
									   objs : Array,
									   callback : Function = null ) : void
		{
			 f.group("containers"
				   ).build( cls, 
				   			id,
				   			args,
				   			kwargs,
				   			function( c : Container, ctx : Object ):void
				   			{
				   				for( var i:uint=0;i<objs.length;i++ )
				   					c.addComponent( ctx[objs[i]] );
				   				/*
				   				if( callback != null )
									callback( c, ctx, objs );*/
							}
				   ).build( ScrollPane, 
				   			id+"ScrollPane", 
				   			null, 
				   			null,
				   			function( sp : ScrollPane, ctx:Object ):void
				   			{
				   				sp.view = ctx[ id ];
				   				sp.styleKey = "NoDecorationComponent";				   				sp.viewport.styleKey = "EmptyComponent";
				   				
				   				if( callback != null )
									callback( sp, ctx, objs );	
				   			}
				   );
		}
		
		protected function buildBatch( f : ComponentFactory,
									   cls : Class, 
									   num : uint,
									   idBase : String,
									   args : Array, 
									   kwargs : Array, 
									   container : Class, 
									   containerId : String,
									   cargs : Array=null, 
									   ckwargs : Object=null,
									   callback : Function=null ) : void
	   {
	   	
	   		var l : uint;
	   		var i : uint;
			l = num;
			var a : Array = [];
	   		for( i=0;i<l;i++ )
	   		{
				a.push( idBase + i );
				f.group("movables"
			    ).build( cls, 
			   			 idBase+i,
			   		 	args ? args[i] : null, 
						 kwargs ? kwargs[i] : null );
	   		}
	   		
	   		f.group("containers"
		    ).build( container, 
		   			containerId,
		   			cargs, 
					ckwargs, function( c : Container, ctx : Object ) : void
					{
						for( var i:uint=0;i<a.length;i++)
							c.addComponent( ctx[a[i]] );
						
						if( callback != null )
							callback( c, ctx, a );	
					}
		    );
		}
		
		public function build (factory : ComponentFactory) : void
		{
			
		}
	}
}

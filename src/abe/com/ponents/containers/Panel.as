package abe.com.ponents.containers 
{
	import abe.com.ponents.core.*;
	import abe.com.ponents.factory.*;
	import abe.com.ponents.buttons.*;
	import abe.com.ponents.text.*;
	import abe.com.ponents.layouts.components.*;
	import abe.com.ponents.utils.*;

	[Skinable(skin="EmptyComponent")]
	public class Panel extends AbstractContainer 
	{
	    FEATURES::BUILDER {
	        static public function buildPreview( factory : ComponentFactory, 
	                                             id : String, 
	                                             kwargs : Object = null ) : void
	        {
	            factory.group("movables")
	                   .build( Label, 
	                           id + "_label", 
	                           ["This is a sample label with wordWrap enabled."],
	                           {'wordWrap':true} )
	                   .build( Button, 
	                           id + "_button", 
	                           ["A sample button"] )
	                   .build( CheckBox, 
	                           id + "_checkBox", 
	                           ["A sample checkbox"] )
	                   .build( Panel, 
	                           id, 
	                           null,
	                           {'childrenLayout':new InlineLayout(null, 4,"left","top","topToBottom",true)},
	                           function ( p : Panel, ctx : Object ) : void
	                           {
	                                p.addComponents( ctx[id + "_label"],
	                                                 ctx[id + "_button"],
	                                                 ctx[id + "_checkBox"] );
	                                p.style.insets = new Insets(4);
	                           } );
	           
	        }
	    }
	}
}

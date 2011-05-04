package abe.com.ponents.tools 
{
	import abe.com.mon.geom.dm;
	import abe.com.mon.geom.pt;
	import abe.com.mon.logs.Log;
	import abe.com.mon.utils.Reflection;
	import abe.com.mon.utils.StringUtils;
	import abe.com.munication.remoting.NetConnectionFactory;
	import abe.com.munication.services.ServiceCall;
	import abe.com.munication.services.ServiceEvent;
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.actions.ProxyAction;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.completion.InputMemory;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.layouts.components.BorderLayout;
	import abe.com.ponents.layouts.components.GridLayout;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.lists.CustomEditCell;
	import abe.com.ponents.lists.ListEditor;
	import abe.com.ponents.menus.ComboBox;
	import abe.com.ponents.text.Label;
	import abe.com.ponents.text.TextInput;
	import abe.com.ponents.tools.prettify.GPrettify;
	import abe.com.ponents.utils.Insets;
	/**
	 * @author cedric
	 */
	public class ServiceTesterPanel extends Panel 
	{
		protected var _tgateway : TextInput;
		protected var _tservice : TextInput;
		protected var _tmethod : TextInput;
		protected var _callButton : Button;
		protected var _argumentsTypeCombo : ComboBox;
		protected var _argumentsList : ListEditor;
		protected var _call : ServiceCall;
		
		public function ServiceTesterPanel ()
		{
			styleKey = "DefaultComponent";
			style.setForAllStates("insets", new Insets(5));
			var l : BorderLayout = new BorderLayout(this, true);
			childrenLayout = l;
			
			var ph : Panel = new Panel();
			ph.childrenLayout = new GridLayout(ph, 2, 3, 3, 3);
			ph.style.insets = new Insets(0, 0, 0, 5 );
			
			_tgateway = new TextInput(0, false, "gateway", true );
			_tservice = new TextInput(0, false, "service", true );
			_tmethod  = new TextInput(0, false, "method", true );
			
			ph.addComponent(new Label(_("Gateway" ), _tgateway ) );
			ph.addComponent(new Label(_("Service" ), _tservice ) );
			ph.addComponent(new Label(_("Method" ), _tmethod ) );
			
			ph.addComponent( _tgateway );
			ph.addComponent( _tservice );
			ph.addComponent( _tmethod );
			
			addComponent( ph );
			l.north = ph;
			
			var pf : Panel = new Panel();
			pf.childrenLayout = new InlineLayout(pf, 3, "right", "top", "leftToRight", false );
			pf.style.insets = new Insets(0, 5, 0, 0);
			
			_callButton = new Button(new ProxyAction( performCall, _("Call Service") ) );
			_callButton.disableButtonDuringActionExecution = true;
			
			pf.addComponent( _callButton );
			
			addComponent( pf );
			l.south = pf;
			
			_argumentsTypeCombo = new ComboBox( 0, 
												"string", 
												false, 
												pt(0,0),
												dm(0,0) );
			_argumentsList = new ListEditor( [] ,_argumentsTypeCombo );
			_argumentsList.list.listCellClass = CustomEditCell;
			
			addComponent(_argumentsList );
			l.center = _argumentsList;			
		}
		
		public function get argumentsTypeCombo () : ComboBox { return _argumentsTypeCombo; }		
		public function get argumentsList () : ListEditor { return _argumentsList; }
		
		protected function performCall () : void
		{
			(_tgateway.autoComplete as InputMemory ).registerCurrent();
			(_tmethod.autoComplete as InputMemory ).registerCurrent();
			(_tservice.autoComplete as InputMemory ).registerCurrent();
			try
			{
				Log.info( _$( "Calling : $0 $1.$2($3)", 
							 _tgateway.value, 
							 _tservice.value, 
							 _tmethod.value, 
							 _argumentsList.value.join(", ")));
				_call = Reflection.buildInstance( ServiceCall, [ _tmethod.value, 
															    _tservice.value, 
															    NetConnectionFactory.get( _tgateway.value ),
															    handleResult,
															    handleError
															   ].concat( _argumentsList.value ) ) as ServiceCall;
				//new ServiceCall(method, serviceName, connection, resultListener, errorListener, args)
				_call.execute();
			}
			catch ( e : Error )
			{
				Log.error( "Error!\n" + e.message + "\n" + e.getStackTrace() );
			}
		}

		protected function handleResult ( e : ServiceEvent ) : void
		{
			var res : * = e.results;
			Log.debug( res );
			Log.debug( "Result:\n" + new GPrettify().prettyPrintOne( recursivePrint( res ), "default", true ), true );			
		}

		protected function handleError ( e : ServiceEvent ) : void
		{
			Log.error( "Error!\n" + e.results );
		}
		protected function recursivePrint( o:*, indent:String = ""):String
		{
			if( typeof o != "object" )
			{
				if( o is String )
					return "'"+o+"'";
				else
					return StringUtils.stringify( o );
			}
			else
			{
				var s : String = "";
				var s2 : String = "";
				var i:String;
				if( o is Array )
				{
					s = "[";
					s2 = "";
					for( i in o )
					{
						s2 += indent + "\t" + recursivePrint(o[i], indent + "\t") + ",\n";
					}
					if( s2 != "" )
						s += "\n" + s2 + indent;
					s += "]";
					return s;
				}
				else
				{
					s = StringUtils.stringify(o) + "{";
					s2 = "";
					for( i in o )
					{
						s2 += indent + "\t'" + i + "' : " +recursivePrint(o[i], indent + "\t") + ",\n";
					}
					if( s2 != "" )
						s += "\n"+s2+indent;
					s += "}";
					return s;
				}
			}
		}
	}
}

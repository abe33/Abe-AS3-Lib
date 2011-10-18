/**
 * @license
 */
package abe.com.munication.services
{
    import abe.com.mands.AbstractCommand;
    import abe.com.mon.utils.RandomUtils;
    import abe.com.munication.services.middleware.ServiceMiddleware;
    import abe.com.patibility.lang._;
    import abe.com.patibility.lang._$;

    import org.osflash.signals.Signal;

    import flash.net.NetConnection;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;
	/**
	 * @author Cédric Néhémie
	 */
	public class ServiceCall extends AbstractCommand
	{
		static public var anyServiceResponded : Signal = new Signal();
		static public var anyServiceErrorOccured : Signal = new Signal();
		static public var anyServiceCallStarted : Signal = new Signal();
		
		static public var timeout : int = -1;
		
		public var serviceResponded : Signal;
		public var serviceErrorOccured : Signal;
		public var serviceCallStarted : Signal;
		
		protected var _method : String;
		protected var _service : Service;
		protected var _serviceName : String;
		protected var _connection : NetConnection;
		protected var _args : Array;
		protected var _timeout : int;
		
		protected var _resultListener : Function;
		protected var _errorListener : Function;

		public function ServiceCall ( method : String,
									  serviceName : String,
									  connection : NetConnection,
									  resultListener : Function = null,
									  errorListener : Function = null,
									  ... args )
		{
			super();
			_method = method;
			_connection = connection;
			_serviceName = serviceName;

			_resultListener = resultListener;
			_errorListener = errorListener;

			_args = args;
			
			serviceResponded = new Signal();
			serviceErrorOccured = new Signal();
			serviceCallStarted = new Signal();
		}
		public function get args () : Array { return _args; }
		public function set args (args : Array) : void
		{
			_args = args;
		}

		public function get connection () : NetConnection { return _connection; }
		public function set connection (connection : NetConnection) : void
		{
			_connection = connection;
		}
		public function get serviceName () : String { return _serviceName; }
		public function set serviceName (serviceName : String) : void
		{
			_serviceName = serviceName;
		}
		public function get service () : Service { return _service; }

		public function get method () : String { return _method; }
		public function set method (method : String) : void
		{
			_method = method;
		}
		override public function execute( ... args ) : void
		{
			CONFIG::WITH_DISTANT_SERVER { 
				_service = ServiceFactory.get( _serviceName, _connection);
			} 

			CONFIG::WITH_LOCAL_SERVER { 
				_service = ServiceFactory.get( _serviceName, _connection);
			} 

			CONFIG::WITHOUT_SERVER { 
				_service = ShadowServiceFactory.get( _serviceName );
			} 

			if( _service )
			{
				registerToServiceSignals();

				CONFIG::WITH_DISTANT_SERVER { 
					(_service[_method] as Function).apply(null,_args);
				} 

				CONFIG::WITH_LOCAL_SERVER { 
					(_service[_method] as Function).apply(null,_args);
				} 

				CONFIG::WITHOUT_SERVER { 
					setTimeout.apply(null, [_service[_method] as Function, RandomUtils.rangeAB(250, 750) ].concat( _args ) );
				} 

				serviceCallStarted.dispatch( this );
				anyServiceCallStarted.dispatch( this );

				if( timeout != -1 )
					_timeout = setTimeout( callTimeout, timeout );
			}
			else
				_commandFailed.dispatch( this, _( "Can't realize the call cause the service don't exist or can't be retreived." ) );
		}

		protected function serviceResult( res : * ):void
		{
			clearTimeout(_timeout);
			try
			{
				if( ServiceMiddlewares.length > 0 )
					res = processMiddlewaresResults( res, ServiceMiddlewares );
					
				serviceResponded.dispatch( res );
				anyServiceResponded.dispatch( res );
				_commandEnded.dispatch( this );
				unregisterFromServiceSignals();
			}
			catch( e : Error )
			{
				unregisterFromServiceSignals();
				throw e;
			}
		}
		protected function serviceError( e : * ):void
		{
			clearTimeout(_timeout);
			try
			{
				if( ServiceMiddlewares.length > 0 )
					processMiddlewaresException( e, ServiceMiddlewares );
				
				var errorMsg : String = _$(_("$0\nError Code:$1"), e.description, e.code );
				serviceErrorOccured.dispatch( errorMsg );
				anyServiceErrorOccured.dispatch( errorMsg );
				commandFailed.dispatch( errorMsg );
				unregisterFromServiceSignals();
			}
			catch( ee : Error )
			{
				unregisterFromServiceSignals();
				throw ee;
			}
		}
		protected function callTimeout () : void
		{
			_service.abort();
			var errorMsg : String = _$(_("Connection Timeout!\nThe call to $0.$1($2) failed because the service haven't respond after $3 ms." ),
										_service.serviceName,
										_method,
										_args.join(","),
										timeout );

			serviceErrorOccured.dispatch( errorMsg );
			anyServiceErrorOccured.dispatch( errorMsg );
			commandFailed.dispatch( errorMsg );
			unregisterFromServiceSignals();
		}
		protected function processMiddlewaresResults( res : *, middlewares : Array ) : *
		{
			var l : uint = middlewares.length;
			
			for( var i : uint = 0; i <l ; i++)
				res = ( middlewares[i] as ServiceMiddleware ).processResult(res);
			
			return res;
		}
		protected function processMiddlewaresException( error : *, middlewares : Array ) : void
		{
			var l : uint = middlewares.length;
			
			for( var i : uint = 0; i <l ; i++)
				( middlewares[i] as ServiceMiddleware ).processException(error);
		}
		protected function registerToServiceSignals () : void
		{
			if( _resultListener != null )
				serviceResponded.add( _resultListener );
			if( _errorListener != null )
				serviceErrorOccured.add( _errorListener );	
			
			_service.serviceResponded.add( serviceResult );
			_service.serviceErrorOccured.add( serviceError );
		}
		protected function unregisterFromServiceSignals () : void
		{
			if( _resultListener != null )
				serviceResponded.remove( _resultListener );
			if( _errorListener != null )
				serviceErrorOccured.remove( _errorListener );	
				
			_service.serviceResponded.remove( serviceResult );
			_service.serviceErrorOccured.remove( serviceError );
		}
	}
}

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

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.NetConnection;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	[Event(name="serviceResult", type="abe.com.munication.services.ServiceEvent")]
	[Event(name="serviceError", type="abe.com.munication.services.ServiceEvent")]	[Event(name="serviceCallStart", type="abe.com.munication.services.ServiceEvent")]
	/**
	 * @author Cédric Néhémie
	 */
	public class ServiceCall extends AbstractCommand
	{
		static public const globalDispatcher : EventDispatcher = new EventDispatcher();

		static public var timeout : int = -1;

		protected var _method : String;
		protected var _service : Service;		protected var _serviceName : String;
		protected var _connection : NetConnection;
		protected var _args : Array;
		protected var _timeout : int;

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

			if( resultListener != null )
				addEventListener( ServiceEvent.SERVICE_RESULT, resultListener );
			if( errorListener != null )
				addEventListener( ServiceEvent.SERVICE_ERROR, errorListener );

			_args = args;
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
		override public function execute (e : Event = null) : void
		{
			/*FDT_IGNORE*/ CONFIG::WITH_DISTANT_SERVER { /*FDT_IGNORE*/
				_service = ServiceFactory.get( _serviceName, _connection);
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			/*FDT_IGNORE*/ CONFIG::WITH_LOCAL_SERVER { /*FDT_IGNORE*/
				_service = ServiceFactory.get( _serviceName, _connection);
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			/*FDT_IGNORE*/ CONFIG::WITHOUT_SERVER { /*FDT_IGNORE*/
				_service = ShadowServiceFactory.get( _serviceName );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			if( _service )
			{
				registerToServiceEvents();

				/*FDT_IGNORE*/ CONFIG::WITH_DISTANT_SERVER { /*FDT_IGNORE*/
					(_service[_method] as Function).apply(null,_args);
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/

				/*FDT_IGNORE*/ CONFIG::WITH_LOCAL_SERVER { /*FDT_IGNORE*/
					(_service[_method] as Function).apply(null,_args);
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/

				/*FDT_IGNORE*/ CONFIG::WITHOUT_SERVER { /*FDT_IGNORE*/
					setTimeout.apply(null, [_service[_method] as Function, RandomUtils.rangeAB(250, 750) ].concat( _args ) );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/

				dispatchEvent( new ServiceEvent( ServiceEvent.SERVICE_CALL_START, null ) );				globalDispatcher.dispatchEvent( new ServiceEvent( ServiceEvent.SERVICE_CALL_START, null ) );

				if( timeout != -1 )
					_timeout = setTimeout( callTimeout, timeout );
			}
			else
				fireCommandFailed(_("Can't realize the call cause the service don't exist or can't be retreived." ) );
		}

		protected function serviceResult( e : ServiceEvent ):void
		{
			clearTimeout(_timeout);
			var res : * = e.results;
			
			if( ServiceMiddlewares.length > 0 )
				res = processMiddlewaresResults( res, ServiceMiddlewares );
				
			dispatchEvent( new ServiceEvent( ServiceEvent.SERVICE_RESULT, res ) );			globalDispatcher.dispatchEvent( new ServiceEvent( ServiceEvent.SERVICE_RESULT, res ) );
			fireCommandEnd();
			unregisterFromServiceEvents();
		}
		protected function serviceError(e : ServiceEvent):void
		{
			clearTimeout(_timeout);
			
			if( ServiceMiddlewares.length > 0 )
				processMiddlewaresException( e.results, ServiceMiddlewares );
			
			var errorMsg : String = _$(_("$0\nError Code:$1"), e.results.description, e.results.code );
			dispatchEvent( new ServiceEvent( ServiceEvent.SERVICE_ERROR, errorMsg ) );			globalDispatcher.dispatchEvent( new ServiceEvent( ServiceEvent.SERVICE_ERROR, errorMsg ) );
			fireCommandEnd();
			unregisterFromServiceEvents();
		}
		protected function callTimeout () : void
		{
			_service.abort();
			var errorMsg : String = _$(_("Connection Timeout!\nThe call to $0.$1($2) failed because the service haven't respond after $3 ms." ),
										_service.serviceName,
										_method,
										_args.join(","),
										timeout );

			dispatchEvent( new ServiceEvent( ServiceEvent.SERVICE_ERROR, errorMsg ) );
			globalDispatcher.dispatchEvent( new ServiceEvent( ServiceEvent.SERVICE_ERROR, errorMsg ) );
			fireCommandEnd();
			unregisterFromServiceEvents();
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
		protected function registerToServiceEvents () : void
		{
			_service.addEventListener(ServiceEvent.SERVICE_RESULT, serviceResult, false, 0, true );
			_service.addEventListener(ServiceEvent.SERVICE_ERROR, serviceError, false, 0, true );
		}
		protected function unregisterFromServiceEvents () : void
		{
			_service.removeEventListener(ServiceEvent.SERVICE_RESULT, serviceResult );
			_service.removeEventListener(ServiceEvent.SERVICE_ERROR, serviceError );
		}
	}
}

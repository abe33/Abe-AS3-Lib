/**
 * @license
 */
package abe.com.munication.services
{
	import abe.com.mon.logs.Log;
	import abe.com.munication.services.middleware.ServiceMiddleware;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	 * Diffusé par l'instance en cas de succès de la communication avec le service.s
	 *
	 * @eventType abe.com.munication.services.ServiceEvent.SERVICE_RESULT
	 */
	[Event(name="serviceResult", type="abe.com.munication.services.ServiceEvent")]
	/**
	 * Diffusé par l'instance en cas d'échec de la communication avec le service
	 *
	 * @eventType abe.com.munication.services.ServiceEvent.SERVICE_ERROR
	 */
	[Event(name="serviceError", type="abe.com.munication.services.ServiceEvent")]	/**
	 * La classe <code>Service</code> représente un proxy vers un service distant.
	 * <p>
	 * Il suffit d'appeler une méthode sur cette objet pour provoquer une communication
	 * avec le service correspondant, les arguments transmis à la fonction seront alors
	 * utilisés comme données transmises au serveur.
	 * </p>
	 *
	 * @author Cédric Néhémie
	 */
	dynamic public class Service extends Proxy implements IEventDispatcher
	{
		/**
		 * Le nom du service.
		 */
		protected var _serviceName : String;
		/**
		 * La connection à utiliser.
		 */
		protected var _netConnection : NetConnection;
		/**
		 * L'objet utilisé pour réaliser l'appel.
		 */
		protected var _responder : Responder;
		/**
		 * Composition d'un <code>EventDispatcher</code> utilisé pour
		 * la diffusion des évènements.
		 */
		protected var _eD : EventDispatcher;
		/**
		 * Constructeur de la classe <code>Service</code>.
		 *
		 * @param	name		le nom du service
		 * @param	connection	la connection à utiliser
		 */
		public function Service ( name : String = null, connection : NetConnection = null )
		{
			_serviceName = name;
			_netConnection = connection;
			_responder = new Responder( handleResult, handleStatus );
			_eD = new EventDispatcher(this);
		}
		/**
		 * Le nom du service.
		 */
		public function get serviceName () : String { return _serviceName; }
		/**
		 * Intercepte les accès à des propriétés non-définies et réalise
		 * un appel au service sans arguments.
		 *
		 * @param	name	nom de la propriété
		 */
		override flash_proxy function getProperty (name : *) : *
		{
			var n : String = name;
			return function (... args) : *
			{
				flash_proxy::callProperty.apply(null,[n].concat(args));
			};
		}
		/**
		 * Intercepte les accès à des méthodes non-définies et réalise
		 * un appel au service avec les arguments transmis.
		 */
		override flash_proxy function callProperty (name : *, ...args : *) : *
		{
			if( _netConnection && _serviceName )
				_netConnection.call.apply( null, [_serviceName + "." + name, _responder].concat(args) );
		}
		/**
		 * Interrompt la connection avec le service.
		 */
		public function abort() : void
		{
			if( _netConnection && _netConnection.connected )
				_netConnection.close();
		}
		/**
		 * Diffuse un évènement de type <code>ServiceEvent.SERVICE_RESULT</code> aux
		 * écouteurs de ce service.
		 *
		 * @param	result	le résultat à transmettre
		 */
		protected function fireServiceResultEvent ( result : *) : void
		{
			dispatchEvent( new ServiceEvent( ServiceEvent.SERVICE_RESULT, result ) );
		}		
		/**
		 * Diffuse un évènement de type <code>ServiceEvent.SERVICE_ERROR</code> aux
		 * écouteurs de ce service.
		 *
		 * @param	error	l'erreur à transmettre
		 */
		protected function fireServiceErrorEvent ( error : *) : void
		{
			dispatchEvent( new ServiceEvent( ServiceEvent.SERVICE_ERROR, error ) );
		}

		public function dispatchEvent (event : Event) : Boolean
		{
			return _eD.dispatchEvent( event );
		}
		public function hasEventListener (type : String) : Boolean
		{
			return _eD.hasEventListener(type);
		}
		public function willTrigger (type : String) : Boolean
		{
			return _eD.willTrigger(type);
		}
		public function removeEventListener (type : String, listener : Function, useCapture : Boolean = false) : void
		{
			_eD.removeEventListener(type, listener, useCapture );
		}
		public function addEventListener (type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void
		{
			_eD.addEventListener(type, listener, useCapture, priority, useWeakReference );
		}
		private function handleResult(... args):void
		{
			fireServiceResultEvent( args[0] );
		}
		private function handleStatus(... args):void
		{
			fireServiceErrorEvent( args[0] );
		}
	}
}

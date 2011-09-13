/**
 * @license
 */
package abe.com.munication.services
{
    import org.osflash.signals.Signal;

    import flash.net.NetConnection;
    import flash.net.Responder;
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;

	/**
	 * La classe <code>Service</code> représente un proxy vers un service distant.
	 * <p>
	 * Il suffit d'appeler une méthode sur cette objet pour provoquer une communication
	 * avec le service correspondant, les arguments transmis à la fonction seront alors
	 * utilisés comme données transmises au serveur.
	 * </p>
	 *
	 * @author Cédric Néhémie
	 */
	dynamic public class Service extends Proxy
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
		
		public var serviceResponded : Signal;
		public var serviceErrorOccured : Signal;
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
			serviceResponded = new Signal();
			serviceErrorOccured = new Signal();
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
		 */
		protected function fireServiceRespondedSignal ( result : *) : void
		{
			serviceResponded.dispatch( result );
		}		
		/**
		 */
		protected function fireServiceErrorOcurredSignal ( error : *) : void
		{
			serviceErrorOccured.dispatch( error );
		}
		private function handleResult(... args):void
		{
			fireServiceRespondedSignal( args[0] );
		}
		private function handleStatus(... args):void
		{
			fireServiceErrorOcurredSignal( args[0] );
		}
	}
}

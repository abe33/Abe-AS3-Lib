/**
 * @license
 */
package abe.com.munication.services
{

	/**
	 * @author Cédric Néhémie
	 */
	public class ShadowServiceFactory
	{
		static protected var _services : Object = {};

		static public function get( serviceName : String ) : Service
		{
			if( _services.hasOwnProperty( serviceName ) )
				return _services[ serviceName ];
			else
				return null;
		}

		static public function registerService ( name : String, service : ShadowService ) : void
		{
			if( !_services.hasOwnProperty( name ) )
				_services[ name ] = service;
		}
	}
}

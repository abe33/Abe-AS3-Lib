/**
 * @license
 */
package aesia.com.munication.services
{
	import flash.net.NetConnection;

	/**
	 * @author Cédric Néhémie
	 */
	public class ServiceFactory
	{
		static protected var _services : Object = {};

		static public function get( serviceName : String, connection : NetConnection ) : Service
		{
			if( _services[ serviceName ] )
				return _services[ serviceName ];
			else
				return _services[ serviceName ] = new Service( serviceName, connection );
		}
	}
}

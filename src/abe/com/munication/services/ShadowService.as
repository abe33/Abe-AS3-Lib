/**
 * @license
 */
package abe.com.munication.services
{
	import flash.net.NetConnection;
	/**
	 * @author Cédric Néhémie
	 */
	dynamic public class ShadowService extends Service
	{
		protected var _aborted : Boolean;

		public function ShadowService ( name : String = null, connection : NetConnection = null )
		{
			super( name, connection );
			_aborted = false;
		}
		override public function abort () : void
		{
			_aborted = true;
		}

		override protected function fireServiceResultEvent ( result : *) : void
		{
			if(!_aborted)
				dispatchEvent( new ServiceEvent( ServiceEvent.SERVICE_RESULT, result ) );
			else _aborted = false;
		}

		override protected function fireServiceErrorEvent ( error : *) : void
		{
			if(!_aborted)
				dispatchEvent( new ServiceEvent( ServiceEvent.SERVICE_ERROR, error ) );
			else _aborted = false;
		}
	}
}

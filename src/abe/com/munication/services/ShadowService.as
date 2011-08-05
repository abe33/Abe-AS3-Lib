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

		override protected function fireServiceRespondedSignal ( result : *) : void
		{
			if(!_aborted)
				serviceResponded.dispatch( result );
			else _aborted = false;
		}

		override protected function fireServiceErrorOcurredSignal ( error : *) : void
		{
			if(!_aborted)
				serviceErrorOccured.dispatch( error );
			else _aborted = false;
		}
	}
}

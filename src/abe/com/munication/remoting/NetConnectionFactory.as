/**
 * @license
 */
package abe.com.munication.remoting
{
	import abe.com.mon.logs.Log;

	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;

	/**
	 * La classe <code>NetConnectionFactory</code> fournit un moyen de construire
	 * et de conserver des connections vers un serveur sous la forme d'objets
	 * <code>NetConnection</code>.
	 *
	 * @author Cédric Néhémie
	 */
	public class NetConnectionFactory
	{
		static private var _connections : Object = {};
		/**
		 * Renvoie un objet <code>NetConnection</code> pour la passerelle
		 * <code>gateway</code>.
		 *
		 * @param	gateway	la passerelle pour laquelle obtenir une connection
		 * @return	un objet <code>NetConnection</code> pour la passerelle
		 */
		static public function get( gateway : String ) : NetConnection
		{
			var con : NetConnection;
			if( _connections[ gateway ] )
			{
				con = _connections[ gateway ];
				/*
				if( !con.connected )
					con.connect( gateway );
				*/
				return con;
			}
			else
			{
				con = _connections[ gateway ] = new NetConnection();
				con.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncError );				con.addEventListener(IOErrorEvent.IO_ERROR, ioError );				con.addEventListener(NetStatusEvent.NET_STATUS, netStatus );
				con.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError );
				con.connect( gateway );
				return con;
			}
		}

		static private function securityError (event : SecurityErrorEvent) : void
		{
			/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
				Log.error( "Error : " + event.text );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		static private function netStatus (event : NetStatusEvent) : void
		{
			/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
				var o:  Object = event.info;
				var s : String = "";

				for(var i:String in o)
					s+="\n" + i + " : " + o[i];

				Log.info( "Status : " + s );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		static private function ioError (event : IOErrorEvent) : void
		{
			/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
				Log.error( "Error : " + event.text );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		static private function asyncError (event : AsyncErrorEvent) : void
		{
			/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
				Log.error( "Error : " + event.text );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
	}
}

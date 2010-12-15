package aesia.com.munication.services.middleware 
{
	/**
	 * @author cedric
	 */
	public interface ServiceMiddleware 
	{
		function processResult( res : * ) : *;
		function processException( error : * ) : void;
	}
}

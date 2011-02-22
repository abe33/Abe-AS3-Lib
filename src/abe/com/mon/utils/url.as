package abe.com.mon.utils
{
	import flash.net.URLRequest;
	/**
	 * Renvoie une instance de la classe <code>URLRequest</code> pointant
	 * vers l'URL passée en paramètre.
	 *
	 * @param	url	une adresse vers laquelle pointée
	 * @return	une instance de la classe <code>URLRequest</code>
	 * @author Cédric Néhémie
	 */
	public function url ( url : String ) : URLRequest
	{
		return new URLRequest(url);
	}
}

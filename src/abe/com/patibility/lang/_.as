package abe.com.patibility.lang 
{
	/**
	 * Renvoie la traduction pour la chaîne <code>id</code> transmise en argument. 
	 * Si aucune traduction n'existe pour <code>id</code>, la chaîne <code>id</code>
	 * est renvoyée.
	 * <p>
	 * La fonction <code>_</code> est un alias de la fonction <code>GetText.translate</code>
	 * tel que préconisé dans la documentation de <a href="http://www.gnu.org/software/hello/manual/gettext/">gettext</a>.
	 * </p>
	 * @param	id	chaîne à traduire
	 * @return	la traduction correspondante si il en existe une, sinon la chaîne <code>id</code>
	 * 			est renvoyée
	 * @see GetText#translate()
	 */
	public function _( id : String ) : String
	{
		return GetTextInstance.translate( id );
	}
}

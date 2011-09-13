package abe.com.patibility.lang
{
    import abe.com.mon.utils.StringUtils;
	/**
	 * Renvoie la chaîne <code>str</code> où les jetons d'insertions ont été
	 * remplacés par les arguments transmis dans le paramètre <code>args</code>.
	 * <p>
	 * Les jetons d'insertions se présentent sous la forme <code>$N</code> où
	 * <code>N</code> représentent l'index de la valeur de <code>args</code>
	 * à utiliser pour le remplacement. L'ordre des jetons dans la chaîne n'a
	 * aucun impact sur le traitement des remplacements.
	 * </p>
	 * <p>
	 * Cette fonction est un alias à la fonction <code>StringUtils.tokenReplace</code>.
	 * </p>
	 * @param	str		la chaîne dans laquelle opérer les remplacements
	 * @param	args	liste des éléments servant pour les remplacements
	 * 					au sein de la chaîne <code>str</code>
	 * @return	la chaîne <code>str</code> dont les jetons auront été remplacés
	 * 			par les éléments transmis dans <code>args</code>
	 * @see abe.com.mon.utils.StringUtils#tokenReplace()
	 * @example <listing>trace( _$('Hello $0 ! Welcome in $1.', 'World', 'Hell') );
	 * // output : Hello World ! Welcome in Hell.</listing>
	 */
	public function _$ ( str : String, ...args ) : String
	{
		return StringUtils.tokenReplace.apply( null, [str].concat(args) );
	}
}
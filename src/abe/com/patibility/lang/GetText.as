package abe.com.patibility.lang
{
	import abe.com.mon.utils.StringUtils;

	/**
	 * La classe <code>GetText</code> implémente le mécanisme de localisation
	 * <code>gettext</code> définie par le proget <code>GNU</code>.
	 *
	 * @author Cédric Néhémie
	 * @see	http://www.gnu.org/software/gettext/ gettext on GNU Project
	 */
	public class GetText
	{
		/**
		 * Un objet contenant les paires <code>clés-&gt;traductions</code>.
		 */
		protected var _translations : Object;
		/**
		 * Un objet contenant les informations sur cette localisation.
		 */
		protected var _infos : Object;
		/**
		 * Un chaîne de caractère contenant le type d'encodage de cette localisation.
		 */
		protected var _charset : String;
		/**
		 * Renvoie la traduction pour la chaîne <code>id</code> transmise en argument.
		 * Si aucune traduction n'existe pour <code>id</code>, la chaîne <code>id</code>
		 * est renvoyée.
		 *
		 * @param	id	chaîne à traduire
		 * @return	la traduction correspondante si il en existe une, sinon la chaîne <code>id</code>
		 * 			est renvoyée
		 */
		public function translate ( id : String ) : String
		{
			if( _translations && _translations.hasOwnProperty( id ) )
			{
				var s : String = _translations[ id ];
				if( s != "" )
					return _translations[ id ];
				else return id;
			}
			else
				return id;
		}
		/**
		 * Un objet contenant les paires <code>clés-&gt;traductions</code>.
		 */
		public function get translations () : Object { return _translations; }
		public function set translations (translations : Object) : void
		{
			_translations = translations;
		}
		/**
		 * Un objet contenant les informations sur cette localisation.
		 */
		public function get infos () : Object { return _infos; }
		public function set infos (infos : Object) : void
		{
			_infos = infos;
		}
		/**
		 * Un chaîne de caractère contenant le type d'encodage de cette localisation.
		 */
		public function get charset () : String { return _charset; }
		public function set charset (charset : String) : void
		{
			_charset = charset;
		}
		/**
		 * Ajoute les traductions présentes dans <code>translations</code>
		 * dans l'objet courant.
		 */
		public function addTranslations ( translations : Object ) : void
		{
			if( !_translations )
				_translations = {};

			for(var i : String in translations)
				_translations[i] = translations[i];
		}
	}
}

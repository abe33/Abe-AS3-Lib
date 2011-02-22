package abe.com.patibility.lang
{

	import abe.com.patibility.lang.LocaleObject;
	import abe.com.patibility.lang.Locale;
	/**
	 * La classe <code>LocalePath</code> représente un lien vers une entrée d'un
	 * objet <code>Locale</code>.
	 *
	 * @author Cédric Néhémie
	 */
	public class LocalePath
	{
		/**
		 * L'identifiant de l'objet <code>Locale</code>.
		 */
		public var localeID : String;
		/**
		 * Le chemin vers l'élément de la localisation.
		 */
		public var localePath : String;
		/**
		 * Constructeur de la classe <code>LocalePath</code>.
		 *
		 * @param	localeID		l'identifiant de l'objet <code>Locale</code>
		 * @param	localePath	le chemin vers l'élément de localisation.
		 */
		public function LocalePath ( localeID : String, localePath : String )
		{
			this.localeID = localeID;
			this.localePath = localePath;
		}
		/**
		 * Renvoie l'objet de traduction présent dans l'objet <code>Locale</code>
		 * au chemin indiqué.
		 *
		 * @param	args	un tableau d'arguments à transmettre à l'objet <code>Locale</code>
		 * @return	l'objet de traduction présent dans l'objet <code>Locale</code>
		 * 			au chemin indiqué
		 */
		public function get ( args : Array = null ) : *
		{
			var path : Array = localePath.split(".");
			var locale : LocaleObject = Locale.get( localeID );

			if( locale )
			{
				while( path.length )
				{
					var id : String = path.shift();

					if( path.length > 0 )
						locale = locale[ id ];
					else
					{
						if( args )
							return locale.get( id, args );
						else
							return locale[ id ];
					}
				}
			}
			return null;
		}
	}
}

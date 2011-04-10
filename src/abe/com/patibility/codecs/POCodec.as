/**
 * @license
 */
package abe.com.patibility.codecs
{
	import abe.com.mon.utils.StringUtils;

	/**
	 * La classe <code>POCodec</code> permet d'encoder et de décoder
	 * des fichiers de traductions au format <code>PO</code> de <code>gettext</code>.
	 *
	 * @author Cédric Néhémie
	 * @see http://www.gnu.org/software/hello/manual/gettext/PO-Files.html Format PO
	 */
	public class POCodec implements Codec
	{
		/**
		 * Constante de caractères de début de commentaire.
		 */
		static public const COMMENT_CHAR : String = "#";
		/**
		 * Constante de préfixe d'identifiant.
		 */
		static public const ID_PREFIX : String = "msgid";
		/**
		 * Constante de prefixe de message.
		 */
		static public const STR_PREFIX : String = "msgstr";
		/**
		 * Constante de caractère d'encadrement des chaînes de messages.
		 */
		static public const QUOTE_CHAR : String = '"';
		/**
		 * @inheritDoc
		 */
		public function encode (o : *) : *
		{
			if( o is Object )
			{
				var s : String = ID_PREFIX + ' ""\n' + STR_PREFIX + '""\n\n';
				for( var i: String in o)
				{
					s += 'msgid "' + i +'"\n';					s += 'msgstr "' + o[i] +'"\n';
				}

				return s;
			}
			else
				throw new Error( "POCodec.encode method accepts only objects of type Object as argument." );

			return null;
		}
		/**
		 * @inheritDoc
		 */
		public function decode (o : *) : *
		{
			if( o is String )
			{
				var s : String = o as String;
				// Removes the comments and empty lines
				s = s.replace( new RegExp( "^" + COMMENT_CHAR +"(.*)$", "gmi" ), "" );				s = StringUtils.trim(s);

				// Split using the msgid token
				var a : Array = s.split( ID_PREFIX );
				a.shift();

				var ob : Object = {};
				var l : uint = a.length;

				// looping through the strings
				for( var i : uint = 0; i < l; i++ )
				{
					var b : Array = (a[i] as String).split( STR_PREFIX );
					var key : String = StringUtils.trim(b[0]);					var value : String = StringUtils.trim(b[1]);

					key = key.replace( new RegExp( QUOTE_CHAR, "gi"), "" ).replace( /[\r\n]*/g, "" ).replace(/\\n*/g, "\n" );					value = value.replace( new RegExp( QUOTE_CHAR, "gi"), "" ).replace( /[\r\n]*/g, "" ).replace( /\\n*/g, "\n" );
					ob[key]=value;
				}
				return ob;

			}
			else
				throw new Error( "POCodec.decode method accepts only String objects as arguments." );

			return null;
		}
		/**
		 * @inheritDoc
		 */
		public function get encodedType () : Class { return String; }
		/**
		 * @inheritDoc
		 */
		public function get decodedType () : Class { return Object; }
	}
}

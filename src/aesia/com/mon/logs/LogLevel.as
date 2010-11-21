/**
 * @license
 */
package  aesia.com.mon.logs
{
	/**
	 * La classe <code>LogLevel</code> est une classe d'énumération utilisée
	 * pour représenter les différents niveaux d'importances des messages d'informations
	 * diffusés par la classe <code>Log</code>.
	 *
	 * @author Cédric Néhémie
	 */
	public class LogLevel
	{
		/*--------------------------------------------------------------------------*
		 * STATIC MEMBERS
		 *--------------------------------------------------------------------------*/
		/**
		 * Instance de <code>LogLevel</code> représentant le niveau <code>DEBUG</code>.
		 */
		static public const DEBUG 	: LogLevel = new LogLevel( 0, "DEBUG",	"#0086B3" );
		/**
		 * Instance de <code>LogLevel</code> représentant le niveau <code>INFO</code>.
		 */
		static public const INFO 	: LogLevel = new LogLevel( 1, "INFO", 	"#00B32D" );
		/**
		 * Instance de <code>LogLevel</code> représentant le niveau <code>WARN</code>.
		 */
		static public const WARN 	: LogLevel = new LogLevel( 2, "WARN", 	"#B38600" );
		/**
		 * Instance de <code>LogLevel</code> représentant le niveau <code>ERROR</code>.
		 */
		static public const ERROR 	: LogLevel = new LogLevel( 3, "ERROR", 	"#B32D00" );
		/**
		 * Instance de <code>LogLevel</code> représentant le niveau <code>FATAL</code>.
		 */
		static public const FATAL 	: LogLevel = new LogLevel( 4, "FATAL", 	"#B3002D" );

		/**
		 * Renvoie l'instance de <code>LogLevel</code> à l'aide de son nom.
		 *
		 * @param	name	nom du niveau d'importance
		 * @return	l'instance de <code>LogLevel</code> à l'aide de son nom
		 */
		static public function getLevelByName ( name : String ) : LogLevel
		{
			switch( name )
			{
				case "DEBUG" :
				default :
					return DEBUG;
				case "INFO" :
					return INFO;
				case "WARN" :
					return WARN;
				case "ERROR" :
					return ERROR;
				case "FATAL" :
					return FATAL;
			}
		}
		/**
		 * Renvoie l'instance de <code>LogLevel</code> à l'aide de son niveau.
		 *
		 * @param	level	entier du niveau d'importance
		 * @return	l'instance de <code>LogLevel</code> à l'aide de son niveau
		 */
		static public function getLevelByLevel ( level : uint ) : LogLevel
		{
			switch( level )
			{
				case 0 :
				default :
					return DEBUG;
				case 1 :
					return INFO;
				case 2 :
					return WARN;
				case 3 :
					return ERROR;
				case 4 :
					return FATAL;
			}
		}

		/*--------------------------------------------------------------------------*
		 * INSTANCE MEMBERS
		 *--------------------------------------------------------------------------*/
		/**
		 * Un entier représentant le niveau d'importance sous forme numérique.
		 */
		protected var _level : uint;
		/**
		 * La couleur associée à ce niveau d'importance.
		 */
		protected var _color : String;
		/**
		 * Le nom de ce niveau d'importance.
		 */
		protected var _name : String;

		/**
		 * Constructeur de la classe <code>LogLevel</code>.
		 *
		 * @param	level	entier représentant le niveau
		 * @param	name	nom du niveau
		 * @param	color	couleur du niveau
		 */
		public function LogLevel ( level : uint, name : String, color : String )
		{
			this._level = level;
			this._name = name;
			this._color = color;
		}
		/**
		 * Un entier représentant le niveau d'importance sous forme numérique.
		 */
		public function get level () : uint { return _level; }
		/**
		 * La couleur associée à ce niveau d'importance.
		 */
		public function get color () : String { return _color; }
		/**
		 * Le nom de ce niveau d'importance.
		 */
		public function get name () : String { return _name; }
	}
}

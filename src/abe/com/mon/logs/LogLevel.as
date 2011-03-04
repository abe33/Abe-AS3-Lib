/**
 * @license
 */
package  abe.com.mon.logs
{
	/**
	 * The <code>LogLevel</code> class is an enumeration used to represent
	 * the different levels of importance of information messages
	 * broadcasted by the class <code>Log</code>.
	 * <fr>
	 * La classe <code>LogLevel</code> est une classe d'énumération utilisée
	 * pour représenter les différents niveaux d'importances des messages d'informations
	 * diffusés par la classe <code>Log</code>.
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public class LogLevel
	{
		/*--------------------------------------------------------------------------*
		 * STATIC MEMBERS
		 *--------------------------------------------------------------------------*/
		/**
		 * <code>LogLevel</code> instance representing the level <code>DEBUG</code>.
		 * <fr>Instance de <code>LogLevel</code> représentant le niveau <code>DEBUG</code>.</fr>
		 */
		static public const DEBUG 	: LogLevel = new LogLevel( 0, "DEBUG",	"#0086B3" );
		/**
		 * <code>LogLevel</code> instance representing the level <code>INFO</code>.
		 * <fr>Instance de <code>LogLevel</code> représentant le niveau <code>INFO</code>.</fr>
		 */
		static public const INFO 	: LogLevel = new LogLevel( 1, "INFO", 	"#00B32D" );
		/**
		 * <code>LogLevel</code> instance representing the level <code>WARN</code>.
		 * <fr>Instance de <code>LogLevel</code> représentant le niveau <code>WARN</code>.</fr>
		 */
		static public const WARN 	: LogLevel = new LogLevel( 2, "WARN", 	"#B38600" );
		/**
		 * <code>LogLevel</code> instance representing the level <code>ERROR</code>.
		 * <fr>Instance de <code>LogLevel</code> représentant le niveau <code>ERROR</code>.</fr>
		 */
		static public const ERROR 	: LogLevel = new LogLevel( 3, "ERROR", 	"#B32D00" );
		/**
		 * <code>LogLevel</code> instance representing the level <code>FATAL</code>.
		 * <fr>Instance de <code>LogLevel</code> représentant le niveau <code>FATAL</code>.</fr>
		 */
		static public const FATAL 	: LogLevel = new LogLevel( 4, "FATAL", 	"#B3002D" );
		/**
		 * Returns the instance of <code>LogLevel</code> using his name.
		 * <fr>
		 * Renvoie l'instance de <code>LogLevel</code> à l'aide de son nom.
		 * </fr>
		 * @param	name	name of the level of importance
		 * 					<fr>nom du niveau d'importance</fr>
		 * @return	instance <code>LogLevel</code> using his name
		 * 			<fr>l'instance de <code>LogLevel</code> à l'aide
		 * 			de son nom</fr>
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
		 * Returns the instance of <code>LogLevel</code> using his level.
		 * <fr>
		 * Renvoie l'instance de <code>LogLevel</code> à l'aide de son niveau.
		 * </fr>
		 * @param	name	the level of importance
		 * 					<fr>niveau d'importance</fr>
		 * @return	instance <code>LogLevel</code> using his level
		 * 			<fr>l'instance de <code>LogLevel</code> à l'aide
		 * 			de son niveau</fr>
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
		 * An integer representing the level of importance in digital form.
		 * <fr>
		 * Un entier représentant le niveau d'importance sous forme numérique.
		 * </fr>
		 */
		protected var _level : uint;
		/**
		 * The color associated with this level of importance.
		 * <fr>
		 * La couleur associée à ce niveau d'importance.
		 * </fr>
		 */
		protected var _color : String;
		/**
		 * The name of this level of importance.
		 * <fr>
		 * Le nom de ce niveau d'importance.
		 * </fr>
		 */
		protected var _name : String;
		/**
		 * <code>LogLevel</code> class constructor.
		 * <fr>
		 * Constructeur de la classe <code>LogLevel</code>.
		 * </fr>
		 * @param	level	integer level
		 * 					<fr>entier représentant le niveau</fr>
		 * @param	name	level's name
		 * 					<fr>nom du niveau</fr>
		 * @param	color	level's color
		 * 					<fr>couleur du niveau</fr>
		 */
		public function LogLevel ( level : uint, name : String, color : String )
		{
			this._level = level;
			this._name = name;
			this._color = color;
		}
		/**
		 * An integer representing the level of importance in digital form.
		 * <fr>
		 * Un entier représentant le niveau d'importance sous forme numérique.
		 * </fr>
		 */
		public function get level () : uint { return _level; }
		/**
		 * The color associated with this level of importance.
		 * <fr>
		 * La couleur associée à ce niveau d'importance.
		 * </fr>
		 */
		public function get color () : String { return _color; }
		/**
		 * The name of this level of importance.
		 * <fr>
		 * Le nom de ce niveau d'importance.
		 * </fr>
		 */
		public function get name () : String { return _name; }
	}
}

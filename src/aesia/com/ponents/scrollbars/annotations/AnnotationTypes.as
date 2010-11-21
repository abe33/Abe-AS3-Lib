package aesia.com.ponents.scrollbars.annotations
{
	import aesia.com.mon.utils.Color;
	/**
	 * @author Cédric Néhémie
	 */
	public class AnnotationTypes
	{
		static public const INFO : String = "info";		static public const WARN : String = "warn";		static public const ERROR : String = "error";		static public const FATAL : String = "fatal";		static public const SEARCH : String = "search";

		static public const COLORS : Object = {
												info:Color.GreenYellow,
												warn:Color.Orange,
												error:Color.Red,
												fatal:Color.Crimson,
												search:Color.DodgerBlue
											   };
	}
}

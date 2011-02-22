/**
 * @license
 */
package abe.com.mon.utils
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	/**
	 * Classe utilitaire contenant des méthodes opérant sur des objets
	 * <code>MovieClip</code>.
	 *
	 * @author Cédric Néhémie
	 */
	public class MovieClipUtils
	{
		/**
		 * Appèle la méthode <code>play</code> sur l'objet <code>mc</code>
		 * et de manière récursive sur tout ses enfants.
		 *
		 * @param	mc	objet dont il faut démarrer l'animation
		 */
		static public function play( mc : MovieClip ) : void
		{
			mc.play();
			var l : uint = mc.numChildren;
			for( var i : uint=0;i<l;i++)
			{
				var smc : DisplayObject = mc.getChildAt( i );
				if( smc is MovieClip )
					play( smc as MovieClip );
			}
		}
		/**
		 * Appèle la méthode <code>stop</code> sur l'objet <code>mc</code>
		 * et de manière récursive sur tout ses enfants.
		 *
		 * @param	mc	objet dont il faut stopper l'animation
		 */
		static public function stop( mc : MovieClip ) : void
		{
			mc.stop();
			var l : uint = mc.numChildren;
			for( var i : uint=0;i<l;i++)
			{
				var smc : DisplayObject = mc.getChildAt( i );
				if( smc is MovieClip )
					stop( smc as MovieClip );
			}
		}
	}
}
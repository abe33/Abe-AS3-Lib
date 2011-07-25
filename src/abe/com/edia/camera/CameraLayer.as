/**
 * @license
 */
package  abe.com.edia.camera
{
	import abe.com.mon.geom.Rectangle2;
	import abe.com.mon.utils.MatrixUtils;

	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * Une implémentation standard d'un écouteur de la classe <code>Camera</code>.
	 * Dans la plupart des situations, il suffit de créer une instance et de lui
	 * ajouter les objets soumis à la caméra, ou d'étendre cette classe afin de définir
	 * son contenu.
	 * <p>
	 * Cette implémentation standard supporte les effets de <i>scrolling</i>, de zoom et
	 * et de parallax.
	 * </p>
	 */
	dynamic public class CameraLayer extends Sprite
	{
		/**
		 * Facteur de parallax pour cette instance de <code>CameraLayer</code>.
		 * Le facteur de parallax est utilisé afin de multiplier les coordonnées
		 * du calque déduite à partir du champs de la caméra.
		 */
		public var parallax : Number;

		/**
		 * Créer une nouvelle instance de la classe <code>CameraLayer</code> avec
		 * le facteur de parallax passé en paramètre.
		 *
		 * @param	parallax	facteur de parallax pour cette instance
		 * 						de <code>CameraLayer</code>
		 */
		public function CameraLayer ( parallax : Number = 1 )
		{
			this.parallax = parallax;
		}
		/**
		 * Renvoie un <code>Rectangle2</code> correspondant à l'espace du calque courant
		 * actuellement visible dans le champs de la caméra.
		 *
		 * @param	c	la caméra dont on souhaite connaître le champs au sein
		 * 				de ce calque
		 * @return	un <code>Rectangle2</code> correspondant à l'espace du calque courant
		 * 			actuellement visible dans le champs de la caméra
		 */
		public function getLocalCameraScreen ( c : Camera ) : Rectangle2
		{
			var p : Point = c.screenCenter;
			var r : Rectangle2 = new Rectangle2( 0, 0,
											 	 c.width / c.zoom / scaleX,
												 c.height / c.zoom / scaleY );
			r.center = p;
			r.rotateAroundCenter( c.rotation );
			return r;
		}
		/**
		 * Fonction appelée lors d'un changement opéré sur le champs de la caméra.
		 * La position et la taille du calque
		 * sont transformés dans cette fonction
		 * en fonction des données de la caméra à laquelle ce calque est associé.
		 */
		public function cameraChanged( camera : Camera ) : void
		{
			//// first we store some usefull data for computation
			var m : Matrix = transform.matrix;
			var sc : Point = camera.screenCenter;
			var csx : Number = sc.x - camera.safeWidth/2;
			var csy : Number = sc.y - camera.safeHeight/2;
			//// reset the matrix
			m.identity();
			//// translate the matrix corresponding to the scroll and parallax part
			m.translate( -csx * parallax, -csy * parallax );
			////  we scale and rotate the matrix according to the center of the camera
			MatrixUtils.scaleAndRotateAroundExternalPoint( 	m,
															sc.x - csx,
															sc.y - csy,
															-camera.rotation,
															camera.zoom,
															camera.zoom );
			//// then we translate the camera to return back the transformation center to the stage center
			//// it's because of that translation that we need to access the camera's original width and height
			m.translate( csx - sc.x + ( camera.safeWidth / 2 ),
			csy - sc.y + ( camera.safeHeight / 2 ) );
			//// affect the matrix to this layer
			transform.matrix = m;
		}
	}
}

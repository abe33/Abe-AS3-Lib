/**
 * @license
 */
package  aesia.com.edia.camera
{
	import aesia.com.mon.geom.Range;
	import aesia.com.mon.geom.Rectangle2;
	import aesia.com.mon.utils.MathUtils;

	/**
	 * Diffusé dès que l'un des paramètres de focale de la caméra est modifié.
	 * Il suffit qu'une des propriétés focale du champs ait été
	 * modifié pour que l'évènement soit diffusé.
	 *
	 * @eventType aesia.com.edia.camera.CameraEvent.DOF_CHANGE
	 */
	[Event(name="dofChange", type="aesia.com.edia.camera.CameraEvent")]

	/**
	 * Une sous classe de <code>Camera</code> offrant le support pour la profondeur
	 * de champs dans un espace 2D. La profondeur de champs est un effet optique qui
	 * fait que les objets vont être plus ou moins flou en fonction de leur distance
	 * à l'objectif et de la profondeur focale de celui-ci.
	 * <p>
	 * Le principe est on ne peut plus simple. Chaque objet soumis à la profondeur
	 * de champs défini sa propre profondeur focale, un entier représentant sa distance
	 * à l'objectif. Ensuite, après avoir souscrit à l'évènement
	 * <code>CameraEvent.DOF_CHANGE</code>, celui-ci pourra calculer le taux de flou
	 * à appliquer à l'aide de la méthode <code>Camera.getBlurRatio ( focalDepth )</code>
	 * qui renvoi un nombre entre 0 et 1, où 0 marque la netteté maximum et où 1 représente
	 * le flou maximum.
	 * </p>
	 * <p>
	 * La profondeur de champs d'une caméra est exprimée à l'aide de quatre données :
	 * </p>
	 * <ul>
	 * <li>La profondeur focale : la profondeur à laquelle la mise au point est la plus nette.</li>
	 * <li>La taille de la plage focale : distance sur laquelle les objets sont nets, son centre
	 * est la profondeur focale.</li>
	 * <li>Le seuil proche : la position à laquelle les objets atteignent
	 * le flou maximum en se rapprochant de la caméra.</li>
	 * <li>Le seuil lointain : la position à laquelle les objets atteignent
	 * le flou maximum en s'éloignant de la caméra.</li>
	 * </ul>
	 * @see Camera
	 */
	public class DOFCamera extends Camera
	{
		private var _nFocalDepth : Number;
		private var _nFocalRangeSize : Number;
		private var _oDepthRange : Range;

		/**
		 * Créer une nouvelle instance de la classe <code>DOFCamera</code>.
		 * Le constructeur de la classe <code>DOFCamera</code> reprend tout
		 * les comportements de sa classe mère.
		 * <p>
		 * Par défaut, si aucun paramètre n'est fournis, la plage de netteté
		 * à une longueur infinie, tout les objets seront donc net. De même
		 * la plage de profondeurs valide pour la profondeur de champs s'étend
		 * de <code>Number.NEGATIVE_INFINITY</code>
		 * à <code>Number.POSITIVE_INFINITY</code>.
		 * </p><p>
		 * La profondeur focale par défaut est <code>0</code>.
		 * </p>
		 *
		 * @param	screen			position et dimension initiale du champs de la caméra
		 * @param	initialZoom		valeur de zoom initiale
		 * @param	zoomRange		plage de valeurs autorisées pour le zoom de la caméra
		 * @param	zoomIncrement	pas du zoom pour l'usage des fonctions <code>zoomIn</code>
		 * 							et <code>zoomOut</code>
		 * @param	focalDepth		profondeur focale initiale
		 * @param	focalRangeSize	longueur de la plage nette initiale
		 * @param	depthRange		plage de profondeurs pour la profondeur de champs
		 */
		public function DOFCamera( screen 		 	: Rectangle2 = null,
								   initialZoom	 	: Number = 1,
								   zoomRange	 	: Range = null,
								   zoomIncrement 	: Number = 0.1,
								   focalDepth	 	: Number = 0,
								   focalRangeSize 	: Number = Number.POSITIVE_INFINITY,
								   depthRange 		: Range = null )
		{
			super( screen, initialZoom, zoomRange, zoomIncrement );
			_nFocalRangeSize = focalRangeSize;
			_nFocalDepth = focalDepth;
			_oDepthRange = depthRange ? depthRange : new Range( Number.NEGATIVE_INFINITY, Number.POSITIVE_INFINITY );
		}
		/**
		 * Seuil proche de la plage de netteté.
		 */
		public function get focalNearDepth () : Number
		{
			return _nFocalDepth - _nFocalRangeSize / 2;
		}

		/**
		 * Seuil lointain de la plage de netteté.
		 */
		public function get focalFarDepth () : Number
		{
			return _nFocalDepth + _nFocalRangeSize / 2;
		}

		/**
		 * Profondeur focale de la caméra.
		 */
		public function get focalDepth () : Number
		{
			return _nFocalDepth;
		}
		/**
		 * @private
		 */
		public function set focalDepth ( n : Number ) : void
		{
			_nFocalDepth = n;
			fireDOFChange();
		}

		/**
		 * Seuil proche de la plage de profondeurs sur laquelle la
		 * profondeur de champs s'applique.
		 */
		public function get nearDepth () : Number
		{
			return _oDepthRange.min;
		}
		/**
		 * @private
		 */
		public function set nearDepth ( d : Number ) : void
		{
			_oDepthRange.min = d;
			fireDOFChange();
		}

		/**
		 * Seuil lointain de la plage de profondeurs sur laquelle la
		 * profondeur de champs s'applique.
		 */
		public function get farDepth () : Number
		{
			return _oDepthRange.max;
		}
		/**
		 * @private
		 */
		public function set farDepth ( d : Number ) : void
		{
			_oDepthRange.max = d;
			fireDOFChange();
		}

		/**
		 * Longueur de la plage de netteté. Celle-ci est centré sur <code>focalDepth</code>.
		 */
		public function get focalRangeSize () : Number
		{
			return _nFocalRangeSize;
		}
		/**
		 * @private
		 */
		public function set focalRangeSize ( n : Number ) : void
		{
			_nFocalRangeSize = n;
			fireDOFChange();
		}

		/**
		 * Plage de profondeurs sur laquelle la profondeur de champs s'applique.
		 */
		public function get depthRange () : Range
		{
			return _oDepthRange;
		}
		/**
		 * @private
		 */
		public function set depthRange ( range : Range ) : void
		{
			_oDepthRange = range;
			fireDOFChange();
		}

		/**
		 * Notifie les écouteurs à l'évènement <code>CameraEvent.DOF_CHANGE</code>
		 * qu'une ou plusieurs propriété de la profondeur de champs ont été modifié.
		 */
		protected function fireDOFChange () : void
		{
			dispatchEvent( new CameraEvent( CameraEvent.DOF_CHANGE ) );
		}

		/**
		 * Renvoie le cohéficient de flou à appliquer en fonction
		 * d'une profondeur donnée.
		 *
		 * @param	z	profondeur pour laquelle on souhaite connaître
		 * 				la netteté
		 * @return	un nombre entre <code>0</code> et <code>1</code> tel
		 * 			que 0 équivaut à la netteté maximum, et 1 au flou
		 * 			maximum
		 */
		public function getBlurRatio ( z : Number ) : Number
		{
			if( z >= focalNearDepth && z <= focalFarDepth )
			{
				return 0;
			}
			else
			{
				var near : Number = _oDepthRange.min;
				var far : Number = _oDepthRange.max;
				var min : Number = focalNearDepth;
				var max : Number = focalFarDepth;
				var b : Number;
				if( z < min )
				{
					if( z < near )
						z = near;

					b = Math.abs( MathUtils.normalize( z, min, near ) );
				}
				else if( z > max )
				{
					if( z > far )
						z = far;

					b = Math.abs(  MathUtils.normalize( z, max, far ) );
				}

				return b;
			}
		}
	}
}
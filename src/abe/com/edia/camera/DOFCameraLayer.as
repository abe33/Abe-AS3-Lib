/**
 * @license
 */
package  abe.com.edia.camera
{
	import flash.filters.BlurFilter;
	/**
	 * Une implémentation standard d'un écouteur de la classe <code>DOFCamera</code>.
	 * Dans la plupart des situations, il suffit de créer une instance et de lui
	 * ajouter les objets soumis à la caméra, ou d'étendre cette classe afin de définir
	 * son contenu. Cette implémentation reprend tout les comportements définis par la 
	 * classe <code>CameraLayer</code>.
	 * <p>
	 * Cette implémentation standard supporte les effets de <i>scrolling</i>, de zoom, 
	 * de parallax et de profondeur de champs.
	 * </p>
	 */
	dynamic public class DOFCameraLayer extends CameraLayer
	{		
		/**
		 * Quantité de flou maximale par défaut.
		 */
		static public var DEFAULT_BLUR_AMOUNT : Number = 20;
		
		/**
		 * Quantité de flou maximale pour cette instance.
		 */
		protected var _nBlurAmount : Number = DEFAULT_BLUR_AMOUNT;
		
		/**
		 * Cohéficient de flou pour cette instance, comme retournée par la
		 * fonction <code>Camera.getBlurRatio</code>.
		 */
		protected var _nBlurCoeficient : Number;
		
		/**
		 * Profondeur focale de l'instance courante.
		 */
		protected var _nFocalDepth : Number;
		
		/**
		 * Créer une nouvelle instance de la classe <code>DOFCameraLayer</code>.
		 * 
		 * @param	focalDepth	profondeur focale pour cette instance
		 * @param	parallax	facteur de parallax pour cette instance
		 */
		public function DOFCameraLayer( focalDepth : Number = 0, parallax : Number = 1)
		{
			super(parallax);
			this._nFocalDepth = focalDepth;
			this._nBlurCoeficient = 0;
		}
		
		/**
		 * Profondeur focale de l'instance courante.
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
		}
		
		/**
		 * Quantité de flou maximale pour cette instance.
		 */
		public function get blurAmount ( ) : Number
		{
			return _nBlurAmount;
		}
		/**
		 * @private
		 */
		public function set blurAmount ( n : Number ) : void
		{
			_nBlurAmount = n;
			applyBlur();
		}
		
		/**
		 * Fonction appelée lors d'un changement opéré sur la profondeur de champs 
		 * de la caméra.
		 * 
		 * @param	e	l'objet <code>CameraEvent</code> diffusé par la caméra
		 */
		public function dofChanged( e : CameraEvent ) : void
		{
			var dofCam : DOFCamera = e.camera as DOFCamera;

			_nBlurCoeficient = dofCam.getBlurRatio( _nFocalDepth );
						
			applyBlur();
		}
		
		/**
		 * Applique l'effet de flou en fonction du cohéficient définit par la caméra
		 */
		protected function applyBlur () : void
		{
			if( _nBlurCoeficient > 0 ) 
				filters = [ new BlurFilter( _nBlurCoeficient * _nBlurAmount, _nBlurCoeficient * _nBlurAmount, 2 ) ];
			else
				filters = [];
		}
	}
}
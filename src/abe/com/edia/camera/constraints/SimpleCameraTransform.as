package abe.com.edia.camera.constraints 
{
	import abe.com.edia.camera.Camera;
	/**
	 * @author cedric
	 */
	public class SimpleCameraTransform implements CameraTransform 
	{
		protected var _camera : Camera;

		public function SimpleCameraTransform ( camera : Camera ) 
		{
			_camera = camera;
		}
		
		public function get camera () : Camera { return _camera; }
		public function set camera (camera : Camera) : void	{ _camera = camera; }
		
		public function performTransformation (tranformation : uint, currentState : *, newState : * ) : *
		{
			switch ( tranformation )
			{
				case CameraTransformations.RESIZE : 
					break;
				case CameraTransformations.ROTATION : 
					break;
				case CameraTransformations.TRANSLATION : 
					break;
				case CameraTransformations.ZOOM : 
					break;
				default : 
					break;
			}
		}
	}
}

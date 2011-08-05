package abe.com.edia.camera.constraints 
{
	import abe.com.edia.camera.Camera;
	/**
	 * @author cedric
	 */
	public interface CameraTransform 
	{
		function get camera() : Camera;
		function set camera( camera : Camera ) : void;
		
		function performTransformation( tranformation : uint, currentState : *, newState : * ) : *;
	}
}

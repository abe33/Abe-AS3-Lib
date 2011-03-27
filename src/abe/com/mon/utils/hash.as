package abe.com.mon.utils
{
	/**
	 * @author cedric
	 */
	public function hash ( o : * ) : uint 
	{
		if( _hashes[o] )
			return _hashes[o];
		else
			return _hashes[o] = _currentHash++;
	}
}

import flash.utils.Dictionary;

internal var _currentHash : uint = 0;
internal var _hashes : Dictionary = new Dictionary(true);

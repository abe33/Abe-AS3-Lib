package aesia.com.motion.properties
{
	/**
	 * @author Cédric Néhémie
	 */
	public class SpecialProperty
	{
		public var getter : Function;
		public var setter : Function;
		public var extraArgs : Array;

		public function SpecialProperty ( getter : Function, setter : Function, extraArgs : Array )
		{
			this.getter = getter;
			this.setter = setter;
			this.extraArgs = extraArgs;
		}
	}
}

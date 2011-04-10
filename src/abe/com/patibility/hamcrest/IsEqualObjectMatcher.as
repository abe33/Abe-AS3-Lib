package abe.com.patibility.hamcrest 
{
	import abe.com.mon.utils.magicEquals;
	import abe.com.ponents.utils.Inspect;

	import org.hamcrest.BaseMatcher;
	import org.hamcrest.Description;
	/**
	 * @author cedric
	 */
	public class IsEqualObjectMatcher extends BaseMatcher 
	{
		protected var _value : Object;
		public function IsEqualObjectMatcher ( value : Object )
		{
			super();
			
			_value = value;		}
		/**
		 * @inheritDoc
		 */
		override public function matches (item : Object) : Boolean
		{
			return areEqual( item, _value );
		}
		/**
		 * @inheritDoc
		 */
		override public function describeTo (description : Description) : void
		{
			description.appendText( "object should be equal to " ).appendValue( Inspect.inspect( _value ).replace(/\n/g,"") );
		}
		override public function describeMismatch (item : Object, mismatchDescription : Description) : void 
		{
			mismatchDescription.appendText( "was " ).appendValue( Inspect.inspect( item ).replace(/\n/g,"") );
		}
		/**
		 * Checks if the given items are equal
		 *
		 * @private
		 */
		private function areEqual (o1 : Object, o2 : Object) : Boolean
		{
			return magicEquals( o1, o2 );
		}
	}
}

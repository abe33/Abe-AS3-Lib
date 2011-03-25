package abe.com.patibility.hamcrest 
{
	import abe.com.patibility.humanize.plural;

	import org.hamcrest.BaseMatcher;
	import org.hamcrest.Description;
	import org.hamcrest.Matcher;
	/**
	 * @author cedric
	 */
	public class PropertiesCountMatcher extends BaseMatcher 
	{
		protected var _value : Object;
		protected var _keys : Array;

		public function PropertiesCountMatcher ( value : Object )
		{
			super();
			
			_value = value;
		}
		/**
		 * @inheritDoc
		 */
		override public function matches (item : Object) : Boolean
		{
			_keys = [];
			for (var i : String in item )
				_keys.push( i );
			
			if( _value is Matcher )
				return ( _value as Matcher ).matches( _keys.length );
			else
				return areEqual( _keys.length, _value );
		}
		/**
		 * @inheritDoc
		 */
		override public function describeTo (description : Description) : void 
		{
			if( _value is Matcher )
			{
				description.appendText( "object properties count should be " );
				( _value as Matcher ).describeTo(description); 
			}
			else
				description.appendText( "object should have " 
						  ).appendValue( _value 
						  ).appendText( plural( _value as Number, " property", " properties" ) ); 
		}
		override public function describeMismatch (item : Object, mismatchDescription : Description) : void 
		{
			mismatchDescription.appendText("object has "
							  ).appendValue( _keys.length 
							  ).appendText( plural( _keys.length, " property", " properties" ) + " : " + _keys );
		}
		private function areEqual (o1 : Object, o2 : Object) : Boolean
		{
			return o1 == o2;
		}
	}
}

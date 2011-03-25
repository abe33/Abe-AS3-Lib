package abe.com.mon.utils 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.geom.Polygon;
	import abe.com.mon.geom.dm;
	import abe.com.mon.geom.pt;
	import abe.com.patibility.hamcrest.equalToObject;

	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.describedAs;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperties;
	import org.hamcrest.object.hasProperty;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.nullValue;

	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	/**
	 * @author Cédric Néhémie
	 */
	public class ReflectionTest 
	{
		/**
		 * Used to verify the count of arguments transmitted to a function when called in a reflection string.
		 */
		static public function testArgumentsCountFunction( ...args ) : uint 
		{
			return args.length;
		}
		static public function testShortcutFunction() : String 
		{
			return "testShortcutFunction";
		}
		
		[Test(description="This test verify that all the code parsing of the Reflection.get() method works as expected")]  
		public function get() : void
		{ 
			// primitives
			assertThat( Reflection.get("10"), 		equalTo(10) );   
			assertThat( Reflection.get("0xff"), 	equalTo(255) );   			assertThat( Reflection.get("-10"), 		equalTo(-10) );   			assertThat( Reflection.get("0.57"), 	equalTo(0.57) );   			assertThat( Reflection.get("'foo'"),	equalTo("foo") );   			assertThat( Reflection.get("\"foo\""),	equalTo("foo") );   			assertThat( Reflection.get("true"), 	equalTo(true) );   			assertThat( Reflection.get("false"),	equalTo(false) );   			assertThat( Reflection.get("null"), 	nullValue() );			
			// cases that we must assert that they return strings due to missing definition or invalid syntax
			assertThat( Reflection.get("new some.unknown::Class()"), allOf( instanceOf( String ), equalTo("new some.unknown::Class()") ) );
			assertThat( Reflection.get("Array..prototype"), allOf( instanceOf( String ), equalTo("Array..prototype") ) );						// arrays and tuples
			assertThat( Reflection.get("[1,2,3,4]"), describedAs( "Reflection.get(%0) should return [<1>,<2>,<3>,<4>]", 
													 array(1,2,3,4), 
													 "[1,2,3,4]" ) ); 
			assertThat( Reflection.get("(1,2,3,4)"), describedAs( "Reflection.get(%0) should return [<1>,<2>,<3>,<4>]", 
													 array(1,2,3,4), 
													 "(1,2,3,4)" ) ); 
			assertThat( Reflection.get("1,2,3,4"), 	 describedAs( "Reflection.get(%0) should return [<1>,<2>,<3>,<4>]", 
													 array(1,2,3,4), 
													 "1,2,3,4" ) ); 			assertThat( Reflection.get("[1,2,3,4],true"), 	 describedAs( "Reflection.get(%0) should return [[<1>,<2>,<3>,<4>],<true>]", 
													 array(array(1,2,3,4),true), 
													 "[1,2,3,4],true" ) ); 
			
			// empty slots in an array should be considered as null
			assertThat( Reflection.get("[1,2,,3, ,4]"), describedAs( "Reflection.get(%0) should return [<1>,<2>,<null>,<3>,<null>,<4>]", 
													 array(1,2,null,3,null,4), 
													 "[1,2,,3, ,4]" ) ); 
			assertThat( Reflection.get("(1,2,,3, ,4)"), describedAs( "Reflection.get(%0) should return [<1>,<2>,<null>,<3>,<null>,<4>]", 
													 array(1,2,null,3,null,4), 
													 "(1,2,,3, ,4)" ) ); 
			assertThat( Reflection.get("1,2,,3, ,4"), 	 describedAs( "Reflection.get(%0) should return [<1>,<2>,<null>,<3>,<null>,<4>]", 
													 array(1,2,null,3,null,4), 
													 "1,2,,3, ,4" ) ); 
			
			// empty arrays and tuples
			assertThat( Reflection.get("[]"),	 	 describedAs( "Reflection.get(%0) should return []", array(), "[]" ) ); 
			assertThat( Reflection.get("()"),	 	 describedAs( "Reflection.get(%0) should return []", array(), "()" ) ); 
			
			// nested arrays and tuples
			assertThat( Reflection.get("[[0,1,2],[3,4,5]]"), 
									   describedAs( "Reflection.get(%0) should return [[0,1,2],[3,4,5]]", 
									   				array( array(0,1,2), array(3,4,5)), 
									   				"[[0,1,2],[3,4,5]]" ) ); 
			assertThat( Reflection.get("((0,1,2),(3,4,5))"), 
									   describedAs( "Reflection.get(%0) should return [[0,1,2],[3,4,5]]", 
									   				array( array(0,1,2), array(3,4,5)), 
									   				"((0,1,2),(3,4,5))" ) );
			assertThat( Reflection.get("([0,1,2],[3,4,5])"), 
									   describedAs( "Reflection.get(%0) should return [[0,1,2],[3,4,5]]", 
									   				array( array(0,1,2), array(3,4,5)), 
									   				"([0,1,2],[3,4,5])" ) ); 
			assertThat( Reflection.get("[(0,1,2),(3,4,5)]"), 
									   describedAs( "Reflection.get(%0) should return [[0,1,2],[3,4,5]]", 
									   				array( array(0,1,2), array(3,4,5)), 
									   				"[(0,1,2),(3,4,5)]" ) ); 
						// objects			assertThat( Reflection.get("{'foo':15,bar:'foobar'}"), describedAs( "Reflection.get(%0) should return an object such as {'foo':15,'bar':'foobar'}", 
																	 allOf( notNullValue(), 
																	 		not( instanceOf( String ) ), 
																	 		hasProperties({'foo':15,'bar':'foobar'}) ), 
																	 "{'foo':15,bar:'foobar'}" ) ); 
			// empty properties are set to true
			assertThat( Reflection.get("{foo}"), describedAs( "Reflection.get(%0) should return an object", 
															  allOf( not( instanceOf(String ) ), 
															  	     notNullValue(),
															  	     hasProperties({'foo':true}) ),
															  "{foo}" ) );
			assertThat( Reflection.get("{}"),	 	 not( instanceOf(String ) ) ); 
						// non string keys gives a dictionary
			assertThat( Reflection.get("{new flash.geom::Point(4,4):'hello'}"), describedAs( "Reflection.get(%0) should return a dictionnary", 
															  allOf( notNullValue(),
															  	     instanceOf( Dictionary ) ),
															  "{new flash.geom::Point(4,4):'hello'}" ) );
			
			// empty slots and invalid declarations in an object declaration are ignored
			assertThat( Reflection.get("{,'foo':15, ,bar:'foobar',foo:,:foo}"), describedAs( "Reflection.get(%0) should return an object such as {'foo':15,'bar':'foobar'}", 
																	 allOf( notNullValue(), 
																	 		not( instanceOf( String ) ), 
																	 		hasProperties({'foo':15,'bar':'foobar'}) ), 
																	 "{,'foo':15, ,bar:'foobar',foo:,:foo}" ) ); 
			
			// arrays, tuples and objects allow an extra comma at the end (as python)
			assertThat( Reflection.get("1,2,3,4,"), 	 describedAs( "Reflection.get(%0) should return [<1>,<2>,<3>,<4>]", 
													 array(1,2,3,4), 
													 "1,2,3,4," ) ); 
			assertThat( Reflection.get("[1,2,3,4,]"), describedAs( "Reflection.get(%0) should return [<1>,<2>,<3>,<4>]", 
													 array(1,2,3,4), 
													 "[1,2,3,4]" ) ); 
			assertThat( Reflection.get("(1,2,3,4,)"), describedAs( "Reflection.get(%0) should return [<1>,<2>,<3>,<4>]", 
													 array(1,2,3,4), 
													 "(1,2,3,4,)" ) ); 
			assertThat( Reflection.get("{'foo':15,bar:'foobar',}"), describedAs( "Reflection.get(%0) should return an object such as {'foo':15,'bar':'foobar'}", 
																	 allOf( notNullValue(), 
																	 		not( instanceOf( String ) ), 
																	 		hasProperties({'foo':15,'bar':'foobar'}) ), 
																	 "{'foo':15,bar:'foobar',}" ) ); 										 
						// dot syntax
			assertThat( Reflection.get("abe.com.mon.utils::Color.Red"), Color.Red );
			assertThat( Reflection.get("abe.com.mon.utils::Color.Red.alphaClone(0x55)"), equalToObject( Color.Red.alphaClone(0x55)) );
			assertThat( Reflection.get("Array.inexistantProperty"), nullValue() );
			
			// function calls and arguments detection			assertThat( Reflection.get("abe.com.mon.utils::ReflectionTest.testArgumentsCountFunction()"), equalTo( 0 ) ); 			assertThat( Reflection.get("abe.com.mon.utils::ReflectionTest.testArgumentsCountFunction(1)"), equalTo( 1 ) ); 			assertThat( Reflection.get("abe.com.mon.utils::ReflectionTest.testArgumentsCountFunction([0,1,2])"), equalTo( 1 ) ); 			assertThat( Reflection.get("abe.com.mon.utils::ReflectionTest.testArgumentsCountFunction(0,1,2)"), equalTo( 3 ) ); 			assertThat( Reflection.get("abe.com.mon.utils::ReflectionTest.testArgumentsCountFunction([0,1,2],true)"), equalTo( 2 ) ); 
		
			
			// native shortcuts
			assertThat( Reflection.get("color(Red)"), Color.Red );
						var url : URLRequest = Reflection.get("@'../some/file.png'");
			assertThat( url, describedAs( "Reflection.get(%0) should return an URLRequest pointing to '../some/file.png'", 
													 allOf( notNullValue(),
															instanceOf( URLRequest ) ), 
													 "@'../some/file.png'" ) );
			
			assertThat( url, hasProperty( "url", "../some/file.png" ) );
			
			var re : RegExp = Reflection.get("/foo/gi");
			assertThat( re, describedAs( "Reflection.get(%0) should return a RegExp equivalent to /foo/gi", 
													allOf( notNullValue(),
														   instanceOf( RegExp ) ), 
													"/foo/gi" ) );			assertThat( re, hasProperties({'ignoreCase':true,'global':true}) );
			
					  	     
		}

		[Test(description="This test verify that the getClassName method extracts the correct values.")]
		public function getClassName() : void
		{ 
			assertThat( Reflection.getClassName( Point ), 		equalTo("Point") );   			assertThat( Reflection.getClassName( Array ), 		equalTo("Array") );   			assertThat( Reflection.getClassName( 10 ), 			equalTo("int") );   			assertThat( Reflection.getClassName( 10.5 ), 		equalTo("Number") );   			assertThat( Reflection.getClassName( "foo" ), 		equalTo("String") );   			assertThat( Reflection.getClassName( dm(5, 5) ),	equalTo("Dimension") );   			assertThat( Reflection.getClassName( null ), 		equalTo("null") );   
		}
		
		[Test(description="This test verify that the vector definition returned is the same as the one defined in code.")]
		public function getVectorDefinition () : void
		{
			assertThat ( Reflection.getVectorDefinition( Point ), equalTo( Vector.<Point> ) );			assertThat ( Reflection.getVectorDefinition( Dimension ), equalTo( Vector.<Dimension> ) );			
			// null value returns a null definition
			assertThat ( Reflection.getVectorDefinition( null ), equalTo( null ) );
		}
		
		[Test(description="This test verify that the getClass method returns the valid class.")]
		public function getClass():void
		{
			// primitives
			assertThat( Reflection.getClass( 1 ), equalTo( int ) );				assertThat( Reflection.getClass( 1.5 ), equalTo( Number ) );				assertThat( Reflection.getClass( "foo" ), equalTo( String ) );				assertThat( Reflection.getClass( [1] ), equalTo( Array ) );	
			
			// null returns itself			assertThat( Reflection.getClass( null ), equalTo( null ) );	
			
			// classes instances			assertThat( Reflection.getClass( dm() ), equalTo( Dimension ) );				assertThat( Reflection.getClass( pt() ), equalTo( Point ) );	
		}
		
		[Test(description="This test verify that the isObject method is able to differenciate an instance of the Object class with instance of others classes.")]
		public function isObject() : void
		{
			assertThat( Reflection.isObject( {} ), describedAs("Reflection.isObject(%0) is true", equalTo( true ), "{}") ); 					assertThat( Reflection.isObject( pt() ), describedAs("Reflection.isObject(%0) is false", equalTo( false ), "pt()") ); 					assertThat( Reflection.isObject( "foo" ), describedAs("Reflection.isObject(%0) is false", equalTo( false ), "'foo'") ); 					assertThat( Reflection.isObject( 15 ), describedAs("Reflection.isObject(%0) is false", equalTo( false ), "15") ); 		
		}
		
		[Test(description="This test verify that any instance can be converted as an anonymous object.")]
		public function asAnonymousObject () : void
		{
			var o : Object;
			
			// without read-only properties
			o = Reflection.asAnonymousObject( pt(12,24), false );	
			assertThat( o, allOf( notNullValue(), 
								  instanceOf( Object ), 
								  hasProperties({'x':12,'y':24}),
								  not( hasProperty("length") ) ) );
			
			
			// with read-only properties
			o = Reflection.asAnonymousObject( pt(12,24), true );	
			assertThat( o, allOf( notNullValue(), 
								  instanceOf( Object ), 
								  hasProperty("length", Math.sqrt( 12*12 + 24*24 ) ) ) );
						
		}
		[Test(description="This test verify that any class can be instanciated with the class reference and an arguments Array.")]
		public function buildInstance():void
		{
			assertThat( Reflection.buildInstance( Point ), allOf( notNullValue(), 
																		   instanceOf( Point ),
																		   hasProperties({'x':0,'y':0}) ) ); 
			assertThat( Reflection.buildInstance( Point , [15,22]), allOf( notNullValue(), 
																		   instanceOf( Point ),
																		   hasProperties({'x':15,'y':22}) ) ); 
			
			assertThat( Reflection.buildInstance( Dimension , [15,22]), allOf( notNullValue(), 
																		instanceOf( Dimension ),
																		hasProperties({'width':15,'height':22}) ) ); 
			
			assertThat( Reflection.buildInstance( String, ["Foo"] ), allOf( notNullValue(), 
																			instanceOf( String ),
																			equalTo( "Foo" ) ) ); 
		}
		[Test(description="This test verify that buildInstance throw an exception when there's more arguments than expected.", 
			  expects="flash.errors.IllegalOperationError")]
		public function buildInstanceFailure1():void
		{
			Reflection.buildInstance( Point, [15, 22, false ] ) ;
		}
		[Test(description="This test verify that buildInstance throw an exception when there's less arguments than expected.", 
			  expects="flash.errors.IllegalOperationError")]
		public function buildInstanceFailure2():void
		{
			Reflection.buildInstance( Polygon ) ;
		}
		[Test(description="This test verify that buildInstance throw an exception when the arguments count is greater to 30.", 
			  expects="flash.errors.IllegalOperationError")]
		public function buildInstanceFailure3():void
		{
			Reflection.buildInstance( Array, [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33] ) ;
		}
		[Test(description="This test verify that we can access to the metadata of a class.")]
		public function getClassMetas () : void
		{
			var o : MetaTester = new MetaTester();
			var metas : XMLList;
			
			metas = Reflection.getClassMetas( o );
			
			assertThat( metas, notNullValue() );
			assertThat( metas.length(), equalTo( 2 ) );
			assertThat( metas[0].@name, equalTo( "Skin" ) );			assertThat( metas[1].@name, equalTo( "Skinable" ) );
		}
		[Test(description="This test verify that we can access to a specific metadata of a class.")]
		public function getClassMeta () : void
		{
			var o : MetaTester = new MetaTester();
			var metas : XMLList;
			
			metas = Reflection.getClassMeta( o, "Skin" );
			
			assertThat( metas, notNullValue() );
			assertThat( metas.length(), equalTo( 1 ) );
			assertThat( metas[0].@name, equalTo( "Skin" ) );
		}
		[Test(description="This test verify that we can access to the properties of a class that have metadatas defined.")]
		public function getClassMembersWithMetas () : void
		{
			var o : MetaTester = new MetaTester();
			var metas : XMLList;
			
			metas = Reflection.getClassMembersWithMetas( o );
			
			assertThat( metas, notNullValue() );
			assertThat( metas.length(), equalTo( 2 ) );
		}
		[Test(description="This test verify that we can access to the properties of a class that have specific metadata defined.")]
		public function getClassMembersWithMeta () : void
		{
			var o : MetaTester = new MetaTester();
			var metas : XMLList;
			
			metas = Reflection.getClassMembersWithMeta( o, "Skin" );
			
			assertThat( metas, notNullValue() );
			assertThat( metas.length(), equalTo( 1 ) );
			assertThat( metas[0].@name, equalTo( "property" ) );
		}
		
		[Test(description="This test verify that custom shortcuts can be added and removed.")]
		public function customShortcuts () : void
		{
			Reflection.addCustomShortcuts( "myCustomShortcuts", "abe.com.mon.utils::ReflectionTest.testShortcutFunction");
			
			assertThat( Reflection.get("myCustomShortcuts()"), describedAs("Reflection.get('myCustomShortcuts()') should return <'testShortcutFunction'>", equalTo( "testShortcutFunction" ) ) );
						assertThat( Reflection.removeCustomShortcuts("myCustomShortcuts"), describedAs( "Reflection.removeCustomShortcuts('myCustomShortcuts') should return <true>", equalTo(true) ) );			
			assertThat( Reflection.get("myCustomShortcuts()"), describedAs("Reflection.get('myCustomShortcuts()') should return <'myCustomShortcuts()'>", equalTo( "myCustomShortcuts()" ) ) );
		}
		
		[Test(description="This test verify that the public members of an object can be retreived using Reflection.getPublicMembers")]
		public function getPublicMembers (): void
		{
			var o : MetaTester = new MetaTester();
			var list : XMLList = Reflection.getPublicMembers( o );
			
			assertThat( list, notNullValue() ); 			assertThat( list.length(), equalTo( 3 ) ); 
		}
	}
}

[Skinable(skin="MetaTesterSkin")]
[Skin(name="MetaTesterSkin")]
internal class MetaTester 
{
	[Form]
	[Skin]
	public var property : String;
	
	[Form]
	public var foo : uint;
	
	private var bar : Boolean;
	protected var oof:String;
	
	public function get fooo() : uint { return foo; }
	
	public function getFoo() : void {}
}
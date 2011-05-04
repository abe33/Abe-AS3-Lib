package  abe.com.prehension.examples{
	import abe.com.edia.text.AdvancedTextField;
	import abe.com.edia.text.builds.BasicBuild;
	import abe.com.edia.text.builds.BuildContext;
	import abe.com.edia.text.builds.StyleContext;
	import abe.com.edia.text.core.Char;
	import abe.com.edia.text.core.SpaceChar;
	import abe.com.edia.text.core.SpriteChar;
	import abe.com.edia.text.fx.complex.TwinklingChar;
	import abe.com.edia.text.fx.hide.RandomFallingChars;
	import abe.com.edia.text.fx.loop.CircularWaveEffect;
	import abe.com.edia.text.fx.loop.TrembleEffect;
	import abe.com.edia.text.fx.loop.WaveEffect;
	import abe.com.mon.colors.Color;
	import abe.com.mon.logs.Log;
	import abe.com.mon.utils.StageUtils;
	import abe.com.ponents.tools.DebugPanel;
	import abe.com.ponents.utils.KeyboardControllerInstance;
	import abe.com.ponents.utils.ToolKit;

	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;

	/**
	 * @author cedric
	 */
	[SWF(height="800", width="640", backgroundColor="#000000")]
	public class AdvancedTextFieldExample extends Sprite 
	{
		[Embed(source="../res/fonts/Ubuntu-BI.ttf", fontName="Ubuntu", embedAsCFF="false")]
		static public var ubuntu : Class;
		[Embed(source="../res/img/money_euro.png")]
		static public var euro : Class;
		[Embed(source="../res/img/money_dollar.png")]
		static public var dollar : Class;
		[Embed(source="../res/img/emoticon_smile.png")]
		static public var smile : Class;
		[Embed(source="../res/img/emoticon_wink.png")]
		static public var wink : Class;
		[Embed(source="../res/img/bullet_star.png")]
		static public var star : Class;
		
		private var txt : AdvancedTextField;

		public function AdvancedTextFieldExample ()
		{
			GlowFilter, WaveEffect, TrembleEffect, CircularWaveEffect, TwinklingChar, RandomFallingChars;
			
			StageUtils.setup(this);
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();
			 
			var p : DebugPanel = new DebugPanel();
			ToolKit.popupLevel.addChild(p);
			p.visible = false;
			
			KeyboardControllerInstance.eventProvider = stage;
			 
			try
			{
				var format : TextFormat = new TextFormat("Verdana",10, 0xffffff ); 
			 	var build : BasicBuild = new BasicBuild ( format, true );
			 	build.addCharMapping( "€", function( s : String, context : BuildContext ):Char
			 	{
			 		return new SpriteChar( new euro() );
				} );
				build.addCharMapping( "$", function( s : String, context : BuildContext ):Char
			 	{
			 		return new SpriteChar( new dollar() );
				} );
				build.addCharMapping( "&wink;", function( s : String, context : BuildContext ):Char
			 	{
			 		return new SpriteChar( new wink() );
				} );
				build.addCharMapping( "&smile;", function( s : String, context : BuildContext ):Char
			 	{
			 		return new SpriteChar( new smile() );
				} );
				build.linkTextFormatter = function ( context : BuildContext, styleContext : StyleContext, attributes : Object ) : void
				{	
					styleContext.format.color = 0x99ff66;
					styleContext.format.underline = true;
				};
				build.addTagMapping( "code", function ( context : BuildContext, styleContext : StyleContext, attributes : Object ) : void
				{
					context.notAChar();
					styleContext.format.font = "MonoSpace";					styleContext.format.color = 0xcccccc;					styleContext.format.size = 10;
					context.backgroundColor = 0x222222;
					context.embedFonts = false;
				});
				build.addTagMapping( "h1", function( context : BuildContext, styleContext : StyleContext, attributes : Object ) : void
			 	{
					context.setChar( new H1Char() );
					styleContext.format.size = 18;
					styleContext.format.bold = true;					styleContext.format.italic = true;
				} );
				build.addTagMapping( "h1:end" , function( context : BuildContext, styleContext : StyleContext, attributes : Object ) : void 
				{
					context.setChar( new H1Char( true ) );
				} );
				build.addTagMapping( "ul" , function( context : BuildContext, styleContext : StyleContext, attributes : Object ) : void 
				{
					context.setChar( new UlChar() );
				} );
				build.addTagMapping( "li" , function( context : BuildContext, styleContext : StyleContext, attributes : Object ) : void 
				{
					context.setChar( new LiChar() );
					context.appendChar( new SpriteChar( new star (), "*" ) );
					context.appendChar( new SpaceChar() );
				} );
				build.addTagMapping( "li:end" , function( context : BuildContext, styleContext : StyleContext, attributes : Object ) : void 
				{
					context.setChar( new LiEndChar() );
				} );
			
				txt = new AdvancedTextField( build );
				txt.width = 640;
				txt.autoSize = "left";
				txt.allowMask = false;
				txt.wordWrap = true;
				txt.start();
				txt.addEventListener(TextEvent.LINK, linkClicked );
				txt.htmlText = "This is a simple string filling the <code>AdvancedTextField</code>'s <code>htmlText</code> property." +
							   "<p>You can use paragraphs (<code>&lt;p&gt;&lt;/p&gt;</code>).</p>" +
							   "<p align='center'>You can align paragraphs <code>&lt;p align='center'&gt;&lt;/p&gt;</code>).</p>" +
							   "<p align='right'>Consecutives paragraphs don't add extra spaces.</p>" +
							   "<p>You can do some basic formatting such as <b>bold</b>, <i>italic</i>, <u>underline</u>, " +
							   "<font color='0x"+Color.Orange.rgb+"'>colored text</font>, <font background='0x99ff66' color='0x000000'>colored background text</font>, " +
							   "changing the <font size='18'>size of the text</font>, and of course, " +
							   "<b>you <i>can <u>nest <font color='0x" + Color.Orange.rgb + "'>all <font background='0x99ff66' color='0x000000'>these " +
							   "<font size='18'>tags</font></font></font></u></i></b>.</p>" +
							   "<p>All html special chars handled by the native <code>TextField</code> are available as well, such as <code>&amp;gt;</code> " +
							   "which will display &gt;.</p>" +
							   "<p><font face='Ubuntu' embedFonts='true' size='16'>You can use embed fonts, locally, via the <code>&lt;font&gt;</code> tag and its <code>embedFonts</code> " +
							   "attribute.</font></p>" +
							   "<p>Link can be created using the <code>&lt;a&gt;</code> tag, and <a href='#some-link'>this is what you get</a></p>"+
							   "<p>You can insert any <code>DisplayObject</code> inlined using the <code>&lt;img&gt;</code> tag " +
							   "and the qualified class name as the <code>src</code> value, <img src='abe.com.prehension.examples::AdvancedTextFieldExample.star'/>, the bottom of the " +
							   "<code>DisplayObject</code> is considered as its baseline. Of course, inlined image are like any other char concerning " +
							   "the background : <font background='0x99ff66'><img src='abe.com.prehension.examples::AdvancedTextFieldExample.star'/></font>.</p>" +
							   "<p>It is possible to create custom mapping functions for any chars, for instance in this string, " +
							   "the € and $ chars are mapped to bitmaps. " +
							   "It's also possible to map custom HTMl special chars, such as &smile;&nbsp;(<code>&amp;smile;</code>) " +
							   "or &wink;&nbsp;(<code>&amp;wink;</code>).</p>" +
							   "<ul>" +
							   "<li>This is list is builded using custom handlers for <code>&lt;ul&gt;</code> and <code>&lt;li&gt;</code> " +
							   "tags.</li>" +
							   "<li>The <code>&lt;ul&gt;</code> tag will create a new line that act as upper margin.</li>" +
							   "<li>The <code>&lt;li&gt;</code> tag will create a <code>TabChar</code>, a <code>SpriteChar</code> and" +
							   "finally a <code>SpaceChar</code>.</li>" +
							   "<li>The <code>&lt;/li&gt;</code> tag will create a <code>NewLineChar</code> to force the line return.</li>" +
							   "</ul>" +
							   "<p>And below, you can see an example of another custom tag, with a <code>&lt;h1&gt;</code> header.</p>" +
							   "<h1>Effects</h1>" +
							   "<p>Let's see now a bit of the advanced features of the <code>AdvancedTextField</code>. There's two kind " +
							   "of char's effects :</p>" +
							   "<ul>" +
							   "<li><b>Filters :</b> Defined with the tag <code>&lt;fx:filter&gt;</code>, they allow to apply " +
							   "<code>BitmapFilters</code> on any sets of chars, such as " +
							   "<fx:filter type='new flash.filters::GlowFilter(0x" + Color.Orange.rgb + ",1,4,4,2,3)'><b>this example</b></fx:filter> or " +
							   "<fx:filter type='new flash.filters::GlowFilter(0xffffff,1,2,2,6,1)'><font color='0x000000'><b>this example</b></font></fx:filter>.</li>" +
							   "<li><b>Effects :</b> Defined with the tag <code>&lt;fx:effect&gt;</code>, they allow to apply " +
							   "procedural effects to any set of chars, such as " +
							   "<fx:effect type='new abe.com.edia.text.fx.loop::WaveEffect(6)'><b>this example</b></fx:effect> or " +
							   "<fx:effect type='new abe.com.edia.text.fx.loop::TrembleEffect()'><b>this example</b></fx:effect>.</li>" +
			 				   "</ul>" +
							   "<p>Background are affected by effects, as in <fx:effect type='new abe.com.edia.text.fx.loop::TrembleEffect()'>" +
							   "<font background='0x99ff66' color='0x000000'><b>this example</b></font></fx:effect>.</p>" +
							   "<p>Effects can be combined to produce much more spectacular transformations : </p>" +							   "<p align='center'>"+
							   "<fx:filter type='new flash.filters::GlowFilter(0xffffff, 1,2,2,10,2)'>" +
								   "<fx:filter type='new flash.filters::GlowFilter(0x"+ Color.OrangeRed.rgb +",1,1.1,1.1,10,3)'>" +
									   "<fx:effect type='new abe.com.edia.text.fx.complex::TwinklingChar()'>" +
										   "<fx:effect type='new abe.com.edia.text.fx.loop::WaveEffect(6)'>" +
											   "<font color='0x"+ Color.Orange.rgb + "' " +
											   		 "size='16' " +
											   		 "face='Ubuntu' " +
											   		 "embedFonts='true' " +
											   		 "letterSpacing='1' >" +												   "<b>Level Complete !</b>" +
											   "</font>" +
										   "</fx:effect>" +
									   "</fx:effect>" +
								   "</fx:filter>" +
							   "</fx:filter>" +
							   "</p>" +
							   "<p><fx:effect id='fall' type='new abe.com.edia.text.fx.hide::RandomFallingChars(50,50,0,false)'>"+
							   "Effects can have an <code>id</code> attribute which allow you to retreive a reference to this " +
							   "effect and then manipulate it by code. Many of the built-in effect support has an <code>autoStart</code> " +
							   "argument in their constructor, allowing to trigger the effect later. For instance, by clicking " +
							   "<a href='#fall'>here</a>, you will start the falls of all this paragraph." +
							   "</fx:effect></p>" +
							   "<p>Finally, you can see in the logs (<code>F4</code> key) the ouput of the <code>AdvancedTextField</code>'s " +
							   "<code>text</code> property.</p>" +
							   "<p>And you can even select the text &wink;</p>" +
							   "<p>That's all folks !</p>";
				ToolKit.mainLevel.addChild( txt );
				Log.debug( txt.text );
			}
			catch( e : Error ) 
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
		protected function linkClicked (event : TextEvent) : void 
		{
			var s : String = event.text;
			if( s.indexOf("#") == 0 )
			{
				s = s.substr(1);
				if( txt.effects.hasOwnProperty( s ) )
					txt.effects[s].start();
			}
		}
	}
}

import abe.com.edia.text.core.NewLineChar;
import abe.com.edia.text.core.TabChar;

internal class LiChar extends TabChar
{
	override public function get text () : String {	return "\t"; }
}
internal class LiEndChar extends NewLineChar
{
	public function LiEndChar () 
	{
		super( false, 0 );
	}
	override public function get text () : String {	return "\n"; }
}
internal class UlChar extends NewLineChar
{
	public function UlChar () 
	{
		super( false, 2 );
	}
	override public function get text () : String { return "\n"; }
}
internal class H1Char extends NewLineChar
{
	private var endTag : Boolean;

	public function H1Char ( endTag : Boolean = false ) 
	{
		this.endTag = endTag;
	}
	override public function get text () : String { return endTag ? "\n" : "\n# "; }
}
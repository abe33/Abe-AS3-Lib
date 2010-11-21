package aesia.com.ponents.demos 
{
	import aesia.com.mon.geom.ColorMatrix;
	import aesia.com.mon.utils.Color;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.buttons.ToggleButton;
	import aesia.com.ponents.core.ComponentStates;
	import aesia.com.ponents.skinning.ComponentStateStyle;
	import aesia.com.ponents.skinning.ComponentStyle;
	import aesia.com.ponents.skinning.SkinManagerInstance;
	import aesia.com.ponents.skinning.decorations.AdvancedSlicedBitmapFill;
	import aesia.com.ponents.skinning.decorations.NoDecoration;
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.ponents.utils.Borders;
	import aesia.com.ponents.utils.Corners;
	import aesia.com.ponents.utils.Insets;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;

	/**
	 * @author Cédric Néhémie
	 */
	[SWF(backgroundColor="#bbbbbb")]
	public class ButtonSkinDemo extends Sprite 
	{
		[Embed(source="bgtile.png")]
		private var bgClass : Class;
		
		[Embed(source="add.png")]
		private var add : Class;
		
		protected var bgBitmap : BitmapData;
		
		public function ButtonSkinDemo ()
		{
			StageUtils.setup( this );
			
			bgBitmap = (new bgClass() as Bitmap).bitmapData;
			
							
			var s9b : AdvancedSlicedBitmapFill = new AdvancedSlicedBitmapFill(bgBitmap, 
									  new Rectangle( 8,8,24,24 ), AdvancedSlicedBitmapFill.STANDARD_REPEAT_BOX );
			  
			var button : Button = new Button( new AbstractAction( "Button", magicIconBuild(add) ) );
			button.x = 10;
			button.y = 10;			button.style.setForAllStates( "fill" , s9b )
						.setForAllStates( "cornerRadius", new Corners(0) )
						.setForAllStates( "insets", new Insets(10,10,10,10) )						.setForAllStates( "stroke", new NoDecoration() )						.setForAllStates( "textColor", Color.White )
						.setStyleForState( ComponentStates.OVER, "format", new TextFormat( null, null, null, null, null, true ));
			//button.preferredSize = new Dimension( 100, 50 );
			
			var button2 : Button = new Button( new AbstractAction( "<b><u>B</u>utton</b>", magicIconBuild(add) ) );
			button2.x = 10;
			button2.y = 55;
			
			button2.style.setForAllStates( "cornerRadius", new Corners(8,0,0,8) );
			
			var m : ColorMatrix = new ColorMatrix();
			m.adjustSaturation( -100 );
			m.adjustAlpha( -100 );
			var innerEnabled : Array = [ new BevelFilter(1,30, Color.DarkSlateGray.hexa, .5, Color.PaleTurquoise.hexa, .7, 0, 0, 1, 2, "outter" ) ];
			var innerDisabled : Array = [ new BevelFilter(1,30, Color.DimGray.hexa, .7, Color.White.hexa, .7, 0, 0, 1, 2, "outter" ), new ColorMatrixFilter( m ) ]; 
			
			var pushButton : ComponentStyle = new ComponentStyle( "EmptyComponent", "PushButton", Vector.<ComponentStateStyle> ( [
		 		// Normal
		 		new ComponentStateStyle(
		 			new PushButtonFill( 6, 10, Color.LightSeaGreen, Color.Teal,	Color.DarkSlateGray ),	
		 			null, Color.Teal, null, new Insets(4, 7, 4, 13), new Borders(0), new Corners(4), null, innerEnabled ),
		 		new ComponentStateStyle(
		 			new PushButtonFill( 6, 10, Color.Gainsboro, Color.Silver, Color.DimGray ), 
		 			null, Color.Silver, null, new Insets(4, 7, 4, 13), new Borders(0), new Corners(4), null, innerDisabled ),
		 		new ComponentStateStyle(
		 			new PushButtonFill( 8, 10, Color.MediumAquamarine, Color.LightSeaGreen,	Color.DarkSlateGray ), 
		 			null, Color.LightSeaGreen, null, new Insets(4, 5, 4, 15), new Borders(0), new Corners(4), null, innerEnabled ),
		 		new ComponentStateStyle(
		 			new PushButtonFill( -1, 10, Color.MediumAquamarine, Color.LightSeaGreen,	Color.DarkSlateGray ), 
		 			null, Color.LightSeaGreen, null, new Insets(4, 14, 4, 6), new Borders(0), new Corners(4), null, innerEnabled ),
		 		
		 		// Focus
		 		new ComponentStateStyle(
		 			new PushButtonFill( 6, 10, Color.MediumAquamarine, Color.DarkCyan,	Color.DarkSlateGray ), 
		 			null, Color.DarkCyan, null, new Insets(4, 7, 4, 13), new Borders(0), new Corners(4), null, innerEnabled ),
		 		new ComponentStateStyle(),
		 		
		 		new ComponentStateStyle(
		 			new PushButtonFill( 8, 10, Color.MediumAquamarine, Color.LightSeaGreen,	Color.DarkSlateGray ), 
		 			null, Color.LightSeaGreen, null, new Insets(4, 4, 4, 16), new Borders(0), new Corners(4), null, innerEnabled ),
		 		new ComponentStateStyle(
		 			new PushButtonFill( -1, 10, Color.MediumAquamarine, Color.LightSeaGreen,	Color.DarkSlateGray ), 
		 			null, Color.LightSeaGreen, null, new Insets(4, 14, 4, 6), new Borders(0), new Corners(4), null, innerEnabled ),
		 		
		 		// Selected
		 		new ComponentStateStyle(
		 			new PushButtonFill( 1, 10, Color.LightSeaGreen, Color.Teal,	Color.DarkSlateGray ), 
		 			null, Color.Teal, null, new Insets(4, 12, 4, 8), new Borders(0), new Corners(4), null, innerEnabled ),
		 		new ComponentStateStyle(
		 			new PushButtonFill( 1, 10, Color.Gainsboro, Color.Silver, Color.DimGray ), 
		 			null, Color.Silver, null, new Insets(4, 12, 4, 8), new Borders(0), new Corners(4), null, innerDisabled ),
		 		new ComponentStateStyle(
		 			new PushButtonFill( 3, 10, Color.MediumAquamarine, Color.LightSeaGreen,	Color.DarkSlateGray ), 
		 			null, Color.LightSeaGreen, null, new Insets(4, 11, 4, 9), new Borders(0), new Corners(4), null, innerEnabled ),
		 		new ComponentStateStyle(
		 			new PushButtonFill( -1, 10, Color.MediumAquamarine, Color.LightSeaGreen,	Color.DarkSlateGray ), 
		 			null, Color.LightSeaGreen, null, new Insets(4, 14, 4, 6), new Borders(0), new Corners(4), null, innerEnabled ),
		 		
		 		// Focus & Selected
		 		new ComponentStateStyle(
		 			new PushButtonFill( 1, 10, Color.MediumAquamarine, Color.DarkCyan,	Color.DarkSlateGray ), 
		 			null, Color.DarkCyan, null, new Insets(4, 12, 4, 8), new Borders(0), new Corners(4), null, innerEnabled ),
		 		new ComponentStateStyle(),
		 		new ComponentStateStyle(
		 			new PushButtonFill( 3, 10, Color.MediumAquamarine, Color.LightSeaGreen,	Color.DarkSlateGray ), 
		 			null, Color.LightSeaGreen, null, new Insets(4, 11, 4, 9), new Borders(0), new Corners(4), null, innerEnabled ),
		 		new ComponentStateStyle(
		 			new PushButtonFill( -1, 10, Color.MediumAquamarine, Color.LightSeaGreen,	Color.DarkSlateGray ), 
		 			null, Color.LightSeaGreen, null, new Insets(4, 14, 4, 6), new Borders(0), new Corners(4), null, innerEnabled )

		 	] ) ).setForAllStates( "format", new TextFormat( "Arial", 18 ) );
			
			SkinManagerInstance.currentSkin = { PushButton:pushButton };
			
			var button3 : Button = new Button( new AbstractAction( "<b>Button</b>" ) );
			button3.styleKey = "PushButton";
			button3.x = 10;
			button3.y = 90;
			
			var button4 : ToggleButton = new ToggleButton( new AbstractAction( "<b>Button</b>" ) );
			button4.styleKey = "PushButton";
			button4.x = 90;
			button4.y = 90;
			button4.selected = true;
			
			var button5 : Button = new Button( new AbstractAction( "<b>Button</b>" ) );
			button5.styleKey = "PushButton";
			button5.x = 170;
			button5.y = 90;
			button5.enabled = false;
			
			var button6 : Button = new Button( new AbstractAction( "<b>Button</b>" ) );
			button6.styleKey = "PushButton";
			button6.x = 250;
			button6.y = 90;
			button6.enabled = false;			button6.selected = true;
			
			var button7 : ToggleButton = new ToggleButton( new AbstractAction( "" ) );
			var ic7 : DisplayObject = new add();
			ic7.width = ic7.height = 24;
			//button7.icon = ic7;
			button7.styleKey = "PushButton";
			button7.x = 375;
			button7.y = 90;
			
			var button8 : ToggleButton = new ToggleButton( new AbstractAction( "" ) );
			var ic8 : DisplayObject = new add();
			ic8.width = ic8.height = 24;
			//button8.icon = ic8;
			button8.styleKey = "PushButton";
			button8.x = 330;
			button8.y = 90;
			button8.enabled = false;
			button8.selected = true;
			
			addChild( button ); 			addChild( button2 ); 			addChild( button3 ); 			addChild( button4 ); 			addChild( button5 ); 			addChild( button6 ); 			addChild( button7 ); 			addChild( button8 ); 
		}
	}
}

import aesia.com.mon.utils.Color;
import aesia.com.ponents.core.Component;
import aesia.com.ponents.skinning.decorations.ComponentDecoration;
import aesia.com.ponents.utils.Borders;
import aesia.com.ponents.utils.Corners;

import flash.display.Graphics;
import flash.geom.Rectangle;

internal class PushButtonFill implements ComponentDecoration
{
	protected var _height : Number;	protected var _maxheight : Number;
	protected var _faceColor : Color; 
	protected var _sideColor : Color; 
	protected var _borderColor : Color;
	
	public function PushButtonFill ( h : Number = 0, maxh : Number = 10, faceColor : Color = null, sideColor : Color = null, borderColor : Color = null )
	{
		_height = h;		_maxheight = maxh;
		_faceColor = faceColor;
		_borderColor = borderColor;
		_sideColor = sideColor;
	}

	public function draw (r : Rectangle, 
							g : Graphics, 
							c : Component,
							borders : Borders = null,
							corners : Corners = null, 
							smoothing : Boolean = false) : void
	{
		drawPushButton( r.x+2, 
						r.y + _maxheight - ( _height > 0 ? _height : 0), 
						r.width - 4 , 
						r.height - _maxheight - 4, 
						_height, 
						g, 
						_faceColor,
						_sideColor,
						_borderColor,
						/*
						Color.LightSeaGreen, 
						Color.Teal, 
						Color.DarkSlateGray,*/ 
						2, 
						corners );
	}

	protected function drawPushButton( x : Number,
										   y : Number,
										   faceWidth : Number,
										   faceHeight : Number, 
										   sideHeight : Number,
										   g : Graphics, 
										   faceColor : Color, 
										   sideColor : Color, 
										   borderColor : Color,
										   borderSize : Number = 2,
										   cornerSize : Corners = null ) : void
		{
			g.lineStyle();
			if( sideHeight > 0 )
			{
				
				g.beginFill( borderColor.hexa );
				/*
				g.drawRoundRectComplex(x-borderSize, 
								y-borderSize, 
								faceWidth + borderSize*2, 
								faceHeight + sideHeight + borderSize*2,
								cornerSize.topLeft + borderSize * 2, 
								cornerSize.topRight + borderSize * 2, 
								cornerSize.bottomLeft + borderSize * 2, 
								cornerSize.bottomRight + borderSize * 2 );
				

				*/
				g.drawRoundRectComplex(x-borderSize, 
								y-borderSize + sideHeight, 
								faceWidth + borderSize*2, 
								faceHeight + borderSize*2,
								cornerSize.topLeft + borderSize * 2, 								cornerSize.topRight + borderSize * 2, 								cornerSize.bottomLeft + borderSize * 2, 								cornerSize.bottomRight + borderSize * 2
								 );
				g.endFill(); 
				
				g.beginFill( sideColor.hexa );
				g.drawRoundRectComplex(x, y, faceWidth, faceHeight + sideHeight, cornerSize.topLeft, cornerSize.topRight, cornerSize.bottomLeft, cornerSize.bottomRight );
				g.endFill();
				
				g.beginFill( faceColor.hexa );
				g.drawRoundRectComplex( x, y, faceWidth, faceHeight, cornerSize.topLeft, cornerSize.topRight, cornerSize.bottomLeft, cornerSize.bottomRight );
				g.endFill();
				
				//g.lineStyle( borderSize, borderColor.hexa, 1, true  );
				//g.drawRoundRect(x, y, faceWidth, faceHeight + sideHeight, cornerSize );
			}
			else if ( sideHeight == 0 )
			{
				g.beginFill( borderColor.hexa );
				g.drawRoundRectComplex(x-borderSize, 
								y-borderSize, 
								faceWidth + borderSize*2, 
								faceHeight + borderSize*2,
								cornerSize.topLeft + borderSize * 2, 
								cornerSize.topRight + borderSize * 2, 
								cornerSize.bottomLeft + borderSize * 2, 
								cornerSize.bottomRight + borderSize * 2 );
				g.endFill(); 
				
				//g.lineStyle( borderSize, borderColor.hexa, 1, true );
				/*
				g.beginFill( sideColor.hexa );
				g.drawRoundRect(x, y, faceWidth, faceHeight, cornerSize );
				g.endFill();
				*/
				g.beginFill( faceColor.hexa );
				g.drawRoundRectComplex(x, y, faceWidth, faceHeight, cornerSize.topLeft-2, cornerSize.topRight-2, cornerSize.bottomLeft-2, cornerSize.bottomRight-2 );
				g.endFill();
			}
			else
			{
				g.beginFill( borderColor.hexa );
				g.drawRoundRectComplex(x-borderSize, 
								y-borderSize, 
								faceWidth + borderSize*2, 
								faceHeight + borderSize*2,
								cornerSize.topLeft-2 + borderSize * 2, 
								cornerSize.topRight-2 + borderSize * 2, 
								cornerSize.bottomLeft-2 + borderSize * 2, 
								cornerSize.bottomRight-2 + borderSize * 2 );
				g.endFill(); 
				
				g.beginFill( sideColor.hexa );
				g.drawRoundRectComplex(x, y, faceWidth, faceHeight, cornerSize.topLeft, cornerSize.topRight, cornerSize.bottomLeft, cornerSize.bottomRight );
				g.endFill();
				
				g.beginFill( faceColor.hexa );
				g.drawRoundRectComplex( x, y - sideHeight, faceWidth, faceHeight + sideHeight, cornerSize.topLeft, cornerSize.topRight, cornerSize.bottomLeft, cornerSize.bottomRight );
				g.endFill();
				
				//g.lineStyle( borderSize, borderColor.hexa, 1, true  );
				//g.drawRoundRect(x, y, faceWidth, faceHeight, cornerSize );
		}
	}
	
	public function equals (o : *) : Boolean
	{
		// TODO: Auto-generated method stub
		return false;
	}
	
	public function toSource () : String
	{
		// TODO: Auto-generated method stub
		return null;
	}
	
	public function toReflectionSource () : String
	{
		// TODO: Auto-generated method stub
		return null;
	}
}

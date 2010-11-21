package aesia.com.ponents.demos 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.logs.LogEvent;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.menus.ComboBox;
	import aesia.com.ponents.models.DefaultComboBoxModel;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextFormat;

	/**
	 * @author Cédric Néhémie
	 */
	public class ComboBoxDemo extends Sprite 
	{
		public function ComboBoxDemo ()
		{
			var lv : LogView;
			var al : Array =[];
			var fl : Function = function ( e : LogEvent):void
			{
				al.push( e.msg );	
			};
			Log.getInstance().addEventListener( LogEvent.LOG_ADD, fl );
			StageUtils.setup(this);
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();
			
			KeyboardControllerInstance.eventProvider = stage;
			
			lv = new LogView();
			lv.size = new Dimension(200,400);
			lv.x = 350;
			ToolKit.mainLevel.addChild(lv);
			Log.debug(al);
			
			try
			{
				var combobox1 : ComboBox = new ComboBox(  "Item 1", 
														  "Item 2", 
														  "Item 3", 
														  "Item 4", 
														  "Item 5 with a longer text", 
														  "Item 6", 
														  "Item 7" );
				
				combobox1.x = 10;				combobox1.y = 10;
				combobox1.popupAsDropDown = true;
				
				var combobox2 : ComboBox = new ComboBox(  "Item 1", 
														  "Item 2", 
														  "Item 3", 
														  "Item 4", 
														  "Item 5 with a longer text", 
														  "Item 6", 
														  "Item 7" );
				
				combobox2.x = 10;
				combobox2.y = 50;
				combobox2.preferredSize = new Dimension( 150, 50 );
				
				var combobox3 : ComboBox = new ComboBox( "Item 1", 
														  "Item 2", 
														  "Item 3", 
														  "Item 4", 
														  "Item 5 with a longer text", 
														  "Item 6", 
														  "Item 7" );
				
				combobox3.x = 10;
				combobox3.y = 130;
				combobox3.popupAlignOnSelection = true;
				
				var combobox4 : ComboBox = new ComboBox( "Item 1", 
														  "Item 2", 
														  "Item 3", 
														  "Item 4", 
														  "Item 5 with a longer text", 
														  "Item 6", 
														  "Item 7" );
				
				combobox4.x = 10;
				combobox4.y = 180;
				combobox4.enabled = false;
				
				var a : Array = Font.enumerateFonts(true);
				//a.length = 40;
				a.sortOn( "fontName", Array.CASEINSENSITIVE );
				var l : Number = a.length;
								var b : Array = [];
				for( var i:Number = 0; i<l; i++ )
				{
					var f : Font = a[i];
					b[i] = f.fontName + "\t<font face='" + f.fontName + "'>Sample</font>";
				}
				var m : DefaultComboBoxModel = new DefaultComboBoxModel( b );
				var combobox5 : ComboBox = new ComboBox(m);
				combobox5.menuItemClass = FontMenuItem;
				combobox5.popupMenu.scrollLayout = 0;
				
				var tf : TextFormat = new TextFormat();
				tf.tabStops = [ 170 ];
				combobox5.style.setForAllStates( "format" , tf );
				combobox5.x = 10;
				combobox5.y = 220;
				
				ToolKit.mainLevel.addChild( combobox1 );				ToolKit.mainLevel.addChild( combobox2 );				ToolKit.mainLevel.addChild( combobox3 );				ToolKit.mainLevel.addChild( combobox4 );				ToolKit.mainLevel.addChild( combobox5 );
			}
			catch( e : Error )
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
	}
}

import aesia.com.ponents.actions.Action;
import aesia.com.ponents.menus.MenuItem;

import flash.text.TextFormat;

internal class FontMenuItem extends MenuItem
{
	public function FontMenuItem ( action : Action = null )
	{
		//Log.debug( 'in FontMenuItem constructor' );
		super(action);
		cacheAsBitmap= true;
		var tf : TextFormat = new TextFormat();
		tf.tabStops = [ 170 ];
		style.setForAllStates( "format" , tf );
		
		_labelTextField.defaultTextFormat = style.format;
		_labelTextField.textColor = style.textColor.hexa;
		updateLabelText();
		
		//Log.debug( _label.defaultTextFormat.tabStops );
	}
}

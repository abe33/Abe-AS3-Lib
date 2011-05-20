package abe.com.ponents.tools 
{
	import abe.com.mon.colors.Color;
	import abe.com.ponents.buttons.*;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.core.*;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.events.PropertyEvent;
	import abe.com.ponents.forms.FormObject;
	import abe.com.ponents.forms.FormUtils;
	import abe.com.ponents.forms.managers.SimpleFormManager;
	import abe.com.ponents.forms.renderers.FieldSetFormRenderer;
	import abe.com.ponents.layouts.components.*;
	import abe.com.ponents.skinning.icons.ColorIcon;

	import flash.events.MouseEvent;

    import org.osflash.signals.Signal;
	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="RGBColorEditor")]
	[Skin(define="RGBColorEditor",
			  inherit="EmptyComponent",
			  state__all__insets="new cutils::Insets(5)"
	)]
	public class RGBColorEditor extends Panel 
	{
		protected var _target : Color;
		protected var _colorIcon : ColorIcon;
		protected var _colorIconSave : ColorIcon;
		protected var _grid : ColorGrid;
		protected var _formObject : FormObject;
		protected var _formManager : SimpleFormManager;
		protected var _formPanel : Container;
		protected var _modeGroup : ButtonGroup;
		
		public var dataChanged : Signal;
		
		public function RGBColorEditor ()
		{
			super( );
			dataChanged = new Signal();
			
			_childrenLayout = new InlineLayout(this);
			_target = new Color();
			_colorIcon = new ColorIcon( _target );
			_colorIconSave = new ColorIcon( _target.clone() );
			
			_grid = new ColorGrid( Color.Black.clone(), ColorGrid.MODE_H );
			_formObject = FormUtils.createFormFromMetas( _target );
			_formManager = new SimpleFormManager( _formObject );
			_formPanel = FieldSetFormRenderer.instance.render( _formObject ) as Container;
			
			_formManager.propertyChanged.add( formPropertyChanged );
			_grid.dataChanged.add( samplerDataChanged );
			_colorIconSave.mouseReleased.add( iconSaveClicked );
			
			_colorIcon.init();
			_colorIconSave.init();
			
			var p : Panel = new Panel();
			var l : BorderLayout = new BorderLayout( p, true, 4 );
			p.childrenLayout = l;
			
			_modeGroup = new ButtonGroup();
			var modeR : RadioToggleButton = new RadioToggleButton("R");
			var modeG : RadioToggleButton = new RadioToggleButton("G");
			var modeB : RadioToggleButton = new RadioToggleButton("B");
			var modeH : RadioToggleButton = new RadioToggleButton("H");
			var modeS : RadioToggleButton = new RadioToggleButton("S");
			var modeV : RadioToggleButton = new RadioToggleButton("V");
			_modeGroup.add( modeR );
			_modeGroup.add( modeG );
			_modeGroup.add( modeB );
			_modeGroup.add( modeH );
			_modeGroup.add( modeS );
			_modeGroup.add( modeV );
			_modeGroup.selectionChanged.add( modeSelectionChanged );

			var p2 : Panel = new Panel();
			p2.childrenLayout = new GridLayout( p2, 6, 1, 3, 3);
			p2.addComponents( modeR, modeG, modeB, modeH, modeS, modeV );
			
			l.center = _grid;
			p.addComponent( _grid );
			
			l.east = p2;
			p.addComponent( p2 );
			
			_formPanel.addComponents( p, _colorIcon, _colorIconSave );
			
			modeH.selected = true;

			addComponent( _formPanel );
			invalidatePreferredSizeCache();
		}
		
		public function modeSelectionChanged( bg : ButtonGroup ) : void
		{
		    switch( _modeGroup.selectedButton.label )
		    {
		        case "R" : 
        		    _grid.mode = ColorGrid.MODE_R;
        		    break;
        		case "G" : 
        		    _grid.mode = ColorGrid.MODE_G;
        		    break;
        		case "B" : 
        		    _grid.mode = ColorGrid.MODE_B;
        		    break;
        		case "S" : 
        		    _grid.mode = ColorGrid.MODE_S;
        		    break;
		        case "V" : 
        		    _grid.mode = ColorGrid.MODE_V;
        		    break; 
		        case "H" : 
		        default : 
        		    _grid.mode = ColorGrid.MODE_H;
        		    break;  
		    }
		}

		public function get target () : Color { return _target; }	
		public function set target (target : Color) : void
		{
			_target = target;
			_colorIcon.color = _target;
			_grid.value = _target.clone();
			_formObject.target = _target;
			_formManager.updateFieldsWithTarget();
		}
		public function get safeTarget( ) : Color { return _colorIconSave.color; }
		public function set safeTarget( target : Color ) : void
		{
			_colorIconSave.color = target.clone(); 
		}
		
		public function get formPanel () : Container { return _formPanel; }
		
		public function formPropertyChanged( propertyName : String, propertyValue : * ) : void 
		{
			_colorIcon.invalidate();
			if( propertyName != "name" && 
				propertyName != "alpha" )
			{
				_grid.value = _target.clone();
			}
			fireDataChangedSignal();
		}

		public function samplerDataChanged ( c : Component, v : * ) : void
		{
			var c2 : Color = _grid.value;
			_target.red = c2.red;
			_target.green = c2.green;
			_target.blue = c2.blue;
			//c.alpha = c2.alpha;
			_colorIcon.invalidate();
			_formManager.updateFieldsWithTarget();
			fireDataChangedSignal();
		}
		protected function iconSaveClicked ( c : Component ) : void
		{
			var c2 : Color = _colorIconSave.color;
			_target.red = c2.red;
			_target.green = c2.green;
			_target.blue = c2.blue;
			_target.alpha = c2.alpha;
			_grid.value = _target;
			_colorIcon.invalidate();
			_formManager.updateFieldsWithTarget();
			fireDataChangedSignal();
		}
		
		protected function fireDataChangedSignal () : void 
		{
			dataChanged.dispatch( this, target );
		}
		
		public function get formManager () : SimpleFormManager { return _formManager;}
	}
}

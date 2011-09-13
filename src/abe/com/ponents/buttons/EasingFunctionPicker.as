package abe.com.ponents.buttons
{
    import abe.com.mands.Command;
    import abe.com.mon.utils.StageUtils;
    import abe.com.motion.AbstractTween;
    import abe.com.motion.easing.Back;
    import abe.com.motion.easing.Bounce;
    import abe.com.motion.easing.Circ;
    import abe.com.motion.easing.Cubic;
    import abe.com.motion.easing.Elastic;
    import abe.com.motion.easing.Expo;
    import abe.com.motion.easing.Linear;
    import abe.com.motion.easing.Quad;
    import abe.com.motion.easing.Quart;
    import abe.com.motion.easing.Quint;
    import abe.com.motion.easing.Sine;
    import abe.com.ponents.actions.builtin.EditEasingFunctionsAction;
    import abe.com.ponents.containers.Panel;
    import abe.com.ponents.core.AbstractContainer;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.forms.FormComponent;
    import abe.com.ponents.layouts.components.BorderLayout;
    import abe.com.ponents.layouts.components.BoxSettings;
    import abe.com.ponents.layouts.components.HBoxLayout;
    import abe.com.ponents.menus.ComboBox;
    import abe.com.ponents.menus.PopupMenu;
    import abe.com.ponents.models.LabelComboBoxModel;
    import abe.com.ponents.monitors.EasingFunctionGraph;
    import abe.com.ponents.skinning.icons.magicIconBuild;
    import abe.com.ponents.utils.ToolKit;

    import org.osflash.signals.Signal;


    /**
     * @author cedric
     */
    [Skinable(skin="EmptyComponent")]
    public class EasingFunctionPicker extends AbstractContainer implements FormComponent
    {
        static public const EASING_FUNCTIONS : Array = initEasingFunctionList ();

		[Embed(source="../skinning/icons/application_form_edit.png")]
		static public var editIcon : Class;

        static private function initEasingFunctionList () : Array
        {
            var easingFunctionList : Array = [
            	[ AbstractTween.noEasing, "No Easing",	"abe.com.motion::AbstractTween.noEasing"],	
                
	        	[ Back.easeIn, 		"Back.easeIn", 		"abe.com.motion.easing::Back.easeIn" ],
	        	[ Back.easeOut, 	"Back.easeOut", 	"abe.com.motion.easing::Back.easeOut" ],
	        	[ Back.easeInOut, 	"Back.easeInOut", 	"abe.com.motion.easing::Back.easeInOut" ],
	            
	            [ Bounce.easeIn, 	"Bounce.easeIn", 	"abe.com.motion.easing::Bounce.easeIn" ],
	        	[ Bounce.easeOut, 	"Bounce.easeOut", 	"abe.com.motion.easing::Bounce.easeOut" ],
	        	[ Bounce.easeInOut, "Bounce.easeInOut", "abe.com.motion.easing::Bounce.easeInOut" ],
	            
	            [ Circ.easeIn, 		"Circ.easeIn", 		"abe.com.motion.easing::Circ.easeIn" ],
	        	[ Circ.easeOut, 	"Circ.easeOut", 	"abe.com.motion.easing::Circ.easeOut" ],
	        	[ Circ.easeInOut, 	"Circ.easeInOut", 	"abe.com.motion.easing::Circ.easeInOut" ],
	            
	            [ Cubic.easeIn, 	"Cubic.easeIn", 	"abe.com.motion.easing::Cubic.easeIn" ],
	        	[ Cubic.easeOut, 	"Cubic.easeOut", 	"abe.com.motion.easing::Cubic.easeOut" ],
	        	[ Cubic.easeInOut, 	"Cubic.easeInOut", 	"abe.com.motion.easing::Cubic.easeInOut" ],
	            
	            [ Elastic.easeIn, 	"Elastic.easeIn", 	"abe.com.motion.easing::Elastic.easeIn" ],
	        	[ Elastic.easeOut, 	"Elastic.easeOut", 	"abe.com.motion.easing::Elastic.easeOut" ],
	        	[ Elastic.easeInOut,"Elastic.easeInOut","abe.com.motion.easing::Elastic.easeInOut" ],
	            
	            [ Expo.easeIn, 		"Expo.easeIn", 		"abe.com.motion.easing::Expo.easeIn" ],
	        	[ Expo.easeOut, 	"Expo.easeOut", 	"abe.com.motion.easing::Expo.easeOut" ],
	        	[ Expo.easeInOut, 	"Expo.easeInOut", 	"abe.com.motion.easing::Expo.easeInOut" ],
	            
	            [ Linear.easeIn, 	"Linear.easeIn", 	"abe.com.motion.easing::Linear.easeIn" ],
	        	[ Linear.easeOut, 	"Linear.easeOut", 	"abe.com.motion.easing::Linear.easeOut" ],
	        	[ Linear.easeInOut, "Linear.easeInOut", "abe.com.motion.easing::Linear.easeInOut" ],
	        	[ Linear.easeNone, 	"Linear.easeNone", 	"abe.com.motion.easing::Linear.easeNone" ],
	            
	            [ Quad.easeIn, 		"Quad.easeIn", 		"abe.com.motion.easing::Quad.easeIn" ],
	        	[ Quad.easeOut, 	"Quad.easeOut", 	"abe.com.motion.easing::Quad.easeOut" ],
	        	[ Quad.easeInOut, 	"Quad.easeInOut", 	"abe.com.motion.easing::Quad.easeInOut" ], 
	            
	            [ Quart.easeIn, 	"Quart.easeIn", 	"abe.com.motion.easing::Quart.easeIn" ],
	        	[ Quart.easeOut, 	"Quart.easeOut", 	"abe.com.motion.easing::Quart.easeOut" ],
	        	[ Quart.easeInOut, 	"Quart.easeInOut", 	"abe.com.motion.easing::Quart.easeInOut" ],
	            
	            [ Quint.easeIn, 	"Quint.easeIn", 	"abe.com.motion.easing::Quint.easeIn" ],
	        	[ Quint.easeOut, 	"Quint.easeOut", 	"abe.com.motion.easing::Quint.easeOut" ],
	        	[ Quint.easeInOut, 	"Quint.easeInOut", 	"abe.com.motion.easing::Quint.easeInOut" ],
	            
	            [ Sine.easeIn, 		"Sine.easeIn", 		"abe.com.motion.easing::Sine.easeIn" ],
	        	[ Sine.easeOut, 	"Sine.easeOut", 	"abe.com.motion.easing::Sine.easeOut" ],
	        	[ Sine.easeInOut, 	"Sine.easeInOut", 	"abe.com.motion.easing::Sine.easeInOut" ], 
	        ];
        
            return easingFunctionList;
        }
         
        protected var _easingFunctions : ComboBox;
        protected var _editFunction : Button;
        protected var _popupGraph : EasingFunctionGraph;
        protected var _graph : EasingFunctionGraph;
        
		protected var _value : Function;
		protected var _disabledMode : uint;
		protected var _disabledValue : *;
		
		protected var _dataChanged : Signal;
        
        public function EasingFunctionPicker ( v : Function = null )
        {
            super ();
            _dataChanged = new Signal();
            _value = v;
            
            var values : Array = [];
            var labels : Array = [];
            
            _popupGraph = new EasingFunctionGraph();
            _graph = new EasingFunctionGraph( v );
            
            _easingFunctions = new ComboBox( getModel() );
            _easingFunctions.popupMenu.scrollLayout = PopupMenu.SCROLLBAR_SCROLL_LAYOUT;
            _easingFunctions.popupMenu.maximumVisibleItems = 8;
            _easingFunctions.itemFormatingFunction = ( _easingFunctions.model as LabelComboBoxModel ).getLabel;
            _easingFunctions.popupMenu.menuList.itemFormatingFunction = ( _easingFunctions.model as LabelComboBoxModel ).getLabel;
            _easingFunctions.popupMenu.menuList.selectionChanged.add( function( i : int ):void {
                _popupGraph.easingFunction = _easingFunctions.model.getElementAt( i );
            } );
            _easingFunctions.popupAppeared.add( function( c : ComboBox ):void {
                ToolKit.popupLevel.addChild( _popupGraph );
                _popupGraph.x = c.popupMenu.x + c.popupMenu.width;
                _popupGraph.y = c.popupMenu.y; 
                
                if( _popupGraph.x + _popupGraph.width > StageUtils.stage.stageWidth )
                	_popupGraph.x = c.popupMenu.x -_popupGraph.width;
            } );
            _easingFunctions.popupHidden.add( function( c : ComboBox ):void {
                ToolKit.popupLevel.removeChild( _popupGraph );
                _graph.easingFunction = _value;	
            } );
            _easingFunctions.dataChanged.add( easingFunctionChanged );
            
            if( _value != null )
            	_easingFunctions.value = _value;
            
            _editFunction = new Button( new EditEasingFunctionsAction( magicIconBuild( editIcon ) ) );
            _editFunction.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
            _editFunction.action.commandEnded.add(function( c : Command ):void{ refreshModel(); });
            
            var bl : BorderLayout = new BorderLayout(this,true,3);
            
            var selectorPanel : Panel = new Panel();
            
            var l : HBoxLayout = new HBoxLayout( this, 3,
					new BoxSettings(100, "left", "center", _easingFunctions, true, true, true ),
					new BoxSettings(0, "left", "left", _editFunction, false, true, false )
			 );
            selectorPanel.childrenLayout = l;
            
			childrenLayout = bl;
            
            bl.center = _graph;
            addComponent( _graph );
            
            bl.south = selectorPanel;
            addComponent( selectorPanel );
            
            selectorPanel.addComponent(_easingFunctions);
            selectorPanel.addComponent(_editFunction);
        }
        
        public function get disabledMode () : uint { return _easingFunctions.disabledMode; }
		public function set disabledMode (b : uint) : void
		{
			_easingFunctions.disabledMode = b;
		}
        public function get dataChanged () : Signal { return _dataChanged; }
        
		public function get disabledValue () : * { return _easingFunctions.disabledValue; }
		public function set disabledValue (v : *) : void { _easingFunctions.disabledValue = v; }

        public function get value () : * { return _value; }
        public function set value ( v : * ) : void 
        { 
            _value = v as Function;
            _easingFunctions.value = _value;
            _graph.easingFunction = _value;
        }

		override public function set enabled (b : Boolean) : void
		{
			super.enabled = b;
			_easingFunctions.enabled = b;
            _editFunction.enabled = b;
		}
        protected function easingFunctionChanged ( c : Component, v : Function ) : void
        {
            _value = v;
            fireDataChangedSignal();
        }
		protected function fireDataChangedSignal () : void
		{
            _dataChanged.dispatch ( this, value );
        }

        public function get easingFunctions () : ComboBox {
            return _easingFunctions;
        }
        public function refreshModel():void
        {
            _easingFunctions.model = getModel();
        }
        protected function getModel():LabelComboBoxModel
        {
            var values : Array = [];
            var labels : Array = [];
            
            for each( var a : Array in EasingFunctionPicker.EASING_FUNCTIONS )
            {
                values.push(a[0]);
                labels.push(a[1]);
            }
            return new LabelComboBoxModel ( values, labels );
        }
    }
}

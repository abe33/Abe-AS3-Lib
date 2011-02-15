package aesia.com.ponents.builder.styles 
{
	import aesia.com.mon.logs.Log;
	import aesia.com.ponents.builder.events.StyleSelectionEvent;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.events.FormEvent;
	import aesia.com.ponents.events.PropertyEvent;
	import aesia.com.ponents.forms.FormField;
	import aesia.com.ponents.forms.FormObject;
	import aesia.com.ponents.forms.FormUtils;
	import aesia.com.ponents.forms.managers.MultiTargetFormManager;
	import aesia.com.ponents.forms.renderers.FieldSetFormRenderer;
	import aesia.com.ponents.layouts.components.BoxSettings;
	import aesia.com.ponents.layouts.components.HBoxLayout;
	import aesia.com.ponents.skinning.ComponentStateStyle;
	import aesia.com.ponents.skinning.ComponentStyle;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.ponents.utils.Insets;

	import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class StyleFormPanel extends ScrollPane 
	{
		[Embed(source="../../skinning/icons/error.png")]
		static private var sharedTipClass : Class;
		
		protected var _formObject : FormObject;
		protected var _formPane : Component;
		protected var _formManager : MultiTargetFormManager;
		protected var _targetStyle : ComponentStyle;

		public function StyleFormPanel (policy : String = "auto")
		{
			super( policy );
			
			_formObject = FormUtils.createFormFromMetas( new ComponentStateStyle() );
			_formPane = FieldSetFormRenderer.instance.render( _formObject );
			//_formPane.preferredWidth = 400;
			_formPane.style.setForAllStates("insets", new Insets(5));
			_formManager = new MultiTargetFormManager( [], _formObject );
			_formManager.addEventListener(PropertyEvent.PROPERTY_CHANGE, formPropertyChange );
			_formManager.addEventListener(FormEvent.SHARED_FIELD, sharedFieldsFound );
			_formManager.preventModificationOfSharedValues = isValueSharedByOtherStates;

			setupForm( _formObject );
			enabled = false;
			
			view = _formPane;
		}
		public function get targetStyle () : ComponentStyle { return _targetStyle; }
		public function set targetStyle (targetStyle : ComponentStyle) : void 
		{
			_targetStyle = targetStyle;
		}
		public function statesSelectionChange ( event : StyleSelectionEvent ) : void 
		{
			if( event.style && event.states )
			{
				targetStyle = event.style;
				var a : Array = [];
				
				/*FDT_IGNORE*/
				TARGET::FLASH_9 { var v : Array = event.states; }			
				TARGET::FLASH_10 { var v : Vector.<uint> = event.states; }			
				TARGET::FLASH_10_1 { /*FDT_IGNORE*/
				var v : Vector.<uint> = event.states; /*FDT_IGNORE*/}/*FDT_IGNORE*/
	
				var s : ComponentStyle = event.style;
	
				for( var i:int=0;i<v.length;i++)
					a.push(s.states[v[i]]);
	
				hideAllSharedTips ();
				_formManager.targets = a;
			}
		}
		protected function formPropertyChange (event : PropertyEvent) : void
		{
			dispatchEvent( new Event(Event.CHANGE) );
		}
		protected function setupForm (formObject : FormObject) : void
		{
			for each( var f : FormField in formObject.fields )
			{
				var c : Component = f.component;
				var p : Panel = c.parentContainer as Panel;
				var l : HBoxLayout = p.childrenLayout as HBoxLayout;
				var sharedTip : Icon = magicIconBuild(sharedTipClass );

				l.boxes.push(new BoxSettings(20, "center", "center", sharedTip, false, false, false ));
				sharedTip.visible = false;
				p.addComponent( sharedTip );
			}
		}
		protected function isValueSharedByOtherStates( value : *, member : String, num : Number ) : Boolean
		{
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { var states : Array = _targetStyle.states; }
			TARGET::FLASH_10 { var states : Vector.<ComponentStateStyle> = _targetStyle.states; }
			TARGET::FLASH_10_1 {/*FDT_IGNORE*/
			var states : Vector.<ComponentStateStyle> = _targetStyle.states; /*FDT_IGNORE*/}/*FDT_IGNORE*/

			var l : uint = states.length;
			var n : uint = 0;
			for(var i:int=0;i<l;i++)
				if( states[i][member] == value )
					n++;

			return n > num;
		}
		protected function hideAllSharedTips () : void
		{
			for each( var f : FormField in _formObject.fields )
			{
				var c : Component = f.component;
				var p : Panel = c.parentContainer as Panel;
				var sharedTip : Icon = p.lastChild as Icon;
				sharedTip.visible = false;
			}
		}

		protected function sharedFieldsFound (event : FormEvent) : void
		{
			var c : Component = event.formField.component;
			var p : Panel = c.parentContainer as Panel;
			var sharedTip : Icon = p.lastChild as Icon;
			sharedTip.visible = true;

			/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
			sharedTip.tooltip = _("The value in this field is shared by other states of this style.\nA copy of this value will be used if you try to modify it.");
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
	}
}

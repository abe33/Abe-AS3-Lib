package aesia.com.ponents.demos
{
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.Reflection;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.mon.utils.magicClone;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.forms.FormObject;
	import aesia.com.ponents.forms.FormUtils;
	import aesia.com.ponents.forms.managers.SimpleFormManager;
	import aesia.com.ponents.forms.renderers.FieldSetFormRenderer;
	import aesia.com.ponents.layouts.components.BorderLayout;
	import aesia.com.ponents.lists.ListEditor;
	import aesia.com.ponents.menus.ComboBox;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientBevelFilter;
	import flash.filters.GradientGlowFilter;

	/**
	 * @author cedric
	 */
	public class ListEditorDemo extends Sprite
	{
		protected var formPanel : Panel;
		private var listEdit : ListEditor;
		protected var simpleManager : SimpleFormManager;
		private var s : Shape;

		public function ListEditorDemo ()
		{
			StageUtils.setup(this);
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();

			var lv : LogView;
			lv = new LogView();

			KeyboardControllerInstance.eventProvider = stage;

			try
			{
				var p : Panel = new Panel();
				var l : BorderLayout = new BorderLayout();
				p.childrenLayout = l;

				listEdit = new ListEditor(/*["toto", "caca", "popo"], new TextInput()*/ );				/*listEdit = new ListEditor( [0xff00ff,0xfedfc4,0x0ef0dc,0xcdef01],
										   new Spinner(new SpinnerNumberModel(0, 0, uint.MAX_VALUE, 1, true) ),
										   uint );*/

				listEdit.x = 10;				listEdit.y = 10;

				var combo : ComboBox =  new ComboBox(
														 new DropShadowFilter(),
														 new GlowFilter(),
														 new BlurFilter(),
														 new ConvolutionFilter(),
														 new BevelFilter(),
														 new ColorMatrixFilter(),
														 new DisplacementMapFilter(),
														 new GradientBevelFilter(4,45,[0x000000,0xffffff],[1,1],[0,255]),
														 new GradientGlowFilter(4,45,[0x000000,0xffffff],[1,1],[0,255])														);

				listEdit.value = [];
				listEdit.newValueProvider = combo;
				listEdit.contentType = BitmapFilter;				listEdit.list.allowMultiSelection = false;
				listEdit.list.loseSelectionOnFocusOut = false;
				listEdit.list.itemFormatingFunction = combo.itemFormatingFunction = Reflection.extractClassName;

				listEdit.list.addEventListener(ComponentEvent.SELECTION_CHANGE, listSelectionChange );				listEdit.list.addEventListener(Event.CHANGE, formChange);

				p.addComponent( listEdit );
				l.west = listEdit;
				p.addComponent( lv );
				l.south = lv;

				formPanel = new Panel();

				s = new Shape();
				s.graphics.beginFill( 0xff0000 );
				s.graphics.drawCircle(0, 0, 50 );
				s.graphics.endFill();

				s.x = 400;				s.y = 200;
				ToolKit.mainLevel.addChild( s );

				p.addComponent( formPanel );
				l.center = formPanel;

				ToolKit.mainLevel.addChild( p );
				StageUtils.lockToStage( p );

				simpleManager = new SimpleFormManager();
				simpleManager.addEventListener(Event.CHANGE, formChange );
			}
			catch( e : Error )
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}

		protected function formChange (event : Event) : void
		{
			s.filters = magicClone( listEdit.value );
		}

		protected function listSelectionChange (event : ComponentEvent) : void
		{
			if( formPanel.hasChildren )
				formPanel.removeAllComponents();

			var filter : BitmapFilter = listEdit.list.selectedValue as BitmapFilter;

			var fo : FormObject = FormUtils.createFormForPublicMembers( filter );

			fo.fields.sortOn("memberName");
			simpleManager.formObject = fo;

			var p : Component = FieldSetFormRenderer.instance.render( fo );

			formPanel.addComponent( p );
		}
	}
}

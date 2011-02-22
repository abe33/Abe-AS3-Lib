package abe.com.ponents.containers
{
	import abe.com.mon.geom.dm;
	import abe.com.patibility.lang._;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.layouts.components.BorderLayout;
	import abe.com.ponents.layouts.components.ComponentLayout;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.skinning.decorations.FieldSetBorders;
	import abe.com.ponents.text.Label;
	import abe.com.ponents.utils.Alignments;
	import abe.com.ponents.utils.CardinalPoints;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="FieldSet")]
	[Skin(define="FieldSet",
		  inherit="NoDecorationComponent",
		  preview="abe.com.ponents.containers::FieldSet.defaultFieldSetPreview",

		  state__all__borders="new cutils::Borders()",
		  state__all__foreground="new deco::FieldSetBorders( skin.borderColor )"
	)]
	[Skin(define="FieldSet_LabelPanel",
		  inherit="NoDecorationComponent",
		  preview="abe.com.ponents.containers::FieldSet.defaultFieldSetPreview",
		  previewAcceptStyleSetup="false",

		  state__all__insets="new cutils::Insets(15,0,15,0)"
	)]
	[Skin(define="FieldSet_InnerPanel",
		  inherit="NoDecorationComponent",
		  preview="abe.com.ponents.containers::FieldSet.defaultFieldSetPreview",
		  previewAcceptStyleSetup="false",

		  state__all__insets="new cutils::Insets(4)"
	)]
	[Skin(define="FieldSet_Label",
		  inherit="EmptyComponent",
		  preview="abe.com.ponents.containers::FieldSet.defaultFieldSetPreview",
		  previewAcceptStyleSetup="false",
		  state__all__insets="new cutils::Insets(2,0,2,0)"
	)]
	public class FieldSet extends Panel
	{
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		static public function defaultFieldSetPreview () : FieldSet
		{
			var f : FieldSet = new FieldSet(_("Sample Label"));

			f.preferredSize = dm(120,60);

			return f;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		static private const DEPENDENCIES : Array = [FieldSetBorders];

		protected var _label : Label;
		protected var _insidePanel : Panel;		protected var _labelPanel : Panel;

		public function FieldSet ( label : String = null )
		{
			_insidePanel = new Panel();			_labelPanel = new Panel();
			
			super();

			if( label )
			{
				var lab : Label = new Label( label );
				this.label = lab;
			}

			_insidePanel.styleKey = "FieldSet_InnerPanel";
			_insidePanel.allowMask = false;			_labelPanel.styleKey = "FieldSet_LabelPanel";
			_labelPanel.childrenLayout = new InlineLayout( _labelPanel, 0, Alignments.LEFT );
			
			var l : BorderLayout = new BorderLayout();			l.addComponent( _labelPanel, CardinalPoints.NORTH );
			l.addComponent( _insidePanel );
			_childrenLayout = l;
			
			super.addComponent( _labelPanel );
			super.addComponent( _insidePanel );
		}
		public function get insidePanel() : Panel { return _insidePanel; }
		override public function get childrenLayout () : ComponentLayout
		{
			return _insidePanel.childrenLayout;
		}
		override public function set childrenLayout (cl : ComponentLayout) : void
		{
			_insidePanel.childrenLayout = cl;
		}

		override public function get childrenCount () : int { return _insidePanel.childrenCount; }
		
		override public function addComponent (c : Component) : void
		{
			_insidePanel.addComponent(c);
			invalidatePreferredSizeCache();
		}
		override public function addComponentAfter (c : Component, after : Component) : void
		{
			_insidePanel.addComponentAfter( c, after );
			invalidatePreferredSizeCache();
		}
		override public function addComponentBefore (c : Component, before : Component) : void
		{
			_insidePanel.addComponentBefore( c, before );
			invalidatePreferredSizeCache();
		}
		override public function addComponents ( ... args ) : void
		{
			_insidePanel.addComponents.apply( null, args );
			invalidatePreferredSizeCache();
		}
		override public function addComponentAt (c : Component, id : uint) : void
		{
			_insidePanel.addComponentAt( c, id );
			invalidatePreferredSizeCache();
		}
		override public function removeComponent (c : Component) : void
		{
			_insidePanel.removeComponent( c );
			invalidatePreferredSizeCache();
		}
		override public function removeAllComponents () : void
		{
			_insidePanel.removeAllComponents();
			invalidatePreferredSizeCache();
		}
		public function get label () : Label { return _label; }
		public function set label ( label : Label ) : void
		{
			if( _label )
			{
				_labelPanel.removeComponent( _label );
			}

			_label = label;

			if( _label )
			{
				_label.forComponent = _insidePanel;
				_label.styleKey = "FieldSet_Label";
				_labelPanel.addComponent( _label );
			}
		}
	}
}

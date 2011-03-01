package abe.com.ponents.demos.dockables 
{
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.AbstractAction;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.buttons.ButtonGroup;
	import abe.com.ponents.buttons.CheckBox;
	import abe.com.ponents.buttons.RadioButton;
	import abe.com.ponents.buttons.ToggleButton;
	import abe.com.ponents.containers.FieldSet;
	import abe.com.ponents.containers.ScrollPane;
	import abe.com.ponents.containers.ScrollablePanel;
	import abe.com.ponents.factory.ComponentFactory;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.skinning.icons.magicIconBuild;
	import abe.com.ponents.utils.Insets;
	/**
	 * @author cedric
	 */
	public class ButtonDemoDockable extends DemoDockable 
	{
		public function ButtonDemoDockable ( id : String, label : String = null, icon : Icon = null)
		{
			super( id, null, label, icon );
		}
		override public function build (factory : ComponentFactory) : void
		{
			/*
			 * BUTTONS
			 */
			buildBatch( factory,
						Button, 
						4, 
						"buttonsDemoButton",
						[ // args
							[new AbstractAction( _("A button"), magicIconBuild("icons/control_play_blue.png") ) ],
							[new AbstractAction( _("Disabled button"), magicIconBuild("icons/control_play_blue.png") ) ],
							[new AbstractAction( _("Selected button"), magicIconBuild("icons/control_play_blue.png") ) ],
							[new AbstractAction( _("Disabled selected button"), magicIconBuild("icons/control_play_blue.png") ) ]
						],
						[ // kwargs
							{},
							{enabled:false},
							{selected:true},
							{selected:true,enabled:false}
						], // container
						FieldSet, 
						"buttonsDemoButtonFieldset", 
						[_("Simple Buttons")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "leftToRight" ) },
						null
			);
			/*
			 * TOGGLE BUTTONS
			 */
			buildBatch( factory,
						ToggleButton, 
						4, 
						"buttonsDemoToggleButton",
						[ // args
							[new AbstractAction( _("Toggle button"), magicIconBuild("icons/control_play_blue.png") ) ],
							[new AbstractAction( _("Disabled button"), magicIconBuild("icons/control_play_blue.png") ) ],
							[new AbstractAction( _("Selected button"), magicIconBuild("icons/control_play_blue.png") ) ],
							[new AbstractAction( _("Disabled selected button"), magicIconBuild("icons/control_play_blue.png") ) ]
						],
						[ // kwargs
							{},
							{enabled:false},
							{selected:true},
							{selected:true,enabled:false}
						], // container
						FieldSet, 
						"buttonsDemoToggleButtonFieldset", 
						[_("Toggle Buttons")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "leftToRight" ) },
						//{ 'childrenLayout':new FlowLayout(null, 3, 3, "left")},
						null );
			/*
			 * CHECKBOX
			 */
			buildBatch( factory,
						CheckBox, 
						4, 
						"buttonsDemoCheckBox",
						[ // args
							[new AbstractAction( _("CheckBox"), magicIconBuild("icons/accept.png") ) ],
							[new AbstractAction( _("Disabled checkbox"), magicIconBuild("icons/error.png") ) ],
							[new AbstractAction( _("Selected checkbox"), magicIconBuild("icons/exclamation.png") ) ],
							[new AbstractAction( _("Disabled selected checkbox") ) ]
						],
						[ // kwargs
							{},
							{enabled:false},
							{selected:true},
							{selected:true,enabled:false}
						], // container
						FieldSet, 
						"buttonsDemoCheckBoxFieldset", 
						[_("CheckBox")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "leftToRight" ) },
						//{ 'childrenLayout':new FlowLayout(null, 3, 3, "left")},
						null );
			/*
			 * RADIO
			 */
			factory.group("movables").build(ButtonGroup, "radioButtonGroup");
			buildBatch( factory,
						RadioButton, 
						4, 
						"buttonsDemoRadio",
						[ // args
							[new AbstractAction( _("Radio"), magicIconBuild("icons/accept.png") ) ],
							[new AbstractAction( _("Disabled radio"), magicIconBuild("icons/error.png") ) ],
							[new AbstractAction( _("Selected radio"), magicIconBuild("icons/exclamation.png") ) ],
							[new AbstractAction( _("Disabled selected radio") ) ]
						],
						[ // kwargs
							{},
							{enabled:false},
							{selected:true},
							{selected:true,enabled:false}
						], // container
						FieldSet, 
						"buttonsDemoRadioFieldset", 
						[_("Radio Buttons")], 
						{ 'childrenLayout':new InlineLayout(null, 3, "left", "center", "leftToRight" ) },
						//{ 'childrenLayout':new FlowLayout(null, 3, 3, "left")},
						function( f : FieldSet, ctx : Object, a : Array ) : void 
						{
							for(var i : * in a)
								( ctx["radioButtonGroup"] as ButtonGroup ).add(ctx[a[i]]);
						} );
			
			fillBatch( factory,
						ScrollablePanel, 
			   		   "buttonsDemoPanel",
			   		    null,
			   			{ 'childrenLayout':new InlineLayout(null, 3, "left", "top", "topToBottom", true ) },
			    		[
			    			"buttonsDemoButtonFieldset",
			    			"buttonsDemoToggleButtonFieldset",
			    		],			    		
			   			onBuildComplete );
		}
		protected function onBuildComplete ( p : ScrollPane, ctx : Object, objs : Array ) : void 
		{
			ctx["buttonsDemoPanel"].style.setForAllStates("insets", new Insets(4));
			_content = p;
		}
	}
}
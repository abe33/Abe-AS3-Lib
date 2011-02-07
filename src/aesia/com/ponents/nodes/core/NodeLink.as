package aesia.com.ponents.nodes.core 
{
	import aesia.com.mon.utils.StringUtils;
	import aesia.com.mon.utils.Reflection;
	import aesia.com.mon.core.Cloneable;
	import aesia.com.mon.core.Copyable;
	import aesia.com.mon.core.FormMetaProvider;
	import aesia.com.mon.utils.PointUtils;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.mon.utils.magicCopy;
	import aesia.com.ponents.actions.builtin.EditObjectPropertiesAction;
	import aesia.com.ponents.containers.Window;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.forms.FormObject;
	import aesia.com.ponents.forms.managers.SimpleFormManager;
	import aesia.com.ponents.history.UndoManagerInstance;
	import aesia.com.ponents.nodes.renderers.links.LinkRendererFactoryInstance;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * @author cedric
	 */
	public class NodeLink extends Sprite implements CanvasElement, Cloneable, Copyable, FormMetaProvider
	{
		[Form(type="String", 
			  label="Anchor",
			  category="Linkage", 
			  order="1", 
			  categoryOrder="1", 
			  enabled="false")]
		public var a : CanvasNode;
		
		[Form(type="String", 
			  label="Target",
			  category="Linkage", 
			  order="2", 
			  enabled="false")]
		
		[Form(type="String", 
			  label="Type", 
			  category="Relationship", 
			  order="1", 
			  categoryOrder="2", 
			  enumeration="aesia.com.ponents.nodes.renderers.links::LinkRendererFactoryInstance.keys")]
		
		[Form(type="String", 
			  label="Direction",
			  category="Relationship", 
			  order="2", 
			  enumeration="'ab','ba','none','both'")]
		public var relationshipDirection : String;
		
		public var anchorA : Point;
		public var tf : TextField;
		public var anchorTfA : TextField;
		public var anchorTfB : TextField;
				
		protected var _displayAnchorALabel : String;
		
		protected var _onStage : Boolean;
		
		protected var _allowEdit : Boolean;

		public function NodeLink (a : CanvasNode,
								  b : CanvasNode,
								  relationship : String = "undefined",
								  relationshipDirection : String = "none" ) 
		{
			doubleClickEnabled = true;
			
			this.a = a;
			this.b = b;
			this.relationship = relationship;
			this.relationshipDirection = relationshipDirection;
		
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		public function get isMovable () : Boolean { return false; }
		
		[Form(type="String", label="A label", category="Display", categoryOrder="2", order="1")]
		public function get displayAnchorALabel () : String { return _displayAnchorALabel; }
		public function set displayAnchorALabel (displayAnchorALabel : String) : void
		{
			if( displayAnchorALabel == "" )
				displayAnchorALabel = null;
				
			if( _displayAnchorALabel == displayAnchorALabel )
				return;
			
			_displayAnchorALabel = displayAnchorALabel;
			
			if( _onStage )
			{
				if( _displayAnchorALabel && !contains( anchorTfA ) )
					setupTextField( anchorTfA );
				else if( !_displayAnchorALabel )
					unsetTextField( anchorTfA );
			}
		}
		[Form(type="String", label="B label", category="Display", order="2")]
		public function get displayAnchorBLabel () : String { return _displayAnchorBLabel; }
		public function set displayAnchorBLabel (displayAnchorBLabel : String) : void
		{
			if( displayAnchorBLabel == "" )
				displayAnchorBLabel = null;
			
			if( _displayAnchorBLabel == displayAnchorBLabel )
				return;
				
			_displayAnchorBLabel = displayAnchorBLabel;
			
			if( _onStage )
			{
				if( _displayAnchorBLabel && !contains( anchorTfB ) )
					setupTextField( anchorTfB );
				else if( !_displayAnchorBLabel )
					unsetTextField( anchorTfB );
			}
		}
		[Form(type="String", label="Label", category="Display", order="0")]
		public function get displayLinkLabel () : String { return _displayLinkLabel; }
		public function set displayLinkLabel (displayLinkLabel : String) : void
		{
			if( displayLinkLabel == "" )
				displayLinkLabel = null;
			
			if( _displayLinkLabel == displayLinkLabel )
				return;
			
			_displayLinkLabel = displayLinkLabel;
			if( _onStage )
			{
				if( _displayLinkLabel && !contains( tf ) )
					setupTextField( tf );
				else if( !_displayLinkLabel )
					unsetTextField( tf );
			}
		}
		public function get allowEdit () : Boolean { return _allowEdit; }
		public function set allowEdit (allowEdit : Boolean) : void { _allowEdit = allowEdit; }

		protected function addedToStage (event : Event) : void 
		{
			_onStage = true;
			tf = new TextField();
			anchorTfA = new TextField();
			anchorTfB = new TextField();
			
			if( _displayLinkLabel )
				setupTextField( tf );
			
			if( _displayAnchorALabel )
			if( _displayAnchorBLabel )
				setupTextField( anchorTfB );
			
			a.addEventListener( ComponentEvent.POSITION_CHANGE, positionChange );
			addEventListener(MouseEvent.DOUBLE_CLICK, editProperties);
		}
		protected function removedFromStage (event : Event) : void 
		{
			_onStage = false;
			
			unsetTextField( tf );
			unsetTextField( anchorTfA );
			unsetTextField( anchorTfB );
			
			tf = null;
			
			a.removeEventListener( ComponentEvent.POSITION_CHANGE, positionChange );
			b.removeEventListener( ComponentEvent.POSITION_CHANGE, positionChange );
			removeEventListener(MouseEvent.DOUBLE_CLICK, editProperties );
		}
		protected function unsetTextField (tf : TextField) : void 
		{
			if( contains( tf ) )
				removeChild( tf );
		}
		protected function setupTextField (tf : TextField) : void 
		{
			tf.autoSize = "left";
			//tf.defaultTextFormat = SkinManagerInstance.getStyle("DefaultComponent").textFormat;
			tf.selectable = false;
			tf.multiline = true;
			tf.doubleClickEnabled = true;
			tf.defaultTextFormat = new TextFormat("Verdana", 10);
			tf.text = "txt";
			
			if( tf == this.tf )
			{
				tf.background= true;
				tf.backgroundColor = 0xffffff;
			}
			addChild( tf );
		}
		protected function positionChange (event : ComponentEvent) : void 
		{
			repaint();
		}
		protected function editProperties ( e : Event = null ) : void 
		{
			if( !_allowEdit )
				return;
			
			new EditObjectPropertiesAction( this, editPropertiesCallback, null, null, null, null, true ).execute();
		}
		protected function editPropertiesCallback ( o : Object, 
													form : FormObject, 
													manager : SimpleFormManager,
													window : Window ):void
		{
			//Log.debug( form + ", " + manager + ", " + window );
			//Log.debug( o + " : " + StringUtils.prettyPrint( o ) );
			//Log.debug( form.target + " : " + StringUtils.prettyPrint( form.target ) );
			//Log.debug( o == form.target );
			manager.save();
			
			UndoManagerInstance.add(new CopyUndoable( Reflection.asAnonymousObject( form.target, false ), 
													  Reflection.asAnonymousObject( this, false ), 
													  this ) );
			
			magicCopy( form.target, this );
			repaint();						
			
			window.close();
			StageUtils.stage.focus = null;
		}
		public function repaint () : void 
		{
			var a1 : Number = Math.atan2( a.y - b.y, a.x - b.x );
			
			anchorA = a.anchorGeometry.getPointAtAngle(a1+ Math.PI );
			anchorB = b.anchorGeometry.getPointAtAngle(a1);
			
			setTextFieldPosition( tf, anchorA, anchorB, "-" );
			
			LinkRendererFactoryInstance.getRenderer(this).render( this, anchorA, anchorB, graphics );
		}
		protected function setTextFieldPosition (tf : TextField, anchorA : Point, anchorB : Point, pos : String) : void 
		{
			if( tf && contains(tf) )
			{
				var invert: Boolean = ( anchorA.y < anchorB.y && anchorA.x > anchorB.x ) || ( anchorB.y < anchorA.y && anchorB.x > anchorA.x ) ;
				switch( pos )
				{
					case "a" :
						tf.text = _displayAnchorALabel;
						p.normalize(20);
						p = PointUtils.rotate(p, Math.PI/4 * ( invert ? -1 : 1 ) );
						tf.x = anchorA.x + p.x - tf.width/2;
						break;
					case "b" :
						tf.text = _displayAnchorBLabel;
						p = PointUtils.rotate(p, Math.PI/4 * ( invert ? -1 : 1 ) );
						p.normalize(20);
						tf.x = anchorB.x + p.x - tf.width/2;
						tf.y = anchorB.y + p.y - tf.height/2;
						break;
					case "-" : 
					default : 
						tf.text = _displayLinkLabel;
						p = anchorB.add( anchorA );
						p.normalize(p.length/2);
						tf.x = p.x - tf.width/2;
						break;
				}
			}
		}
		override public function toString () : String 
		{
			return StringUtils.stringify( this, { 'a':a, 'b':b } );
		}
		public function clone () : *
		{
			var n : NodeLink = new NodeLink( a, b, relationship, relationshipDirection);
			n.displayAnchorALabel = displayAnchorALabel;
			return n;
		}
		public function copyTo (o : Object) : void
		{
			safeGetAndSetProperty( this, o, "a" );
			safeGetAndSetProperty( this, o, "displayAnchorALabel" );
		public function copyFrom (o : Object) : void
		{
			safeGetAndSetProperty( o, this, "a" );
			safeGetAndSetProperty( o, this, "b" );
			safeGetAndSetProperty( o, this, "relationship" );
			safeGetAndSetProperty( o, this, "relationshipDirection" );
		}
	}
}

import aesia.com.mon.utils.magicCopy;
import aesia.com.patibility.lang._;
import aesia.com.ponents.history.AbstractUndoable;
import aesia.com.ponents.nodes.core.NodeLink;

internal function safeGetAndSetProperty( a : Object, b : Object, i : String ) : void
{
	if( a.hasOwnProperty( i ) && b.hasOwnProperty( i ) )
		b[ i ] = a[ i ];
}


internal class CopyUndoable extends AbstractUndoable
{
	protected var a : Object;
	protected var b : Object;
	protected var c : NodeLink;

	public function CopyUndoable ( a : Object, b : Object, c : NodeLink ) 
	{
		_label = _("Edit link");
		this.a = a;
	}
	override public function undo () : void 
	{
		magicCopy( b, c );
		c.repaint();
	}
	override public function redo () : void 
	{
		magicCopy( a, c );
		c.repaint();
		super.redo();
	}
}
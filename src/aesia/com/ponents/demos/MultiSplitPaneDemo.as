package aesia.com.ponents.demos 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.containers.MultiSplitPane;
	import aesia.com.ponents.dnd.DnDDragObjectRenderer;
	import aesia.com.ponents.dnd.DnDDropRenderer;
	import aesia.com.ponents.dnd.DnDManagerInstance;
	import aesia.com.ponents.layouts.components.splits.Leaf;
	import aesia.com.ponents.layouts.components.splits.Split;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	public class MultiSplitPaneDemo extends Sprite 
	{
		private var dragRenderer : DnDDragObjectRenderer;
		private var dropRenderer : DnDDropRenderer;
		
		public function MultiSplitPaneDemo ()
		{
			StageUtils.setup( this );
			ToolKit.initializeToolKit();
			
			KeyboardControllerInstance.eventProvider = stage;
			
			var msp1 : MultiSplitPane = createMSP(10,10);
			msp1.dragEnabled = false;
			msp1.allowResize = false;
			
			var msp2 : MultiSplitPane = createMSP(180,10);
			msp2.enabled = false;
			
			ToolKit.mainLevel.addChild( msp1 );			ToolKit.mainLevel.addChild( msp2 );
						ToolKit.mainLevel.addChild( createMSP(10,140, new Dimension( 300, 240) ) );
			
			dragRenderer = new DnDDragObjectRenderer( DnDManagerInstance );
			dropRenderer = new DnDDropRenderer( DnDManagerInstance );
		}

		private function createMSP ( x : Number, y : Number, size : Dimension = null ) : MultiSplitPane
		{
			var msp : MultiSplitPane = new MultiSplitPane();
			
			var bt1 : DnDButton = new DnDButton();
			var bt2 : DnDButton = new DnDButton();
			var bt3 : DnDButton = new DnDButton();
			var bt4 : DnDButton = new DnDButton();
			var bt5 : DnDButton = new DnDButton();
			var bt6 : DnDButton = new DnDButton();
			
			var model : Split = new Split(false);
			var col : Split = new Split(false);
			var row : Split = new Split();
			
			msp.multiSplitLayout.modelRoot = model;
			
			msp.multiSplitLayout.addSplitChild(col, new Leaf(bt1));
			msp.multiSplitLayout.addSplitChild(col, new Leaf(bt2));
			msp.multiSplitLayout.addSplitChild(col, new Leaf(bt3));
			
			msp.multiSplitLayout.addSplitChild(row, new Leaf(bt4));
			msp.multiSplitLayout.addSplitChild(row, col);
			msp.multiSplitLayout.addSplitChild(row, new Leaf(bt5));
			
			msp.multiSplitLayout.addSplitChild(model, row);
			msp.multiSplitLayout.addSplitChild(model, new Leaf(bt6));
			
			msp.addComponent( bt1 );
			msp.addComponent( bt2 );
			msp.addComponent( bt3 );
			msp.addComponent( bt4 );
			msp.addComponent( bt5 );
			msp.addComponent( bt6 );
			
			msp.x = x;
			msp.y = y;
			
			if( size )
				msp.size = size;
			
			return msp;
		}
	}
}

import aesia.com.ponents.buttons.DraggableButton;
import aesia.com.ponents.transfer.ComponentTransferable;
import aesia.com.ponents.transfer.Transferable;

internal class DnDButton extends DraggableButton
{
	override public function get transferData () : Transferable
	{
		return new ComponentTransferable( this );
	}
}

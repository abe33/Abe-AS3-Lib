package abe.com.ponents.dnd 
{
    import abe.com.mon.utils.StageUtils;
    import abe.com.motion.SingleTween;
    import abe.com.ponents.core.*;
    import abe.com.ponents.layouts.components.*;
    import abe.com.ponents.transfer.*;
    import abe.com.ponents.utils.ToolKit;

    import flash.display.Shape;
    import flash.geom.Rectangle;
    /**
     * @author Cédric Néhémie
     */
    public class DnDDropRenderer 
    {
        protected var _shape : Shape;
        protected var _manager : DnDManager;
        
        protected var _currentTargets : Array;
        protected var _currentAcceptedTarget : DropTarget;
        
        protected var tween : SingleTween;
        
        protected var _drawnShapes : Array;
        
        public function DnDDropRenderer ( manager : DnDManager )
        {
            manager.dropTargetsChanged.add( dropTargetsChanged );        
            manager.dragAccepted.add( dragAccepted );        
            manager.dragStarted.add( dragStarted );        
            manager.dragExited.add( dragExited );        
            manager.dragStopped.add( dragStopped );        
            manager.dragged.add( drag );
            manager.dropped.add( drop );
            
            _manager = manager;
            _shape = new Shape();
            _shape.alpha = .5;
            tween = new SingleTween( _shape, "alpha", .5, 250, 0 );
        }
        
        protected function tweenEnd ( t : SingleTween ) : void
        {
            tween.commandEnded.remove( tweenEnd );
            tween.reversed = false;
            ToolKit.dndLevel.removeChild( _shape );
        }
        protected function drop ( manager : DnDManager, transferable : Transferable, source : DragSource, target : DropTarget ) : void {}
        
        protected function drag ( manager : DnDManager, transferable : Transferable, source : DragSource, target : DropTarget ) : void {}
        
        protected function dragStopped ( manager : DnDManager, transferable : Transferable, source : DragSource, target : DropTarget ) : void
        {
            tween.reversed = true;
            tween.commandEnded.add( tweenEnd );
            tween.execute();
            //_shape.graphics.clear();
            //ToolKit.dndLevel.removeChild( _shape );
        }
        
        protected function dragStarted ( manager : DnDManager, transferable : Transferable, source : DragSource ) : void
        {
            ToolKit.dndLevel.addChildAt( _shape, 0 );
            tween.execute(); 
        }

        protected function dragExited ( manager : DnDManager, transferable : Transferable, source : DragSource, target : DropTarget ) : void
        {
            _currentAcceptedTarget = null;
            drawDropTargets();
        }

        protected function dragAccepted ( manager : DnDManager, transferable : Transferable, source : DragSource, target : DropTarget ) : void
        {
            _currentAcceptedTarget = target;
            drawDropTargets();
        }

        protected function dropTargetsChanged ( manager : DnDManager, transferable : Transferable, source : DragSource ) : void
        {            
            if( _currentTargets )
                unregisterFromTargetsEvent( _currentTargets );
            
            
            _currentTargets = DnDManagerInstance.allowedDropTargets.concat();
            
            if( _currentTargets )
                registerToTargetsEvent( _currentTargets );
            
            drawDropTargets ();
            
        }
        
        protected function dropTargetsRepainted ( c : Component ) : void
        {
            drawDropTargets();
        }
        
        protected function registerToTargetsEvent (currentTargets : Array) : void
        {
            for each( var v : * in currentTargets )
                if( v is Component )
                {
                    var c : Component = v as Component;
                    c.componentRepainted.add( dropTargetsRepainted );
                }
                else if( v is ComponentLayout ) 
                {
                    var l : ComponentLayout = v as ComponentLayout;
                    l.container.componentRepainted.add( dropTargetsRepainted );
                }
        }

        protected function unregisterFromTargetsEvent (currentTargets : Array) : void
        {
            for each( var v : * in currentTargets )
               if( v is Component )
                {
                    var c : Component = v as Component;
                    c.componentRepainted.remove( dropTargetsRepainted );
                }
                else if( v is ComponentLayout ) 
                {
                    var l : ComponentLayout = v as ComponentLayout;
                    l.container.componentRepainted.remove( dropTargetsRepainted );
                }
        }
        protected function hasAnAncestorInDropTargets ( o : DropTarget, targets : Array ) : Boolean
        {
            for each( var dt : DropTarget in targets )
            {
                if( lookupAncestors(o, dt) )
                    return true;
            }
            return false;
        }
        protected function lookupAncestors( a : DropTarget, b : DropTarget ) : Boolean
        {
            return a && b && a != b && ( b.component is Container ) && (b.component as Container).isDescendant( a.component );
        }
         
        protected function drawDropTargets () : void
        {
            _drawnShapes = [];
            
            _shape.graphics.clear();
            _shape.graphics.beginFill( 0 );
            _shape.graphics.drawRect(0, 0, StageUtils.stage.stageWidth, StageUtils.stage.stageHeight );
            //_shape.graphics.endFill();
            
            var bb : Rectangle; 
            var o : DropTarget;
            //_shape.graphics.endFill();
            for each ( o in _currentTargets )
            {
                if( hasAnAncestorInDropTargets( o, _currentTargets ) )
                    continue;
                
                bb = DnDManagerInstance.getScreenVisibleArea( o );
                
                var a: Array = checkDropShape( bb, _drawnShapes );
                
                _shape.graphics.drawRect(bb.x, bb.y, bb.width, bb.height );
                _drawnShapes.push(bb);
                if( a.length > 0 )
                {
                    for( var i:uint=0;i< a.length;i++)
                    {
                        var r : Rectangle =a[i];
                        _shape.graphics.drawRect(r.x, r.y, r.width, r.height );
                    }
                }
            }
            _shape.graphics.endFill();
            
            for each ( o in _currentTargets )
            {
                bb = DnDManagerInstance.getScreenVisibleArea( o );
                if( o !== _currentAcceptedTarget )
                {
                    if( hasAnAncestorInDropTargets( _currentAcceptedTarget, _currentTargets ) )
                        continue;
                    
                    _shape.graphics.beginFill( 0, .25 );
                    _shape.graphics.drawRect(bb.x, bb.y, bb.width, bb.height );
                    _shape.graphics.endFill();
                }
            }
            /*
            if( _currentAcceptedTarget )
            {
                bb = DnDManagerInstance.getScreenVisibleArea( _currentAcceptedTarget );
                        
                _shape.graphics.beginFill( Color.YellowGreen.hexa );
                _shape.graphics.drawRect(bb.x, bb.y, bb.width, bb.height );
                _shape.graphics.endFill();
            }*/
        }
        protected function checkDropShape (bb : Rectangle, drawnShapes : Array) : Array 
        {
            var a : Array = [];
            for each( var r : Rectangle in drawnShapes )
                if( r.intersects( bb ) )
                    a.push(r.intersection( bb ));
                    
            return a;
        }
    }
}

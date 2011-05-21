/**
 * @license
 */
package  abe.com.ponents.dnd 
{
    import abe.com.mon.utils.StageUtils;
    import abe.com.ponents.transfer.DataFlavor;
    import abe.com.ponents.transfer.Transferable;
    import abe.com.ponents.utils.ToolKit;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.InteractiveObject;
    import flash.events.Event;
    import flash.geom.Rectangle;
    
    import org.osflash.signals.Signal;

    public class DnDManager
    {        
        FEATURES::DND { 
        
            public var dragged : Signal;
            public var dragEntered : Signal;
            public var dragExited : Signal;
            public var dragAborted : Signal;
            public var dragAccepted : Signal;
            public var dragRejected : Signal;
            public var dragStarted : Signal;
            public var dragStopped : Signal;
            public var dropped : Signal;
            public var dropTargetsChanged : Signal;
        
            protected var _dropTargets : Array;
            protected var _dragging : Boolean;
            
            protected var _allowedDropTargets : Array;
            protected var _allowedDropTargetsScreenVisibleArea : Array;
            
            public function DnDManager () 
            {
                dragged = new Signal();
                dragEntered = new Signal();
                dragExited = new Signal();
                dragAborted = new Signal();
                dragAccepted = new Signal();
                dragRejected = new Signal();
                dragStarted = new Signal();
                dragStopped = new Signal();
                dropped = new Signal();
                dropTargetsChanged = new Signal();
            
                _dropTargets = [];
            }
            public function get dragging () : Boolean { return _dragging; }
            public function get dropTargets () : Array { return _dropTargets; }        
            public function get allowedDropTargets () : Array { return _allowedDropTargets; }
            public function get allowedDropTargetsScreenVisibleArea () : Array { return _allowedDropTargetsScreenVisibleArea; }
            
            public function getScreenVisibleArea ( t : DropTarget ) : Rectangle
            {
                if( _allowedDropTargets.indexOf( t ) != -1 )
                    return _allowedDropTargetsScreenVisibleArea[ _allowedDropTargets.indexOf( t ) ];
                else
                    return null;
            }

            /*-------------------------------------------------------------------
             * DROP TARGETS HANDLERS
             *------------------------------------------------------------------*/
            
            public function registerDropTarget ( target : DropTarget ) : void
            {
                if( !isRegistered( target ) )
                    _dropTargets.push( target );
            }

            public function unregisterDropTarget ( target : DropTarget ) : void
            {
                if( isRegistered( target ) )
                    _dropTargets.splice( _dropTargets.indexOf( target ), 1 );
            }
            public function isRegistered (  target : DropTarget  ) : Boolean
            {
                return _dropTargets.indexOf( target ) != -1;
            }

            
            /*-------------------------------------------------------------------
             * DRAG AND DROP HANDLERS
             *------------------------------------------------------------------*/
            private var currentTransferable : Transferable;
            private var currentDragSource : DragSource;
            private var currentDropTarget : DropTarget;
            private var currentTargetUnderTheMouse : DropTarget;
            
            public function enterFrame ( e : Event ) : void
            {
                var l : Number = _allowedDropTargets.length;
                /*
                 * On boucle sur toutes les cibles pour savoir si 
                 * l'une d'elle est sous la souris
                 */
                dragged.dispatch( this,
                                  currentTransferable,
                                  currentDragSource, 
                                  currentTargetUnderTheMouse );
                while( l-- )
                {
                    var target : DropTarget = _allowedDropTargets[ l ] as DropTarget;
                    var r : Rectangle = _allowedDropTargetsScreenVisibleArea[ l ];
                    
                    // On a un contact avec une cible
                    if( /*target.dropGeometry.parent &&
                        target.dropGeometry.hitTestPoint( StageUtils.stage.mouseX , 
                                                          StageUtils.stage.mouseY )*/
                        r.contains( StageUtils.stage.mouseX , StageUtils.stage.mouseY) )
                    {
                        // qui est différente de celle sous la souris
                        if( target != currentTargetUnderTheMouse )
                        {
                            if( currentTargetUnderTheMouse )
                                currentTargetUnderTheMouse.dragExit ( this, currentTransferable, currentDragSource );
                                
                            currentTargetUnderTheMouse = target;
                            
                            currentTargetUnderTheMouse.dragEnter( this, currentTransferable, currentDragSource );
                            
                            dragEntered.dispatch( this, 
                                                  currentTransferable, 
                                                  currentDragSource, 
                                                  currentTargetUnderTheMouse );
                        }
                        // c'est la même, on ne fait que se déplacer dessus
                        else
                        {
                            if( currentDropTarget )
                                currentDropTarget.dragOver( this, currentTransferable, currentDragSource );
                        }
                        return;
                    }
                }
                /*
                 * On n'a aucune cible sous la souris, mais une enregistrée
                 * précédemment, on vient donc de sortir
                 */
                if( currentTargetUnderTheMouse )
                {
                    currentTargetUnderTheMouse.dragExit( this, currentTransferable, currentDragSource );
                    dragExited.dispatch( this, 
                                         currentTransferable,
                                         currentDragSource, 
                                         currentTargetUnderTheMouse );
                                    
                    currentTargetUnderTheMouse = null;
                    currentDropTarget = null;
                }
            }
            public function refreshDropTargets () : void
            {
                var flavors : Array = currentTransferable.flavors;
                var a : Array = _dropTargets;
                
                var filter : Function = function(dt:DropTarget, ... args ) : Boolean 
                {    
                    var f : Array = dt.supportedFlavors;
                    var some : Function = function(flavor:DataFlavor, ... args ) : Boolean 
                    {    
                        return flavor.isSupported( flavors ); 
                    };
                    return dt.component.displayed && f.some( some ); 
                };
                
                _allowedDropTargets = a.filter( filter );            
                _allowedDropTargets.sort( targetSort );
                _allowedDropTargetsScreenVisibleArea = _allowedDropTargets.map( function (item : DropTarget, ...args ) : * {
                     return item.component.screenVisibleArea;
                } );
                
                dropTargetsChanged.dispatch( this, 
                                             currentTransferable, 
                                             currentDragSource );
            }
            protected function targetSort( a : DropTarget, b : DropTarget ) :int
            {
                var doa : DisplayObject = a.component as DisplayObject;
                var dob : DisplayObject = b.component as DisplayObject;
                
                var aIsPopup : Boolean = StageUtils.isDescendant( doa, ToolKit.popupLevel );
                var bIsPopup : Boolean = StageUtils.isDescendant( dob, ToolKit.popupLevel );
                
                if( doa is DisplayObjectContainer && StageUtils.isDescendant( dob, doa as DisplayObjectContainer ) )
                    return -1;
                else if( dob is DisplayObjectContainer && StageUtils.isDescendant( doa, dob as DisplayObjectContainer ) )
                    return 1;        
                else if( aIsPopup && bIsPopup )
                    return 0;
                else if( aIsPopup )
                    return 1;
                else if( bIsPopup )
                    return -1;
                else
                    return 0;
            }
            public function startDrag ( source : DragSource, transferable : Transferable ) : void
            {
                _dragging = true;
                currentDragSource = source;
                currentTransferable = transferable;
                
                refreshDropTargets();
                
                dragStarted.dispatch( this, 
                                      currentTransferable, 
                                      currentDragSource );
                                            
                (currentDragSource as DisplayObject).addEventListener( Event.ENTER_FRAME, enterFrame);
            }

            public function drop() : void
            {
                if( currentDropTarget )
                {
                    currentDropTarget.drop( this, currentTransferable );
                    StageUtils.stage.focus = currentDropTarget as InteractiveObject;
                    dropped.dispatch( this, 
                                      currentTransferable, 
                                      currentDragSource, 
                                      currentDropTarget );
                }
                else
                {
                    dragAborted.dispatch( this,
                                          currentTransferable,
                                          currentDragSource );
                }
                
                stopDrag();
            }

            public function stopDrag () : void
            {
                _dragging = false;
                dragStopped.dispatch( this, 
                                      currentTransferable, 
                                      currentDragSource, 
                                      currentDropTarget );
                
                (currentDragSource as DisplayObject).removeEventListener( Event.ENTER_FRAME, enterFrame );
                currentDragSource = null;
                currentTransferable = null;
                currentDropTarget = null;
                currentTargetUnderTheMouse = null;
            }    

            public function acceptDrag ( target : DropTarget ) : void
            {
                currentDropTarget = target;
                dragAccepted.dispatch( this, 
                                       currentTransferable, 
                                       currentDragSource,
                                       currentDropTarget );
            }

            public function rejectDrag ( target : DropTarget ) : void
            {
                currentDropTarget = null;
                dragRejected.dispatch( this, 
                                       currentTransferable, 
                                       currentDragSource,
                                       target );
            }
        } 
    }
}

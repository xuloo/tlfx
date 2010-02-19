package flashx.textLayout.edit
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import flashx.textLayout.edit.helpers.ListItemElementEnterHelper;
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.elements.ListItemElement;
	import flashx.undo.IUndoManager;
	
	public class ExtendedEditManager extends EditManager
	{
		public function ExtendedEditManager(undoManager:IUndoManager=null)
		{
			super(undoManager);
		}
		
		override public function keyDownHandler(event:KeyboardEvent) : void
		{
			var startElement:FlowLeafElement = this.textFlow.findLeaf( this.absoluteStart );
			var endElement:FlowLeafElement = this.textFlow.findLeaf( this.absoluteEnd );
			
			switch ( event.keyCode )
			{
				case Keyboard.TAB:
					this.insertText( '\t' );
					break;
				case Keyboard.ENTER:
					if ( this.hasSelection() )
					{
						switch ( ExtendedEditManager.getClass( startElement ) )
						{
							case ListItemElement:
								trace('list item element');
								ListItemElementEnterHelper.processReturnKey( this, startElement as ListItemElement );
								break;
							default:
								trace('default');
								this.insertText( '\n' );
								break;
						}
					}
					break;
				case Keyboard.BACKSPACE:
					if ( this.hasSelection() )
					{
						var previousElement:FlowLeafElement = this.textFlow.findLeaf( startElement.getElementRelativeStart( this.textFlow ) - 1 );
						
						if ( (startElement is ListItemElement) || (endElement is ListItemElement) )
						{
							ListItemElementEnterHelper.processDeleteKey( this, startElement, endElement );
						}
						else if ( previousElement is ListItemElement )
						{
							var previousItem:ListItemElement = previousElement as ListItemElement;
							var selectionState:SelectionState = new SelectionState( this.textFlow, this.absoluteStart, this.absoluteEnd, this.textFlow.format );
							
							if ( this.isRangeSelection() )
							{
								this.deleteText( selectionState );
								this.selectRange( this.absoluteStart-2, this.absoluteStart-2 );
							}
							else
							{
								previousItem.text = previousItem.rawText.substr( 0, previousItem.rawText.length-2 );
								var selectionPos:int = previousItem.getElementRelativeStart( this.textFlow ) + previousItem.text.length - 2;
								this.selectRange( selectionPos, selectionPos );
							}
							this.textFlow.flowComposer.updateAllControllers();
						}
						else
						{
							super.keyDownHandler( event );
						}
					}
					break;
				default:
					if ( startElement is ListItemElement )
					{
						//	Insert text being entered into position it's being entered
						var startItem:ListItemElement = startElement as ListItemElement;
						
						
					}
					super.keyDownHandler( event );
					break;
			}
		}
		
		private static function getClass(obj:Object):Class
		{
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
	}
}
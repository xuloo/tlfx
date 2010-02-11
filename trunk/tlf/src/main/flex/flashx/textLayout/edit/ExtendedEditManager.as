package flashx.textLayout.edit
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.elements.ListElement;
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
			switch ( event.keyCode )
			{
				case Keyboard.TAB:
					this.insertText( '\t' );
					break;
				case Keyboard.ENTER:
					if ( this.hasSelection() )
					{
						var startElement:FlowLeafElement = this.textFlow.findLeaf( this.absoluteStart );
						var endElement:FlowLeafElement = this.textFlow.findLeaf( this.absoluteEnd );
						
						if ( startElement is ListItemElement )
						{
							trace('list item element');
							if ( startElement.parent )
							{
								trace('parent exists');
								var listElem:ListElement = startElement.parent as ListElement;
								if ( listElem )
								{
									var childPos:uint = listElem.getChildIndex( startElement );
									
									/* Need to get the position of the start of the selection in the ListItemElement
									and then copy all the text in the selection into the new ListItemElement that I need to add right afterwards. */
									
									var startElementStart:int = startElement.getElementRelativeStart( this.textFlow );
									var endElementStart:int = endElement.getElementRelativeStart( this.textFlow );
									var relativeStart_Start:int = this.absoluteStart - startElementStart;
									var relativeStart_End:int = this.absoluteEnd - endElementStart;
									
									var strToPass:String = '';
									
									var newElement:ListItemElement = new ListItemElement();
									
									if ( this.absoluteStart == this.absoluteEnd )
									{
										//	Adjust the relative start position to not include the extraneous text
										relativeStart_Start -= ( startElement as ListItemElement ).mode == ListElement.BULLETED ? 3 : 4;
										relativeStart_End -= ( startElement as ListItemElement ).mode == ListElement.BULLETED ? 3 : 4;
										
										//	Nothing actually selected
										//	Get text from relative start to element to end of element's raw text & use it to set the text of the new element
										var startingText:String = ( startElement as ListItemElement ).rawText;
										
										strToPass = startingText.substring( relativeStart_Start, startingText.length );
										( startElement as ListItemElement ).text = startingText.substring( 0, relativeStart_Start );
										
										newElement.text = strToPass;
										
										( endElement as ListItemElement ).text = ( endElement as ListItemElement ).rawText.substring( 0, relativeStart_End );
									}
									else
									{
										
									}
									
									//	Last child
									if ( childPos == listElem.numChildren-1 )
									{
										trace('last child');
										listElem.addChild( newElement );
									}
									else
									{
										trace('not last child');
										listElem.addChildAt( childPos+1, newElement );
									}
									
									this.setSelectionState( new SelectionState( this.textFlow, this.absoluteEnd + newElement.text.length, this.absoluteEnd + newElement.text.length, this.textFlow.format ) );
									
									this.updateAllControllers();
								}
							}
						}
						else
						{
							this.insertText( '\n' );
						}
					}
					break;
				default:
					super.keyDownHandler( event );
					break;
			}
		}
	}
}
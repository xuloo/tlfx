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
							if ( startElement.parent )
							{
								var listElem:ListElement = startElement.parent as ListElement;
								if ( listElem )
								{
									var childPos:int = listElem.getChildIndex( startElement );
									
									var startElementStart:int = startElement.getElementRelativeStart( this.textFlow );
									var endElementStart:int = endElement.getElementRelativeStart( this.textFlow );
									var relativeStart_Start:int = this.absoluteStart - startElementStart;
									var relativeStart_End:int = this.absoluteEnd - endElementStart;
									
									//	Adjust the relative start position to not include the extraneous text
									relativeStart_Start -= ( startElement as ListItemElement ).mode == ListElement.BULLETED ? 3 : 4;
									relativeStart_End -= ( startElement as ListItemElement ).mode == ListElement.BULLETED ? 3 : 4;
									
									var strToPass:String = '';
									
									var newElement:ListItemElement = new ListItemElement();
									
									var startingText:String = ( startElement as ListItemElement ).rawText;
									var endingText:String = ( endElement as ListItemElement ).rawText;
									
									if ( this.absoluteStart == this.absoluteEnd )
									{
										//	Nothing actually selected
										//	Get text from relative start to element to end of element's raw text & use it to set the text of the new element
										
										strToPass = startingText.substring( relativeStart_Start, startingText.length );
										( startElement as ListItemElement ).text = startingText.substring( 0, relativeStart_Start-1 );
										
										this.setSelectionState( new SelectionState( this.textFlow, this.absoluteEnd + strToPass.length, this.absoluteEnd + strToPass.length, this.textFlow.format ) );
									}
									else
									{
										if ( startElement != endElement )
										{
											//	Range selection:  Delete selected text by adjusting beginning accordingly, delete any items between the two selected items, and use remaining text for new element
											( startElement as ListItemElement ).text = startingText.substring( 0, relativeStart_Start-1 );
											
											var endPos:int = listElem.getChildIndex( endElement );
											var numToDelete:int = endPos - childPos;
											var totalTextOffset:int = 0;
											while ( numToDelete-- > 0 )
											{
												var li:ListItemElement = listElem.getChildAt( childPos + numToDelete ) as ListItemElement;
												totalTextOffset += li.text.length;
												listElem.removeChild( li );
											}
											
											( endElement as ListItemElement ).text = startingText.substring( 0, relativeStart_Start-1 );
											
											strToPass = endingText.substring( relativeStart_End, endingText.length );
											
											this.setSelectionState( new SelectionState( this.textFlow, this.absoluteEnd + strToPass.length - totalTextOffset + 1, this.absoluteEnd + strToPass.length - totalTextOffset + 1, this.textFlow.format ) );
										}
										else
										{
											//	Range selection:  Delete selected text and pass remaining text to new element
											( startElement as ListItemElement ).text = startingText.substring( 0, relativeStart_Start );
											
											strToPass = endingText.substring( relativeStart_End, endingText.length );
										}
									}
									
									newElement.text = strToPass;
									
									//	Last child
									if ( childPos == listElem.numChildren-1 )
										listElem.addChild( newElement );
									else
										listElem.addChildAt( childPos+1, newElement );
									
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
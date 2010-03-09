package flashx.textLayout.edit.helpers
{
	import flashx.textLayout.edit.ExtendedEditManager;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.elements.ListElement;
	import flashx.textLayout.elements.ListItemElement;
	import flashx.textLayout.elements.SpanElement;
	
	public class ListItemElementEnterHelper
	{
		public function ListItemElementEnterHelper()
		{
			//
		}
		
		private static function deleteItems( from:ListElement, startingAt:uint, number:uint ):void
		{
			var i:int = number;
			while( i > 0 )
			{
				from.removeChildAt( startingAt + i );
				i--;
			}
		}
		
		public static function processDeleteKey( extendedEditManager:ExtendedEditManager, startElement:FlowLeafElement, endElement:FlowLeafElement ):void
		{
			var list:ListElement;
			var startIndex:int = extendedEditManager.textFlow.getChildIndex( startElement );
			var endIndex:int = extendedEditManager.textFlow.getChildIndex( endElement );
			var startPos:int = startElement.getElementRelativeStart( extendedEditManager.textFlow );
			var endPos:int = endElement.getElementRelativeStart( extendedEditManager.textFlow );
			
			var startIndexRelative:int;
			var endIndexRelative:int;
			
			var startPosRelative:int;
			var endPosRelative:int;
			
			var startItem:ListItemElement;
			var endItem:ListItemElement;
			
			var startText:String;
			var endText:String;
			
			var newSelectionState:SelectionState;
			
			//	Delete up to the absolute start position
			if ( startElement is ListItemElement )
			{
				var endSelectedText:String;
				startItem = startElement as ListItemElement;
				list = startItem.parent as ListElement;
				startIndexRelative = list.getChildIndex( startItem );
				startPosRelative = startItem.getElementRelativeStart( list );
				if ( endElement is ListItemElement )
				{
					endItem = endElement as ListItemElement;
					endIndexRelative = list.getChildIndex( endItem );
					endPosRelative = endItem.getElementRelativeStart( list );
					
					endSelectedText = endItem.text.substr(0, extendedEditManager.absoluteEnd - endPos);
					
					//	create new selection state & use the edit manager to delete the text, as it creates far less hassle
					newSelectionState = new SelectionState( extendedEditManager.textFlow, extendedEditManager.absoluteStart, endPos + endSelectedText.length, extendedEditManager.textFlow.format );
					extendedEditManager.deleteText( newSelectionState );
					
					//	force an update to fix the #'s
					list.update();
				}
				else
				{
					endSelectedText = endElement.text.substr(0, extendedEditManager.absoluteEnd - endPos);	//	correct
					
					var offset:int = list.mode == ListElement.BULLETED ? 4 : 5;
					var newStartText:String = startItem.rawText.substr(0, extendedEditManager.absoluteStart-startPos-offset);	//	works
					startItem.text = newStartText;
					
					
					
					newSelectionState = new SelectionState( extendedEditManager.textFlow, extendedEditManager.absoluteStart, endPos + endSelectedText.length - 1, extendedEditManager.textFlow.format );
					extendedEditManager.deleteText( newSelectionState );
					
					list.update();
				}
			}
			//	Delete down to the position previous the beginning of the list item,
			//	Delete all list items between 
			else if ( endElement is ListItemElement )
			{
				//	Impossible that they're both ListItemElements
				//	Delete everything before
				//	Normal delete for ListItemElements
			}
			else
			{
				trace('Why was this called? That doesn\'t make any sense!');
			}
		}
		
		public static function processReturnKey( extendedEditManager:ExtendedEditManager, startItem:ListItemElement ):void
		{
			var endElem:FlowElement = extendedEditManager.textFlow.findLeaf( extendedEditManager.absoluteEnd );
			var endItem:ListItemElement = endElem is ListItemElement ? endElem as ListItemElement : null;
			
			if ( startItem.parent )
			{
				var list:ListElement = startItem.parent as ListElement;
				
				var startTextPosition:uint = startItem.getElementRelativeStart( extendedEditManager.textFlow );
				//	End position based on either the ListItem or FlowLeafElement representation of the item at the end of the selection
				var endTextPosition:uint =	endItem ?
					endItem.getElementRelativeStart( extendedEditManager.textFlow )
					:
					endElem.getElementRelativeStart( extendedEditManager.textFlow );
				
				var startRel:uint = extendedEditManager.absoluteStart - startTextPosition;	//	absolute start minus item's start provides offset
				var endRel:uint = extendedEditManager.absoluteEnd - endTextPosition;		//	absolute end minus item's end
				
				var adjustOffset:uint = startItem.mode == ListElement.BULLETED ? 3 : 4;
				
				startRel -= adjustOffset;
				endRel -= adjustOffset;
				
				var newStr:String = '';
				
				var startText:String = startItem.rawText;
				var endText:String = new String();
				
				if ( endItem )
				{
					endText = endItem.rawText;
				}
				else
				{
					if ( endElem is SpanElement )
					{
						endText = ( endElem as SpanElement ).text
					}
					else if ( endElem is LinkElement )
					{
						endText = ( endElem as LinkElement ).href;
					}
					
					//	can't do ParagraphElements or DivElements as they have no text
				}
				
				var startPos:int = list.getChildIndex( startItem );
				var endPos:int = list.getChildIndex( endItem ? endItem : endElem );
				
				var newElement:ListItemElement = new ListItemElement();
				
				//	At least 1 whole character is selected (i.e. end of selection != start of selection)
				if ( extendedEditManager.isRangeSelection() )
				{
					//	Multiple lines
					if ( startItem != endElem )
					{
						var numToDelete:int;
						//	All ListItemElements
						if ( endItem )
						{
							startItem.text = startText.substring( 0, startRel-1 );
							
							ListItemElementEnterHelper.deleteItems( list, startPos, (endPos - startPos) );
							
							endItem.text = startText.substring( 0, startRel-1 );
							
							newStr = endText.substring( endRel, endText.length );
						}
						//	Multiple types
						else
						{
							//	Reset the text for the items beyond the list elements
							var newSelectionState:SelectionState = new SelectionState( extendedEditManager.textFlow, extendedEditManager.absoluteStart, extendedEditManager.absoluteEnd, extendedEditManager.textFlow.format);
							extendedEditManager.deleteText( newSelectionState );
							
							//	Reset the starting element's text
							startItem.text = startText.substring( 0, startRel-1 );
						}
					}
					//	Single line
					else
					{
						startItem.text = startText.substring( 0, startRel );
						
						newStr = endText.substring( endRel, endText.length );
					}
				}
				//	No selection
				else
				{
					var currChar:String = extendedEditManager.textFlow.getText( extendedEditManager.absoluteStart, extendedEditManager.absoluteEnd + 1 );
					var prevChar:String = extendedEditManager.textFlow.getText( extendedEditManager.absoluteStart - 1, extendedEditManager.absoluteEnd );
					
					if ( currChar == ' ' )
						newStr = startText.substring( startRel, startText.length );
					else
					{
						if ( prevChar == ' ' )
							newStr = startText.substring( startRel, startText.length );
						else
							newStr = startText.substring( startRel - 1, startText.length );
					}
					
					startItem.text = startText.substring( 0, startRel );
				}
				
				newElement.text = newStr;
				
				//	Last child
				if ( startPos == list.numChildren-1 )
				{
					list.addChild( newElement );
				}
				else
				{
					list.addChildAt( startPos+1, newElement );
				}
				
				extendedEditManager.notifyInsertOrDelete( extendedEditManager.absoluteStart, extendedEditManager.absoluteEnd-extendedEditManager.absoluteStart );
				
				var newAnchorPosition:int = newElement.getElementRelativeStart( extendedEditManager.textFlow ) + newElement.text.length - 1;
				extendedEditManager.setSelectionState( new SelectionState( extendedEditManager.textFlow, newAnchorPosition, newAnchorPosition, extendedEditManager.textFlow.format ) );
				
				extendedEditManager.textFlow.flowComposer.updateAllControllers();
			}
		}
	}
}
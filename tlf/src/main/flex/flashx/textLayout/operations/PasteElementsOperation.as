package flashx.textLayout.operations
{
	import flashx.textLayout.container.AutosizableContainerController;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.edit.ParaEdit;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.edit.TextFlowEdit;
	import flashx.textLayout.edit.TextScrap;
	import flashx.textLayout.elements.ContainerFormattedElement;
	import flashx.textLayout.elements.DivElement;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.FlowGroupElement;
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.elements.table.TableDataElement;
	import flashx.textLayout.events.ModelChange;
	import flashx.textLayout.tlf_internal;
	
	use namespace tlf_internal;
	/**
	 * PasteElementOperation is an operation that handles placing flow elements into an insertion point within the text flow. 
	 * @author toddanderson
	 */
	public class PasteElementsOperation extends FlowTextOperation
	{
		protected var _elementsToPaste:Array;
		protected var _elementInsertIndex:int;
		protected var _isPartOfComposite:Boolean;
		
		/**
		 * Constructor. 
		 * @param operationState SelectionState
		 * @param elements Array
		 */
		public function PasteElementsOperation( operationState:SelectionState, elements:Array )
		{
			super( operationState );
			_elementsToPaste = elements;
		}
		
		protected function internalDoOperation():void
		{
			// Update selection state if part of merge
			if( _isPartOfComposite )
			{
				originalSelectionState = textFlow.interactionManager.getSelectionState();
				absoluteStart = originalSelectionState.absoluteStart;
				absoluteEnd = originalSelectionState.absoluteEnd;
			}
			
			var i:int;
			var index:int = 0;
			var length:int;
			var leaf:FlowLeafElement = textFlow.findLeaf( absoluteEnd );
			var para:ParagraphElement = textFlow.findAbsoluteParagraph(absoluteEnd);
			var paraSplitIndex:int = absoluteEnd - para.getAbsoluteStart();
			var flowElIndex:int = para.parent.getChildIndex(para);
			var topGroup:FlowGroupElement = para.parent;
			
			var insertIndex:int;
			var targetGroup:FlowGroupElement;
			var isPastingIntoTable:Boolean = topGroup is TableDataElement;
			// Flow up to find parent as long as not TextFlow or TableDataElement.
			topFind: while( !isPastingIntoTable && !(topGroup is TextFlow) )
			{
				if( topGroup.parent is TextFlow ) break topFind;
				if( topGroup.parent is TableDataElement ) 
				{
					isPastingIntoTable = true;
					break topFind;
				}
				topGroup = topGroup.parent;
			}
			
			// Pasting content into a table takes on a different context.
			if( !isPastingIntoTable )
			{
				// If Paragraph is dirct child of TextFlow, just split it.
				if( topGroup is TextFlow )
				{
					insertIndex = topGroup.getChildIndex( para ) + 1;
					if (paraSplitIndex > 0)
					{
						if (paraSplitIndex < (para.textLength - 1))
						{
							para.splitAtPosition( paraSplitIndex );
						}
					}
					else
					{
						insertIndex = 0;
					}
				}
				// Else, split flow up.
				else
				{
					insertIndex = textFlow.getChildIndex( topGroup ) + 1;
					if (paraSplitIndex > 0)
					{
						if (paraSplitIndex < (para.textLength - 1))
						{
							TextFlowEdit.splitElement( topGroup, absoluteEnd - topGroup.getAbsoluteStart(), true );
						}
					}
					else
					{
						insertIndex = 0;
					}
				}
				targetGroup = textFlow;
			}
			// Switch target to table data element for operation.
			else
			{
				var cellElement:TableDataElement;
				if( topGroup is TableDataElement ) 
				{
					cellElement = topGroup as TableDataElement;
					insertIndex = cellElement.getChildIndex( para ) + 1;
					ParaEdit.splitParagraph( para, absoluteEnd - para.getAbsoluteStart() );
				}
				else
				{
					cellElement = topGroup.parent as TableDataElement;
					insertIndex = cellElement.getChildIndex( topGroup ) + 1;
					TextFlowEdit.splitElement( topGroup, absoluteEnd - topGroup.getAbsoluteStart(), true );	
				}
				insertElementsIntoCell( topGroup as TableDataElement, para, _elementsToPaste );
				targetGroup = cellElement;
			}
			// Add the elements to the target group.
			var elem:FlowElement;
			var elemInsert:int = insertIndex;
			for( i = 0; i < _elementsToPaste.length; i++ )
			{
				elem = _elementsToPaste[i];
				targetGroup.addChildAt( elemInsert, elem );
				length += elem.textLength;
				elemInsert++;
			}
			
			// Check if we emptied out where we split/started.
//			var insertElement:FlowElement = targetGroup.getChildAt( insertIndex - 1 );
//			if( insertElement.textLength == 0 )
//			{
//				targetGroup.removeChild( insertElement );
//			}
//			else if( insertElement is FlowGroupElement && insertElement.textLength == 1 )
//			{
//				// Empty spans, ones that are handed a paragraph terminator have the *awesome* design of havin textlength = 1.
//				leaf = ( insertElement as FlowGroupElement ).findLeaf( absoluteStart ) as FlowLeafElement;
//				if( leaf is SpanElement )
//				{
//					if( leaf.textLength == 1 && ( leaf as SpanElement ).hasParagraphTerminator )
//					{
//						targetGroup.removeChild( insertElement );
//					}
//				}
//			}
			
			// Notify and update selection.
			textFlow.interactionManager.notifyInsertOrDelete( absoluteEnd, length );
			textFlow.interactionManager.setSelectionState( new SelectionState( textFlow, absoluteStart + length, absoluteStart + length ) );
		}
		
		protected function insertElementsIntoCell( element:TableDataElement, beforePara:ParagraphElement, elements:Array ):void
		{
			var i:int;
			var endIndex:int = element.mxmlChildren.length;
			for( i = 0; i < element.mxmlChildren.length; i++ )
			{
				if( element.mxmlChildren[i] == beforePara )
					break;
			}
			var content:Array = element.mxmlChildren;
			var head:Array = content.slice( 0, i );
			head = head.concat( elements );
			var tail:Array = content.slice( i, endIndex );
			var newChildren:Array = head.concat( tail );
			for( i = 0; i < newChildren.length; i++ )
			{
				element.addChild( newChildren[i] as FlowElement );
			}
		}
		
		override public function doOperation():Boolean
		{
			internalDoOperation();
			return true;
		}
		
		override public function undo():SelectionState
		{
			if( _elementsToPaste != null )
			{
				var i:int;
				for( i = 0; i < _elementsToPaste.length; i++ )
				{
					textFlow.removeChildAt( --_elementInsertIndex );
				}
				if ( textFlow.interactionManager )
					textFlow.interactionManager.notifyInsertOrDelete( absoluteStart, 0 );
			}
			
			return originalSelectionState;
		}
		
		override public function redo():SelectionState
		{
			if ( _elementsToPaste != null )
				internalDoOperation();		
			
			return new SelectionState(textFlow, absoluteStart, absoluteStart, null );
		}
		
		tlf_internal override function merge(operation:FlowOperation):FlowOperation
		{
			if (this.endGeneration != operation.beginGeneration)
				return null;
			
			if ((operation is SplitParagraphOperation))
			{
				_isPartOfComposite = true;
				return new CompositeOperation([operation,this]);
			}
			return null;
		}
		
		public function get elements():Array
		{
			return _elementsToPaste;
		}
		public function set elements( value:Array ):void
		{
			_elementsToPaste = value;
		}
		
		public function get insertIndex():int
		{
			return _elementInsertIndex;
		}
		
		// [TA] 07-27-2010 :: See comment on FlowOperation.
		override public function get affectsFlowStructure():Boolean
		{
			return true;
		}
		// [END TA]
	}
}
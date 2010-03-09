package flashx.textLayout.elements
{
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.tlf_internal;

	use namespace tlf_internal;
	
	public class ListItemElement extends DivElement
	{
		private var _p:ParagraphElement;
		private var _span:SpanElement;
		
		private var _rawText:String;
		private var _mode:String;
		
		private var _number:uint;
		
		private var _first:Boolean;
		private var _last:Boolean;
		
		public function ListItemElement()
		{
			super();
			
			_mode = ListElement.UNORDERED;
			
			_rawText = '';
			
			_number = 1;
			
			_first = _last = false;
			
			_p = new ParagraphElement();
			_span = new SpanElement();
			_p.addChild( _span );
			super.addChild( _p );
		}
		
		
		
		override public function addChild(child:FlowElement) : FlowElement
		{
			if ( child is DivElement || child is ListElement )
			{
				var newChild:FlowElement = super.addChild( child );
				_p = new ParagraphElement();
				_span = new SpanElement();
				_p.addChild( _span );
				super.addChild( _p );
				return newChild;
			}
			else
			{
				return _p.addChild( child );
			}
		}
		
		override public function addChildAt(index:uint, child:FlowElement) : FlowElement
		{
			if ( child is DivElement || child is ListElement )
			{
				var newChild:FlowElement = super.addChildAt(index, child);
				if ( index < getChildIndex( _p ) )
				{
					_p = new ParagraphElement();
					_span = new SpanElement();
					_p.addChild( _span );
					super.addChild( _p );
				}
				return newChild;
			}
			else
			{
				return _p.addChildAt(index, child);
			}
		}
		
//		override public function removeChild(child:FlowElement) : FlowElement
//		{
//			return child.parent.removeChild(child);
//		}
//		
//		override public function removeChildAt(index:uint) : FlowElement
//		{
//			return 
//		}
		
		
		
		public function get separator():String
		{
			//	TODO: Leave open for extending with different bullets
			if ( mode == ListElement.ORDERED )
			{
				return number.toString() + '. ';
			}
			else
			{
				return '\u2022 ';
			}
		}
		
		public function set mode( value:String ):void
		{
			if ( value == ListElement.ORDERED || value == ListElement.UNORDERED )
			{
				_mode = value;
				text = rawText;
			}
			else
				return;
		}
		public function get mode():String
		{
			return _mode;
		}
		
		public function set number( value:uint ):void
		{
			_number = value;
			text = rawText;
		}
		public function get number():uint
		{
			return _number;
		}
		
		public function set first( value:Boolean ):void
		{
			_first = value;
			text = rawText;
		}
		public function get first():Boolean
		{
			return _first;
		}
		
		public function set last( value:Boolean ):void
		{
			_last = value;
			text = rawText;
		}
		public function get last():Boolean
		{
			return _last;
		}
		
		public function set text( value:String ):void
		{
			_rawText = value;
			
			var start:String;
			var end:String;
			
//			if ( parent )
//			{
//				if ( parent.parent )
//				{
//					if ( parent.parent is ListItemElement )
//					{
						start = '\t' + separator;
//						end = '\n';
						
						_span.text = start + rawText + end;
//						return;
//					}
//				}
//			}
//			start = first ? '\n' : '';
//			end = last ? '\n' : '';
//			
//			start += '\t' + separator;
//			end += '\n';
			
			_span.text = start + rawText;// + end;
		}
		public function get text():String
		{
			return _span.text;
		}
		
		public function get rawText():String
		{
			return _rawText;
		}
		
		
		
		//	Necessary in order to be able to add children
		override tlf_internal function canOwnFlowElement(elem:FlowElement) : Boolean
		{
			return elem is SpanElement || elem is InlineGraphicElement || elem is LinkElement || elem is DivElement || elem is ParagraphElement || elem is ListElement || elem is FlowGroupElement || elem is FlowLeafElement;
		}
		
		//	Necessary for instantiation
		override protected function get abstract() : Boolean
		{
			return false;
		}
	}
}
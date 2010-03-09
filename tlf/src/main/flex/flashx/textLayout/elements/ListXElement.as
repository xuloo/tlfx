package flashx.textLayout.elements
{
	import flashx.textLayout.tlf_internal;

	use namespace tlf_internal;
	
	public class ListXElement extends DivElement
	{
		public static const ORDERED:String		=	'ordered';
		public static const UNORDERED:String	=	'unordered';
		
		private var _mode:String;
		
		public function ListXElement()
		{
			super();
			
			_mode = ListXElement.UNORDERED;
		}
		
		
		
		override public function addChild(child:FlowElement) : FlowElement
		{
			var newChild:ListItemXElement = super.addChild( child ) as ListItemXElement;
			
			newChild.mode = mode;
			newChild.number = numChildren;
			
			setFirstAndLast();
			update();
			return newChild;
		}
		
		override public function addChildAt(index:uint, child:FlowElement) : FlowElement
		{
			var newChild:ListItemXElement = super.addChildAt(index, child) as ListItemXElement;
			
			newChild.mode = mode;
			
			//	Reset all current ListItem numbers
			var i:int = numChildren;
			while ( --i > index-1 )
			{
				( getChildAt(i) as ListItemXElement ).number = i+1;
			}
			
			setFirstAndLast();
			update();
			return newChild;
		}
		
		override public function removeChild(child:FlowElement) : FlowElement
		{
			var removedChild:ListItemXElement = super.removeChild( child ) as ListItemXElement;
			setFirstAndLast();
			update();
			return removedChild;
		}
		
		override public function removeChildAt(index:uint) : FlowElement
		{
			var removedChild:ListItemXElement = super.removeChildAt( index ) as ListItemXElement;
			setFirstAndLast();
			update();
			return removedChild;
		}
		
		
		
		private function setFirstAndLast():void
		{
			//	Reset all elements to not be first and/or last (no extra breaks)
			var i:int = numChildren;
			while ( --i > -1 )
			{
				( getChildAt(i) as ListItemXElement ).first = ( getChildAt(i) as ListItemXElement ).last = false;
			}
			
			//	If there are still children, set the first and last (mimics the breaks of an ordered or unordered list in html)
			if ( numChildren > 0 )
			{
				( getChildAt(0) as ListItemXElement ).first = true;
				( getChildAt(numChildren - 1) as ListItemXElement ).last = true;
			}
		}
		
		private function update():void
		{
			if ( getTextFlow() )
			{
				if ( getTextFlow().flowComposer )
				{
					getTextFlow().flowComposer.updateAllControllers();
				}
			}
		}
		
		
		
		public function set mode( value:String ):void
		{
			if ( value == ListXElement.ORDERED || value == ListXElement.UNORDERED )
			{
				_mode = value;
				var i:int = numChildren;
				while ( --i > -1 )
				{
					( getChildAt(i) as ListItemXElement ).mode = _mode;
				}
				update();
			}
			else
				return;
		}
		public function get mode():String
		{
			return _mode;
		}
		
		
		
		//	Necessary in order to be able to add children
		override tlf_internal function canOwnFlowElement(elem:FlowElement) : Boolean
		{
			return elem is ListItemXElement;
		}
		
		//	Necessary for instantiation
		override protected function get abstract() : Boolean
		{
			return false;
		}
	}
}
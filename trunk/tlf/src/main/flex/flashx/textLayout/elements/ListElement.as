package flashx.textLayout.elements
{
	import flashx.textLayout.tlf_internal;
	
	use namespace tlf_internal;
	
	public class ListElement extends SubParagraphGroupElement
	{
		public static const BULLETED:String	=	'bulleted';
		public static const NUMBERED:String	=	'numbered';
		
		private var _mode:String;
		
		public function ListElement()
		{
			super();
			_mode = ListElement.BULLETED;
		}
		
		
		
		override public function addChild(child:FlowElement) : FlowElement
		{
			trace('adding');
			var toReturn:ListItemElement = new ListItemElement();
			if ( !(child is ListItemElement) )
			{
				trace('not list item element');
				if ( child is SpanElement )
				{
					trace('\tspan');
					toReturn.text = ( child as SpanElement ).text;
				}
				else if ( child is LinkElement )
				{
					trace('\tlink');
					toReturn.text = ( child as LinkElement ).getText( 0, ( child as LinkElement ).textLength );
				}
				else
				{
					trace('\tdunno:', child);
					toReturn.text = '';
				}
			}
			else
			{
				trace('is, recasting');
				toReturn = child as ListItemElement;
			}
			
			toReturn.mode = _mode;
			toReturn.number = this.numChildren + 1;
			
			resetFirstAndLast();
			
			if ( this.getChildAt( 0 ) )
				( this.getChildAt( 0 ) as ListItemElement ).first = true;
			else
				toReturn.first = true;
			
			toReturn.last = true;
			
			return super.addChild( toReturn );
		}
		
		override public function addChildAt(index:uint, child:FlowElement) : FlowElement
		{
			trace('adding at');
			var toReturn:ListItemElement = new ListItemElement();
			if ( !(child is ListItemElement) )
			{
				trace('not list item element');
				if ( child is SpanElement )
				{
					trace('\tspan');
					toReturn.text = ( child as SpanElement ).text;
				}
				else if ( child is LinkElement )
				{
					trace('\tlink');
					toReturn.text = ( child as LinkElement ).getText( 0, ( child as LinkElement ).textLength );
				}
				else
				{
					trace('\tdunno:', child);
					toReturn.text = '';
				}
			}
			else
			{
				trace('is, recasting');
				toReturn = child as ListItemElement;
			}
			
			toReturn.mode = _mode;
			toReturn.number = index+1;
			
			for ( var i:int = index; i < this.numChildren; i++ )
			{
				//	+1 is to convert from 0-9 to 1-10 range & extra +1 is to correct #
				( this.getChildAt(i) as ListItemElement ).number = i+2;
			}
			
			if ( index == 0 || index >= this.numChildren )
			{
				resetFirstAndLast();
				if ( index == 0 )
					toReturn.first = true;
				if ( index >= this.numChildren )
					toReturn.last = true;
			}
			
			return super.addChildAt(index > this.numChildren ? this.numChildren : index, child);
		}
		
		override public function removeChild(child:FlowElement) : FlowElement
		{
			var retChild:FlowElement = super.removeChild(child);
			changeMode( _mode );
			return retChild;
		}
		
		override public function removeChildAt(index:uint) : FlowElement
		{
			var retChild:FlowElement = super.removeChildAt(index);
			changeMode( _mode );
			return retChild;
		}
		
		override public function replaceChildren(beginChildIndex:int, endChildIndex:int, ...rest) : void
		{
			super.replaceChildren( beginChildIndex, endChildIndex, rest );
			changeMode( _mode );
		}
		
		
		
		private function changeMode( value:String ):void
		{
			if ( value != ListElement.BULLETED && value != ListElement.NUMBERED )
				throw new Error( 'Invalid mode set on ListElement object: ' + this );
			
			_mode = value;
			
			resetFirstAndLast();
			
			if ( this.numChildren > 0 )
			{
				var i:int = this.numChildren;
				while ( --i > -1 )
				{
					( this.getChildAt(i) as ListItemElement ).mode = _mode;
					( this.getChildAt(i) as ListItemElement ).number = i+1;
				}
				( this.getChildAt(0) as ListItemElement ).first = true;
				( this.getChildAt(this.numChildren-1) as ListItemElement ).last = true;
				update();
			}
		}
		
		private function resetFirstAndLast():void
		{
			var i:int = this.numChildren;
			while ( --i > -1 )
			{
				( this.getChildAt(i) as ListItemElement ).first = false;
				( this.getChildAt(i) as ListItemElement ).last = false;
			}
		}
		
		public function update():void
		{
			if ( this.getParagraph() )
			{
				for ( var i:int = 0; i < this.getParagraph().numChildren; i++ )
				{
					var child:FlowElement = this.getParagraph().getChildAt(i);
					if ( child is ListElement )
					{
						var le_child:ListElement = child as ListElement;
						for ( var j:int = 0; j < le_child.numChildren; j++ )
						{
							var innerChild:FlowElement = le_child.getChildAt(j);
						}
					}
				}
			}
			
			if ( this.getTextFlow() )
				this.getTextFlow().flowComposer.updateAllControllers();
		}
		
		
		
		public function get mode():String
		{
			return _mode;
		}
		public function set mode( value:String ):void
		{
			if ( value != ListElement.BULLETED && value != ListElement.NUMBERED )
				throw new Error( 'Invalid mode set on ListElement object: ' + this );
			changeMode( value );
		}
		
		
		
		override tlf_internal function canOwnFlowElement(elem:FlowElement) : Boolean
		{
			return elem is ListItemElement;
		}
		
		override protected function get abstract() : Boolean
		{
			return false;
		}
	}
}
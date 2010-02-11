package flashx.textLayout.elements
{
	import flashx.textLayout.tlf_internal;
	
	use namespace tlf_internal;
	
	public class ListItemElement extends SpanElement
	{
		private var _baseText:String;
		private var _mode:String;
		
		private var _num:uint;
		
		private var _first:Boolean;
		private var _last:Boolean;
		
		public function ListItemElement()
		{
			super();
			
			tlf_internal::setTextLength(1);
			
			_mode = ListElement.BULLETED;
			_baseText = '';
			_num = 0;
			_first = false;
			_last = false;
		}
		
		private function getSeparator():String
		{
			if ( _mode )
			{
				if ( _mode == ListElement.BULLETED )
					return '\u2022 ';
				else
				{
					if ( isNaN( _num ) )
						return '\u2022 ';
					else
						return _num.toString() + '. ';
				}
			}
			return '\u2022 ';
		}
		
		override tlf_internal function canReleaseContentElement() : Boolean
		{
			return false;
		}
		
		
		
		public function set mode( value:String ):void
		{
			if ( value != ListElement.BULLETED && value != ListElement.NUMBERED )
				return;
			_mode = value;
			this.text = rawText;
		}
		public function get mode():String
		{
			return _mode;
		}
		
		public function set number( value:uint ):void
		{
			_num = value;
			this.text = rawText;
		}
		public function get number():uint
		{
			return _num;
		}
		
		public function set first( value:Boolean ):void
		{
			_first = value;
			if ( first )
				this.text = rawText;
		}
		public function get first():Boolean
		{
			return _first;
		}
		
		public function set last( value:Boolean ):void
		{
			_last = value;
			if ( last )
				this.text = rawText;
		}
		public function get last():Boolean
		{
			return _last;
		}
		
		override public function set text(textValue:String) : void
		{
			_baseText = textValue;
			var start:String = first ? '\n' : '';
			var end:String = last ? '\n' : '';
			
			start += '\t' + getSeparator();
			end += '\n';
			
			var textToPass:String = start + textValue + end;
			super.text = textToPass;
		}
		override public function get text() : String
		{
			return super.text;
		}
		
		public function get rawText() : String
		{
			return _baseText;
		}
		
		override protected function get abstract() : Boolean
		{
			return false;
		}
	}
}
package flashx.textLayout.utils
{
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.FlowValueHolder;
	import flashx.textLayout.formats.FormatValue;
	import flashx.textLayout.formats.ITextLayoutFormat;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.tlf_internal;

	use namespace tlf_internal;
	
	public class TextLayoutFormatUtils
	{
		static private function normalizeColorProperty( value:String ):Number
		{
			return 0x000000;
			return Number( value );
		}
		
		static private function normalizeFontSizeProperty( value:String ):Number
		{
			return 12;
			return Number( value );	
		}
		
		static public function mergeFormats( format:ITextLayoutFormat, overlayFormat:ITextLayoutFormat ):ITextLayoutFormat
		{	
			var property:String;
			for( property in TextLayoutFormat.description )
			{
				if( overlayFormat[property] != undefined )
					format[property] = overlayFormat[property];
			}
			return format;
		}
		
		static public function applyUserStyles( element:FlowElement ):void
		{
			var format:FlowValueHolder = element.format as FlowValueHolder;
			if( format.userStyles == null ) return;
			
			var userStyles:String = format.userStyles.style;
			var styleClass:String = format.userStyles.styleClass;
			
			var property:String;
			var value:*
			for( property in userStyles )
			{
				property = StyleAttributeUtil.camelize( property );
				value = userStyles[property];
				if( property == "color" )
					value = TextLayoutFormatUtils.normalizeColorProperty( value );
				else if( property == "fontSize" )
					value = TextLayoutFormatUtils.normalizeFontSizeProperty( value );
				
				try {
					element.format[property] = value;
				}
				catch( e:Error ) {
					// property not on format.
				}
			}
		}
		
		static public function stripWhitespaces( value:String ):String
		{
			var char:String = value.charAt(0);
			while( char == " " )
			{
				value = value.substr( 1, value.length );
				char = value.charAt( 0 );
			}
			char = value.charAt(value.length - 1);
			while( char == " " )
			{
				value = value.substr( 0, value.length - 1 );
				char = value.charAt(value.length - 1);
			}
			return value;
		}
	}
}
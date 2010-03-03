package flashx.textLayout.utils
{
	import flashx.textLayout.elements.FlowElement;

	public class StyleAttributeUtil
	{
		public static const DASH:String = "-";
		public static const STYLE_DELIMITER:String = ";";
		public static const STYLE_PROPERTY_DELIMITER:String = ":";
		
		static protected function isValidStyleString( value:String ):Boolean
		{
			return value != null && value != "" && value != "undefined";
		}
		
		static protected function isValidStyleNumber( value:Number ):Boolean
		{
			return !isNaN(value);
		}
		
		static protected function isValidFontSize( value:Number ):Boolean
		{
			return !isNaN(value) && value != 0;
		}
			
		/**
		 * Turns any dashed properties to camelCaps. 
		 * @param value String
		 * @return String
		 */
		protected static function camelize( value:String ):String
		{
			var i:int;
			var char:String;
			while( value.indexOf( StyleAttributeUtil.DASH ) > -1 )
			{
				i = value.indexOf( StyleAttributeUtil.DASH );
				char = value.charAt(i+1);
				value = value.replace( StyleAttributeUtil.DASH + char, char.toUpperCase() );
			}
			return value;
		}
		
		protected static function dasherize( value:String ):String
		{
			var match:* = value.match( /[A-Z]/ig );
			return value;
		}
		
		/**
		 * Parses @style attiribute on node and places specific attributes on node.
		 * @param node XML
		 */
		public static function assignStylesAsAttributes( node:XML ):void
		{
			var style:String = node.@style;
			if( !isValidStyleString( style ) ) return;
			
			var styles:Array = style.split(StyleAttributeUtil.STYLE_DELIMITER);
			var attribute:String;
			var value:String;
			var i:int;
			for( i = 0; i < styles.length; i++ )
			{
				var keyValue:Array = styles[i].split(StyleAttributeUtil.STYLE_PROPERTY_DELIMITER);
				attribute = camelize( keyValue[0] );
				value = keyValue[1];
				node["@" + attribute] = value;
			}
		}
		
		/**
		 * Assigns styles from FlowElement as individual attributes on tag. 
		 * @param tag XML
		 * @param element FlowElement
		 */
		public static function assignStylesFromElement( tag:XML, element:FlowElement ):void
		{
			var styles:Array = [];
			if( isValidStyleString( element.fontFamily ) )
				styles.push( "font-family:" + element.fontFamily );
			if( isValidStyleString( element.fontWeight ) )
				styles.push( "font-weight:" + element.fontWeight );
			if( isValidStyleString( element.fontStyle ) )
				styles.push( "font-style:" + element.fontStyle );
			if( isValidStyleString( element.textDecoration ) )
				styles.push( "text-decoration:" + element.textDecoration );
			if( isValidStyleNumber( element.color ) )
				styles.push( "color:#" + element.color );
			if( isValidFontSize( element.fontSize ) )
				styles.push( "font-size:" + element.fontSize + "px" );
			
			if( styles.length > 0 )
			{
				var i:int;
				var keyValues:Array;
				var attribute:String;
				var value:String;
				for( i = 0; i < styles.length; i++ )
				{
					keyValues = styles[i].split( StyleAttributeUtil.STYLE_PROPERTY_DELIMITER );
					attribute = StyleAttributeUtil.camelize( keyValues[0] );
					value = keyValues[1].toString();
					tag["@" + attribute] = value;
				}
			}
		}
		
		/**
		 * Assigns styles on element as @style property to tag. 
		 * @param tag XML
		 * @param element FlowElement
		 */
		static public function stylizeTag( tag:XML, element:FlowElement ):void
		{
			var styles:Array = [];
			if( isValidStyleString( element.fontFamily ) )
				styles.push( "font-family:" + element.fontFamily );
			if( isValidStyleString( element.fontWeight ) )
				styles.push( "font-weight:" + element.fontWeight );
			if( isValidStyleString( element.fontStyle ) )
				styles.push( "font-style:" + element.fontStyle );
			if( isValidStyleString( element.textDecoration ) )
				styles.push( "text-decoration:" + element.textDecoration );
			if( isValidStyleNumber( element.color ) )
				styles.push( "color:" + element.color );
			if( isValidFontSize( element.fontSize ) )
				styles.push( "font-size:" + element.fontSize + "px" );
			
			if( styles.length > 0 )
			{
				var style:String = styles.join(";");
				tag.@style = style;
			}
		}
		
		static public function assignAttributesAsStyle( tag:XML ):void
		{
			var fontFamily:String = tag.@fontFamily;
			var fontWeight:String = tag.@fontWeight;
			var fontStyle:String = tag.@fontStyle;
			var textDecoration:String = tag.@textDecoration;
			var color:Number = Number( tag.@color );
			var fontSize:Number = Number( tag.@fontSize );
			
			var styles:Array = [];
			if( isValidStyleString( fontFamily ) )
				styles.push( "font-family:" + fontFamily );
			if( isValidStyleString( fontWeight ) )
				styles.push( "font-weight:" + fontWeight );
			if( isValidStyleString( fontStyle ) )
				styles.push( "font-style:" + fontStyle );
			if( isValidStyleString( textDecoration ) )
				styles.push( "text-decoration:" + textDecoration );
			if( isValidStyleNumber( color ) )
				styles.push( "color:#" + color );
			if( isValidStyleNumber( fontSize ) )
				styles.push( "font-size:" + fontSize + "px" );
			
			if( styles.length > 0 )
			{
				var style:String = styles.join(";");
				tag.@style = style;
			}
			
			delete tag.@fontFamily;
			delete tag.@fontWeight;
			delete tag.@fontStyle;
			delete tag.@textDecoration;
			delete tag.@color;
			delete tag.@fontSize;
		}
	}
}
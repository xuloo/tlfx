package flashx.textLayout.utils
{
	import flashx.textLayout.model.style.BorderStyleEnum;
	import flashx.textLayout.model.style.BoxModelShorthand;

	public class BoxModelUnitShorthandUtil
	{
		protected static function isColorUnit( value:* ):Boolean
		{
			return !isNaN(ColorValueUtil.normalizeForLayoutFormat( value ));
		}
		
		protected static function isStyleUnit( value:* ):Boolean
		{
			var list:Array = BorderStyleEnum.getList();
			var i:int;
			for( i = 0; i < list.length; i++ )
			{
				if( value == list[i] )
					return true;
			}
			return false;
		}
		
		protected static function isWidthUnit( value:* ):Boolean
		{
			return !isNaN(BoxModelStyleUtil.normalizeBorderUnit( value ));
		}
		
		protected static function indexOfColorUnit( units:Array ):int
		{
			var i:int;
			for( i = 0; i < units.length; i++ )
			{
				if( isColorUnit( units[i] ) )
					return i;
			}
			return -1;
		}
		
		protected static function indexOfStyleUnit( units:Array ):int
		{
			var i:int;
			for( i = 0; i < units.length; i++ )
			{
				if( isStyleUnit( units[i] ) )
					return i;
			}
			return -1;
		}
		
		protected static function indexOfWidthUnit( units:Array ):int
		{
			var i:int;
			for( i = 0; i < units.length; i++ )
			{
				if( isWidthUnit( units[i] ) )
					return i;
			}
			return -1;
		}
		
		public static function deserializeShortHand( value:* ):BoxModelShorthand
		{
			if( !value ) return null;
			
			var color:*;
			var style:*;
			var width:*;
			
			var units:Array = value.toString().split( " " );
			var cIndex:int = BoxModelUnitShorthandUtil.indexOfColorUnit( units );
			if( cIndex >= 0 )
			{
				color = ColorValueUtil.normalizeForLayoutFormat( units[cIndex] );
				units.splice( cIndex, 1 );
			}
			var sIndex:int = BoxModelUnitShorthandUtil.indexOfStyleUnit( units );
			if( sIndex >= 0 )
			{
				style = units[sIndex]
				units.splice( sIndex, 1 );	
			}
			var wIndex:int = BoxModelUnitShorthandUtil.indexOfWidthUnit( units );
			if( wIndex >= 0 )
			{
				width = BoxModelStyleUtil.normalizeBorderUnit( units[wIndex] )
			}
			
			return new BoxModelShorthand( color, style, width );
		}
	}
}
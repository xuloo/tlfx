package flashx.textLayout.model.table
{
	import flash.events.Event;
	
	import flashx.textLayout.converter.TableMapper;
	import flashx.textLayout.elements.table.TableRowElement;
	import flashx.textLayout.model.attribute.IAttribute;
	import flashx.textLayout.model.attribute.TableAttribute;
	import flashx.textLayout.model.style.ITableStyle;
	import flashx.textLayout.model.style.TableStyle;

	[Event(name="resize", type="flash.events.Event")]
	/**
	 * Table represents the data associated with a Table. 
	 * @author toddanderson
	 */
	public class Table extends TableModelBase
	{
		public var rows:Vector.<TableRow>;
		public var columns:Vector.<TableColumn>;
		public var cellAmount:int;
		
		protected var _width:Number;
		protected var _height:Number;
		
		/**
		 * Constructor. 
		 * @param rows Vector.<TableRow> The list of rows.
		 */
		public function Table() 
		{ 
			context = new TableDecorationContext( getDefaultAttributes(), getDefaultStyle() );
		}
		
		/**
		 * @inherit
		 */
		override protected function getDefaultAttributes():IAttribute
		{
			return TableAttribute.getDefaultAttributes();
		}
		
		/**
		 * @inherit
		 */
		override protected function getDefaultStyle():ITableStyle
		{
			return new TableStyle();
		}
		
		public function getContextImplementation():ITableDecorationContext
		{
			return ( context as ITableDecorationContext );
		}
		
		/**
		 * Returns the cellspacing attribute value. 
		 * @return int
		 */
		public function get cellspacing():int
		{
			return ( context as ITableDecorationContext ).determineCellSpacing();
		}
		
		/**
		 * Returns the cellpadding attribute value. 
		 * @return int
		 */
		public function get cellpadding():int
		{
			return ( context as ITableDecorationContext ).determineCellPadding();
		}
		
		/**
		 * Returns the overall computed height of the table for display based on context and held properties. 
		 * @return Number
		 */
		public function getComputedHeight():Number
		{
			return _height + ( context as ITableDecorationContext ).getComputedHeightOfBorders() + ( cellspacing * 2 );
		}
		/**
		 * Returns the overall computed width of the table for display based on context and held properties. 
		 * @return Number
		 */
		public function getComputedWidth():Number
		{
			return _width + ( context as ITableDecorationContext ).getComputedWidthOfBorders() + ( cellspacing * 2 );
		}
		
		/**
		 * Returns the specified width for the table. 
		 * @return Number
		 */
		public function get width():Number
		{
			return _width;
		}
		public function set width( value:Number ):void
		{
			if( value == _width ) return;
			
			_width = value;
			dispatchEvent( new Event( Event.RESIZE ) );
		}
		
		/**
		 * Returns the specified height for the table. 
		 * @return String
		 */
		public function get height():Number
		{
			return _height;
		}
		public function set height( value:Number ):void
		{
			if( value == height ) return;
			
			_height = value;
			dispatchEvent( new Event( Event.RESIZE ) );
		}
	}
}
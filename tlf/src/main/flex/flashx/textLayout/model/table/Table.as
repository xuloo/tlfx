package flashx.textLayout.model.table
{
	import flashx.textLayout.model.attribute.TableAttribute;
	import flashx.textLayout.format.IStyle;

	/**
	 * Table represents the data associated with a Table. 
	 * @author toddanderson
	 */
	public class Table extends TableBaseElement
	{
		public var rows:Vector.<TableRow>;
		public var columns:Vector.<TableColumn>;
		
		protected var _width:Number;
		protected var _height:Number;
		
		/**
		 * Constructor. 
		 * @param rows Vector.<TableRow> The list of rows.
		 * @param style IStyle The IStyle implementation associated with the Table.
		 */
		public function Table( rows:Vector.<TableRow>, columns:Vector.<TableColumn>, style:IStyle = null )
		{
			super();
			this.rows = rows;
			this.columns = columns;
			this.styles = style;
		}
		
		/**
		 * @inherit
		 */
		override protected function setDefaultAttributes():void
		{
			attributes = TableAttribute.getDefaultAttributes();
		}
		
		/**
		 * Returns the cellspacing attribute value. 
		 * @return int
		 */
		public function get cellspacing():int
		{
			if( attributes == null ) return TableAttribute.DEFAULTS[TableAttribute.CELLSPACING];
			return attributes[TableAttribute.CELLSPACING];
		}
		
		/**
		 * Returns the cellpadding attribute value. 
		 * @return int
		 */
		public function get cellpadding():int
		{
			if( attributes == null ) return TableAttribute.DEFAULTS[TableAttribute.CELLPADDING];
			return attributes[TableAttribute.CELLPADDING];
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
			_width = value;
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
			_height = value;
		}
	}
}
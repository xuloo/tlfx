package flashx.textLayout.model.table
{
	/**
	 * TableColumn represents a column of cells within a Table model. 
	 * @author toddanderson
	 */
	public class TableColumn extends TableBaseElement
	{
		public var tableData:Vector.<TableData>;
		public var nextColumn:TableColumn;
		public var previousColumn:TableColumn;
		
		public var width:Number;
		public var height:Number;
		
		/**
		 * Constructor. 
		 * @param tableData Vector.<TableData>
		 */
		public function TableColumn( tableData:Vector.<TableData> = null )
		{
			super();
			this.tableData = tableData || new Vector.<TableData>();
		}
	}
}
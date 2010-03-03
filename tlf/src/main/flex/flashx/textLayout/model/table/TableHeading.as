package flashx.textLayout.model.table
{
	import flashx.textLayout.model.attribute.TableHeadingAttribute;

	/**
	 * TableHeading works primarily the same as a table cell. 
	 * @author toddanderson
	 */
	public class TableHeading extends TableData
	{
		/**
		 * @inherit
		 */
		public function TableHeading( data:XML )
		{
			super( data );
		}
		
		/**
		 * @inherit
		 */
		override protected function setDefaultAttributes():void
		{
			attributes = TableHeadingAttribute.getDefaultAttributes();
		}
	}
}
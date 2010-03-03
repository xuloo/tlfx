package flashx.textLayout.model.table
{
	import flashx.textLayout.format.IStyle;
	import flashx.textLayout.model.attribute.IAttribute;

	/**
	 * TableElement is the base class for all models making up a table. 
	 * @author toddanderson
	 * 
	 */
	public class TableBaseElement
	{
		public var attributes:IAttribute;
		public var styles:IStyle;
		
		public function TableBaseElement() 
		{
			setDefaultAttributes();
		}
		
		/**
		 * @private
		 * 
		 * Creates default IAttributes implementation.
		 */
		protected function setDefaultAttributes():void
		{
			// abtract.
		}
	}
}
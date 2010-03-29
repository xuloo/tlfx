package flashx.textLayout.container.table
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * TableCellDisplay is a basic extension of Sprite used mainly for type checking when referencing containersw within a textflow. 
	 * @author toddanderson
	 */
	public class TableCellDisplay extends Sprite
	{
		/**
		 * Master is a reference to the master display on which this cell resides.
		 * Used mainly as a reference point to tie back ContainerController target displays to TableElement 
		 */
		public var master:DisplayObjectContainer;
		/**
		 * Constructor.
		 */
		public function TableCellDisplay() { super(); }
	}
}
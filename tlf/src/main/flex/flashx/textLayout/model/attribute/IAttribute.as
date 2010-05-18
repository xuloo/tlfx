package flashx.textLayout.model.attribute
{
	import flashx.textLayout.formats.TextLayoutFormat;

	/**
	 * IAttribute is an interface for a dynaic attribute map. 
	 * @author toddanderson
	 * 
	 */
	public interface IAttribute
	{
		/**
		 * Returns flag of holding property value. 
		 * @param property String
		 * @return Boolean
		 */
		function hasProperty( property:String ):Boolean;
		/**
		 * Returns flag of attribute considered as undefined. 
		 * @param property String
		 * @return Boolean
		 */
		function isUndefined( property:String ):Boolean;
		/**
		 * Applies any propety values held on supplied object to current existing attributes. 
		 * @param attributes Object A key/value pair object.
		 */
		function modifyAttributes( attributes:Object ):void;
		/**
		 * Applies any property vlaues to a TxtLayoutFormat instance as they relate to any attributes for the specified element. 
		 * @param format TextLayoutFormat
		 */
		function applyAttributesToFormat( format:TextLayoutFormat ):void;
		/**
		 * Removes any attributes from the held map that equate to the default value for that property.
		 */
		function getStrippedAttributes():Object;
	}
}
package flashx.textLayout.converter
{
	import flash.events.IEventDispatcher;

	/**
	 * ITagParser parses a valid HTML markup into a model representation. 
	 * @author toddanderson
	 */
	public interface ITagParser extends ITagCleaner
	{
		/**
		 * Parses specific fragment of HTML based on implementations specification. 
		 * @param fragment String
		 */
		function parse( fragment:String ):*;
	}
}
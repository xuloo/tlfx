package flashx.textLayout.events
{
	import flash.events.Event;
	
	import flashx.textLayout.container.AutosizableContainerController;
	
	/**
	 * AutosizableContainerControllerEvent is an event corresponding to the resize of an autosizable container controller. 
	 * @author toddanderson
	 */
	public class AutosizableContainerControllerEvent extends Event
	{
		public var offset:Number;
		public var controller:AutosizableContainerController;
		public static const RESIZE_COMPLETE:String = "resizeComplete";
		/**
		 * Constructor. 
		 * @param type String
		 * @param controller AutosizableContainerController The dispatching instance.
		 * @param offset Number The offset in height after a resize operation.
		 */
		public function AutosizableContainerControllerEvent( type:String, controller:AutosizableContainerController, offset:Number )
		{
			super( type );
			this.offset = offset;
			this.controller = controller;
		}
		
		/**
		 * @inherit
		 */
		override public function clone():Event
		{
			return new AutosizableContainerControllerEvent( type, controller, offset );
		}
	}
}
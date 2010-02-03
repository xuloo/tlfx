package flashx.textLayout.edit
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import flashx.undo.IUndoManager;
	
	public class ExtendedEditManager extends EditManager
	{
		public function ExtendedEditManager(undoManager:IUndoManager=null)
		{
			super(undoManager);
		}
		
		override public function keyDownHandler(event:KeyboardEvent) : void
		{
			if ( event.keyCode == Keyboard.TAB )
			{
				this.insertText('\t');
			}
			else
			{
				super.keyDownHandler( event );
			}
		}
	}
}
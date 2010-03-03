package flashx.textLayout.elements.table
{
	import flash.display.DisplayObjectContainer;
	
	import flashx.textLayout.converter.ITagAssembler;
	import flashx.textLayout.converter.ITagParser;
	import flashx.textLayout.elements.ContainerFormattedElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.TagParserCleanCompleteEvent;
	import flashx.textLayout.events.TagParserCleanProgressEvent;
	import flashx.textLayout.model.table.Table;

	public class TableElement extends ContainerFormattedElement
	{
		protected var _table:Table;
		protected var _fragment:*;
		protected var _importer:ITagParser;
		protected var _exporter:ITagAssembler;
		
		protected var _tableManager:ITableElementManager;
		protected var _elementalIndex:int;
		protected var _targetContainer:DisplayObjectContainer;
		
		protected var _textFlow:TextFlow;
		
		public function TableElement()
		{
			super();
		}
		
		override protected function get abstract() : Boolean
		{
			return false;
		}
		
		/**
		 * @private
		 * 
		 * Event handler for parser clean progress. Used to notify a client of progress. 
		 * @param evt TagParserCleanProgressEvent
		 */
		protected function handleParseCleanProgress( evt:TagParserCleanProgressEvent ):void
		{
//			// Create progress alert if not there.
//			if( _progressAlert == null )
//				_progressAlert = new TableProgressAlert();
//			
//			// Show and update.
//			_alertManager.showAlert( _progressAlert );
//			_progressAlert.message = evt.message;
//			_progressAlert.percent = evt.percent;
		}
		
		/**
		 * @private
		 * 
		 * Event handler for complete of parse clean. Moves on to continue parsing table and building textflow. 
		 * @param evt TagParserCleanCompleteEvent
		 */
		protected function handleParseCleanComplete( evt:TagParserCleanCompleteEvent ):void
		{
			// Kill progress alert if shown.
//			if( _progressAlert )
//			{
//				_alertManager.hideAlert( _progressAlert );
//				_progressAlert = null;
//			}
			
			// Parse html string into a Table object using the importer.
			_table = _importer.parse( evt.xml.toString() ) as Table;
			_tableManager.create( this, _table, _targetContainer );
		}
		
		public function initialize( textFlow:TextFlow, targetContainer:DisplayObjectContainer ):void
		{
			_textFlow = textFlow;
			_targetContainer = targetContainer;
			
			_importer.addEventListener( TagParserCleanCompleteEvent.CLEAN_COMPLETE, handleParseCleanComplete );
			_importer.addEventListener( TagParserCleanProgressEvent.CLEAN_PROGRESS, handleParseCleanProgress );
			_importer.clean( _fragment );
		}
		
		override public function getTextFlow():TextFlow
		{
			return _textFlow;
		}
		
		public function serialize():String
		{
			XML.prettyIndent = 4;
			XML.prettyPrinting = true;
			_fragment = XML( _exporter.createFragment( _table ) );
			return _fragment.toXMLString();
		}
		
		public function get tableManager():ITableElementManager
		{
			return _tableManager;
		}
		public function set tableManager( value:ITableElementManager ):void
		{
			_tableManager = value;
		}
		
		public function get fragment():* /* String or XML */
		{
			return _fragment;
		}
		public function set fragment( value:* /* String or XML */ ):void
		{
			_fragment = value;
		}
		
		public function get importer():ITagParser
		{
			return _importer;
		}
		public function set importer( value:ITagParser ):void
		{
			_importer = value;
		}
		
		public function get exporter():ITagAssembler
		{
			return _exporter;
		}
		public function set exporter( value:ITagAssembler ):void
		{
			_exporter = value;
		}
		
		public function get elementalIndex():int
		{
			return _elementalIndex;
		}
		public function set elementalIndex( value:int ):void
		{
			_elementalIndex = value;
		}
	}
}
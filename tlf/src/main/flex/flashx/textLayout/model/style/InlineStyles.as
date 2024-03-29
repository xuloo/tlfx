package flashx.textLayout.model.style
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.events.InlineStyleEvent;
	import flashx.textLayout.formats.ITextLayoutFormat;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.utils.FragmentAttributeUtil;
	import flashx.textLayout.utils.StyleAttributeUtil;

	[Event(name="appliedStyleChange", type="flashx.textLayout.events.InlineStyleEvent")]
	[Event(name="explicitStyleChange", type="flashx.textLayout.events.InlineStyleEvent")]
	[Event(name="listItemParentStyleChange", type="flashx.textLayout.events.InlineStyleEvent")]
	/**
	 * InlineStyles is a basic model for holding attibutes related to a FlowElement as they pertain to id and class of style. 
	 * An InlineStyles object is handed to a FlowElement through its userStyles property.
	 * @author toddanderson
	 */
	public class InlineStyles extends EventDispatcher
	{
		public var node:XML;
		protected var _appliedStyle:*; 						/* Style applied from stylesheet */
		protected var _explicitStyle:Object; 				/* Generic object fo key/value pairs for style properties. */
		protected var _listItemParentStyle:Object;			/* Generic object fo key/value pairs for style properties for list items. */ 
		
		/**
		 * Constructor. 
		 * @param elementTag XML The tag to parse.
		 */
		public function InlineStyles( elementTag:XML = null )
		{
			// Deserialize style atts from tag if available.
			if( elementTag )
				deserialize( elementTag );
		}
		
		/**
		 * Serializes held properties to a tag. 
		 * @param tag XML
		 */
		public function serialize( tag:XML ):void
		{	
			if( node )
			{
				var nodeAttributes:XMLList = node.attributes();
				var propertyName:String;
				var propertyValue:String;
				var attribute:XML;
				for each( attribute in nodeAttributes )
				{
					propertyName = attribute.name().localName;
					if( propertyName == "style" ) continue;
					propertyValue = attribute.toString();
					if( !FragmentAttributeUtil.exists( tag, propertyName ) ) 
						tag["@" + propertyName] = propertyValue;
				}
			}
		}
		
		/**
		 * Deserializes tag attributes to properties. 
		 * @param tag XML
		 */
		public function deserialize( tag:XML ):void
		{
			node = tag;
			var style:String = ( tag ) ? tag.@style : null;
			if( style && style.length > 0 ) explicitStyle = StyleAttributeUtil.parseStyles( style );
		}
		
		public function clone():InlineStyles
		{
			var copy:InlineStyles = new InlineStyles();
			copy.node = node;
			copy.appliedStyle = _appliedStyle;
			copy.explicitStyle = _explicitStyle;
			copy.listItemParentStyle = _listItemParentStyle;
			return copy;
		}
		
		public function get styleId():String
		{
			if( !node ) return null;
			return FragmentAttributeUtil.exists( node, "id" ) ? node.@id : null;
		}
		
		public function get styleClass():String
		{
			if( !node ) return null;
			return FragmentAttributeUtil.exists( node, "class" ) ? node["@class"] : null;
		}
		
		/**
		 * Accessor/Modifier for applied style object which is updated based on supplied external style sheet. 
		 * @return *
		 */
		public function get appliedStyle():*
		{
			return _appliedStyle;
		}
		public function set appliedStyle( value:* ):void
		{
			var oldStyle:* = _appliedStyle;
			_appliedStyle = value;
			dispatchEvent( new InlineStyleEvent( InlineStyleEvent.APPLIED_STYLE_CHANGE, oldStyle, _appliedStyle ) );
		}
		
		/**
		 * Accessor/Modifier for explicit style object defined on the @style attribute for the target node element. 
		 * @return Object
		 */
		public function get explicitStyle():Object
		{
			return _explicitStyle;
		}
		public function set explicitStyle( value:Object ):void
		{
			var oldStyle:Object = _explicitStyle;
			_explicitStyle = value;
			dispatchEvent( new InlineStyleEvent( InlineStyleEvent.EXPLICIT_STYLE_CHANGE, oldStyle, _explicitStyle ) );
		}

		/**
		 * Accessor/Modifier for inheriting parent style for list item. The way list items are created in the flow, nested items share same parent
		 * as non-nested. As such we need to track what styles were on the list item parent in order to track explicit and cascaded styles. 
		 * @return 
		 * 
		 */
		public function get listItemParentStyle():Object
		{
			return _listItemParentStyle;
		}
		public function set listItemParentStyle(value:Object):void
		{
			var oldStyle:Object = _listItemParentStyle;
			_listItemParentStyle = value;
			dispatchEvent( new InlineStyleEvent( InlineStyleEvent.LIST_ITEM_PARENT_STYLE_CHANGE, oldStyle, _listItemParentStyle ) );
		}

	}
}
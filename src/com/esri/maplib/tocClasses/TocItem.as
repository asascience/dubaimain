/*
 * Copyright 2009 ESRI
 *
 * All rights reserved under the copyright laws of the United States
 * and applicable international laws, treaties, and conventions.
 *
 * You may freely redistribute and use this sample code, with or
 * without modification, provided you include the original copyright
 * notice and use restrictions.
 *
 * See use restrictions at http://resources.esri.com/help/9.3/usagerestrictions.htm.
 */
package com.esri.maplib.tocClasses
{
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;
import mx.events.PropertyChangeEvent;
import mx.utils.ObjectUtil;

/**
 * The base TOC item.
 */
public class TocItem extends EventDispatcher
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	public function TocItem( parentItem:TocItem = null )
	{
		_parent = parentItem;
	}
	
	//--------------------------------------------------------------------------
	//  Property:  parent
	//--------------------------------------------------------------------------
	
	private var _parent:TocItem;
	
	/**
	 * The parent TOC item of this item.
	 */
	public function get parent():TocItem
	{
		return _parent;
	}
	
	//--------------------------------------------------------------------------
	//  Property:  children
	//--------------------------------------------------------------------------
	
	[Bindable]
	/**
	 * The child items of this TOC item.
	 */
	public var children:ArrayCollection; // of TocItem
	
	/**
	 * Adds a child TOC item to this item.
	 */
	internal function addChild( item:TocItem ):void
	{
		if (!children)
		{
			children = new ArrayCollection();
		}
		children.addItem(item);
		
		updateIndeterminateState(true);
	}
	
	//--------------------------------------------------------------------------
	//  Property:  label
	//--------------------------------------------------------------------------
	
	internal static const DEFAULT_LABEL:String = "(Unknown)";
	
	private var _label:String = DEFAULT_LABEL;
	
	[Bindable("propertyChange")]
	/**
	 * The text label for the item renderer.
	 */
	public function get label():String
	{
		return _label;
	}
	/**
	 * @private
	 */
	public function set label( value:String ):void
	{
		var oldValue:Object = _label;
		_label = (value ? value : DEFAULT_LABEL);
		
		// Dispatch a property change event to notify the item renderer
		dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "label", oldValue, _label));
	}
	
	//--------------------------------------------------------------------------
	//  Property:  visible
	//--------------------------------------------------------------------------
	
	internal static const DEFAULT_VISIBLE:Boolean = true;
	
	private var _visible:Boolean = DEFAULT_VISIBLE;
	
	[Bindable("propertyChange")]
	/**
	 * Whether the map layer referred to by this TOC item is visible or not.
	 */
	public function get visible():Boolean
	{
		return _visible;
	}
	/**
	 * @private
	 */
	public function set visible( value:Boolean ):void
	{
		setVisible(value, true);
	}
	
	/**
	 * Allows subclasses to change the visible state without causing a layer refresh.
	 */
	internal function setVisible( value:Boolean, layerRefresh:Boolean = true ):void
	{
		if (value != _visible)
		{
			var oldValue:Object = _visible;
			_visible = value;
			
			updateIndeterminateState();
			if (layerRefresh)
			{
				refreshLayer();
			}
			
			// Dispatch a property change event to notify the item renderer
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "visible", oldValue, value));
		}
	}
	
	private function setVisibleDirect( value:Boolean ):void
	{
		if (value != _visible)
		{
			var oldValue:Object = _visible;
			_visible = value;
			
			// Dispatch a property change event to notify the item renderer
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "visible", oldValue, value));
		}
	}
	
	//--------------------------------------------------------------------------
	//  Property:  indeterminate
	//--------------------------------------------------------------------------
	
	internal static const DEFAULT_INDETERMINATE:Boolean = false;
	
	private var _indeterminate:Boolean = DEFAULT_INDETERMINATE;
	
	[Bindable("propertyChange")]
	/**
	 * Whether the visibility of this TOC item is in a mixed state,
	 * based on child item visibility or other criteria.
	 */
	public function get indeterminate():Boolean
	{
		return _indeterminate;
	}
	/**
	 * @private
	 */
	public function set indeterminate( value:Boolean ):void
	{
		if (value != _indeterminate)
		{
			var oldValue:Object = _indeterminate;
			_indeterminate = value;
			
			// Dispatch a property change event to notify the item renderer
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "indeterminate", oldValue, value));
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Whether this TOC item is at the root level.
	 */
	public function isTopLevel():Boolean
	{
		return _parent == null;
	}
	
	/**
	 * Whether this TOC item contains any child items.
	 */
	public function isGroupLayer():Boolean
	{
		return children && children.length > 0;
	}
	
	/**
	 * Updates the indeterminate visibility state of this TOC item.
	 * The default behavior is to call <tt>updateIndeterminateState</tt> on the parent TOC item.
	 * Subclasses can override to perform item-specific logic.
	 */
	internal function updateIndeterminateState( calledFromChild:Boolean = false ):void
	{
		// Inspect the visibility of the children
		var vis:Boolean = false;
		var invis:Boolean = false;
		for each (var item:TocItem in children)
		{
			if (item.indeterminate)
			{
				vis = invis = true;
				break;
			}
			else if (item.visible)
			{
				vis = true;
			}
			else
			{
				invis = true;
			}
		}
		indeterminate = (vis && invis);
		
		// Special case for when children are all shown or all hidden
		if (calledFromChild)
		{
			if (vis && !invis)
			{
				setVisibleDirect(true);
			}
			else if (!vis && invis)
			{
				setVisibleDirect(false);
			}
		}
		
		// Recurse up the tree
		if (parent)
		{
			parent.updateIndeterminateState(true);
		}
	}
	
	/**
	 * Invalidates any map layer that is associated with this TOC item.
	 * The default behavior is to call <tt>refreshMap</tt> on the parent TOC item.
	 * Subclasses can override to perform the actual map/layer invalidation.
	 */
	internal function refreshLayer():void
	{
		// Recurse up the tree
		if (parent)
		{
			parent.refreshLayer();
		}
	}
	
	/**
	 * Cleans up this TOC item instance, when the item is being removed
	 * from the TOC data provider.
	 */
	public function destroy():void
	{
		// Recurse down the tree
		for each (var child:TocItem in children)
		{
			child.destroy();
		}
		
		// Remove references to other tree nodes
		children = null;
		_parent = null;
	}
	
	override public function toString():String
	{
		return ObjectUtil.toString(this);
	}
}

}

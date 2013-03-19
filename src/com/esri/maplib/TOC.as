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
package com.esri.maplib
{
import com.esri.ags.Map;
import com.esri.ags.events.MapEvent;
import com.esri.ags.layers.GraphicsLayer;
import com.esri.ags.layers.Layer;
import com.esri.maplib.tocClasses.TocItem;
import com.esri.maplib.tocClasses.TocItemRenderer;
import com.esri.maplib.tocClasses.TocMapLayerItem;
import com.esri.maplib.utils.MapUtil;

import flash.events.Event;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.controls.Tree;
import mx.core.ClassFactory;
import mx.effects.Effect;
import mx.effects.Fade;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.ListEvent;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 * Specifies the icon for leaf (non-group) layers within a map service.
 */
[Style(name="layerIcon", type="Class", inherit="yes")]

/**
 * Specifies the icon for group layers within a map service.
 */
[Style(name="groupLayerIcon", type="Class", inherit="yes")]

/**
 * Specifies the icon for map service items.
 */
[Style(name="mapServiceIcon", type="Class", inherit="yes")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[IconFile("toc.gif")]

/**
 * A tree-based Table of Contents component for a Map.
 */
public class TOC extends Tree
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Creates a new TOC object.
	 * 
	 * @param map The map that is linked to this TOC.
	 */
	public function TOC( map:Map = null )
	{
		super();
		
		dataProvider = _tocRoots;
		itemRenderer = new ClassFactory(TocItemRenderer);
		iconFunction = tocItemIcon;
		
		this.map = map;
		
		// Double click support for expanding/collapsing tree branches
		doubleClickEnabled = true;
		addEventListener(ListEvent.ITEM_DOUBLE_CLICK, onItemDoubleClick);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	// The tree data provider
	private var _tocRoots:ArrayCollection = new ArrayCollection(); // of TocItem
	private var _mapLayerItems:Dictionary = new Dictionary(); // maps Layer -> TocMapLayerItem
	
	private var _map:Map;
	private var _mapChanged:Boolean = false;
	
	// Layer list filters
	private var _includeLayers:ArrayCollection;
	private var _excludeLayers:ArrayCollection;
	private var _excludeGraphicsLayers:Boolean = false;
	private var _layerFiltersChanged:Boolean = false;
	
	// Label function for TocMapLayerItem
	private var _labelFunction:Function = null;
	private var _labelFunctionChanged:Boolean = false;
	
	private var _hideTopLevelItems:Boolean = false;
	private var _hideTopLevelItemsChanged:Boolean = false;
	
	// The effect used on layer show/hide
	private var _fade:Effect;
	private var _fadeDuration:Number = 250; // milliseconds
	private var _useLayerFadeEffect:Boolean = false;
	private var _useLayerFadeEffectChanged:Boolean = false;
	
	[Embed(source="/assets/layer.png")]
	private static var _layerIcon:Class;
	
	[Embed(source="/assets/group-layer.png")]
	private static var _groupLayerIcon:Class;
	
	[Embed(source="/assets/map-service.png")]
	private static var _mapServiceIcon:Class;
	
	// List of styles that trigger a repaint of the item renderers
	private const IS_ITEM_STYLE:Object =
	{
		layerIcon: true,
		groupLayerIcon: true,
		mapServiceIcon: true
	};
	
	private static var _classConstructed:Boolean = classConstruct();
	
	private static function classConstruct():Boolean
	{
		// Set the default styles for the TOC class
		if (!StyleManager.getStyleDeclaration("TOC"))
		{
			const styles:CSSStyleDeclaration = new CSSStyleDeclaration();
			styles.defaultFactory = function():void
			{
				this.borderStyle = "none";
//				this.layerIcon = _layerIcon;
//				this.groupLayerIcon = _groupLayerIcon;
//				this.mapServiceIcon = _mapServiceIcon;
			}
			StyleManager.setStyleDeclaration("TOC", styles, true);
		}
		return true;
	}
	
	//--------------------------------------------------------------------------
	//  Property:  map
	//--------------------------------------------------------------------------
	
	[Bindable("mapChanged")]
	/**
	 * The Map to which this TOC is attached.
	 */
	public function get map():Map
	{
		return _map;
	}
	/**
	 * @private
	 */
	public function set map( value:Map ):void
	{
		if (value !== _map)
		{
			removeMapListeners();
			_map = value;
			// Note: addMapListeners() is called from commitProperties()
			
			_mapChanged = true;
			invalidateProperties();
			
			dispatchEvent(new Event("mapChanged"));
		}
	}
	
	//--------------------------------------------------------------------------
	//  Property:  includeLayers
	//--------------------------------------------------------------------------
	
	[Bindable("includeLayersChanged")]
	/**
	 * A list of layer objects and/or layer IDs to include in the TOC.
	 */
	public function get includeLayers():Object
	{
		return _includeLayers;
	}
	/**
	 * @private
	 */
	public function set includeLayers( value:Object ):void
	{
		removeLayerFilterListeners(_includeLayers);
		_includeLayers = normalizeLayerFilter(value);
		addLayerFilterListeners(_includeLayers);
		
		onFilterChange();
		
		dispatchEvent(new Event("includeLayersChanged"));
	}
	
	//--------------------------------------------------------------------------
	//  Property:  excludeLayers
	//--------------------------------------------------------------------------
	
	[Bindable("excludeLayersChanged")]
	/**
	 * A list of layer objects and/or layer IDs to exclude from the TOC.
	 */
	public function get excludeLayers():Object
	{
		return _excludeLayers;
	}
	/**
	 * @private
	 */
	public function set excludeLayers( value:Object ):void
	{
		removeLayerFilterListeners(_excludeLayers);
		_excludeLayers = normalizeLayerFilter(value);
		addLayerFilterListeners(_excludeLayers);
		
		onFilterChange();
		
		dispatchEvent(new Event("excludeLayersChanged"));
	}
	
	//--------------------------------------------------------------------------
	//  Property:  excludeGraphicsLayers
	//--------------------------------------------------------------------------
	
	[Bindable]
	[Inspectable(category="Mapping", defaultValue="false")]
	/**
	 * Whether to exclude all GraphicsLayer map layers from the TOC.
	 * 
	 * @default false
	 */
	public function get excludeGraphicsLayers():Boolean
	{
		return _excludeGraphicsLayers;
	}
	/**
	 * @private
	 */
	public function set excludeGraphicsLayers( value:Boolean ):void
	{
		_excludeGraphicsLayers = value;
		
		onFilterChange();
	}
	
	//--------------------------------------------------------------------------
	//  Property:  labelFunction
	//--------------------------------------------------------------------------
	
	/**
	 * A label function for map layers.
	 * 
	 * The function signature must be: <code>labelFunc( layer : Layer ) : String</code>
	 */
	override public function set labelFunction( value:Function ):void
	{
		// CAUTION: We are overriding the semantics and method signature of the 
		//   super Tree's labelFunction, so do not set the super.labelFunction property.
		//
		//   Also, we must reference the function using "_labelFunction" instead of
		//   "labelFunction" since the latter will call the getter method on Tree, 
		//   rather than grabbing this TOC's instance variable.
		
		_labelFunction = value;
		
		_labelFunctionChanged = true;
		invalidateProperties();
	}
	
	//--------------------------------------------------------------------------
	//  Property:  hideTopLevelItems
	//--------------------------------------------------------------------------
	
	[Bindable]
	[Inspectable(category="Mapping", defaultValue="false")]
	/**
	 * Whether the top-level TOC tree nodes (i.e. map service items) should be hidden
	 * from the tree view. If so, then any child layers of the map services will be
	 * arranged as the top-level tree nodes.
	 * 
	 * @default false
	 */
	public function get hideTopLevelItems():Boolean
	{
		return _hideTopLevelItems;
	}
	/**
	 * @private
	 */
	public function set hideTopLevelItems( value:Boolean ):void
	{
		if (value != _hideTopLevelItems)
		{
			_hideTopLevelItems = value;
			
			_hideTopLevelItemsChanged = true;
			invalidateProperties();
		}
	}
	
	//--------------------------------------------------------------------------
	//  Property:  useLayerFadeEffect
	//--------------------------------------------------------------------------
	
	[Bindable("useLayerFadeEffectChanged")]
	[Inspectable(category="Mapping", defaultValue="false")]
	/**
	 * Whether to use a Fade effect when the map layers are shown or hidden.
	 * 
	 * @default false
	 */
	public function get useLayerFadeEffect():Boolean
	{
		return _useLayerFadeEffect;
	}
	/**
	 * @private
	 */
	public function set useLayerFadeEffect( value:Boolean ):void
	{
		if (value != _useLayerFadeEffect)
		{
			_useLayerFadeEffect = value;
			
			_useLayerFadeEffectChanged = true;
			invalidateProperties();
			
			dispatchEvent(new Event("useLayerFadeEffectChanged"));
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override public function styleChanged( styleProp:String ):void
	{
		if (IS_ITEM_STYLE[styleProp])
		{
			itemsSizeChanged = true;
			invalidateDisplayList();
		}
		
		super.styleChanged(styleProp);
	}
	
	/**
	 * @private
	 */
	override protected function commitProperties():void
	{
		super.commitProperties();
		
		if (_mapChanged)
		{
			addMapListeners();
		}
		
		if (_mapChanged ||
			_layerFiltersChanged ||
			_labelFunctionChanged ||
			_hideTopLevelItemsChanged
		)
		{
			_mapChanged = false;
			_layerFiltersChanged = false;
			_labelFunctionChanged = false;
			_hideTopLevelItemsChanged = false;
			
			// Repopulate the TOC data provider
			registerAllMapLayers();
		}
		
		if (_useLayerFadeEffectChanged)
		{
			_useLayerFadeEffectChanged = false;
			
			MapUtil.forEachMapLayer(map, function( layer:Layer ):void
			{
				setLayerFadeEffect(layer);
			});
		}
	}
	
	private function addMapListeners():void
	{
		if (map)
		{
			map.addEventListener(MapEvent.LAYER_ADD, onLayerAdd, false, 0, true);
			map.addEventListener(MapEvent.LAYER_REMOVE, onLayerRemove, false, 0, true);
			map.addEventListener(MapEvent.LAYER_REMOVE_ALL, onLayerRemoveAll, false, 0, true);
			map.addEventListener(MapEvent.LAYER_REORDER, onLayerReorder, false, 0, true);
		}
	}
	
	private function removeMapListeners():void
	{
		if (map)
		{
			map.removeEventListener(MapEvent.LAYER_ADD, onLayerAdd);
			map.removeEventListener(MapEvent.LAYER_REMOVE, onLayerRemove);
			map.removeEventListener(MapEvent.LAYER_REMOVE_ALL, onLayerRemoveAll);
			map.removeEventListener(MapEvent.LAYER_REORDER, onLayerReorder);
		}
	}
	
	/**
	 * Registers the new map layer in the TOC tree.
	 */
	private function onLayerAdd( event:MapEvent ):void
	{
		registerMapLayer(event.layer);
	}
	
	private function onLayerRemove( event:MapEvent ):void
	{
		unregisterMapLayer(event.layer);
	}
	
	private function onLayerRemoveAll( event:MapEvent ):void
	{
		unregisterAllMapLayers();
	}
	
	private function onLayerReorder( event:MapEvent ):void
	{
		var layer:Layer = event.layer;
		var index:int = event.index;
		
		// TODO: fix this function, making sure to handle hideTopLevelItems property
		for (var i:int = 0; i < _tocRoots.length; i++)
		{
			var item:TocItem = _tocRoots[i];
//			if (item is TocMapLayerItem && TocMapLayerItem(item).layer === layer)
//			{
//				_tocRoots.removeItemAt(i);
//				_tocRoots.addItemAt(item, _tocRoots.length - index - 1);
//				break;
//			}
		}
	}
	
	private function unregisterAllMapLayers():void
	{
		// Clean up the current data provider items
		for each (var item:TocItem in _mapLayerItems)
		{
			item.destroy();
		}
		
		// Reset the data provider
		_tocRoots.removeAll();
		_mapLayerItems = new Dictionary();
	}
	
	private function unregisterMapLayer( layer:Layer ):void
	{
		const mapLayerItem:TocMapLayerItem = _mapLayerItems[layer];
		if (mapLayerItem)
		{
			// This loop gracefully handles removing root tree nodes,
			// regardless of the value of hideTopLevelItems.
			for (var i:int = _tocRoots.length - 1; i >= 0; i--)
			{
				var rootItem:TocItem = _tocRoots[i];
				if (rootItem === mapLayerItem || rootItem.parent === mapLayerItem)
				{
					_tocRoots.removeItemAt(i);
				}
			}
			
			mapLayerItem.destroy();
			delete _mapLayerItems[layer];
		}
	}
	
	/**
	 * Registers all existing map layers in the TOC tree.
	 */
	private function registerAllMapLayers():void
	{
		unregisterAllMapLayers();
		
		MapUtil.forEachMapLayer(map, function( layer:Layer ):void
		{
			registerMapLayer(layer);
		});
	}
	
	/**
	 * Creates a new top-level TOC item for the specified map layer.
	 */
	private function registerMapLayer( layer:Layer ):void
	{
		if (filterOutLayer(layer))
		{
			//trace("Filtering out TOC layer '" + layer.id + "'");
			return;
		}
		
		// Init any layer properties, styles, and effects
		if (useLayerFadeEffect)
		{
			setLayerFadeEffect(layer);
		}
		
		// Add a new top-level TOC item at the beginning of the list (reverse rendering order)
		var tocItem:TocMapLayerItem = new TocMapLayerItem(layer, _labelFunction, hideTopLevelItems ? _tocRoots : null);
		_mapLayerItems[layer] = tocItem;
		if (!hideTopLevelItems)
		{
			_tocRoots.addItemAt(tocItem, 0);
		}
		
		//trace("Adding TOC layer '" + layer.id + "' as '" + tocItem.label + "'");
	}
	
	private function setLayerFadeEffect( layer:Layer ):void
	{
		if (useLayerFadeEffect)
		{
			// Lazy load the effect
			if (!_fade)
			{
				_fade = new Fade();
				_fade.duration = _fadeDuration;
			}
			layer.setStyle("showEffect", _fade);
			layer.setStyle("hideEffect", _fade);
		}
		else
		{
			layer.clearStyle("showEffect");
			layer.clearStyle("hideEffect");
		}
	}
	
	private function addLayerFilterListeners( filter:ArrayCollection ):void
	{
		if (filter)
		{
			filter.addEventListener(CollectionEvent.COLLECTION_CHANGE, onFilterChange, false, 0, true);
		}
	}
	
	private function removeLayerFilterListeners( filter:ArrayCollection ):void
	{
		if (filter)
		{
			filter.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onFilterChange);
		}
	}
	
	private function onFilterChange( event:CollectionEvent = null ):void
	{
		var isValidChange:Boolean = false;
		
		if (event == null)
		{
			// Called directly from the setters
			isValidChange = true;
		}
		else
		{
			// Only act on certain kinds of collection changes.
			//  Specifically, avoid acting on the UPDATE kind.
			//   It causes unwanted refresh of the TOC model.
			switch (event.kind)
			{
				case CollectionEventKind.ADD:
				case CollectionEventKind.REMOVE:
				case CollectionEventKind.REPLACE:
				case CollectionEventKind.REFRESH:
				case CollectionEventKind.RESET:
					isValidChange = true;
					break;
			}
		}
		
		if (isValidChange)
		{
			_layerFiltersChanged = true;
			invalidateProperties();
		}
	}
	
	private function filterOutLayer( layer:Layer ):Boolean
	{
		var exclude:Boolean = false;
		if (excludeGraphicsLayers && layer is GraphicsLayer)
		{
			exclude = true;
		}
		if (!exclude && excludeLayers)
		{
			exclude = false;
			for each (var item:* in excludeLayers)
			{
				if (item === layer || item == layer.id)
				{
					exclude = true;
					break;
				}
			}
		}
		if (includeLayers)
		{
			exclude = true;
			for each (item in includeLayers)
			{
				if (item === layer || item == layer.id)
				{
					exclude = false;
					break;
				}
			}
		}
		return exclude;
	}
	
	private function normalizeLayerFilter( value:Object ):ArrayCollection
	{
		var filter:ArrayCollection;
		if (value is ArrayCollection)
		{
			filter = value as ArrayCollection;
		} 
		else if (value is Array)
		{
			filter = new ArrayCollection(value as Array);
		}
		else if (value is String || value is Layer)
		{
			// Possibly a String (layer id) or Layer object
			filter = new ArrayCollection([value]);
		}
		else
		{
			// Unsupported value type
			filter = null;
		}
		return filter;
	}
	
	/**
	 * Double click handler for expanding or collapsing a tree branch.
	 */
	private function onItemDoubleClick( event:ListEvent ):void
	{
		if (event.itemRenderer && event.itemRenderer.data)
		{
			const item:Object = event.itemRenderer.data;
			expandItem(item, !isItemOpen(item), true, true, event);
		}
	}
	
	private function tocItemIcon( item:Object ):Class
	{
		if (item is TocMapLayerItem)
		{
			return chooseIcon(getStyle("mapServiceIcon"), _mapServiceIcon);
		}
		if (item is TocItem)
		{
			return TocItem(item).isGroupLayer()
				? chooseIcon(getStyle("groupLayerIcon"), _groupLayerIcon)
				: chooseIcon(getStyle("layerIcon"), _layerIcon);
		}
		return chooseIcon(getStyle("layerIcon"), _layerIcon);
	}
	
	private function chooseIcon( userDefined:*, defaultIcon:* ):*
	{
		return (userDefined !== undefined) ? userDefined : defaultIcon;
	}
}

}

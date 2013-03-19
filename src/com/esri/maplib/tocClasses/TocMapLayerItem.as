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
import com.esri.ags.events.LayerEvent;
import com.esri.ags.layers.ArcGISDynamicMapServiceLayer;
import com.esri.ags.layers.ArcGISTiledMapServiceLayer;
import com.esri.ags.layers.ArcIMSMapServiceLayer;
import com.esri.ags.layers.Layer;

import com.esri.ags.layers.supportClasses.LayerInfo;
import com.esri.maplib.utils.MapUtil;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;

/**
 * A TOC item representing a map service or graphics layer.
 */
public class TocMapLayerItem extends TocItem
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	public function TocMapLayerItem( layer:Layer, labelFunction:Function = null, addChildrenAsTocRoots:ArrayCollection = null )
	{
		super();
		
		_layer = layer;
		_tocRoots = addChildrenAsTocRoots;
		addLayerListeners();
		
		// Whether the visible layer list uses LayerInfo.name instead of LayerInfo.id
		// ArcIMS requires layer names, whereas ArcGIS Server requires layer IDs
		_usingLayerInfoName = (layer is ArcIMSMapServiceLayer);
		
		// Set the initial visibility without causing a layer refresh
		setVisible(layer.visible, false);
		
		if (labelFunction == null)
		{
			// Default label function
			labelFunction = MapUtil.labelLayer;
		}
		_labelFunction = labelFunction;
		label = labelFunction(layer);
		
		if (layer.loaded)
		{
			// Process the layer info immediately
			createChildren();
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	private var _layer:Layer;
	private var _labelFunction:Function;
	private var _tocRoots:ArrayCollection;
	private var _usingLayerInfoName:Boolean;
	
	//--------------------------------------------------------------------------
	//  Property:  mapLayer
	//--------------------------------------------------------------------------
	
	/**
	 * The map layer to which this TOC item is attached.
	 */
	public function get layer():Layer
	{
		return _layer;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override internal function updateIndeterminateState( calledFromChild:Boolean = false ):void
	{
		indeterminate = DEFAULT_INDETERMINATE;
		
		// Recurse up the tree
		if (parent)
		{
			parent.updateIndeterminateState(true);
		}
	}
	
	/**
	 * @private
	 */
	override internal function refreshLayer():void
	{
		layer.visible = visible;
		
		var visLayers:Array = [];
		for each (var child:TocItem in children)
		{
			accumVisibleLayers(child, visLayers);
		}
		
		if (layer is ArcGISDynamicMapServiceLayer)
		{
			// Bug #NIM040263
			//
			// If all map service layers are turned OFF (e.g. using the TOC), 
			// then AGS 9.3 Java incorrectly assumes that all layers should be turned ON.
			// The workaround is to send an invalid layer ID (-1) as the only visible layer, 
			// thereby causing the server to return a blank/transparent map image, as intended.
			// This fix works for both AGS Java and AGS .NET, even though the bug is only
			// evident in AGS Java.
			//
			if (visLayers.length == 0)
			{
				var nonExistentLayerId:Number = -1;
				visLayers.push(nonExistentLayerId);
			}
			
			ArcGISDynamicMapServiceLayer(layer).visibleLayers = new ArrayCollection(visLayers);
		}
		else if (layer is ArcIMSMapServiceLayer)
		{
			ArcIMSMapServiceLayer(layer).visibleLayers = new ArrayCollection(visLayers);
		}
	}
	
	private function accumVisibleLayers( item:TocItem, accum:Array ):void
	{
		if (item.isGroupLayer())
		{
			// Don't include group layer IDs in the visible layer list, since the ArcGIS REST API
			// implicitly turns on all child layers when the group layer is visible. This goes
			// counter to what most users have come to expect from apps, e.g. ArcMap.
			for each (var child:TocItem in item.children)
			{
				accumVisibleLayers(child, accum);
			}
		}
		else  // Leaf layer
		{
			if (item.visible)
			{
				if (item is TocLayerInfoItem)
				{
					var layer:TocLayerInfoItem = TocLayerInfoItem(item);
					accum.push(_usingLayerInfoName ? layer.layerInfo.name : layer.layerInfo.id);
				}
			}
		}
	}
	
	private function addLayerListeners():void
	{
		if (layer)
		{
			// Listen for future layer load events.
			// We use a negative event priority to allow user code to modify
			// the layer's layerInfos objects (e.g. LayerInfo.name) before
			// we generate tree node labels from LayerInfo.  This is useful
			// for customizing the labels of LayerInfo-based tree nodes.
			layer.addEventListener(LayerEvent.LOAD, onLayerLoad, false, -1, true);
			
			// Listen for changes in layer visibility
			layer.addEventListener(FlexEvent.SHOW, onLayerShow, false, 0, true);
			layer.addEventListener(FlexEvent.HIDE, onLayerHide, false, 0, true);
		}
	}
	
	private function removeLayerListeners():void
	{
		if (layer)
		{
			layer.removeEventListener(LayerEvent.LOAD, onLayerLoad);
			layer.removeEventListener(FlexEvent.SHOW, onLayerShow);
			layer.removeEventListener(FlexEvent.HIDE, onLayerHide);
		}
	}
	
	private function onLayerLoad( event:LayerEvent ):void
	{
		// Relabel this item, since map layer URL or service name might have changed.
		label = _labelFunction(layer);
		
		createChildren();
	}
	
	private function onLayerShow( event:FlexEvent ):void
	{
		setVisible(layer.visible, false);
	}
	
	private function onLayerHide( event:FlexEvent ):void
	{
		setVisible(layer.visible, false);
	}
	
	/**
	 * Populates this item's children collection based on any layer info
	 * of the map service.
	 */
	private function createChildren():void
	{
		removeAllChildren();
		
		var layerInfos:Array;  // of LayerInfo
		var visibleLayers:ArrayCollection;  // of Number or String
		
		if (layer is ArcGISTiledMapServiceLayer)
		{
			layerInfos = ArcGISTiledMapServiceLayer(layer).layerInfos;
			visibleLayers = ArcGISTiledMapServiceLayer(layer).visibleLayers;
		}
		else if (layer is ArcGISDynamicMapServiceLayer)
		{
			layerInfos = ArcGISDynamicMapServiceLayer(layer).layerInfos;
			visibleLayers = ArcGISDynamicMapServiceLayer(layer).visibleLayers;
		}
		else if (layer is ArcIMSMapServiceLayer)
		{
			layerInfos = ArcIMSMapServiceLayer(layer).layerInfos;
			visibleLayers = ArcIMSMapServiceLayer(layer).visibleLayers;
		}
		
		if (layerInfos)
		{
			var rootLayers:Array = findRootLayers(layerInfos);
			for each (var layerInfo:LayerInfo in rootLayers)
			{
				addChild( createTocLayer(this, layerInfo, layerInfos, visibleLayers) );
			}
		}
	}
	
	override internal function addChild( item:TocItem ):void
	{
		super.addChild(item);
		
		// If hideTopLevelItems == true
		if (_tocRoots)
		{
			_tocRoots.addItem(item);
		}
	}
	
	private function removeAllChildren():void
	{
		children = null;
		
		// If hideTopLevelItems == true
		if (_tocRoots)
		{
			for (var i:int = _tocRoots.length - 1; i >= 0; i--)
			{
				if (TocItem(_tocRoots[i]).parent === this)
				{
					_tocRoots.removeItemAt(i);
				}
			}
		}
	}
	
	override public function destroy():void
	{
		super.destroy();
		
		removeLayerListeners();
		removeAllChildren();
		_tocRoots = null;
	}
	
	private function createTocLayer( parentItem:TocItem, layerInfo:com.esri.ags.layers.supportClasses.LayerInfo, layerInfos:Array, visibleLayers:ArrayCollection ):TocLayerInfoItem
	{
		// Determine if the layer is currently visible, based on default visibility and user-defined visibility
		var isLayerVisible:Boolean;
		if (visibleLayers)
		{
			isLayerVisible = visibleLayers.contains(_usingLayerInfoName ? layerInfo.name : layerInfo.id);
		}
		else
		{
			isLayerVisible = layerInfo.defaultVisibility;
		}
		
		var item:TocLayerInfoItem = new TocLayerInfoItem(parentItem, layerInfo, isLayerVisible);
		
		// Handle any sublayers of a group layer
		if (layerInfo.subLayerIds)
		{
			for each (var childId:Number in layerInfo.subLayerIds)
			{
				var childLayer:LayerInfo = findLayerById(childId, layerInfos);
				if (childLayer)
				{
					item.addChild( createTocLayer(item, childLayer, layerInfos, visibleLayers) );
				}
			}
		}
		
		return item;
	}
	
	private static function findRootLayers( layerInfos:Array ):Array  // of LayerInfo
	{
		var roots:Array = [];
		for each (var layerInfo:LayerInfo in layerInfos)
		{
			// ArcGIS: parentLayerId is -1
			// ArcIMS: parentLayerId is NaN
			if (isNaN(layerInfo.parentLayerId) || layerInfo.parentLayerId == -1)
			{
				roots.push(layerInfo);
			}
		}
		return roots;
	}
	
	private static function findLayerById( id:Number, layerInfos:Array ):LayerInfo
	{
		for each (var layerInfo:LayerInfo in layerInfos)
		{
			if (id == layerInfo.id)
			{
				return layerInfo;
			}
		}
		return null;
	}
}

}

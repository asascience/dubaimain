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
package com.esri.viewer.components
{
import com.esri.ags.Map;

import flash.events.Event;

import mx.containers.Accordion;
import mx.containers.Canvas;
import mx.core.ClassFactory;
import mx.core.IFactory;
import com.esri.viewer.components.toc.TOC;

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
 * An accordion-based Table of Contents component for a Map.
 * 
 * Map service layers can be grouped into categories. Each tab of
 * the accordion displays a category label and a TOC instance
 * containing only the map layers belonging to its category.
 */
public class TOCAccordion extends Accordion
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Creates a new Accordion TOC object.
	 * 
	 * @param map The map that is linked to this TOC.
	 * @param categories The groups of map layers.
	 */
	public function TOCAccordion( map:Map = null, categories:Array = null )
	{
		super();
		
		this.map = map;
		this.categories = categories;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	// The label to use when no categories are configured
	private static const DEFAULT_CATEGORY_LABEL:String = "Map Layers";
	
	// The current child TOC components
	[Bindable]
	public var _childTocs:Array;
	
	// A factory for creating child TOC instances
	private var _tocFactory:IFactory = null;
	private var _defaultTocFactory:IFactory = new ClassFactory(TOC);
	private var _tocFactoryChanged:Boolean = false;
	
	private var _categories:Array;
	private var _categoriesChanged:Boolean = false;
	
	// Local storage of underlying TOC properties
	private var _map:Map = null;
	private var _labelFunction:Function = null;
	private var _hideTopLevelItems:Boolean = false;
	private var _showDataTips:Boolean = false;
	private var _useLayerFadeEffect:Boolean = false;
	
	
	//--------------------------------------------------------------------------
	//  Property:  map
	//--------------------------------------------------------------------------
	
	[Bindable]
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
		_map = value;
		
		// Propagate this property to child TOC components
		for each (var toc:TOC in _childTocs)
		{
			toc.map = _map;
		}
	}
	
	//--------------------------------------------------------------------------
	//  Property:  categories
	//--------------------------------------------------------------------------
	
	[Bindable("categoriesChanged")]
	/**
	 * The category model, containing labels and layer groups.
	 */
	public function get categories():Array
	{
		return _categories;
	}
	/**
	 * @private
	 */
	public function set categories( value:Array ):void
	{
		_categories = value;
		
		_categoriesChanged = true;
		invalidateProperties();
		
		dispatchEvent(new Event("categoriesChanged"));
	}
	
	//--------------------------------------------------------------------------
	//  Property:  labelFunction
	//--------------------------------------------------------------------------
	
	/**
	 * A label function for map layers.
	 * 
	 * The function signature must be: <code>labelFunc( layer : Layer ) : String</code>
	 */
	public function get labelFunction():Function
	{
		return _labelFunction;
	}
	/**
	 * @private
	 */
	public function set labelFunction( value:Function ):void
	{
		_labelFunction = value;
		
		// Propagate this property to child TOC components
		for each (var toc:TOC in _childTocs)
		{
			toc.labelFunction = _labelFunction;
		}
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
		_hideTopLevelItems = value;
		
		// Propagate this property to child TOC components
		for each (var toc:TOC in _childTocs)
		{
			//toc.hideTopLevelItems = _hideTopLevelItems;
			
		}
	}
	
	//--------------------------------------------------------------------------
	//  Property:  showDataTips
	//--------------------------------------------------------------------------
	
	[Bindable]
	[Inspectable(category="Mapping", defaultValue="false")]
	/**
	 * A flag that indicates whether dataTips are displayed for text in the rows.
	 * 
	 * @see mx.controls.listClasses.ListBase
	 * @default false
	 */
	public function get showDataTips():Boolean
	{
		return _showDataTips;
	}
	/**
	 * @private
	 */
	public function set showDataTips( value:Boolean ):void
	{
		_showDataTips = value;
		
		// Propagate this property to child TOC components
		for each (var toc:TOC in _childTocs)
		{
			toc.showDataTips = _showDataTips;
		}
	}
	
	//--------------------------------------------------------------------------
	//  Property:  useLayerFadeEffect
	//--------------------------------------------------------------------------
	
	[Bindable]
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
		_useLayerFadeEffect = value;
		
		// Propagate this property to child TOC components
		for each (var toc:TOC in _childTocs)
		{
			toc.useLayerFadeEffect = _useLayerFadeEffect;
		}
	}
	
	//--------------------------------------------------------------------------
	//  Property: tocFactory
	//--------------------------------------------------------------------------
	
	/**
	 * A factory for creating and customizing new TOC instances.
	 */
	public function get tocFactory():IFactory
	{
		return _tocFactory;
	}
	/**
	 * @private
	 */
	public function set tocFactory( value:IFactory ):void
	{
		_tocFactory = value;
		
		_tocFactoryChanged = true;
		invalidateProperties();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	override protected function commitProperties():void
	{
		super.commitProperties();
		
		if (_categoriesChanged || _tocFactoryChanged)
		{
			_categoriesChanged = false;
			_tocFactoryChanged = false;
			
			// Clear any existing accordion tabs
			var lastSelectedIndex:int = selectedIndex;
			_childTocs = null;
			removeAllChildren();
			
			if (categories)
			{
				// Add a new tab for each category
				for each (var category:Object in categories)
				{
					addCategory(category.label, category.layers);
				}
			}
			else
			{
				// Add a default tab with all layers
				addCategory(DEFAULT_CATEGORY_LABEL, null);
			}
			
			// Restore the previously selected accordion tab
			selectedIndex = lastSelectedIndex;
		}
	}
	
	private function addCategory( label:String, layers:Object ):void
	{
		trace("add Category");
		trace(label);
		trace(layers);
		
		var toc:TOC = (tocFactory ? tocFactory.newInstance() : _defaultTocFactory.newInstance());
		
		toc.percentWidth = 100;
		toc.percentHeight = 100;
		toc.map = map;
		toc.includeLayers = layers;
		toc.labelFunction = _labelFunction;
		toc.variableRowHeight = true;
		toc.liveScrolling = true;		
		toc.useLayerFadeEffect = useLayerFadeEffect;
		toc.showDataTips = showDataTips;
		toc.excludeGraphicsLayers = false;
		
		var box:Canvas = new Canvas();
		box.width = 100;
		box.height = 100;
		box.label = label;
		box.addChild(toc);
		
		this.addChild(box);
		
		// Store a reference to this TOC
		if (!_childTocs)
		{
			_childTocs = [];
		}
		_childTocs.push(toc);
	}
}

}

////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2010 ESRI
//
// All rights reserved under the copyright laws of the United States.
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  See use restrictions in the file:
// <install location>/License.txt
//
////////////////////////////////////////////////////////////////////////////////
package widgets.TOC.toc.tocClasses
{

	import com.esri.ags.layers.Layer;
	import com.esri.ags.layers.TiledMapServiceLayer;
	import com.esri.viewer.ViewerContainer;
	import widgets.TOC.toc.controls.CheckBoxScaleDependant;
	import widgets.TOC.toc.layerAlpha;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.controls.treeClasses.TreeListData;
	
	import spark.components.HSlider;
	
	/**
	 * A custom tree item renderer for a map Table of Contents.
	 */
	public class TocItemRenderer extends TreeItemRenderer
	{
	    // Renderer UI components
		private var _checkbox:CheckBoxScaleDependant;
		
		private var _btn:Image;
		
		private var _layAlpha:layerAlpha
	
	    // UI component spacing
	    private static const PRE_CHECKBOX_GAP:Number = 5;
	
	    private static const POST_CHECKBOX_GAP:Number = 4;
		
		[Embed(source="widgets/TOC/assets/images/alpha.png")]
		[Bindable]
		private var _Icon:Class;
		
		private function showAlpha(evt:Event):void
		{
			if (data is TocItem) {
				var item:TocItem = TocItem(data);
				var lay:Layer = ViewerContainer.getInstance().mapManager.map.getLayer(item.label);
				_layAlpha.layer = lay;
				_layAlpha.visible = true;
				_layAlpha.includeInLayout = true;
				label.visible = false;
			}
		}
		
		private function sldrDataTipFormatter(value:Number):String 
		{ 
			return int(value * 100) + "%"; 
		}
	
	    /**
	     * @private
	     */
	    override protected function createChildren():void
	    {
	        super.createChildren();
	
	        // Create a checkbox child component for toggling layer visibility.
	        if (!_checkbox)
	        {
	            _checkbox = new CheckBoxScaleDependant();
	            _checkbox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
	            _checkbox.addEventListener(MouseEvent.DOUBLE_CLICK, onCheckBoxDoubleClick);
	            _checkbox.addEventListener(MouseEvent.MOUSE_DOWN, onCheckBoxMouseDown);
	            _checkbox.addEventListener(MouseEvent.MOUSE_UP, onCheckBoxMouseUp);
	            addChild(_checkbox);
	        }
			if (!_btn)
			{
				_btn = new Image();
				_btn.id = "btnAlpha"
				_btn.toolTip = "Set Map Layer Transparency";
				_btn.width = 20;
				_btn.height = 20;
				_btn.alpha = 0.6;
				_btn.buttonMode = true;
				_btn.useHandCursor = true;
				_btn.source = _Icon;
				_btn.visible = false;
				_btn.includeInLayout = false;
				addChild(_btn);
				_btn.addEventListener(MouseEvent.CLICK, showAlpha);
			}
			if(!_layAlpha)
			{
				_layAlpha = new layerAlpha();
				_layAlpha.visible = false;
				_layAlpha.includeInLayout = false;
				label.visible = true;
				addChild(_layAlpha);
			}
	    }
	
	    /**
	     * @private
	     */
	    override protected function commitProperties():void
	    {
	        super.commitProperties();
	
	        if (data is TocItem)
	        {
	            var item:TocItem = TocItem(data);
	
	            // Set the checkbox state
				_checkbox.scaledependant = item.scaledependant;
	            // The indeterminate state has visual priority over the selected state
	            _checkbox.selected = item.visible;
	
	            // Hide the checkbox for child items of tiled map services
	            var checkboxVisible:Boolean = true;
	            if (isTiledLayerChild(item))
	            {
	                checkboxVisible = false;
	            }
	            _checkbox.visible = checkboxVisible;
	
	            // Apply a bold label style to root nodes
				// Apply a bold label style to root nodes
				if (item.isTopLevel())
				{
					setStyle("fontWeight", "bold");
					_btn.visible = true;
					_btn.includeInLayout = true;
				}
				else
				{
					setStyle("fontWeight", "normal");
					_btn.visible = false;
					_btn.includeInLayout = false;
					_layAlpha.visible = false;
					_layAlpha.includeInLayout = false;
				}
	        }
	    }
	
	    /**
	     * @private
	     */
	    override protected function measure():void
	    {
	        super.measure();
	
	        // Add space for the checkbox and gaps
	        if (isNaN(explicitWidth) && !isNaN(measuredWidth))
	        {
	            var w:Number = measuredWidth;
	            w += _checkbox.measuredWidth;
	            w += PRE_CHECKBOX_GAP + POST_CHECKBOX_GAP;
	            measuredWidth = w;
	        }
	    }
	
	    /**
	     * @private
	     */
	    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	    {
	        super.updateDisplayList(unscaledWidth, unscaledHeight);
	
	        var startx:Number = data ? TreeListData(listData).indent : 0;
	        if (icon)
	        {
	            startx = icon.x;
	        }
	        else if (disclosureIcon)
	        {
	            startx = disclosureIcon.x + disclosureIcon.width;
	        }
	        startx += PRE_CHECKBOX_GAP;
	
	        // Position the checkbox between the disclosure icon and the item icon
	        _checkbox.x = startx;
	        _checkbox.setActualSize(_checkbox.measuredWidth, _checkbox.measuredHeight);
	        _checkbox.y = (unscaledHeight - _checkbox.height) / 2;
			_layAlpha.y = (unscaledHeight - _layAlpha.height) / 2;
			if(_layAlpha.visible == false)
				label.visible = true;
			_btn.y = (unscaledHeight - _btn.height) / 2;
	        startx = _checkbox.x + _checkbox.width + POST_CHECKBOX_GAP;
	
	        if (icon)
	        {
	            icon.x = startx;
	            startx = icon.x + icon.width;
	        }
	
	        label.x = startx;
			_layAlpha.x = label.x - 8;
	        label.setActualSize(unscaledWidth - startx, measuredHeight);
			_btn.x = label.x + label.width - 27;
	    }
	
	    /**
	     * Whether the specified TOC item is a child of a tiled map service layer.
	     */
	    private function isTiledLayerChild(item:TocItem):Boolean
	    {
	        while (item)
	        {
	            item = item.parent;
	            if (item is TocMapLayerItem)
	            {
	                if (TocMapLayerItem(item).layer is TiledMapServiceLayer)
	                {
	                    return true;
	                }
	            }
	        }
	        return false;
	    }
	
	    /**
	     * Updates the visible property of the underlying TOC item.
	     */
	    private function onCheckBoxClick(event:MouseEvent):void
	    {
	        event.stopPropagation();
	
	        if (data is TocItem)
	        {
	            var item:TocItem = TocItem(data);
	            item.visible = _checkbox.selected;
	        }
	    }
	
	    private function onCheckBoxDoubleClick(event:MouseEvent):void
	    {
	        event.stopPropagation();
	    }
	
	    private function onCheckBoxMouseDown(event:MouseEvent):void
	    {
	        event.stopPropagation();
	    }
	
	    private function onCheckBoxMouseUp(event:MouseEvent):void
	    {
	        event.stopPropagation();
	    }
	}
}
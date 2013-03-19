////////////////////////////////////////////////////////////////////////////////
//
// Copyright � 2008 ESRI
//
// All rights reserved under the copyright laws of the United States.
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  See use restrictions in the file:
// <install location>/FlexViewer/License.txt
//
////////////////////////////////////////////////////////////////////////////////

package com.esri.viewer.components.toc.tocClasses
{
	
	import com.esri.ags.events.ExtentEvent;
	import com.esri.ags.layers.supportClasses.LayerInfo;
	import com.esri.viewer.ViewerContainer;
	
	/**
	 * A TOC item representing a member layer of an ArcGIS or ArcIMS map service.
	 * This includes group layers that contain other member layers.
	 */
	public class TocLayerInfoItem extends TocItem
	{
		public function TocLayerInfoItem( parentItem:TocItem, layerInfo:LayerInfo)
		{
			super(parentItem);
			
			_layerInfo = layerInfo;
			
			label = layerInfo.name;
			
			// Set the initial visibility without causing a layer refresh
			setVisible(layerInfo.defaultVisibility, false);
			
			ViewerContainer.getInstance().mapManager.map.addEventListener(ExtentEvent.EXTENT_CHANGE,checkExtent);
		}
		
		internal static const DEFAULT_MAX:Number = 0;
		
		private var _maxScale:Number = DEFAULT_MAX;
		
		public function set maxScale( value:Number ):void
		{
			_maxScale = value;
			this.scaledependant = true;
			
			if (_maxScale > 0 ){
				if ((ViewerContainer.getInstance().mapManager.map.scale >= _maxScale)){
					this.scaledependant = false;
				}
			} else if (_minScale > 0 ) {
				if ((ViewerContainer.getInstance().mapManager.map.scale <= _minScale)){
					this.scaledependant = false;
				}
			} else {
				this.scaledependant = false;
			}
		}
		
		public function get maxScale():Number
		{
			return _maxScale;
		}
		
		private function checkExtent(evt:ExtentEvent):void{
			this.scaledependant = true;
			if (_maxScale > 0 ){
				if ((ViewerContainer.getInstance().mapManager.map.scale >= _maxScale)){
					this.scaledependant = false;
				}
			} else if (_minScale > 0 ) {
				if ((ViewerContainer.getInstance().mapManager.map.scale <= _minScale)){
					this.scaledependant = false;
				}
			} else {
				this.scaledependant = false;
			}
		}
		
		internal static const DEFAULT_MIN:Number = 0;
		
		private var _minScale:Number = DEFAULT_MIN;
		
		public function set minScale( value:Number ):void
		{
			_minScale = value;
			this.scaledependant = true;
			
			if (_maxScale > 0 ){
				if ((ViewerContainer.getInstance().mapManager.map.scale >= _maxScale)){
					this.scaledependant = false;
				}
			} else if (_minScale > 0 ) {
				if ((ViewerContainer.getInstance().mapManager.map.scale <= _minScale)){
					this.scaledependant = false;
				}
			} else {
				this.scaledependant = false;
			}
		}
		
		public function get minScale():Number
		{
			return _minScale;
		}
		
		//--------------------------------------------------------------------------
		//  Property:  layerInfo
		//--------------------------------------------------------------------------
		
		private var _layerInfo:LayerInfo;
		
		/**
		 * The map layer info that backs this TOC item.
		 */
		public function get layerInfo():LayerInfo
		{
			return _layerInfo;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override internal function setVisible( value:Boolean, layerRefresh:Boolean = true ):void
		{
			// Set the visible state of all children, but defer the layer refresh
			for each (var item:TocItem in children) {
				item.setVisible(value, false);
			}
			
			// Set the visible state of this item, but defer the layer refresh
			super.setVisible(value, false);
			
			// Allow the layer refresh now that all changes have been made
			if (layerRefresh) {
				refreshLayer();
			}
		}
	}

}

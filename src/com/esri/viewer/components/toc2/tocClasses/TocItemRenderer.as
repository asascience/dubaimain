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
package com.esri.viewer.components.toc.tocClasses
{	
	import com.esri.ags.layers.ArcGISDynamicMapServiceLayer;
	import com.esri.ags.layers.ArcGISTiledMapServiceLayer;
	import com.esri.ags.layers.ArcIMSMapServiceLayer;
	import com.esri.ags.layers.TiledMapServiceLayer;
	import com.esri.ags.utils.JSON;
	import com.esri.viewer.IFrame;
	import com.esri.viewer.components.toc.controls.CheckBoxIndeterminate;
	import com.google.code.flexiframe.IFrame;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	
	import mx.containers.Canvas;
	import mx.containers.TabNavigator;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.controls.Text;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.controls.treeClasses.TreeListData;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	import spark.components.Panel;
	import spark.components.TextArea;
	import spark.components.TitleWindow;
	
	/**
	 * A custom tree item renderer for a map Table of Contents.
	 */
	public class TocItemRenderer extends TreeItemRenderer
	{
		// Renderer UI components
		private var _checkbox:CheckBoxIndeterminate;
		
		//private var _btn:Image;
		private var info:TitleWindow;
		
		// UI component spacing
		private static const PRE_CHECKBOX_GAP:Number = 5;
		private static const POST_CHECKBOX_GAP:Number = 4;
		
		//RS//Icon we will use for the button
		//[Embed(source="assets/images/toc/metadata.png")]
		//[Bindable]
		//private var _Icon:Class;
		
		/**
		 * @private
		 */
		override protected function createChildren():void
		{
			super.createChildren();
						
			// Create a checkbox child component for toggling layer visibility.
			if (!_checkbox) {
				_checkbox = new CheckBoxIndeterminate();
				_checkbox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
				_checkbox.addEventListener(MouseEvent.DOUBLE_CLICK, onCheckBoxDoubleClick);
				_checkbox.addEventListener(MouseEvent.MOUSE_DOWN, onCheckBoxMouseDown);
				_checkbox.addEventListener(MouseEvent.MOUSE_UP, onCheckBoxMouseUp);
				addChild(_checkbox);
			}
			
			//RS//This is where we add the metadata button
			//_btn = new Image();
			//_btn.id = "btnMeta"
			//_btn.toolTip = "Get MetaData";
			//_btn.width = 20;
			//_btn.height = 20;
			//_btn.buttonMode = true;
			//_btn.useHandCursor = true;
			//RS//use the icon that we embeded above
			////un commment for metadata icon
			//_btn.source = _Icon;
			//addChild(_btn);
			//RS//Addthe function that will be called when the button is clicked
			//_btn.addEventListener(MouseEvent.CLICK, showMeta);
		}
		
		private function showMeta(evt:Event):void
		{
			if (data is TocItem) {
				var item:TocItem = TocItem(data);
				var lUrl:String = "";
				var ldesc:String = "";
				var lId:String = "";
				//RS//This is to get the mapservice layer of the leaf in the toc we clicked
				var mlItem:TocMapLayerItem;
				if(item.parent is TocMapLayerItem){
					mlItem = item.parent as TocMapLayerItem;
				} else if (item.parent.parent is TocMapLayerItem) {
					mlItem = item.parent.parent as TocMapLayerItem;
				} else if (item.parent.parent.parent is TocMapLayerItem) {
					mlItem = item.parent.parent.parent as TocMapLayerItem;
				}
				//RS//ensure we clicked on a layer of a map service
				if (item is TocLayerInfoItem)
				{
					var liItem:TocLayerInfoItem = item as TocLayerInfoItem;
					//RS//we need the id of the layer to display the correct htm page for the meatadata
					lId = liItem.layerInfo.id.toString();
					if (mlItem.layer is ArcGISTiledMapServiceLayer) {
						var tLay:ArcGISTiledMapServiceLayer = ArcGISTiledMapServiceLayer(mlItem.layer);
						lUrl = tLay.url;
					} else if (mlItem.layer is ArcGISDynamicMapServiceLayer) {
						var dLay:ArcGISDynamicMapServiceLayer = ArcGISDynamicMapServiceLayer(mlItem.layer);
						lUrl = dLay.url;
					} else if (mlItem.layer is ArcIMSMapServiceLayer) {
						var iLay:ArcIMSMapServiceLayer = ArcIMSMapServiceLayer(mlItem.layer);
						lUrl = iLay.serviceName;
					}
				}
				
				var tabs:TabNavigator = new TabNavigator;
				var fram2:com.google.code.flexiframe.IFrame = new com.google.code.flexiframe.IFrame;
				var info:TitleWindow = new TitleWindow;
				PopUpManager.removePopUp(info);
				info.addEventListener(CloseEvent.CLOSE, infoClose);
				info.removeAllElements();
				var alay:String = lUrl+ "/" + lId + "?f=json";
				var des:String = "";
				var img:Image = new Image();
				var pan1:VBox = new VBox;
				info.title = "Layer";
				pan1.label = "Information";
				
				var desctext:TextArea = new TextArea;
				desctext.text = "Info Loading...";
				desctext.width = 400;
				desctext.height = 120;
				
				img.width = 392;
				img.height = 270;
				lUrl = lUrl.replace("/MapServer","");
				
				var ms:String = lUrl.substr(lUrl.lastIndexOf("/") + 1,1000);
				var url:String  = "http://24.249.210.121/Metadata/" + ms + "/" + lId + ".htm";
				
				//RS//now open the new window with the metadata html
				//var window:String = "_blank";
				//var features:String = "toolbar=no,location=no,resizable=no,directories=no,status=no,scrollbars=no,copyhistory=no,width=610,height=700";
				//var WINDOW_OPEN_FUNCTION : String = "window.open";
				//ExternalInterface.call( WINDOW_OPEN_FUNCTION, url, window, features );
				
				//Connect to JSON webservice info				
				var webservrequest:HTTPService = new HTTPService();
				webservrequest.url = alay;
				webservrequest.addEventListener(ResultEvent.RESULT, addserviceInfo);
				webservrequest.addEventListener(FaultEvent.FAULT, loadError);
				webservrequest.send();
				
				function loadError(event:Event):void
				{
				}
				
				function addserviceInfo(event:ResultEvent):void
				{	
					fram2.source = url;
					var rawData:Object = JSON.decode(event.result as String);
					des = rawData.description;
					if(des == ""){
						desctext.text = "No Information created at this time."
					}
					else{
						desctext.text = des;
					}
					pan1.addElement(desctext);
					
					info.title = rawData.name;
					if(info.title == "Layer"){
						Alert.show("No Information created at this time.");
					}
					else{
						var myBitmap:Bitmap = new Bitmap;
						var bitmapLoader:Loader = new Loader; 
						var bitmapPath:String = "http://staging.asascience.com/flexclients/nep/assets/images/toc/"+lId+"_"+info.title+".PNG";
						bitmapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, addBitmap);
						bitmapLoader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR, loadError);
						bitmapLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
						
						bitmapLoader.load(new URLRequest(bitmapPath));
						
						function addBitmap(event:Event):void
						{
							img.source = event.currentTarget.content;
							pan1.addElement(img);
						}
						function loadError(event:Event):void
						{
						}
					}
				}
				//fram2.source = url;
				fram2.label = "Metadata";
				
				tabs.width = 420;
				tabs.height = 400;
				tabs.addElement(pan1);
				tabs.addChild(fram2);
				
				info.addElement(tabs);
				info.x = 250;
				info.y = 130;
				PopUpManager.removePopUp(info);
				PopUpManager.addPopUp(info,this.parent,false);
				info.isPopUp = false;
				//PopUpManager.centerPopUp(info);
				
				function infoClose (event:CloseEvent):void 
				{
					info.removeEventListener(CloseEvent.CLOSE, infoClose);
					PopUpManager.removePopUp(info);
				}
			}
		}
		
		/**
		 * @private
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (data is TocItem) {
				var item:TocItem = TocItem(data);
				//item.addEventListener(MouseEvent.CLICK, showMeta);
				// Set the checkbox state
				
				_checkbox.indeterminate = item.indeterminate;
				_checkbox.selected = item.visible && !item.indeterminate;
				
				// Hide the checkbox for child items of tiled map services
				var checkboxVisible:Boolean = true;
				if (isTiledLayerChild(item)) {
					checkboxVisible = true;
				}
				//RS//Hide the button for map service leafs
				/*var btnVisible:Boolean = true;
				if (item.isGroupLayer()||item.isTopLevel()) {
					btnVisible = true;
				}
				if(item.label == "Wind" || item.label == "Temperature" || item.label == "Waves"){
					btnVisible = false;
				}
				_btn.visible = btnVisible;*/
				_checkbox.visible = checkboxVisible;
				// Apply a bold label style to root nodes
				if (item.isGroupLayer()) {
					_checkbox.visible = true;
					setStyle("fontWeight", "bold");
				} else {
					setStyle("fontWeight", "normal");
				}
				//remove certain features*****
				if(item.label == "Wind" || item.label == "Temperature" || item.label == "Waves"){
					_checkbox.visible = false;
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
			if (isNaN(explicitWidth) && !isNaN(measuredWidth)) {
				var w:Number = measuredWidth;
				w += _checkbox.measuredWidth;
				w += PRE_CHECKBOX_GAP + POST_CHECKBOX_GAP;
				measuredWidth = w;
			}
		}
		
		/**
		 * @private
		 */
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var startx:Number = data ? TreeListData(listData).indent : 0;
			if (icon) {
				startx = icon.x;
			} else if (disclosureIcon) {
				startx = disclosureIcon.x + disclosureIcon.width;
			}
			startx += PRE_CHECKBOX_GAP;
			
			// Position the checkbox between the disclosure icon and the item icon
			_checkbox.x = startx;
			_checkbox.setActualSize(_checkbox.measuredWidth, _checkbox.measuredHeight);
			_checkbox.y = (unscaledHeight - _checkbox.height) / 2;
			startx = _checkbox.x + _checkbox.width + POST_CHECKBOX_GAP;
			
			if (icon) {
				icon.x = startx;
				startx = icon.x + icon.width;
			}
			
			label.x = startx;
			label.setActualSize(unscaledWidth - startx, measuredHeight);
			//RS//This is where we place the button based on the end of the leafs label and then
			//RS//back it up by 27 because the button is 20 and I think 7 is a good margin from
			//RS//the right of the widget
			//_btn.x = label.x + label.width - 27;
		}
		
		/**
		 * Whether the specified TOC item is a child of a tiled map service layer.
		 */
		private function isTiledLayerChild( item:TocItem ):Boolean
		{
			while (item) {
				item = item.parent;
				if (item is TocMapLayerItem) {
					if (TocMapLayerItem(item).layer is TiledMapServiceLayer) {
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * Updates the visible property of the underlying TOC item.
		 */
		private function onCheckBoxClick( event:MouseEvent ):void
		{
			event.stopPropagation();
			
			if (data is TocItem) {
				var item:TocItem = TocItem(data);
				
				item.visible = _checkbox.selected;
			}
		}
		
		private function onCheckBoxDoubleClick( event:MouseEvent ):void
		{
			event.stopPropagation();
		}
		
		private function onCheckBoxMouseDown( event:MouseEvent ):void
		{
			event.stopPropagation();
		}
		
		private function onCheckBoxMouseUp( event:MouseEvent ):void
		{
			event.stopPropagation();
		}
	}
	
}

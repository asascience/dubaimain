// Copyright (c) 2004-2010 Azavea, Inc.
// 
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

package com.azavea
{
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.supportClasses.LOD;
	import com.esri.ags.layers.supportClasses.TileInfo;
	import com.esri.ags.layers.TiledMapServiceLayer;
	import mx.controls.Alert;
	
	import flash.net.URLRequest;
	
	/**
	 * This class provides a tiled WMS layer for WMS services in a web mercator projection (102100).<p/>
	 *
	 * Using a WMS service as a tiled service (instead of requesting the entire viewport) has a number of
	 * advantages, but the primary use is for base maps in which the underlying data is not going to change.
	 * By requesting tiles, the client does not need to keep requesting rendered images for the map extent
	 * that the client has already requested.  The standard dynamic layer requests the full extent of the 
	 * viewport every time the client pans or zooms.
	 * 
	 * This layer is compatable with tiling systems that expect WMS extents instead of other tiling
	 * standards, such as GeoWebCache.
	 *
	 * @example Using the layer in AS3:
	 
	 <listing version="3.0">
	 var layer : WMSWebMercatorTiledLayer = new WMSWebMercatorTiledLayer();
	 layer.url = "http://labs.metacarta.com/wms/vmap0";
	 layer.name = "basic";
	 
	 map.addLayer(layer);
	 </listing> 
	 
	 */
	
	public class WMSWebMercatorTiledLayer extends TiledMapServiceLayer
	{        
		// Minimum and maximum zoom level.
		private var _minZoomLevel:int = 6;
		private var _maxZoomLevel:int = 16;		
		// Values to calculate resolution and scale
		private const INCHES_PER_METER:Number = 39.47;
		private const DPI:int = 96;
		private const FORMAT:String = "PNG8";
		private const TILESIZE:int = 256;
		
		private const ORIGIN_SHIFT : Number = 20037508.342789244;
		private const INITIAL_RESOLUTION : Number = 156543.03392804062;
		
		internal const service:String = "WMS";
		internal const version:String = "1.1.1";
		internal const request:String = "GetMap";
		internal const scalar:Number = 1;
		
		public var format:String = "image/png";
		private var _wmsLayer : String;
		public var _url:String;
		
		/**
		 * Specified WMS styles (optional)
		 */
		public var styles:String = "";
		/**
		 * Requested projection -- web mercator ID varies between services 
		 */
		public var srs:String = "EPSG:900913";
		/**
		 * Service name.
		 */
		public var serviceName:String;
		/**
		 * Transparent background (default to true)        
		 */
		public var transparentBG:Boolean = true;
		
		public var wmtVersion:String;
		
		private var _tileInfo:TileInfo;
		
		
		// There are two valid values for tileNumberingQuadrant: 'upperRight' and 'lowerRight'
		// TMS ("http://wiki.osgeo.org/wiki/Tile_Map_Service_Specification") numbers tiles as if 
		// they were points in the upper right quadrant of a cartesian coordinate graph:
		
		//  0,2 | 1,2 | 2,2
		//  0,1 | 1,1 | 2,1
		//  0,0 | 1,0 | 2,0
		// the lower left tile is 0,0 and y increases as rows move upwards.  This is the default.
		
		// Google (for example) numbers tiles as if they were in the lower right quadrant of a graph:
		//
		// 0,0 | 0,1 | 0,2
		// 0,1 | 1,1 | 1,2
		// 0,2 | 1,2 | 2,2
		private var tileNumberingQuadrant: String = 'upperRight';
		public function WMSWebMercatorTiledLayer()
		{
			super();
			buildTileInfo(); // to create our hardcoded tileInfo
			setLoaded(false); // Map will only use loaded layers
		}
		
		/**
		 * 
		 * Builds tile information based on parameters minZoomLevel and maxZoomLevel.
		 * 
		 * For more explanation about how to calculate these levels of detail, here's a reference:
		 * http://msdn.microsoft.com/en-us/library/aa940990.aspx
		 * 
		 */
		private function buildTileInfo():void
		{
			var tileInfo:TileInfo = new TileInfo();
			
			tileInfo.spatialReference = new SpatialReference(102100);
			tileInfo.dpi = this.DPI;
			tileInfo.format = this.FORMAT;
			tileInfo.width = this.TILESIZE;
			tileInfo.height = this.TILESIZE;
			tileInfo.origin = new MapPoint(-20037508.342787, 20037508.342787);
			
			
			var halfEarthCircumference : Number = 20037508.342789244;
			var initialResolution : Number = (halfEarthCircumference * 2) / tileInfo.width;
			
			var tileLods : Array = new Array();
			
			tileLods.push( new LOD( 7, 1222.99245256249, 4622324.434309 ) );
			tileLods.push( new LOD( 8, 611.49622628138, 2311162.217155 ) );
			tileLods.push( new LOD( 9, 305.748113140558, 1155581.108577) );
			tileLods.push( new LOD( 10, 152.874056570411, 577790.554289 ) );
			tileLods.push( new LOD( 11, 76.4370282850732, 288895.277144 ) );
			tileLods.push( new LOD( 12, 38.2185141425366, 144447.638572 ) );
			tileLods.push( new LOD( 13, 19.1092570712683, 72223.819286 ) );
			tileLods.push( new LOD( 14, 9.55462853563415, 36111.909643 ) );
			tileLods.push( new LOD( 15, 4.77731426794937,18055.954822 ) );
			tileLods.push( new LOD( 16, 2.38865713397468, 9027.977411) );
			
			
			/*for ( var zoomLevel:int = _minZoomLevel; zoomLevel <= _maxZoomLevel; zoomLevel++) {
				var resolution : Number = initialResolution / Math.pow( 2, zoomLevel );
				var scale : Number = resolution * tileInfo.dpi * this.INCHES_PER_METER;
				var lod:LOD = new LOD(zoomLevel, resolution, scale);
				tileLods.push(lod);
			
			tileLods.push( new LOD( 6, 2445.98490512499, 9244648.868618) );
			}*/
			
			tileInfo.lods = tileLods;
			_tileInfo = tileInfo;
		}
		
		
		
		/**
		 * Name of the layer to request from WMS service.
		 * 
		 * The WMS "LAYERS" cgi parameter is set to this string.
		 * 
		 * Multiple layers can be selected from many WMS servers with a comma
		 * separated list of layer names.
		 */
		public function get wmsLayer ():String {
			return this._wmsLayer;
		}
		public function set wmsLayer(value:String):void {
			this._wmsLayer = value;
			if (this.url != null) {
				setLoaded(true);
			}
		}
		
		/**
		 * Set the URL of the WMS service.
		 */
		public function get url ():String { return this._url; }
		
		public function set url( url :String):void {
			this._url = url;
			if (this.wmsLayer != null) {
				setLoaded(true);
			}
		}
		
		/**
		 * Set the minimum zoom level. (Defaults to 0)
		 * 
		 * Zoom level 0 is the earth's full extent in one tile.
		 */
		public function set minZoomLevel(minZoomLevel:int):void {
			this._minZoomLevel = minZoomLevel;
		}
		
		/**
		 * Set the maximum zoom level.  (Defaults to 18)
		 * 
		 * Zoom level 18 is the earth's full extent in 2^^18 by 2^^18 tiles.
		 */
		public function set maxZoomLevel(maxZoomLevel:int):void {
			this._maxZoomLevel = maxZoomLevel;
		}
		
		/**
		 * Returns Extent(-20M (million), -20M, 20M, 20M).  The units in web mercator 
		 * are meters along the equator, and the circumference of the earth around the equator is ~40 million km.  The origin is offset by half: 20M.
		 */
		override public function get fullExtent():Extent
		{
			return new Extent(
				-20037508.34, -20037508.34, 20037508.34, 20037508.34, 
				new SpatialReference(102100)
			);
		}
		
		
		/**
		 *  Defaults to fullExtent.
		 */
		override public function get initialExtent():Extent
		{
			return this.fullExtent;
		}
		
		override public function get units():String
		{
			return "esriMeters";
		}
		
		
		override public function get spatialReference():SpatialReference 
		{
			return new SpatialReference(102113);
		}
		override public function get tileInfo():TileInfo {
			return _tileInfo;
		}
		
		
		override protected function getTileURL(level:Number, row:Number, col:Number):URLRequest
		{                            
			var url:String = _url;
			
			var index : int = _url.indexOf( "?");
			var prefix : String = index == -1 ? "?" : "&"; 
			
			url += prefix + urlParameter("SERVICE", service);
			url += urlParameter("VERSION", version);
			url += urlParameter("REQUEST", request);
			
			// Many of these parameters are specific to particular WMS implementations, and won't
			// be necessary for all of them.
			
			url += urlParameter("SERVICENAME", serviceName);
			url += urlParameter("WMTVER", wmtVersion);
			url += urlParameter("LAYERS", wmsLayer);
			url += urlParameter("STYLES", styles);
			
			url += urlParameter("TRANSPARENT", (transparentBG ? 'true' : 'false' ));
			url += urlParameter("SRS", srs);
			url += urlParameter("FORMAT", format);
			url += urlParameter("WIDTH", TILESIZE.toString() );
			url += urlParameter("HEIGHT", TILESIZE.toString() );
			
			var tileExtent : Extent = this.TileBounds(col, row, level, this.tileNumberingQuadrant);
			url += "&BBOX=" + tileExtent.xmin.toString() + "," + tileExtent.ymax.toString() + "," + tileExtent.xmax.toString() + ',' + tileExtent.ymin.toString();
			url += "&LAYERSs" + this.wmsLayer;
			
			trace(url);
			return new URLRequest(url);
		}
		
		private function urlParameter(name: String, value: String):String {
			return "&" + name + "=" + (value != null ? value : '');
		}		
		
		/**
		 * Returns bounds of tile in web mercator, based on current zoom.
		 */
		private function TileBounds(tx : int, ty : int, zoom : int, tileNumberingQuadrant : String) : Extent {
			var extent : Extent = new Extent();
			var bottomLeft : MapPoint = this.PixelsToMeters( tx* 256, ty* 256, zoom );
			var topRight : MapPoint = this.PixelsToMeters ( (tx+1)*256, (ty+1)*256, zoom );
			
			extent.xmin = bottomLeft.x;
			// see explanation of tileNumberingQuadrant above
			if ( this.tileNumberingQuadrant == 'upperRight') {
				extent.ymin = 0 - bottomLeft.y;
			} else {
				extent.ymin = bottomLeft.y;
			}
			
			extent.xmax = topRight.x;
			if ( this.tileNumberingQuadrant == 'upperRight') {
				extent.ymax = 0 - topRight.y;
			} else {
				extent.ymax = topRight.y;
			}
			return extent;
		}
		
		private function PixelsToMeters( px : int, py: int, zoom: int ):MapPoint {
			var res : Number = Resolution(zoom);
			var mx : int = px * res - ORIGIN_SHIFT;
			var my : int = py * res - ORIGIN_SHIFT;
			var mapPoint : MapPoint = new MapPoint(mx, my);
			return mapPoint;
		}
		
		/**
		 * Returns resoltuion (meters/pixel) for given zoom level (measured at Equator)
		 */
		private function Resolution(zoom:int):Number {
			//"Resolution (meters/pixel) for given zoom level (measured at Equator)"
			return INITIAL_RESOLUTION / Math.pow(2, zoom);
		}
		
	}
}
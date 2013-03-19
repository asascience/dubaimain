// ASA
// 
package com.azavea
{
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.TiledMapServiceLayer;
	import com.esri.ags.virtualearth.VETiledLayer;
	import com.esri.ags.layers.supportClasses.LOD;
	import com.esri.ags.layers.supportClasses.TileInfo;
	import mx.controls.Alert;
	
	import flash.net.URLRequest;
	
    /**
	 * 
   This extends the tile cache base map layers for a static, file based geoweb cache.
 
 *  Example URL link:  http://c1753222.cdn.cloudfiles.rackspacecloud.com/RBSW-DEV_NOAA_Layer_Group/EPSG_900913_13/019_040/002472_005134.png
 * 
    */

	public class GeoWebCacheTiledLayer extends TiledMapServiceLayer
	{        
		// Minimum and maximum zoom level.
        private var _minZoomLevel:int = 0;
        private var _maxZoomLevel:int = 18;
        
        // Values to calculate resolution and scale
        private const INCHES_PER_METER:Number = 39.47;
        private const DPI:int = 96;
        private const TILESIZE:int = 256;

        private const ORIGIN_SHIFT : Number = 20037508.342789244;
        private const INITIAL_RESOLUTION : Number = 156543.03392804062;

        internal const scalar:Number = 1;
        
		///Setting the file came extension....Usually PNG
		private var imgtype:String = ".png";
		
        private var _wmsLayer : String;
        public var _url:String;

        /**
         * Specified WMS styles (optional)
         */
        public var styles:String = "";
        /**
        * Requested projection -- web mercator ID varies between services 
        */
        public var srs:String;
        /**
         * Layer folder name of the location of data.
         */
        public var layerName:String;
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
		public function GeoWebCacheTiledLayer()
		{
			super();
			buildTileInfo(); // to create our hardcoded tileInfo
			setLoaded(false); // Map will only use loaded layers
			trace("hit geo web cache request");
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
			trace("build tile info");
            var tileInfo:TileInfo = new TileInfo();
            
            tileInfo.spatialReference = new SpatialReference(102100);
            tileInfo.width = this.TILESIZE;
            tileInfo.height = this.TILESIZE;
            tileInfo.origin = new MapPoint(-20037508.342787, 20037508.342787);
            
            
            var halfEarthCircumference : Number = 20037508.342789244;
            var initialResolution : Number = (halfEarthCircumference * 2) / tileInfo.width;
            
            var tileLods : Array = new Array();
            
            for ( var zoomLevel:int = _minZoomLevel; zoomLevel <= _maxZoomLevel; zoomLevel++) {
                var resolution : Number = initialResolution / Math.pow( 2, zoomLevel );
                var scale : Number = resolution * tileInfo.dpi * this.INCHES_PER_METER;
                var lod:LOD = new LOD(zoomLevel, resolution, scale);
                tileLods.push(lod);
            }

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
   			return new SpatialReference(102100);
   		}
   		override public function get tileInfo():TileInfo {
   			return _tileInfo;
   		}


		override protected function getTileURL(level:Number, row:Number, col:Number):URLRequest
		{                            
            var url:String = _url;
           
            //var index : int = _url.indexOf( "?");
            //var prefix : String = index == -1 ? "?" : "&"; 
            
			url += wmsLayer+"/"
            url += srs+"_"+level
            url += "/"+[row/(2(level/2))]+"_"+[col/(2(level/2))]
            url += "/"+row+"_"+col+imgtype
           			
			var tileExtent : Extent = this.TileBounds(col, row, level, this.tileNumberingQuadrant);
    		//url += "&BBOX=" + tileExtent.xmin.toString() + "," + tileExtent.ymax.toString() + "," + tileExtent.xmax.toString() + ',' + tileExtent.ymin.toString();
            //url += "&LAYERS=" + this.wmsLayer;
			
			trace("tile URL");
			trace(url);
			//Alert.show(url);
            return new URLRequest(url);
		}
		
		override protected function updateLayer():void {
			
			trace("update layer");
			this.refresh();	
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
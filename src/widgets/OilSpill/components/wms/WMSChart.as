package widgets.OilSpill.components.wms
{
	
import com.esri.ags.Map;
import com.esri.ags.SpatialReference;
import com.esri.ags.Units;
import com.esri.ags.events.ExtentEvent;
import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.Geometry;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.layers.DynamicMapServiceLayer;
import com.esri.ags.tasks.GeometryService;
import com.esri.ags.utils.WebMercatorUtil;

import flash.display.Loader;
import flash.events.Event;
import flash.net.URLRequest;
import flash.net.URLVariables;

import mx.rpc.soap.LoadEvent;

	public class WMSChart extends DynamicMapServiceLayer
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Creates a new CityStatesWMSLayer object.
		 */
		public function WMSChart(wmsURL:String, layerRequest:String)
		{
			//TODO: Basic validation on wmsURL, layerRequest, layerID
			
			super();  
			setLoaded(true); // Map will only use loaded layers        
			//this.id=layerID;
			
			//for any wms use these parameters:
			_url = wmsURL;      
			_params = new URLVariables();
			//_params.request = "GetMap";
			//_params.transparent = true;
			//_params.format = "image/png";
			//_params.version = "1.1.1";
			//JMO 05182010 adding option for setting the style (e.g. heatmap for prob grid)
			//_params.styles = "";
			_params.layers = layerRequest;
			
			//build request
			_urlRequest = new URLRequest(_url);
			_urlRequest.data = _params;  			
		}
			
			//--------------------------------------------------------------------------
			//
			//  Variables
			//
			//--------------------------------------------------------------------------
			
			private var _params:URLVariables;
			private var _urlRequest:URLRequest;
			private var _url:String;
			//JMO 03152010 will need for identify
			public function get params():URLVariables
			{
				return _params;
			}
			public function get url():String
			{
				return _url;
			}
			
			//--------------------------------------------------------------------------
			//
			//  Overridden properties
			//      initialExtent()
			//      spatialReference()
			//      units()
			//
			//--------------------------------------------------------------------------
			
			public var _time:Date = new Date();
			
			//--------------------------------------------------------------------------
			//
			//  Overridden properties
			//      initialExtent()
			//      spatialReference()
			//      units()
			//
			//--------------------------------------------------------------------------
			
			//----------------------------------
			//  initialExtent
			//  - needed if Map doesn't have an extent
			//----------------------------------
			
			override public function get initialExtent():Extent
			{
				return new Extent(-165, 18, -67, 67, new SpatialReference(4326));
			}
			
			//----------------------------------
			//  spatialReference
			//  - needed if Map doesn't have a spatialReference
			//----------------------------------
			
			override public function get spatialReference():SpatialReference
			{
				return new SpatialReference(4326);
			}
			
			//----------------------------------
			//  units
			//  - needed if Map doesn't have it set
			//----------------------------------
			
			override public function get units():String
			{
				return Units.DECIMAL_DEGREES;
			}
			
			//--------------------------------------------------------------------------
			//
			//  Overridden methods
			//      loadMapImage(loader:Loader):void
			//
			//--------------------------------------------------------------------------
			
			override protected function loadMapImage(loader:Loader):void
			{
				// update changing values
				//const geoExtent:Extent = WebMercatorUtil.webMercatorToGeographic(map.extent) as Extent;
				//geoExtent needed in ArcGIS 2.0 Framework
				//_params.bbox = geoExtent.xmin + "," + geoExtent.ymin + "," + geoExtent.xmax + "," + geoExtent.ymax;

				_params.bbox = map.extent.xmin + "," + map.extent.ymin + "," + map.extent.xmax + "," + map.extent.ymax;
				//trace(map.extent.xmin + "," + map.extent.ymin + "," + map.extent.xmax + "," + map.extent.ymax);
				//_params.srs = "EPSG:" + map.spatialReference.wkid,
				
				if(map.spatialReference.wkid == 102100)
				{
					//_params.srs = "EPSG:3857";
					_params.bbox = map.extent.xmin + "," + map.extent.ymin + "," + map.extent.xmax + "," + map.extent.ymax;
				}
				else
				{
					//_params.srs = "EPSG:" + map.spatialReference.wkid;
					_params.bbox = map.extent.xmin + "," + map.extent.ymin + "," + map.extent.xmax + "," + map.extent.ymax;
				}
				
				_params.width = map.width;
				_params.height = map.height;
				
				//var formatTime:String = new String(_time.fullYear + "-" + String(Number(_time.month+1)) + "-" + _time.date + "T" + _time.toTimeString().substr(0,5));
				
				//_params.time = formatTime;
				//application/vnd.ogc.se_xml
				//_params.exceptions = "application/vnd.ogc.se_xml";       //   "application/vnd.ogc.se_inimage"

				loader.load(_urlRequest);
				//trace("loading url request");
			}
		}
}
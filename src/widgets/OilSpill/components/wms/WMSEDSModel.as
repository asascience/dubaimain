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
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	public class WMSEDSModel extends DynamicMapServiceLayer
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		
		public function WMSEDSModel(wmsURL:String, edsID:String, timeSpill:String,styleString:String="",imageType:String="png")
		{
			super();  
			setLoaded(true); // Map will only use loaded layers      
			
			_url = wmsURL;      
			_params = new URLVariables();
			_params.request = "GetMap";
			_params.transparent = true;
			_params.format = "image/"+imageType;
			_params.version = "1.1.1";
			_params.styles = styleString;
			_params.layers = edsID;
			_params.service="WMS";
			
			var time_array:Array = timeSpill.split(":");
			var timeFORMAT:String = new String(time_array[0] + time_array[1] + time_array[2]);
			_params.time=timeSpill;
			
			_urlRequest = new URLRequest(_url);
			_urlRequest.data = _params;  
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		public var _params:URLVariables;
		private var _urlRequest:URLRequest;
		private var _url:String;
		
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
			
			_params.bbox = map.extent.xmin + "," + map.extent.ymin + "," + map.extent.xmax + "," + map.extent.ymax;
			
			if(map.spatialReference.wkid == 102100)
			{
				_params.srs = "EPSG:3857";
			}
			else
			{
				_params.srs = "EPSG:" + map.spatialReference.wkid;
			}
			
			_params.width = map.width;
			_params.height = map.height;
			_params.exceptions = "application/vnd.ogc.se_inimage";
			
			loader.load(_urlRequest);
		}
	}
}
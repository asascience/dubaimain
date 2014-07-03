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
	
	public class WMSModel extends DynamicMapServiceLayer
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		
		public function WMSModel(userID:String,sessionID:String,wmsURL:String,oilID:String,layerName:String,requestLayers:String, scenarioID:String, timeSpill:String,modelType:String,langID:int,trackline:Boolean,contour:Boolean,spillets:Boolean,mass:Boolean,swept:Boolean,boom:Boolean=false)
		{			
			super();  
			setLoaded(true); // Map will only use loaded layers        
			this.id=oilID;
			this.name=layerName;
			
			_url = wmsURL;      
			_params = new URLVariables();
			_params.request = "GetMap";
			_params.transparent = true;
			_params.format = "image/png";
			_params.version = "1.1.1";
			_params.styles = "";
			_params.layers = requestLayers;
			_params.service="WMS";
			_params.lang=langID;
			_params.DAYNIGHTICON=false;
			_params.SUMMARYTABLE=false;
            
            _params.OM_TRACKLINE = trackline;
            _params.OM_SPILLETS = spillets;
            _params.OM_SWEPT = swept;
            _params.DEPTH = 6;
            
			_params.OM_MASS = mass;
			_params.OM_BOOM = boom;
			_params.OM_OVERFLIGHT = false;
                      
            
			_params.user_id=userID;
			_params.session_id=sessionID;
			_params.scenario_id=scenarioID;
			//_params.timestamp=new Date().time;
			
			//var time_array:Array = timeSpill.split(":");
			//var timeFORMAT:String = new String(time_array[0] + time_array[1] + time_array[2]);
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
		
		public var _requestLayers:String = new String();  
		
		private var paramsString:String="";
		public function getparamsString():String
		{
			return paramsString;
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
		
		// to use EPSG:4326 to request the wms , so comment this
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
			_params.layers = _requestLayers;
			_params.exceptions = "application/vnd.ogc.se_inimage";
			
			paramsString=_url+_params.toString();
			
			loader.load(_urlRequest);
		}
	}
}
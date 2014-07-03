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
	import com.esri.viewer.AppEvent;
	import com.esri.viewer.ViewerContainer;
	
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import widgets.TimeSlider.components.util.DateTimeUtilities;
	
	public class WMSUserEDS extends DynamicMapServiceLayer
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		
		public function WMSUserEDS(mapLayerID:String,mapLayerName:String,wmsURL:String, requestLayers:String, currentTime:String,res_id:String,user_id:String,session:String,timeZone:Number)
		{
			super();  
			setLoaded(true); // Map will only use loaded layers      
			this.id=mapLayerID;
			this.name=mapLayerName;
			_url = wmsURL;      
			_params = new URLVariables();
			_params.request = "GetMap";
			_params.transparent = true;
			_params.format = "image/png";
			_params.version = "1.1.1";
			_params.styles = "";
			_params.layers = requestLayers;
			_params.service="WMS";
			
			_params.time=currentTime;
			_params.res_id=res_id;
			_params.user_id=user_id;
			_params.session_id=session;
			
			_params.zlayer=1;
			_params.stride="AUTO";
			_params.Contour="false";
			_params.xycolor="true";
			_params.grid="false";
			
			_urlRequest = new URLRequest(_url);
			_urlRequest.data = _params;
			
			_timeZone=timeZone;
			
			ViewerContainer.addEventListener(AppEvent.SPILL_TIME_CHANGED, spillTimeChanged);	
			ViewerContainer.addEventListener(AppEvent.TIME_SLIDER_TIME_CHANGED, updateCurrentTime);
		}
		private function updateCurrentTime(event:AppEvent):void
		{
			var currentTime:Date = event.data as Date;
			_params.time=DateTimeUtilities.spillHyphenServiceDateWithTimeZone2UTC(currentTime,_timeZone);
		}
		private function spillTimeChanged(event:AppEvent):void
		{
			var resultArray:Array=event.data as Array;
			var currentTime:Date=new Date(resultArray[0].toString());
			_params.time=DateTimeUtilities.spillHyphenServiceDateWithTimeZone2UTC(currentTime,_timeZone);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		public var _params:URLVariables;
		private var _urlRequest:URLRequest;
		private var _url:String;
		public var _timeZone:Number;
		
		public function get params():URLVariables
		{
			return _params;
		}
		public function get url():String
		{
			return _url;
		}
		//added by HongShen
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
			
			//added by HongShen
			paramsString=_url+_params.toString();
			//ViewerContainer.dispatchEvent(new AppEvent(AppEvent.CHANGEBBOX));
			
			loader.load(_urlRequest);
		}
	}
}
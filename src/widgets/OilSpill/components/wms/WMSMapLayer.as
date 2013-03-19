package widgets.OilSpill.components.wms
{
	import com.esri.ags.layers.DynamicMapServiceLayer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class WMSMapLayer extends DynamicMapServiceLayer
	{
		internal const service:String = "WMS";
		internal const version:String = "1.1.1";
		internal const request:String = "GetMap";
		public var format:String = "image/png";
		internal const scalar:Number = 1;
		
		public var wmsLayer:String;
		public var serviceName:String;
		
		public var wmtVersion:String;
		public var styles:String = "";
		public var srs:String = "EPSG:4326";
		public var url:String;
		public var transparentBG:String;
		
		public function WMSMapLayer()
		{
			super();
			this.setLoaded(true);
		}
		
		override protected function loadMapImage(loader:Loader):void {
			
			// Get our pixel dimensions.
			var pxWidth:Number = Math.floor(this.map.width * scalar);
			var pxHeight:Number = Math.floor(this.map.height * scalar);
			
			// Build the GetMap request
			var index : int = url.indexOf( "?");
			var prefix : String = index == -1 ? "?" : "&"; 
			var _url:String = url;
			_url += prefix + "SERVICE="+service;
			_url += "&VERSION="+version;
			_url += "&REQUEST="+request;
			// For many WMS servers, SERVICENAME and others are unused, but some must be included or the server will reject our request. For example STYLES.
			if( serviceName != null) {
				_url += "&SERVICENAME="+serviceName;
			}
			if( wmtVersion != null) {
				_url += "&WMTVER="+wmtVersion;
			}
			if( wmsLayer != null) {
				_url += "&LAYERS="+wmsLayer;
			}
			_url += "&STYLES="+styles;
			if(transparentBG != null) {
				_url += "&TRANSPARENT="+transparentBG;
			}
			if( srs != null) {
				_url += "&SRS="+srs;
			}
			_url += "&FORMAT="+format;
			_url += "&WIDTH="+pxWidth;
			_url += "&HEIGHT="+pxHeight;
			/*_url += "&BBOX=" + this.map.extent.xmin+","+
				this.map.extent.ymin+","+
				this.map.extent.xmax+","+
				this.map.extent.ymax;*/
			_url += "&BBOX=-180,-90,180,90";
			
			// We create a new URLRequest
			var wmsReq:URLRequest = new URLRequest(_url);
			// And finally pass it to our parent as a Loader. This URL will be then loaded into the map window.
			loader.load(wmsReq);
		}
	}
}
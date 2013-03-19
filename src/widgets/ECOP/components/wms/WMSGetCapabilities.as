package widgets.ECOP.components.wms
{
	import flash.net.URLVariables;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Box;
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import widgets.ECOP.components.events.ActiveChangeEvent;
	import widgets.ECOP.components.utils.Hashtable;
	
	/// an object to make and parse a WMS getCapabilites request
	public class WMSGetCapabilities extends Box
	{
		private const VERSION:String="1.1.1";
		private const REQUEST:String="GetCapabilities";
		private const SERVICE:String="WMS";
		
		private var _DoneEvent:ActiveChangeEvent;
		private var _params:URLVariables;
		private var _httpService:HTTPService;
		private var _BaseURL:String;
		
        /* private var _dataHash:Hashtable;
        public function get results():Hashtable
        {
        	return _dataHash;
        } */
        
        private var _caps:ArrayCollection;
        public function get capsArray():ArrayCollection
        {
        	return _caps;
        }
        
        //constr
        public function WMSGetCapabilities(wmsBaseURL:String)
        {
        	_BaseURL = wmsBaseURL;
        	getCapabilities();
        }
        
        private function getCapabilities():void
		{
			createRequestParameters();
			_httpService = new HTTPService();
			_httpService.url =_BaseURL;
			_httpService.addEventListener("result", capabilitiesResult);
            _httpService.addEventListener("fault", onFault);
            _httpService.resultFormat = "xml"; 
            _httpService.send(_params);
                       
		}
		
		private function capabilitiesResult(event:ResultEvent):void
		{
				try
				{
					var capabilities:XML = new XML(event.result);
					parseCapabilities(capabilities);
					
				}
				catch (error:Error)
				{
					Alert.show("An error occured in processing identify request: " + error.message);
				}
				finally
				{
					_httpService.removeEventListener("result", capabilitiesResult);
				}
		}
		
		private function parseCapabilities(capDoc:XML):void
		{
			//_dataHash = new Hashtable();
		   var displayArray:Array = new Array();
		   _caps = new ArrayCollection();
           
           //parse the capabilities xml and build something that can be accessed
              var layerCapabilities:Hashtable = new Hashtable();
		      var value:String = null;
		      var layerTitle:String = null;
		      var name:String = null;
		      // *** var latLon:Bounds = null;
		      var minx:String; var miny:String; var maxx:String; var maxy:String; var bounds:String; var extProj:String;
		      var sep:String = ",";
			  var type:String = null;
		
		      var layerNodes:XMLList = capDoc..*::Layer;
		      this.removeNamespaces(capDoc);
		      
		      var c:Number = 0;
		      var projections:Array = [];
		
		      for each (var layer:XML in layerNodes)
		      {
				if (c == 0)
		        {
		          var SRSNodes:XMLList = layer.SRS;
		          for each (var srsnode:XML in SRSNodes)
		          {
		            value = srsnode.toString();
		            projections.push(value);
		          }
		        } 
		        else
		        {
		          name = layer.Name;
		          layerCapabilities.add("Name", name);
		          		  
		          layerTitle = layer.Title;
		          layerCapabilities.add("Title", layerTitle);
		  
		          value = layer.SRS;
		          value = value.substr(value.indexOf("EPSG"));
		          layerCapabilities.add("SRS", value);
		  
		          value = layer.Abstract;
		          layerCapabilities.add("Abstract", value);
		          
		          layerCapabilities.add("Version", "1.1.1");
		  
		          // STYLES
		          var styleNodes:XMLList = layer..*::Style;
		          var styles:Array = [];
		          var titl:String = null;
		          var dat:String = null;
		          for each (var style:XML in styleNodes)
		          {
		            titl = style.Title;
		            dat = style.Name;
		            styles.push({label: titl, data: dat})
		          }
		          layerCapabilities.add("Styles", styles);
		  
		          minx = layer.LatLonBoundingBox.@minx;
		          miny = layer.LatLonBoundingBox.@miny;
		          maxx = layer.LatLonBoundingBox.@maxx;
		          maxy = layer.LatLonBoundingBox.@maxy;
		          bounds = minx + sep + miny + sep + maxx + sep + maxy;
		          // *** latLon = Bounds.getBoundsFromString(bounds);
		          layerCapabilities.add("LatLonExtent", bounds);
		          
		          minx = layer.BoundingBox.@minx;
		          miny = layer.BoundingBox.@miny;
		          maxx = layer.BoundingBox.@maxx;
		          maxy = layer.BoundingBox.@maxy;
		          extProj = layer.BoundingBox.@SRS;
		          bounds = minx + sep + miny + sep + maxx + sep + maxy;
		          // *** latLon = Bounds.getBoundsFromString(bounds);
		          layerCapabilities.add("Extent", bounds);
		          layerCapabilities.add("ExtentProjection", extProj);
		         
		          layerCapabilities.add("Projections", projections);
		    
		          //create a hashTable of hashTables
		          // _dataHash.add(name, layerCapabilities);
				  
				  ///string search for type
				  
				  var n:String = name;
				  
				  if(n.search("CURRENTS") != -1)
				  {
					  type = "CURRENTS";
				  }
				  else if(n.search("WINDS") != -1)
				  {
					  type = "WINDS";
				  }
				  else
				  { 
					  type = "OTHER"  
				  }
		  
		          //add values to array
		          displayArray.push({nameKey:name,
                    	   title:layerTitle, visible:false,
                    	   values:layerCapabilities, type:type});
                  
                   //We cannot use clear() or reset() or we'll loose the datas
		          layerCapabilities = new Hashtable();
                    	   
		        }
		        c++;
		      }
              
            _caps.source=displayArray;  
			//finally, let the caller know we are fully parsed
			dispatchDataGetDone();

		}
		
		 private function removeNamespaces(doc:XML):void
		 {
      		var namespaces:Array = doc.inScopeNamespaces();
      		for each (var ns:String in namespaces) {
        	doc.removeNamespace(new Namespace(ns));
      	 }
    }

		
		
		private function dispatchDataGetDone():void
		{
			_DoneEvent = new ActiveChangeEvent(ActiveChangeEvent.DATA_GET_DONE, 0,"ECOP");
			dispatchEvent(_DoneEvent);
		    
		}
		
		private function createRequestParameters():void
		{
			_params = new URLVariables();
			_params.request = this.REQUEST;
            _params.version = this.VERSION;
            _params.service = this.SERVICE;
		}

        //on fault
		private function onFault(event:FaultEvent):void
		{                    
		   Alert.show("An error occured in getCapabilitiesRequest: " + event.fault.toString());   
		   _httpService.removeEventListener("fault",onFault);      
		}	

	}
}
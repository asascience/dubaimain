package widgets.ECOP.components.wms
{

import com.esri.ags.SpatialReference;
import com.esri.ags.Units;
import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.Geometry;
import com.esri.ags.geometry.Polygon;
import com.esri.ags.geometry.WebMercatorExtent;
import com.esri.ags.layers.DynamicMapServiceLayer;
import com.esri.ags.utils.WebMercatorUtil;

import flash.display.Loader;
import flash.net.URLRequest;
import flash.net.URLVariables;

/**
 * CityStatesWMSLayer
 */
public class WMSLayer extends DynamicMapServiceLayer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
     
    //JMO 05182010 adding option for heatmap for prob grid 
    //public function WMSLayer(wmsURL:String, layerRequest:String, layerID:String, isSarops:Boolean=false, saropsNCFilePath:String="")
    public function WMSLayer(wmsURL:String, layerRequest:String, layerID:String,imageTyp:String ="png", style:String="")
    {
    	//TODO: Basic validation on wmsURL, layerRequest, layerID
    	
        super();  
        setLoaded(true); // Map will only use loaded layers        
        this.id=layerID;
        
        //for any wms use these parameters:
         _url = wmsURL;      
        _params = new URLVariables();
        _params.request = "GetMap";
        _params.transparent = true;
        _params.format = "image/"+imageTyp;
        _params.version = "1.1.1";
        //JMO 05182010 adding option for setting the style (e.g. heatmap for prob grid)
        _params.styles = style;
        _params.layers = layerRequest;
        
        //special for sarops
        /*if(isSarops)
        {
        	//saropsNCFilePath = "D:\\Data\\877\\particles.nc";  //for testing. Select Run 877.
        	_params.sarops = saropsNCFilePath;
        }*/
        
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
    
    //----------------------------------
    //  initialExtent
    //  - needed if Map doesn't have an extent
    //---------------------------------
    override public function get initialExtent():Extent
    {
        return new Extent(-178,-16,18.6,89.5, new SpatialReference(4326));
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
		//map.extent.spatialReference.wkid = 3847;
		
		//var ex:Extent = WebMercatorUtil.webMercatorToGeographic(map.extent) as Extent;
		//var ex:Extent= new Extent(map.extent.xmin,map.extent.ymin,map.extent.xmax,map.extent.ymax);
		
		//var n:Number =  (map.extent.xmin*(-1))-20037508.342789244;
		_params.bbox = map.extent.xmin + "," + map.extent.ymin + "," + map.extent.xmax + "," + map.extent.ymax;
		//trace(_params.bbox);
        _params.srs = "EPSG:3857"; // + map.spatialReference.wkid,
        _params.width = map.width;
        _params.height = map.height;
                
        var formatTime:String = new String(_time.fullYear + "-" + String(Number(_time.month+1)) + "-" + _time.date + "T" + _time.toTimeString().substr(0,5));
        
        _params.time = formatTime;
        //application/vnd.ogc.se_xml
        _params.exceptions = "application/vnd.ogc.se_inimage";       //   "application/vnd.ogc.se_inimage"
        
        loader.load(_urlRequest);        
    }
}

}
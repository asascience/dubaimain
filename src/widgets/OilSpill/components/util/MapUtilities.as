package widgets.OilSpill.components.util
{	
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.GraphicsLayer;
	
	import mx.formatters.NumberFormatter;
	import mx.formatters.PhoneFormatter;
	
	public final class MapUtilities
	{
	     public static const LONGITUDE:String = "longitude";
         public static const LATITUDE:String = "latitude";
         
         public static function decimalDegreesToCoordString(ddCoord:Number, coorType:String):String	
         { 
         	var rtnStr:String="";
         	var coord:Number= Math.abs(ddCoord);
         	var dd:Number = Math.floor(coord);
         	var numFormatter:NumberFormatter = new NumberFormatter();
         	var numFormatterII:PhoneFormatter = new PhoneFormatter();
         	var tmpStr:String="";
         	
         	numFormatterII.formatString="##.###";
         	
         	coord -= dd;
         	coord *=60;
         	
         	switch(coorType)
         	{
         		case MapUtilities.LONGITUDE:
         		   tmpStr = dd.toString();
         		   if (tmpStr.length < 3)
         		   {tmpStr = "0" + tmpStr;}
         		   rtnStr = tmpStr + "-";
         		   break;
         		   
         		case MapUtilities.LATITUDE:
         		  tmpStr = dd.toString();
         		   if (tmpStr.length < 2)
         		   {tmpStr = "0" + tmpStr;}
         		   rtnStr = tmpStr + "-";
         		   break;
         	}
         	
         	numFormatter.precision=3;
         	tmpStr = numFormatter.format(coord);
            var arr:Array = tmpStr.split(".");
            var tmpStrII:String = arr[0].toString();
            
            if (tmpStrII.length < 2)
            {tmpStrII = "0" + tmpStrII;}
            
         	rtnStr += tmpStrII + "." + arr[1].toString();   //coord.toString("##.###");
         	
         	switch(coorType)
         	{
         		case MapUtilities.LONGITUDE:
         		   if(ddCoord < 0)
         		   rtnStr +="W";
         		   else
         		   rtnStr +="E";
         		   break;
         		
         		case MapUtilities.LATITUDE:
         		    if (ddCoord < 0)
         		    rtnStr +="S";
         		    else
         		    rtnStr +="N";
         			break;	
         	}
         	
         	return rtnStr;  
         }       		
         	
		public static function coordStr2DD(coordStr:String):Number
		{
			
	       var _Spart:Array = coordStr.split("-");
	       var _Dd:Number = Number(_Spart[0]);
	       var _Scompass:String = _Spart[1].toString().slice(-1, _Spart[1].toString().length); 
	       _Scompass = _Scompass.toUpperCase();
	       _Spart[1] = _Spart[1].toString().substring(0, _Spart[1].toString().length - 1);
	       var _Dm:Number = Number(_Spart[1]);
	       _Dd += (_Dm / 60);
	                    
	       if ((_Scompass == "S") || (_Scompass == "W"))
	       {
	          _Dd *= -1;
	       }
	                    
	       return _Dd;
		}
		
		 public static function NM2DD(NM:Number):Number
        {           
           return NM * 0.01665518;   
        }
        
         public static function NM2DDLat(NM:Number, Latitude:Number):Number
        {
           return NM * 0.01665518 * (1.0 / Math.acos(Latitude * 0.0174533));
        }
        
         public static function displayLegend(mp:MapPoint, legendSource:String, grLyr:GraphicsLayer ):void
        {
        	
			var gra;
			//var overLaySym:OverlaySymbol = new "Bob2";
			//var gra:Graphic = new Graphic(mp);
			//var overLaySym:OverlaySymbol = new OverlaySymbol(legendSource, 360, 180, 0);
			/* overLaySym.source = legendSource;
			overLaySym.width = 360;
			overLaySym.height = 180;
			overLaySym.rotation = 0; */
			gra.symbol = "1020";
			grLyr.add(gra);
        }
 }
}
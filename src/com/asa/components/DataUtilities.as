package com.asa.components
{
	import com.esri.ags.Graphic;
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.*;
	import com.esri.ags.symbols.*;
	import com.esri.ags.utils.WebMercatorUtil;
	
	import flash.external.ExternalInterface;
	import flash.system.System;
	import flash.utils.ByteArray;

	public final class DataUtilities
	{
		public function DataUtilities()
		{
		}
		//used when get the url from config file
		public static function CheckWSURL(serviceURL:String,serverURL:String):String
		{
			if(serviceURL.indexOf("http://")<0)
			{
				return serverURL+serviceURL;
			}
			else
			{
				return serviceURL;
			}
		}
		//used when save and get the graphics
		//default SRID change is between mercator to Geographic.
		public static function GeometryToCoordinates(geometry:Geometry):String
		{
			var coordinates:String;
			switch(geometry.type)
			{
				case Geometry.MAPPOINT:
					
					coordinates="POINT(";
					var _point:MapPoint=MapPoint(WebMercatorUtil.webMercatorToGeographic(geometry));
					//一个Graphic中的polyline只有一条线段
					coordinates+=_point.x.toFixed(4);
					coordinates+=" ";
					coordinates+=_point.y.toFixed(4);
					coordinates+=")";
					break;
				case Geometry.MULTIPOINT:
					return null;
					break;
				case Geometry.POLYLINE:
					coordinates="LINESTRING(";
					var _polyline:Polyline=Polyline(WebMercatorUtil.webMercatorToGeographic(geometry));
					//一个Graphic中的polyline只有一条线段
					coordinates+=_polyline.getPoint(0,0).x.toFixed(4);
					coordinates+=" ";
					coordinates+=_polyline.getPoint(0,0).y.toFixed(4);
					for(var h:int=1;h<_polyline.paths[0].length;h++)
					{
						coordinates+=",";
						coordinates+=_polyline.getPoint(0,h).x.toFixed(4);
						coordinates+=" ";
						coordinates+=_polyline.getPoint(0,h).y.toFixed(4);
					}
					coordinates+=")";
					break;
				case Geometry.EXTENT:
					coordinates="POLYGON((";
					var _extent:Extent=Extent(WebMercatorUtil.webMercatorToGeographic(geometry));
					//top left
					coordinates+=_extent.xmin.toFixed(4);
					coordinates+=" ";
					coordinates+=_extent.ymax.toFixed(4);
					coordinates+=",";
					//bottom left
					coordinates+=_extent.xmin.toFixed(4);
					coordinates+=" ";
					coordinates+=_extent.ymin.toFixed(4);
					coordinates+=",";
					//bottom right
					coordinates+=_extent.xmax.toFixed(4);
					coordinates+=" ";
					coordinates+=_extent.ymin.toFixed(4);
					coordinates+=",";
					//top right
					coordinates+=_extent.xmax.toFixed(4);
					coordinates+=" ";
					coordinates+=_extent.ymax.toFixed(4);
					coordinates+=",";
					//top left
					coordinates+=_extent.xmin.toFixed(4);
					coordinates+=" ";
					coordinates+=_extent.ymax.toFixed(4);
					coordinates+="))";
					break;
				case Geometry.POLYGON:
					coordinates="POLYGON((";
					var _polygon:Polygon=Polygon(WebMercatorUtil.webMercatorToGeographic(geometry));
					var ringArray:Array=_polygon.rings;
					//loop through rings
					for(var x:int=0;x<ringArray.length;x++)
					{
						var ringpointArray:Array=ringArray[x];
						coordinates+=ringpointArray[0].x.toFixed(4);
						coordinates+=" ";
						coordinates+=ringpointArray[0].y.toFixed(4);
						
						if(ringpointArray.length<101)
						{
							for(var i:int=1;i<ringpointArray.length;i++)
							{
								coordinates+=",";
								coordinates+= ringpointArray[i].x.toFixed(4);
								coordinates+=" ";
								coordinates+= ringpointArray[i].y.toFixed(4);
							}
						}
						else if(ringpointArray.length>100&&ringpointArray.length<202)
						{
							//like circle, there are too many mappoints,and select one of every five to save
							for(var j:int=0;(j*5)<ringpointArray.length;j++)
							{
								coordinates+=",";
								coordinates+= ringpointArray[j*5].x.toFixed(4);
								coordinates+=" ";
								coordinates+= ringpointArray[j*5].y.toFixed(4);
							}
						}
						else
						{
							//like ellipse, there are too many mappoints,and select one of every ten to save
							for(var k:int=0;(k*5)<ringpointArray.length;k++)
							{
								coordinates+=",";
								coordinates+= ringpointArray[k*5].x.toFixed(4);
								coordinates+=" ";
								coordinates+= ringpointArray[k*5].y.toFixed(4);
							}
						}
						//this closes off the array of rings unless it is the last array
						if(x ==ringArray.length-1)
						{
							
						}
						else{
							coordinates+="),("
						}
					}
					
					coordinates+="))";
					break;
				default:
					return null;
					break;
			}
			return coordinates;
		}
		//only for simple point, line and polygon
		//coordinates String format: POINT(x y);LINESTRING(x1 y1,x2 y2,...,xn yn);POLYGON((x1 y1,x2 y2,...,xn yn,x1 y1))
		public static function CoordinatesToGraphic(coordinates:String,graphicSymbol:Symbol=null):Graphic
		{
			var GeoType:String=coordinates.substring(0,coordinates.indexOf("("));
			var coor:String=coordinates.substring(coordinates.indexOf("(")+1,coordinates.lastIndexOf(")"));
			
			var newRef:SpatialReference=new SpatialReference(4326);
			var newGeometry:Geometry=new Geometry();
			switch(GeoType)
			{
				case "POINT":
					var pointArray:Array=coor.split(" ");
					newGeometry=new MapPoint(Number(pointArray[0]),Number(pointArray[1]),newRef);
					break;
				case "LINESTRING":
					var pointsArray:Array=coor.split(",");
					var mappointArray:Array=new Array();
					for each (var pointString:String in pointsArray)
					{
						var pointArray_L:Array=pointString.split(" ");
						var newMappoint:MapPoint=new MapPoint(pointArray_L[0],pointArray_L[1],newRef);
						mappointArray.push(newMappoint);
					}
					newGeometry=new Polyline([mappointArray],newRef);
					break;
				case "POLYGON":
					var polygonCoor:String=coor.substring(coor.indexOf("(")+1,coor.lastIndexOf(")"));
					var ringArray:Array = polygonCoor.split("),(");
					
					var geomPoly:Polygon = new Polygon();
					//loop through rings
					for each (var ringString:String in ringArray)
					{
						var pointsArray_P:Array=ringString.split(",");
						var mappointArray_P:Array=new Array();
						for each (var pointString_P:String in pointsArray_P)
						{
							var pointArray_P:Array=pointString_P.split(" ");
							var newMappoint_P:MapPoint=new MapPoint(pointArray_P[0],pointArray_P[1],newRef);
							mappointArray_P.push(newMappoint_P);
						}
						geomPoly.addRing(mappointArray_P);
					}
					newGeometry=geomPoly;
					break;
				default:
					return null;
					break;
			}
			var newGeometryMercator:Geometry=WebMercatorUtil.geographicToWebMercator(newGeometry);
			var gra:Graphic = new Graphic(newGeometryMercator,graphicSymbol);
			return gra;
		}
		//coordinates String format: 
		//POINT(x y);LINESTRING(x1 y1,x2 y2,...,xn yn);POLYGON((x1 y1,x2 y2,...,xn yn,x1 y1))
		//EXTENT(xmin,ymin,xmax,ymax)
		public static function CoordinatesToGeoMetry(coordinates:String):Geometry
		{
			var GeoType:String=coordinates.substring(0,coordinates.indexOf("("));
			var coor:String=coordinates.substring(coordinates.indexOf("(")+1,coordinates.lastIndexOf(")"));
			
			var newRef:SpatialReference=new SpatialReference(4326);
			var newGeometry:Geometry;
			switch(GeoType.toUpperCase())
			{
				case "POINT":
					var pointArray:Array=coor.split(" ");
					newGeometry=new MapPoint(Number(pointArray[0]),Number(pointArray[1]),newRef);
					break;
				case "LINESTRING":
					var pointsArray:Array=coor.split(",");
					var mappointArray:Array=new Array();
					for each (var pointString:String in pointsArray)
					{
						var pointArray_L:Array=pointString.split(" ");
						var newMappoint:MapPoint=new MapPoint(pointArray_L[0],pointArray_L[1],newRef);
						mappointArray.push(newMappoint);
					}
					newGeometry=new Polyline([mappointArray],newRef);
					break;
				case "POLYGON":
					var polygonCoor:String=coor.substring(coor.indexOf("(")+1,coor.lastIndexOf(")"));
					var ringArray:Array = polygonCoor.split("),(");
					
					var geomPoly:Polygon = new Polygon();
					//loop through rings
					for each (var ringString:String in ringArray)
					{
						var pointsArray_P:Array=ringString.split(",");
						var mappointArray_P:Array=new Array();
						for each (var pointString_P:String in pointsArray_P)
						{
							var pointArray_P:Array=pointString_P.split(" ");
							var newMappoint_P:MapPoint=new MapPoint(pointArray_P[0],pointArray_P[1],newRef);
							mappointArray_P.push(newMappoint_P);
						}
						geomPoly.addRing(mappointArray_P);
					}
					newGeometry=geomPoly;
					break;
				case "EXTENT":
					var extentArray:Array=coor.split(",");
					newGeometry=new Extent(Number(extentArray[0]),Number(extentArray[1]),Number(extentArray[2]),Number(extentArray[3]),newRef);
					break;
				default:
					break;
			}
			return newGeometry;
		}
		public static function DateToString(d:Date,formatType:int=0) : String 
		{
			var zd:Date = d;
			var yea:String = zd.fullYear.toString();
			var mon:String = (zd.month+1).toString().length == 1 ? "0" + (zd.month+1).toString() : (zd.month+1).toString();
			var dat:String = zd.date.toString().length == 1 ? "0" + zd.date.toString() : zd.date.toString();
			var hrs:String = zd.hours.toString().length == 1 ? "0" + zd.hours.toString() : zd.hours.toString();
			var mis:String = zd.minutes.toString().length == 1 ? "0" + zd.minutes.toString() : zd.minutes.toString();
			var sec:String = zd.seconds.toString().length == 1 ? "0" + zd.seconds.toString() : zd.seconds.toString();			
			var qd:String;
			switch(formatType)
			{
				case 0:
					//return format:YYYY-MM-DD
					qd=yea + "-" + mon + "-" + dat;
					break;
				case 1:
					//return format:YYYY-MM-DDTHH:MM
					qd=yea + "-" + mon + "-" + dat+"T"+hrs + ":" + mis;
					break;
				case 2:
					//return format:YYYY-MM-DDTHH:MM:SS
					qd=yea + "-" + mon + "-" + dat+"T"+hrs + ":" + mis + ":" + sec;
					break;
				default:
					break;
			}
			return qd;
		}
		public static function DateToString_TimeZone2UTC(d:Date,_timeZone:Number,formatType:int=0):String
		{
			var zd:Date=new Date();
			var dateYear:int=d.fullYear;
			var dateMonth:int=d.month;
			var dateDate:int=d.date;
			var dateHours:int=d.hours;
			var dateMinutes:int=d.minutes;
			zd.setUTCFullYear(dateYear,dateMonth,dateDate);
			zd.setUTCHours(dateHours,dateMinutes,0,0);
			zd.hours-=int(_timeZone);
			zd.minutes-=((_timeZone%1)*60);
			var yea:String = zd.fullYearUTC.toString();
			var mon:String = (zd.monthUTC+1).toString().length == 1 ? "0" + (zd.monthUTC+1).toString() : (zd.monthUTC+1).toString();
			var dat:String = zd.dateUTC.toString().length == 1 ? "0" + zd.dateUTC.toString() : zd.dateUTC.toString();
			var hrs:String = zd.hoursUTC.toString().length == 1 ? "0" + zd.hoursUTC.toString() : zd.hoursUTC.toString();
			var min:String = zd.minutesUTC.toString().length == 1 ? "0" + zd.minutesUTC.toString() : zd.minutesUTC.toString();
			var sec:String = zd.secondsUTC.toString().length == 1 ? "0" + zd.secondsUTC.toString() : zd.secondsUTC.toString();
			var qd:String;
			switch(formatType)
			{
				case 0:
					//format:yyyymmddThhmm
					qd=yea + mon + dat + "T" + hrs + min;
					break;
				case 1:
					qd=yea +"-"+ mon+"-" + dat + "T" + hrs +":"+ min+":"+sec;
					break;
			}
			return qd;
		}
		public static function StringToDate_UTC2TimeZone(utcString:String,_timeZone:Number,formatID:int=0):Date
		{
			var dateYear:int; 
			var dateMonth:int;
			var dateDate:int;
			var dateHours:int;
			var dateMinutes:int;
			switch(formatID)
			{
				case 0:
					//string format: yyyymmddThhmm
					dateYear = new int(new String(utcString.charAt(0) + utcString.charAt(1) + utcString.charAt(2) + utcString.charAt(3))); 
					dateMonth = (new int(utcString.charAt(4) + utcString.charAt(5)) - 1);
					dateDate= new int(new String(utcString.charAt(6) + utcString.charAt(7)));
					dateHours = new int(new String(utcString.charAt(9) + utcString.charAt(10)));
					dateMinutes = new int(new String(utcString.charAt(11) + utcString.charAt(12)));
					break;
				case 1:
					//string format: yyyy-mm-ddThh:mm:ss
					dateYear = new int(new String(utcString.charAt(0) + utcString.charAt(1) + utcString.charAt(2) + utcString.charAt(3))); 
					dateMonth = (new int(utcString.charAt(5) + utcString.charAt(6)) - 1);
					dateDate = new int(new String(utcString.charAt(8) + utcString.charAt(9)));
					dateHours= new int(new String(utcString.charAt(11) + utcString.charAt(12)));
					dateMinutes = new int(new String(utcString.charAt(14) + utcString.charAt(15)));
					break;
				case 3:
					//string format: yyyy/mm/dd hh:mm   such as: 2012/9/9 4:00
					dateYear = new int(new String(utcString.charAt(0) + utcString.charAt(1) + utcString.charAt(2) + utcString.charAt(3))); 
					dateMonth = new int(utcString.substring(5,utcString.indexOf("/",5)));
					dateDate = new int(utcString.substring(utcString.indexOf("/",5)+1,utcString.indexOf(" ",5)));
					dateHours= new int(utcString.substring(utcString.indexOf(" ",5)+1,utcString.indexOf(":",5)));
					dateMinutes = new int(utcString.substring(utcString.indexOf(":",5)+1,utcString.length-1));
					break;
				case 4:
					//string format: yyyy/mm/dd hh:mm:ss   such as: 2012/9/9 4:00:00
					dateYear = new int(new String(utcString.charAt(0) + utcString.charAt(1) + utcString.charAt(2) + utcString.charAt(3))); 
					dateMonth = new int(utcString.substring(5,utcString.indexOf("/",5)));
					dateDate = new int(utcString.substring(utcString.indexOf("/",5)+1,utcString.indexOf(" ",5)));
					dateHours= new int(utcString.substring(utcString.indexOf(" ",5)+1,utcString.indexOf(":",5)));
					dateMinutes = new int(utcString.substring(utcString.indexOf(":",5)+1,utcString.indexOf(":",utcString.indexOf(":") + 1)));
					break;
			}
			var zd:Date=new Date();
			var timeDifference:Number=_timeZone-(-zd.getTimezoneOffset()/60);
			zd.setUTCFullYear(dateYear,dateMonth,dateDate);
			zd.setUTCHours(dateHours,dateMinutes,0,0);
			//convert scenario date to customized time zone
			zd.hours+=int(timeDifference);
			zd.minutes+=((timeDifference%1)*60);
			return zd;
		}
		public static function DeepCopy(source:Object):Object
		{
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return(myBA.readObject());
		}
		public static function str2utf8(str:String):String//字符串转换为utf8编码
		{
			var strnew:String = "";
			var byte:ByteArray = new ByteArray();
			byte.writeMultiByte(str,"UTF-8");
			for (var i:int=0; i<byte.length; i++)
			{
				strnew = strnew + byte[i].toString(16);
			}
			return strnew;
		}
		public static function str2GB2312(str:String):String
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeMultiByte(str, "gb2312");
			byteArray.position = 0;
			var newStr:String = byteArray.readMultiByte(byteArray.bytesAvailable, "gb2312");
			return newStr;
		}
		public static function decimal2(num:Number,n:Number):Number
		{ 	
			var ts:String="1"; 
			var tn:Number=1; 
			
			for(var i:int=0;i<n;i++){ 
				ts+="0" 
			} 
			
			tn=Number(ts); 
			return Math.round(num*tn)/tn 
		}
		public static function getBrowserName():String
		{
			var browser:String;
			
			//Uses external interface to reach out to browser and grab browser useragent info.
			var browserAgent:String = ExternalInterface.call("function getBrowser(){return navigator.userAgent;}");
			//Determines brand of browser using a find index. If not found indexOf returns (-1).
			if (browserAgent != null && browserAgent.indexOf("Firefox") >= 0)
				browser = "Firefox";
			else if (browserAgent != null && browserAgent.indexOf("Safari") >= 0)
				browser = "Safari";
			else if (browserAgent != null && browserAgent.indexOf("MSIE") >= 0)
				browser = "IE";
			else if (browserAgent != null && browserAgent.indexOf("Opera") >= 0)
				browser = "Opera";
			else
				browser = "Undefined";
			return browser;
		}

	}
}
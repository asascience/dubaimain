package com.asa.components
{
	import com.esri.ags.Graphic;
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.*;
	import com.esri.ags.symbols.*;
	import com.esri.ags.utils.WebMercatorUtil;
	
	import flash.system.System;

	public final class DataUtilitiesold
	{
		public function DataUtilitiesold()
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
		public static function GraphicToCoordinates(graphic:Graphic):String
		{
			var coordinates:String;
			switch(graphic.geometry.type)
			{
				case Geometry.MAPPOINT:
					
					coordinates="POINT(";
					var _point:MapPoint=MapPoint(WebMercatorUtil.webMercatorToGeographic(graphic.geometry));
					//一个Graphic中的polyline只有一条线段
					coordinates+=_point.x.toString();
					coordinates+=" ";
					coordinates+=_point.y.toString();
					coordinates+=")";
					break;
				case Geometry.MULTIPOINT:
					return null;
					break;
				case Geometry.POLYLINE:
					coordinates="LINESTRING(";
					var _polyline:Polyline=Polyline(WebMercatorUtil.webMercatorToGeographic(graphic.geometry));
					//一个Graphic中的polyline只有一条线段
					coordinates+=_polyline.getPoint(0,0).x.toString();
					coordinates+=" ";
					coordinates+=_polyline.getPoint(0,0).y.toString();
					for(var j:int=1;j<_polyline.paths[0].length;j++)
					{
						coordinates+=",";
						coordinates+=_polyline.getPoint(0,j).x.toString();
						coordinates+=" ";
						coordinates+=_polyline.getPoint(0,j).y.toString();
					}
					coordinates+=")";
					break;
				case Geometry.EXTENT:
					coordinates="POLYGON((";
					var _extent:Extent=Extent(WebMercatorUtil.webMercatorToGeographic(graphic.geometry));
					//top left
					coordinates+=_extent.xmin.toString();
					coordinates+=" ";
					coordinates+=_extent.ymax.toString();
					coordinates+=",";
					//bottom left
					coordinates+=_extent.xmin.toString();
					coordinates+=" ";
					coordinates+=_extent.ymin.toString();
					coordinates+=",";
					//bottom right
					coordinates+=_extent.xmax.toString();
					coordinates+=" ";
					coordinates+=_extent.ymin.toString();
					coordinates+=",";
					//top right
					coordinates+=_extent.xmax.toString();
					coordinates+=" ";
					coordinates+=_extent.ymax.toString();
					coordinates+=",";
					//top left
					coordinates+=_extent.xmin.toString();
					coordinates+=" ";
					coordinates+=_extent.ymax.toString();
					coordinates+="))";
					break;
				case Geometry.POLYGON:
					coordinates="POLYGON((";
					var _polygon:Polygon=Polygon(WebMercatorUtil.webMercatorToGeographic(graphic.geometry));
					var ringArray:Array=_polygon.rings;
					//一个简单polygon中的rings只有一个ring
					var ringpointArray:Array=ringArray[0];
					
					coordinates+=ringpointArray[0].x.toString();
					coordinates+=" ";
					coordinates+=ringpointArray[0].y.toString();
					
					if(ringpointArray.length<101)
					{
						for(var i:int=1;i<ringpointArray.length;i++)
						{
							coordinates+=",";
							coordinates+= ringpointArray[i].x.toString();
							coordinates+=" ";
							coordinates+= ringpointArray[i].y.toString();
						}
					}
					else if(ringpointArray.length>100&&ringpointArray.length<202)
					{
						//like circle, there are too many mappoints,and select one of every five to save
						for(var j:int=0;(j*5)<ringpointArray.length;j++)
						{
							coordinates+=",";
							coordinates+= ringpointArray[j*5].x.toString();
							coordinates+=" ";
							coordinates+= ringpointArray[j*5].y.toString();
						}
					}
					else
					{
						//like ellipse, there are too many mappoints,and select one of every ten to save
						for(var k:int=0;(k*5)<ringpointArray.length;k++)
						{
							coordinates+=",";
							coordinates+= ringpointArray[k*5].x.toString();
							coordinates+=" ";
							coordinates+= ringpointArray[k*5].y.toString();
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
		public static function CoordinatesToGraphic(coordinates:String,graphicSymbol:Symbol):Graphic
		{
			var GeoType:String=coordinates.substring(0,coordinates.indexOf("("));
			var coor:String=coordinates.substring(coordinates.indexOf("(")+1,coordinates.indexOf(")"));
			
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
						var pointArray:Array=pointString.split(" ");
						var newMappoint:MapPoint=new MapPoint(pointArray[0],pointArray[1],newRef);
						mappointArray.push(newMappoint);
					}
					newGeometry=new Polyline([mappointArray],newRef);
					break;
				case "POLYGON":
					var pointsArray:Array=coor.split(",");
					var mappointArray:Array=new Array();
					for each (var pointString:String in pointsArray)
					{
						var pointArray:Array=pointString.split(" ");
						var newMappoint:MapPoint=new MapPoint(pointArray[0],pointArray[1],newRef);
						mappointArray.push(newMappoint);
					}
					newGeometry=new Polygon([mappointArray],newRef);
					break;
				default:
					return null;
					break;
			}
			var newGeometryMercator:Geometry=WebMercatorUtil.geographicToWebMercator(newGeometry);
			var gra:Graphic = new Graphic(newGeometryMercator,graphicSymbol);
			return gra;
		}
		//return format:YYYY-MM-DD
		public static function DateToString(d:Date) : String 
		{
			var zd:Date = d;
			var yea:String = zd.fullYear.toString();
			var mon:String = (zd.month+1).toString().length == 1 ? "0" + (zd.month+1).toString() : (zd.month+1).toString();
			var dat:String = zd.date.toString().length == 1 ? "0" + zd.date.toString() : zd.date.toString();
			var hrs:String = zd.hours.toString().length == 1 ? "0" + zd.hours.toString() : zd.hours.toString();
			var mis:String = zd.minutes.toString().length == 1 ? "0" + zd.minutes.toString() : zd.minutes.toString();
			var qd:String=yea + "-" + mon + "-" + dat;
			return qd;
		}
	}
}
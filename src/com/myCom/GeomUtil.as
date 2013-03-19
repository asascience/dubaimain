package com.myCom
{
	import com.esri.ags.geometry.MapPoint;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	
	public final class GeomUtil
	{
		/*public function GeomUtil()
		{
			super();
		}*/
		
		public static function InsidePolygon(ringListCollection:ArrayCollection, p:MapPoint):Boolean
		{
			var inaRing:Boolean = false;
			
			//iterate through entire list of poly rings
			for(var r:int=0; r <ringListCollection.length; r++)
			{
				var pointList:Array = [];
				pointList = ringListCollection[r];
				
				var counter:int = 0;
				var i:int;
				var xinters:Number;
				var p1:MapPoint;
				var p2:MapPoint;
				var n:int = pointList.length;
				
				p1 = pointList[0];
				//determine if that point falls in this ring
				for (i = 1; i <= n; i++)
				{
					p2 = pointList[i % n];
					if (p.y > Math.min(p1.y, p2.y))
					{
						if (p.y <= Math.max(p1.y, p2.y))
						{
							if (p.x <= Math.max(p1.x, p2.x))
							{
								if (p1.y != p2.y) {
									xinters = (p.y - p1.y) * (p2.x - p1.x) / (p2.y - p1.y) + p1.x;
									if (p1.x == p2.x || p.x <= xinters)
										counter++;
								}
							}
						}
					}
					p1 = p2;
				}
				if (counter % 2 == 0)
				{
					//return(false);
				}
				else
				{
					//return(true);
					inaRing = true;
				}
			}
			return inaRing
		}      
	}
}	

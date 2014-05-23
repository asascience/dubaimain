package widgets.OilSpill.components.util
{
	import mx.formatters.DateFormatter;
	public final class DateTimeUtilities
	{
		public static function gmtDateToDBDateString(dateIn:Date):String
		{
			//Mon Jan 18 11:59:00 GMT-0500 2010 to "Jan 18 2010 11:59:00"
			//trace(dateIn.toString());
			var monthNames:Array = new Array(
				  "JAN",
                  "FEB",
                  "MAR",
                  "APR",
                  "MAY",
                  "JUN",
                  "JUL",
                  "AUG",
                  "SEP",
                  "OCT",
                  "NOV",
                  "DEC");
             var monthStr:String = monthNames[dateIn.getMonth()];
             var dayStr:String = dateIn.getDate().toString();
             if(dayStr.length==1)
             {dayStr="0" + dayStr;}
             var yearStr:String = dateIn.getFullYear().toString();
             var hoursStr:String = dateIn.getHours().toString();
             if(hoursStr.length==1)
             {hoursStr="0" + hoursStr;}
             var minsStr:String = dateIn.getMinutes().toString();
             if(minsStr.length==1)
             {minsStr="0" + minsStr;}
             var secsStr:String = dateIn.getSeconds().toString();
             if(secsStr.length==1)
             {secsStr="0" + secsStr;}
             var spaceStr:String = " ";
             var rtnString:String = monthStr + spaceStr + dayStr + spaceStr + yearStr + spaceStr + hoursStr + ":"
                + minsStr + ":" + secsStr;
             //trace(rtnString);
             return rtnString;   
		}
		public static function getFeatureDateToDBDateString(dateIn:Date):String
		{
			//Mon Jan 18 11:59:00 GMT-0500 2010 to "01-18-2010 12:00:00"
			//trace(dateIn.toString());
			var monthNames:Array = new Array(
				"JAN",
				"FEB",
				"MAR",
				"APR",
				"MAY",
				"JUN",
				"JUL",
				"AUG",
				"SEP",
				"OCT",
				"NOV",
				"DEC");
			var monthStr:String = (dateIn.getMonth()+1).toString();
			if(monthStr.length==1)
			{monthStr="0" + monthStr;}
			var dayStr:String = dateIn.getDate().toString();
			if(dayStr.length==1)
			{dayStr="0" + dayStr;}
			var yearStr:String = dateIn.getFullYear().toString();
			//var hoursStr:String = (dateIn.getHours() + 4).toString();
			var hoursStr:String = dateIn.getHours().toString();
			if(hoursStr.length==1)
			{hoursStr="0" + hoursStr;}
			var minsStr:String = dateIn.getMinutes().toString();
			if(minsStr.length==1)
			{minsStr="0" + minsStr;}
			var secsStr:String = dateIn.getSeconds().toString();
			if(secsStr.length==1)
			{secsStr="0" + secsStr;}
			var spaceStr:String = " ";
			var dashStr:String = "-";
			if(Number(minsStr)>29)
			{
				if(hoursStr=="00")
				{
					hoursStr="01";
				}
				else if(hoursStr=="01")
				{
				hoursStr="02";
				}
				else if(hoursStr=="02")
				{
				hoursStr="03";
				}
				else if(hoursStr=="04")
				{
				hoursStr="05";
				}
				else if(hoursStr=="05")
				{
				hoursStr="06";
				}
				else if(hoursStr=="07")
				{
				hoursStr="08";
				}
				else if(hoursStr=="08")
				{
				hoursStr="09";
				}
				else if(hoursStr=="09")
				{
				hoursStr="10";
				}
				else if(hoursStr=="10")
				{
				hoursStr="11";
				}
				else if(hoursStr=="11")
				{
				hoursStr="12";
				}
				else if(hoursStr=="13")
				{
				hoursStr="14";
				}
				else if(hoursStr=="14")
				{
				hoursStr="15";
				}
				else if(hoursStr=="15")
				{
					hoursStr="16";
				}
				else if(hoursStr=="16")
				{
				hoursStr="17";
				}
				else if(hoursStr=="17")
				{
				hoursStr="18";
				}
				else if(hoursStr=="18")
				{
					hoursStr="19";
				}
				else if(hoursStr=="19")
				{
				hoursStr="20";
				}
				else if(hoursStr=="20")
				{
				hoursStr="21";
				}
				else if(hoursStr=="21")
				{
					hoursStr="22";
				}
				else if(hoursStr=="22")
				{
				hoursStr="23";
				}
				else if(hoursStr=="23")
				{
					hoursStr="00";
					dayStr = (Number(dayStr)+1).toString();
					if(dayStr.length==1)
					{
						{dayStr="0" + dayStr;};
					}
				}
			}
			
			var rtnString:String = monthStr + dashStr + dayStr + dashStr + yearStr + spaceStr + hoursStr + ":00:00";
			//trace(rtnString);
			return rtnString;   
		}
		
		//For finding closest date for 6 hour intervals
		public static function getFeatureDateWarningToDBDateString(dateIn:Date):String
		{
			//Mon Jan 18 11:59:00 GMT-0500 2010 to "01-JAN-2010 12:00"
			//trace(dateIn.toString());
			var monthNames:Array = new Array(
				"JAN",
				"FEB",
				"MAR",
				"APR",
				"MAY",
				"JUN",
				"JUL",
				"AUG",
				"SEP",
				"OCT",
				"NOV",
				"DEC");
			var monthStr:String = monthNames[dateIn.getMonth()];
			var dayStr:String = dateIn.getDate().toString();
			if(dayStr.length==1)
			{dayStr="0" + dayStr;}
			var yearStr:String = dateIn.getFullYear().toString();
			//var hoursStr:String = (dateIn.getHours() + 4).toString();
			var hoursStr:String = dateIn.getHours().toString();
			if(hoursStr.length==1)
			{hoursStr="0" + hoursStr;}
			var minsStr:String = dateIn.getMinutes().toString();
			if(minsStr.length==1)
			{minsStr="0" + minsStr;}
			var secsStr:String = dateIn.getSeconds().toString();
			if(secsStr.length==1)
			{secsStr="0" + secsStr;}
			var spaceStr:String = " ";
			var dashStr:String = "-";
			
			if(hoursStr=="00")
			{
				hoursStr="00";
			}
			else if(hoursStr=="01")
			{
				hoursStr="00";
			}
			else if(hoursStr=="02")
			{
				hoursStr="00";
			}
			else if(hoursStr=="03")
			{
				hoursStr="00";
			}
			else if(hoursStr=="04")
			{
				hoursStr="06";
			}
			else if(hoursStr=="05")
			{
				hoursStr="06";
			}
			else if(hoursStr=="07")
			{
				hoursStr="06";
			}
			else if(hoursStr=="08")
			{
				hoursStr="06";
			}
			else if(hoursStr=="09")
			{
				hoursStr="12";
			}
			else if(hoursStr=="10")
			{
				hoursStr="12";
			}
			else if(hoursStr=="11")
			{
				hoursStr="12";
			}
			else if(hoursStr=="13")
			{
				hoursStr="12";
			}
			else if(hoursStr=="14")
			{
				hoursStr="12";
			}
			else if(hoursStr=="15")
			{
				hoursStr="12";
			}
			else if(hoursStr=="16")
			{
				hoursStr="18";
			}
			else if(hoursStr=="17")
			{
				hoursStr="18";
			}
			else if(hoursStr=="18")
			{
				hoursStr="18";
			}
			else if(hoursStr=="19")
			{
				hoursStr="18";
			}
			else if(hoursStr=="20")
			{
				hoursStr="18";
			}
			else if(hoursStr=="21")
			{
				hoursStr="18";
			}
			else
			{
				hoursStr="00";
				dayStr = (Number(dayStr)+1).toString();
				if(dayStr.length==1)
				{
					{dayStr="0" + dayStr;};
				}
				if(new Date(dateIn.setTime()*1000*60*60*3).month>dateIn.month)
				{
					dayStr = "00";
					monthStr = monthNames[dateIn.getMonth()+1]
				}
			}
			
			var rtnString:String = dayStr + dashStr + monthStr + dashStr + yearStr + spaceStr + hoursStr + ":00";
			//trace(rtnString);
			return rtnString;   
		}
		
		//For finding closest date for 6 hour intervals
		public static function getDateWarningToDBDateStringRound(dateIn:Date):Object
		{
			//Mon Jan 18 11:59:00 GMT-0500 2010 to "01-JAN-2010 12:00"
			//trace(dateIn.toString());
			var monthNames:Array = new Array(
				"JAN",
				"FEB",
				"MAR",
				"APR",
				"MAY",
				"JUN",
				"JUL",
				"AUG",
				"SEP",
				"OCT",
				"NOV",
				"DEC");
			var monthStr:String = monthNames[dateIn.getMonth()];
			var dayStr:String = dateIn.getDate().toString();
			if(dayStr.length==1)
			{dayStr="0" + dayStr;}
			var yearStr:String = dateIn.getFullYear().toString();
			//var hoursStr:String = (dateIn.getHours() + 4).toString();
			var hoursStr:String = dateIn.getHours().toString();
			if(hoursStr.length==1)
			{hoursStr="0" + hoursStr;}
			var minsStr:String = dateIn.getMinutes().toString();
			if(minsStr.length==1)
			{minsStr="0" + minsStr;}
			var secsStr:String = dateIn.getSeconds().toString();
			if(secsStr.length==1)
			{secsStr="0" + secsStr;}
			var spaceStr:String = " ";
			var dashStr:String = "-";
			
			var objectReturn:Object = new Object;
			var roundedHow:String;
			
			if(hoursStr=="00")
			{
				hoursStr="00";
				roundedHow = "down";
			}
			else if(hoursStr=="01")
			{
				hoursStr="00";
				roundedHow = "down";
			}
			else if(hoursStr=="02")
			{
				hoursStr="00";
				roundedHow = "down";
			}
			else if(hoursStr=="03")
			{
				hoursStr="06";
				roundedHow = "down";
			}
			else if(hoursStr=="04")
			{
				hoursStr="06";
				roundedHow = "up";
			}
			else if(hoursStr=="05")
			{
				hoursStr="06";
				roundedHow = "up";
			}
			else if(hoursStr=="06")
			{
				hoursStr="06";
				roundedHow = "down";
			}
			else if(hoursStr=="07")
			{
				hoursStr="06";
				roundedHow = "down";
			}
			else if(hoursStr=="08")
			{
				hoursStr="06";
				roundedHow = "down";
			}
			else if(hoursStr=="09")
			{
				hoursStr="12";
				roundedHow = "up";
			}
			else if(hoursStr=="10")
			{
				hoursStr="12";
				roundedHow = "up";
			}
			else if(hoursStr=="11")
			{
				hoursStr="12";
				roundedHow = "up";
			}
			else if(hoursStr=="12")
			{
				hoursStr="12";
				roundedHow = "down";
			}
			else if(hoursStr=="13")
			{
				hoursStr="12";
				roundedHow = "down";
			}
			else if(hoursStr=="14")
			{
				hoursStr="12";
				roundedHow = "down";
			}
			else if(hoursStr=="15")
			{
				hoursStr="18";
				roundedHow = "up";
			}
			else if(hoursStr=="16")
			{
				hoursStr="18";
				roundedHow = "up";
			}
			else if(hoursStr=="17")
			{
				hoursStr="18";
				roundedHow = "up";
			}
			else if(hoursStr=="18")
			{
				hoursStr="18";
				roundedHow = "down";
			}
			else if(hoursStr=="19")
			{
				hoursStr="18";
				roundedHow = "down";
			}
			else if(hoursStr=="20")
			{
				hoursStr="18";
				roundedHow = "down";
			}
			else if(hoursStr=="21")
			{
				hoursStr="18";
				roundedHow = "down";
			}
			else
			{
				roundedHow = "up";
				hoursStr="00";
				dayStr = (Number(dayStr)+1).toString();
				if(dayStr.length==1)
				{
					{dayStr="0" + dayStr;};
				}
				if(new Date(dateIn.setTime()*1000*60*60*3).month>dateIn.month)
				{
					dayStr = "00";
					monthStr = monthNames[dateIn.getMonth()+1]
				}
			}
			
			var rtnString:String = dayStr + dashStr + monthStr + dashStr + yearStr + spaceStr + hoursStr + ":00";
			objectReturn.date = rtnString;
			objectReturn.rounded = roundedHow;
			return objectReturn;   
		}
		
		
		//For finding closest date for 6 hour intervals
		public static function getFeatureDateWarningToDBDate(dateIn:Date):Date
		{
			//Mon Jan 18 11:59:00 GMT-0500 2010 to "01-JAN-2010 12:00"
			var newDate:Date = dateIn;
			var hoursStr:String = newDate.hours.toString();
			
			newDate.setMinutes(0);
			
			if(hoursStr=="1")
			{
				newDate.setHours(0);
			}
			else if(hoursStr=="2")
			{
				newDate.setHours(0);
			}
			else if(hoursStr=="3")
			{
				newDate.setHours(6);
			}
			else if(hoursStr=="4")
			{
				newDate.setHours(6);
			}
			else if(hoursStr=="5")
			{
				newDate.setHours(6);
			}
			else if(hoursStr=="7")
			{
				newDate.setHours(6);
			}
			else if(hoursStr=="8")
			{
				newDate.setHours(6);
			}
			else if(hoursStr=="9")
			{
				newDate.setHours(12);
			}
			else if(hoursStr=="10")
			{
				newDate.setHours(12);
			}
			else if(hoursStr=="11")
			{
				newDate.setHours(12);
			}
			else if(hoursStr=="13")
			{
				newDate.setHours(12);
			}
			else if(hoursStr=="14")
			{
				newDate.setHours(12);
			}
			else if(hoursStr=="15")
			{
				newDate.setHours(18);
			}
			else if(hoursStr=="16")
			{
				newDate.setHours(18);
			}
			else if(hoursStr=="17")
			{
				newDate.setHours(18);
			}
			else if(hoursStr=="18")
			{
				newDate.setHours(18);
			}
			else if(hoursStr=="19")
			{
				newDate.setHours(18);
			}
			else if(hoursStr=="20")
			{
				newDate.setHours(18);
			}
			else if(hoursStr=="21")
			{
				newDate.setHours(18);
			}
			else if(hoursStr=="22"||hoursStr=="23")
			{
				newDate.setHours(0);
				
				newDate.setDate(newDate.date+1);
				/*if(new Date(dateIn.setTime()*1000*60*60*3).month>dateIn.month)
				{
					newDate.setMonth(newDate.month+1);
				}
				else{
				}*/
			}
			
			return newDate;   
		}
		
		//For finding closest date for three hour intervals
		public static function getFeatureDateGFSToDBDateString(dateIn:Date):String
		{
			//Mon Jan 18 11:59:00 GMT-0500 2010 to "01-18-2010 12:00:00"
			//trace(dateIn.toString());
			var monthNames:Array = new Array(
				"JAN",
				"FEB",
				"MAR",
				"APR",
				"MAY",
				"JUN",
				"JUL",
				"AUG",
				"SEP",
				"OCT",
				"NOV",
				"DEC");
			var monthStr:String = (dateIn.getMonth()+1).toString();
			if(monthStr.length==1)
			{monthStr="0" + monthStr;}
			var dayStr:String = dateIn.getDate().toString();
			if(dayStr.length==1)
			{dayStr="0" + dayStr;}
			var yearStr:String = dateIn.getFullYear().toString();
			//var hoursStr:String = (dateIn.getHours() + 4).toString();
			var hoursStr:String = dateIn.getHours().toString();
			if(hoursStr.length==1)
			{hoursStr="0" + hoursStr;}
			var minsStr:String = dateIn.getMinutes().toString();
			if(minsStr.length==1)
			{minsStr="0" + minsStr;}
			var secsStr:String = dateIn.getSeconds().toString();
			if(secsStr.length==1)
			{secsStr="0" + secsStr;}
			var spaceStr:String = " ";
			var dashStr:String = "-";
			
			if(hoursStr=="00")
			{
				hoursStr="00";
			}
			else if(hoursStr=="01")
			{
				hoursStr="00";
			}
			else if(hoursStr=="02")
			{
				hoursStr="03";
			}
			else if(hoursStr=="04")
			{
				hoursStr="03";
			}
			else if(hoursStr=="05")
			{
				hoursStr="06";
			}
			else if(hoursStr=="07")
			{
				hoursStr="06";
			}
			else if(hoursStr=="08")
			{
				hoursStr="09";
			}
			else if(hoursStr=="09")
			{
				hoursStr="09";
			}
			else if(hoursStr=="10")
			{
				hoursStr="12";
			}
			else if(hoursStr=="11")
			{
				hoursStr="12";
			}
			else if(hoursStr=="13")
			{
				hoursStr="12";
			}
			else if(hoursStr=="14")
			{
				hoursStr="15";
			}
			else if(hoursStr=="15")
			{
				hoursStr="15";
			}
			else if(hoursStr=="16")
			{
				hoursStr="15";
			}
			else if(hoursStr=="17")
			{
				hoursStr="18";
			}
			else if(hoursStr=="18")
			{
				hoursStr="18";
			}
			else if(hoursStr=="19")
			{
				hoursStr="21";
			}
			else if(hoursStr=="20")
			{
				hoursStr="21";
			}
			else if(hoursStr=="21")
			{
				hoursStr="21";
			}
			else
			{
				hoursStr="00";
				dayStr = (Number(dayStr)+1).toString();
				if(dayStr.length==1)
				{
					{dayStr="0" + dayStr;};
				}
			}
			
			var rtnString:String = monthStr + dashStr + dayStr + dashStr + yearStr + spaceStr + hoursStr + ":00:00";
			//trace(rtnString);
			return rtnString;   
		}
		
		public static function ZuluToDateTime(zulu:String):Date
		{
			var sDateTime:String = zulu.replace("Z", "");
			var day:String;
			var hour:String;
			var month:String;
			var min:String;
			var year:String;
									
			sDateTime=sDateTime.replace(" ", "");
			day=sDateTime.substr(0,2);
			hour=sDateTime.substr(2,2);
			min=sDateTime.substr(4,2);
			month=sDateTime.substr(6,3);
			
			var monthNames:Array = new Array("JAN",
                  "FEB",
                  "MAR",
                  "APR",
                  "MAY",
                  "JUN",
                  "JUL",
                  "AUG",
                  "SEP",
                  "OCT",
                  "NOV",
                  "DEC");
		    
		    var monthNum:int = monthNames.indexOf(month, 0);
		    sDateTime=sDateTime.replace(day, "").replace(hour, "").replace(min,"").replace(month,"");	
		    year = "20" + sDateTime.replace(" ", "");  //TODO: DANGER DANGER!! Handle 2 digit year 
			var rsltDate:Date= new Date(year, monthNum, Number(day), Number(hour), Number(min));
			return rsltDate;
		}
		
		public static function DBStringDateToZulu(strIn:String):String
		{
			if(strIn==null || strIn=="")return "";
			var dateOut:Date = DBStringDateToDate(strIn);
			var stringOut:String = DateTimeToZulu(dateOut);
			return stringOut;
		}
		
		public static function DBStringDateToDate(strIn:String):Date
		{
			  //2009-08-20T16:23:00-04:00 to "2009/08/20 16:23:00"
              var len:int = strIn.lastIndexOf("-");
              var tmpStr:String = strIn.substring(0, len);
              tmpStr=tmpStr.replace("T", " ");
              var pattern:RegExp = /-/gi;
              tmpStr=tmpStr.replace(pattern, "/");
              var realDate:Date = new Date(tmpStr);
              return realDate;  
		}
		
		public static function DBStringDateToStringDate(strIn:String):String
		{
			//2009-08-20T16:23:00 to "2009/08/20 16:23:00"
			var len:int = strIn.lastIndexOf("T");
			var dateStr:String = strIn.substring(0, len);
			var pattern:RegExp = /-/gi;
			dateStr=dateStr.replace(pattern, "/");
			var timeStr:String= strIn.substr(len+1,strIn.length);
			if(timeStr=="00:00:00")
			{return dateStr;}
			else
			{return dateStr + " " + timeStr;}
		}
		
		public static function StringDateTimeToZuluNoHyphens(dateIn:String):String
		{
			//in: MAR 03 2010 11:00:00
			//trace(dateIn);
			var rtnString:String = "";
			//get month, day, year, hour, minute
			var dateTimeParts:Array = dateIn.split(" ");
			var timeParts:Array = dateTimeParts[3].toString().split(":");
			var monthName:String = dateTimeParts[0];
            var day:String = dateTimeParts[1].toString();
            var year:String = dateTimeParts[2].toString();
            var hour:String = timeParts[0].toString();
            var min:String = timeParts[1].toString();
            
            rtnString = day + hour + min + "Z " + monthName + " " + year.substr(2,2);
			return rtnString;
		}
		public static function StringDateTimeToZulu(dateIn:String):String
		{
			//trace(dateIn);
			var rtnString:String = "";
			//get month, day, year, hour, minute
			var dateTimeParts:Array = dateIn.split(" ");
			var dateParts:Array = dateTimeParts[0].toString().split("-");
            var timeParts:Array = dateTimeParts[1].toString().split(":");
            
			var monthNames:Array = new Array("JAN",
                  "FEB",
                  "MAR",
                  "APR",
                  "MAY",
                  "JUN",
                  "JUL",
                  "AUG",
                  "SEP",
                  "OCT",
                  "NOV",
                  "DEC");
             
            var monthName:String = monthNames[parseInt(dateParts[0])-1];
            var day:String = dateParts[1].toString();
            var year:String = dateParts[2].toString();
            var hour:String = timeParts[0].toString();
            var min:String = timeParts[1].toString();
            
            rtnString = day + hour + min + "Z " + monthName + " " + year.substr(2,2);
			return rtnString;
             
		}
		
		public static function DateTimeToZulu(dateIn:Date):String
		{   
			//trace(dateIn);
			//trace(dateIn.toDateString());
			var rtnString:String = "";
			var day:String = dateIn.getDate().toString();
			if(day=="NaN"){return "";}
			if(day.length==1){day="0" + day;}
			var hour:String = dateIn.getHours().toString();
			if(hour.length==1){hour="0" + hour;}
			var min:String = dateIn.getMinutes().toString();
			if(min.length==1){min="0" + min;}
			var year:String = dateIn.getFullYear().toString();
			var monthNames:Array = new Array("JAN",
                  "FEB",
                  "MAR",
                  "APR",
                  "MAY",
                  "JUN",
                  "JUL",
                  "AUG",
                  "SEP",
                  "OCT",
                  "NOV",
                  "DEC");
            var monthName:String = monthNames[dateIn.getMonth()];
           
            rtnString = day.toString() + hour.toString() + min.toString() + "Z " + monthName + " " + year.toString().substr(2,2);
			return rtnString;
		}
		
		public static function numbertoMonth(mon:String):Number
		{
			var monthNames:Array = new Array("JAN",
				"FEB",
				"MAR",
				"APR",
				"MAY",
				"JUN",
				"JUL",
				"AUG",
				"SEP",
				"OCT",
				"NOV",
				"DEC");
			
			var num:Number;
				
			for(var i:uint=0; i <monthNames.length; i++)
			{
				if(mon == monthNames[i])
				{
					num = i;
				}
			}
			
			return num;
		}		
		
		//calculates the difference in hours between two dates
		public static function DateDiffHours(startDate:Date, endDate:Date):Number
		{
			var oneHourMS:Number = 1000 * 60 * 60;
			var date1MS:Number = startDate.getTime();
			var date2MS:Number = endDate.getTime();
			var differenceMS:Number = Math.abs(date2MS - date1MS);
			//trace("DateDiff: startDate = " + date1MS.toString() + ", endDate = " + date2MS.toString());
			return Math.round(differenceMS/oneHourMS);
			
		}
		
		//compares two dates, determines if first date is earlier, equal to, or later than the
		//second date, returning -1, 0, and 1 respectively
		public static function DateCompare(date1:Date, date2:Date):Number
        {
        	var date1TimeStamp:Number=date1.getTime();
            var date2TimeStamp:Number=date2.getTime();
		    var result:Number=-1;
		
		    if (date1TimeStamp==date2TimeStamp)
		    { result = 0;}
		    
		    else if (date1TimeStamp > date2TimeStamp)
		    {result = 1;}
		
		    return result;
        }
		
		public static function spillServiceDate(d:Date) : String 
		{
			var zd:Date = d;
			var df:DateFormatter = new DateFormatter;
			df.formatString = "YYYYMMDD";
			var qd:String = df.format(zd.toDateString());
			var hrs:String = zd.hours.toString().length == 1 ? "0" + zd.hours.toString() : zd.hours.toString();
			var min:String = zd.minutes.toString().length == 1 ? "0" + zd.minutes.toString() : zd.minutes.toString();
			var sec:String = zd.seconds.toString().length == 1 ? "0" + zd.seconds.toString() : zd.seconds.toString();
			qd = qd + "T" + hrs + ":" + min + ":" + sec;
			return qd;
		}
		//2 means for MultiLanguage
		public static function spillServiceDate2(d:Date) : String
		{
			//return yyyymmddThh:mm:ss
			var zd:Date = d;
			var yea:String = zd.fullYear.toString();
			var mon:String = (zd.month+1).toString().length == 1 ? "0" + (zd.month+1).toString() : (zd.month+1).toString();
			var dat:String = zd.date.toString().length == 1 ? "0" + zd.date.toString() : zd.date.toString();
			var hrs:String = zd.hours.toString().length == 1 ? "0" + zd.hours.toString() : zd.hours.toString();
			var min:String = zd.minutes.toString().length == 1 ? "0" + zd.minutes.toString() : zd.minutes.toString();
			var sec:String = zd.seconds.toString().length == 1 ? "0" + zd.seconds.toString() : zd.seconds.toString();
			var qd:String=yea + mon + dat + "T" + hrs + ":" + min + ":" + sec;
			return qd;
		}
		
		public static function spillServiceDate3(d:Date) : String
		{
			//return yyyy.mm.dd, hh:00:00
			var zd:Date = d;
			var yea:String = zd.fullYear.toString();
			var mon:String = (zd.month+1).toString().length == 1 ? "0" + (zd.month+1).toString() : (zd.month+1).toString();
			var dat:String = zd.date.toString().length == 1 ? "0" + zd.date.toString() : zd.date.toString();
			var hrs:String = zd.hours.toString().length == 1 ? "0" + zd.hours.toString() : zd.hours.toString();
			var qd:String=dat + "/" + mon + "/" + yea + ", " + hrs + ":00:00";
			return qd;
		}
		//for MutilLanguage and UTC
		public static function spillServiceDate2UTC(d:Date) : String
		{
			var zd:Date = d;
			var yea:String = zd.fullYearUTC.toString();
			var mon:String = (zd.monthUTC+1).toString().length == 1 ? "0" + (zd.monthUTC+1).toString() : (zd.monthUTC+1).toString();
			var dat:String = zd.dateUTC.toString().length == 1 ? "0" + zd.dateUTC.toString() : zd.dateUTC.toString();
			var hrs:String = zd.hoursUTC.toString().length == 1 ? "0" + zd.hoursUTC.toString() : zd.hoursUTC.toString();
			var min:String = zd.minutesUTC.toString().length == 1 ? "0" + zd.minutesUTC.toString() : zd.minutesUTC.toString();
			var sec:String = zd.secondsUTC.toString().length == 1 ? "0" + zd.secondsUTC.toString() : zd.secondsUTC.toString();
			var qd:String=yea + mon + dat + "T" + hrs + ":" + min + ":" + sec;
			return qd;
		}
		//for customized time zone to UTC
		public static function spillServiceDateWithTimeZone2UTC(d:Date,_timeZone:Number):String
		{
			
			var zd:Date=new Date();
			var dateYear:int=d.fullYear;
			var dateMonth:int=d.month;
			var dateDate:int=d.date;
			var dateHours:int=d.hours;
			zd.setUTCFullYear(dateYear,dateMonth,dateDate);
			zd.setUTCHours(dateHours,0,0,0);
			zd.hours-=int(_timeZone);
			zd.minutes-=((_timeZone%1)*60);
			var yea:String = zd.fullYearUTC.toString();
			var mon:String = (zd.monthUTC+1).toString().length == 1 ? "0" + (zd.monthUTC+1).toString() : (zd.monthUTC+1).toString();
			var dat:String = zd.dateUTC.toString().length == 1 ? "0" + zd.dateUTC.toString() : zd.dateUTC.toString();
			var hrs:String = zd.hoursUTC.toString().length == 1 ? "0" + zd.hoursUTC.toString() : zd.hoursUTC.toString();
			var min:String = zd.minutesUTC.toString().length == 1 ? "0" + zd.minutesUTC.toString() : zd.minutesUTC.toString();
			var sec:String = zd.secondsUTC.toString().length == 1 ? "0" + zd.secondsUTC.toString() : zd.secondsUTC.toString();
			var qd:String=yea + mon + dat + "T" + hrs + ":" + min + ":" + sec;
			return qd;
		}
		public static function spillHyphenServiceDate(d:Date) : String 
		{
			var zd:Date = d;
			var df:DateFormatter = new DateFormatter;
			df.formatString = "YYYY-MM-DD";
			var qd:String = df.format(zd.toDateString());
			var hrs:String = zd.hours.toString().length == 1 ? "0" + zd.hours.toString() : zd.hours.toString();
			var min:String = zd.minutes.toString().length == 1 ? "0" + zd.minutes.toString() : zd.minutes.toString();
			var sec:String = zd.seconds.toString().length == 1 ? "0" + zd.seconds.toString() : zd.seconds.toString();
			qd = qd + "T" + hrs + ":" + min + ":" + sec;			
			return qd;
		}
		//for MultiLanguage
		public static function spillHyphenServiceDate2(d:Date):String
		{
			var zd:Date = d;
			var yea:String = zd.fullYear.toString();
			var mon:String = (zd.month+1).toString().length == 1 ? "0" + (zd.month+1).toString() : (zd.month+1).toString();
			var dat:String = zd.date.toString().length == 1 ? "0" + zd.date.toString() : zd.date.toString();
			var hrs:String = zd.hours.toString().length == 1 ? "0" + zd.hours.toString() : zd.hours.toString();
			var min:String = zd.minutes.toString().length == 1 ? "0" + zd.minutes.toString() : zd.minutes.toString();
			var sec:String = zd.seconds.toString().length == 1 ? "0" + zd.seconds.toString() : zd.seconds.toString();
			var qd:String=yea + "-" + mon + "-" + dat + "T" + hrs + ":" + min + ":" + sec;
			return qd;
		}
		//for MutilLanguage and UTC
		public static function spillHyphenServiceDate2UTC(d:Date):String
		{
			var zd:Date = d;
			var yea:String = zd.fullYearUTC.toString();
			var mon:String = (zd.monthUTC+1).toString().length == 1 ? "0" + (zd.monthUTC+1).toString() : (zd.monthUTC+1).toString();
			var dat:String = zd.dateUTC.toString().length == 1 ? "0" + zd.dateUTC.toString() : zd.dateUTC.toString();
			var hrs:String = zd.hoursUTC.toString().length == 1 ? "0" + zd.hoursUTC.toString() : zd.hoursUTC.toString();
			var min:String = zd.minutesUTC.toString().length == 1 ? "0" + zd.minutesUTC.toString() : zd.minutesUTC.toString();
			var sec:String = zd.secondsUTC.toString().length == 1 ? "0" + zd.secondsUTC.toString() : zd.secondsUTC.toString();
			var qd:String=yea + "-" + mon + "-" + dat + "T" + hrs + ":" + min + ":" + sec;
			return qd;
		}
		//for customized time zone to UTC
		public static function spillHyphenServiceDateWithTimeZone2UTC(d:Date,_timeZone:Number):String
		{
			var zd:Date=new Date();
			var dateYear:int=d.fullYear;
			var dateMonth:int=d.month;
			var dateDate:int=d.date;
			var dateHours:int=d.hours;
			zd.setUTCFullYear(dateYear,dateMonth,dateDate);
			zd.setUTCHours(dateHours,0,0,0);
			zd.hours-=int(_timeZone);
			zd.minutes-=((_timeZone%1)*60);
			var yea:String = zd.fullYearUTC.toString();
			var mon:String = (zd.monthUTC+1).toString().length == 1 ? "0" + (zd.monthUTC+1).toString() : (zd.monthUTC+1).toString();
			var dat:String = zd.dateUTC.toString().length == 1 ? "0" + zd.dateUTC.toString() : zd.dateUTC.toString();
			var hrs:String = zd.hoursUTC.toString().length == 1 ? "0" + zd.hoursUTC.toString() : zd.hoursUTC.toString();
			var min:String = zd.minutesUTC.toString().length == 1 ? "0" + zd.minutesUTC.toString() : zd.minutesUTC.toString();
			var sec:String = zd.secondsUTC.toString().length == 1 ? "0" + zd.secondsUTC.toString() : zd.secondsUTC.toString();
			var qd:String=yea + "-" + mon + "-" + dat + "T" + hrs + ":" + min + ":" + sec;
			return qd;
		}
		
		//for customized time zone to UTC  WITHOUT TIME
		public static function spillHyphenServiceDateWithTimeZone2UTCnotime(d:Date,_timeZone:Number):String
		{
			var zd:Date=new Date();
			var dateYear:int=d.fullYear;
			var dateMonth:int=d.month;
			var dateDate:int=d.date;
			var dateHours:int=d.hours;
			zd.setUTCFullYear(dateYear,dateMonth,dateDate);
			zd.setUTCHours(dateHours,0,0,0);
			zd.hours-=int(_timeZone);
			zd.minutes-=((_timeZone%1)*60);
			var yea:String = zd.fullYearUTC.toString();
			var mon:String = (zd.monthUTC+1).toString().length == 1 ? "0" + (zd.monthUTC+1).toString() : (zd.monthUTC+1).toString();
			var dat:String = zd.dateUTC.toString().length == 1 ? "0" + zd.dateUTC.toString() : zd.dateUTC.toString();
			var hrs:String = zd.hoursUTC.toString().length == 1 ? "0" + zd.hoursUTC.toString() : zd.hoursUTC.toString();
			var min:String = zd.minutesUTC.toString().length == 1 ? "0" + zd.minutesUTC.toString() : zd.minutesUTC.toString();
			var sec:String = zd.secondsUTC.toString().length == 1 ? "0" + zd.secondsUTC.toString() : zd.secondsUTC.toString();
			var qd:String=yea + "-" + mon + "-" + dat;
			return qd;
		}
		
		public static function convertDateEuro(d:Date):String
		{
			var zd:Date = d;
			var df:DateFormatter = new DateFormatter();
			df.formatString = "DD MMM YYYY";
			var qd:String = df.format(zd.toDateString());
			var hrs:String = zd.hours.toString().length == 1 ? "0" + zd.hours.toString() : zd.hours.toString();
			var min:String = zd.minutes.toString().length == 1 ? "0" + zd.minutes.toString() : zd.minutes.toString();
			//var sec:String = zd.seconds.toString().length == 1 ? "0" + zd.seconds.toString() : zd.seconds.toString();
			qd = qd + " " + hrs + ":" + min + ":" + "00";
			return qd;
		}
		public static function convertDateEuronoTime(d:Date):String
		{
			var zd:Date = d;
			var df:DateFormatter = new DateFormatter();
			df.formatString = "DD MMM YYYY";
			var qd:String = df.format(zd.toDateString());
			var hrs:String = zd.hours.toString().length == 1 ? "0" + zd.hours.toString() : zd.hours.toString();
			var min:String = zd.minutes.toString().length == 1 ? "0" + zd.minutes.toString() : zd.minutes.toString();
			//var sec:String = zd.seconds.toString().length == 1 ? "0" + zd.seconds.toString() : zd.seconds.toString();
			//qd = qd;
			return qd;
		}
		public static function convertDate(d:Date) : String 
		{
			var zd:Date = d;
			var df:DateFormatter = new DateFormatter();
			df.formatString = "YYYYMMDD";
			var qd:String = df.format(zd.toDateString());
			var hrs:String = zd.hours.toString().length == 1 ? "0" + zd.hours.toString() : zd.hours.toString();
			var min:String = zd.minutes.toString().length == 1 ? "0" + zd.minutes.toString() : zd.minutes.toString();
			//var sec:String = zd.seconds.toString().length == 1 ? "0" + zd.seconds.toString() : zd.seconds.toString();
			qd = qd + "T" + hrs + min + "00";
			return qd;
		}
		//some methods for customized time zone
		public static function FullYearUTCWithTimeZone(d:Date,_timeZone:Number):Number
		{
			var zd:Date=new Date(d);
			var computerTimeZone:Number=-zd.getTimezoneOffset()/60;
			var timeDifference:Number=_timeZone-computerTimeZone;
			zd.hours-=int(timeDifference);
			zd.minutes-=((timeDifference%1)*60);
			return zd.fullYearUTC;
		}
		public static function MonthUTCWithTimeZone(d:Date,_timeZone:Number):Number
		{
			var zd:Date=new Date(d);
			var computerTimeZone:Number=-zd.getTimezoneOffset()/60;
			var timeDifference:Number=_timeZone-computerTimeZone;
			zd.hours-=int(timeDifference);
			zd.minutes-=((timeDifference%1)*60);
			return zd.monthUTC;
		}
		public static function DateUTCWithTimeZone(d:Date,_timeZone:Number):Number
		{
			var zd:Date=new Date(d);
			var computerTimeZone:Number=-zd.getTimezoneOffset()/60;
			var timeDifference:Number=_timeZone-computerTimeZone;
			zd.hours-=int(timeDifference);
			zd.minutes-=((timeDifference%1)*60);
			return zd.dateUTC;
		}
		public static function HoursUTCWithTimeZone(d:Date,_timeZone:Number):Number
		{
			var zd:Date=new Date(d);
			var computerTimeZone:Number=-zd.getTimezoneOffset()/60;
			var timeDifference:Number=_timeZone-computerTimeZone;
			zd.hours-=int(timeDifference);
			zd.minutes-=((timeDifference%1)*60);
			return zd.hoursUTC;
		}
	}
}
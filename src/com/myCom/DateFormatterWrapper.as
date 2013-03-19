package com.myCom
{
	import mx.formatters.DateFormatter;
	
	public class DateFormatterWrapper extends DateFormatter
	{
		public function DateFormatterWrapper()
		{
			super();
		}
		
		public function parseDate(str:String):Date
		{
			return parseDateString(str);
		}       
	}
}	

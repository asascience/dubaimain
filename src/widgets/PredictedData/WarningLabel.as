package widgets.PredictedData
{
	import mx.controls.Label;
	import mx.controls.listClasses.*;
	
	public class WarningLabel extends Label {
		
		private const POSITIVE_COLOR:uint = 0x58595b; // Black
		private const NEGATIVE_COLOR:uint = 0xFF0000; // Red
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			/* Set the font color based on the item price. */
			if(data)
			{
				setStyle("color", (parseFloat(data.flag) > 0) ? NEGATIVE_COLOR : POSITIVE_COLOR);
			}
		}
	}
}
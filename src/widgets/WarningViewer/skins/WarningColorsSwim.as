package widgets.WarningViewer.skins
{
	import mx.controls.Label;
	import mx.controls.listClasses.*;
	
	public class WarningColorsSwim extends Label {
		
		private const POSITIVE_COLOR:uint = 0x999999; // Black
		private const NEGATIVE_COLOR:uint = 0xFF0000; // Red
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			/* Set the font color based on the item price. */
			if(data)
			{				
				if(data.swim != "nowarning")
				{
					setStyle("color",NEGATIVE_COLOR);
				}
				else{
					setStyle("color",POSITIVE_COLOR);
				}
			}
		}
	}
}
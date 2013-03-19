package widgets.ECOP.components.utils
{
	import mx.charts.chartClasses.DataTip;
	import mx.charts.*;
	import flash.display.*; 
	import flash.geom.Matrix;
	import flash.text.TextField;     
	
	public class ChartDataTip extends DataTip {
		
		// The title is renderered in a TextField.
		private var myText:TextField; 
		
		public function ChartDataTip() {
			super();            
		}       
		
		override protected function createChildren():void{ 
			super.createChildren();
			myText = new TextField();
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void {
			super.updateDisplayList(w, h);
			
			// The data property provides access to the data tip's text.
			if(data.hasOwnProperty('text')) {
				myText.text = data.text;
			} else {
				myText.text = data.toString();        
			}
			
			this.setStyle("textAlign","center");
			var g:Graphics = graphics; 
			g.clear();  
			var m:Matrix = new Matrix();
			m.createGradientBox(w+45,h,0,0,0);
			g.beginGradientFill(GradientType.LINEAR,[0xE5E5E5,0xE5E5E5],
				[.9,1],[0,255],m,null,null,0);
			g.drawRoundRect(-20,0,w+45,h,25);
			g.endFill(); 
		}
	}
}
package widgets.ShapeFiles
{
    import com.esri.ags.Map;
    import com.esri.ags.geometry.Geometry;
    import com.esri.ags.symbol.Symbol;
    
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public final class lineSymbol extends Symbol
    {
        private var m_lineWidth:Number = 3;
        private var m_lineColor:Number = 0xFF0000;
        private var m_lineAlpha:Number = 0.8;

        public function lineSymbol()
        {
        }

        override public function clear(sprite:Sprite):void
        {
            sprite.graphics.clear();
        }

        override public function draw(sprite:Sprite, geometry:Geometry, attributes:Object, map:Map):void
        {
            const shpPolyline:ShpLine = ShpLine(geometry);
            if (map.extent.intersects(shpPolyline.extent))
            {
                sprite.graphics.lineStyle(m_lineWidth,m_lineColor,m_lineAlpha);
                const interval:int = attributes.interval;
           		
                for each (var ring:Array in shpPolyline.rings)
                {
                    var index:int = 0;
                    var lastX:int = toScreenX(map, ring[index++]);
                    var lastY:int = toScreenY(map, ring[index++]);
                    sprite.graphics.moveTo(lastX, lastY);
                    while (index < ring.length)
                    {
                        var currX:int = toScreenX(map, ring[index++]);
                        var currY:int = toScreenY(map, ring[index++]);
                        if (currX !== lastX || currY !== lastY)
                        {
                            sprite.graphics.lineTo(currX, currY);
                            lastX = currX;
                            lastY = currY;
                        }
                    }
                }
                if (sprite.numChildren > 0) {
            		sprite.removeChildAt(0);
            	}
            	if (map.scale < 2500000) {
            		var ftsize:int;
            		if (map.scale < 600000) {
            			ftsize = 16;
            		} else {
            		 	ftsize = 14;
            		}
            		var atrText:TextField = new TextField();
            		var atrFormat:TextFormat = new TextFormat;
            		atrFormat.font = "Verdana";
            		atrFormat.size = ftsize;
            		atrFormat.bold = true;
            		atrText.defaultTextFormat = atrFormat;
            		atrText.text = attributes.toString();
            		atrText.x = toScreenX(map, shpPolyline.extent.xmax);
            		atrText.y = toScreenY(map, shpPolyline.extent.ymax);
            		atrText.autoSize = TextFieldAutoSize.LEFT;
            		sprite.addChild(atrText);
            	}
            }
        }
    }
}
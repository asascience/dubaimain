package widgets.ShapeFiles
{
    import com.esri.ags.Map;
    import com.esri.ags.geometry.Geometry;
    import com.esri.ags.symbol.Symbol;

    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public final class ShpSymbol extends Symbol
    {
        private var m_lineWidth:Number = 2;
        private var m_lineColor:Number = 0xFF0000;
        private var m_fillAlpha:Number = 0.2;

        public function ShpSymbol()
        {
        }

        override public function clear(sprite:Sprite):void
        {
            sprite.graphics.clear();
        }

        override public function draw(sprite:Sprite, geometry:Geometry, attributes:Object, map:Map):void
        {
            const shpPolygon:ShpPolygon = ShpPolygon(geometry);
            if (map.extent.intersects(shpPolygon.extent))
            {
                sprite.graphics.lineStyle(m_lineWidth, m_lineColor);
                
                var color:Number = 0xFF0000;
                const interval:int = attributes.interval;
                    
                sprite.graphics.beginFill(color, m_fillAlpha);
                for each (var ring:Array in shpPolygon.rings)
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
                sprite.graphics.endFill();
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
            		atrText.x = toScreenX(map, shpPolygon.extent.center.x);
            		atrText.y = toScreenY(map, shpPolygon.extent.center.y);
            		atrText.autoSize = TextFieldAutoSize.CENTER;
            		sprite.addChild(atrText);
            	}
            }
        }
    }
}
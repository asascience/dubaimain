package widgets.ShapeFiles
{
    import com.esri.ags.geometry.Extent;
    import com.esri.ags.geometry.Geometry;
    import com.esri.ags.geometry.MapPoint;
    import com.esri.ags.geometry.Polygon;

    public class ShpPolygon extends Geometry
    {
        private var m_extent:Extent;

        public var rings:Array;

        public function ShpPolygon(extent:Extent, rings:Array)
        {
            m_extent = extent;
            this.rings = rings;
        }

        override public function get extent():Extent
        {
            return m_extent;
        }

        public function toPolygon():Polygon
        {
            const polygonRings:Array = [];
            for each (var numbers:Array in rings)
            {
                const arrOfMapPoints:Array = [];
                const index:int = 0;
                while (index < numbers.length)
                {
                    const x:Number = numbers[index++];
                    const y:Number = numbers[index++];
                    arrOfMapPoints.push(new MapPoint(x, y));
                }
                polygonRings.push(arrOfMapPoints);
            }
            return new Polygon(polygonRings);
        }
    }
}
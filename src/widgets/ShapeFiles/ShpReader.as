package widgets.ShapeFiles
{
    import com.esri.ags.geometry.Extent;
    import com.esri.ags.geometry.MapPoint;
    
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    public final class ShpReader
    {
        private var m_src:ByteArray;
        private var m_hdr:ShpHeader;
        private var m_xmin:Number;
        private var m_ymin:Number;
        private var m_xmax:Number;
        private var m_ymax:Number;
        private var m_parts:Array;

        public var recordNumber:int;
        public var contentLength:uint;
        public var contentLengthBytes:uint;
        public var shapeType:int;

        public function ShpReader(src:ByteArray)
        {
            m_src = src;
            m_hdr = new ShpHeader(src);
        }

        public function get shpHeader():ShpHeader
        {
            return m_hdr;
        }

        public function get extent():Extent
        {
            return m_hdr.extent;
        }

        private function readRecordHeader():void
        {
            m_src.endian = Endian.BIG_ENDIAN;

            recordNumber = m_src.readInt();
            contentLength = m_src.readInt();
            contentLengthBytes = contentLength + contentLength - 4;

            m_src.endian = Endian.LITTLE_ENDIAN;

            shapeType = m_src.readInt();
        }

        public function hasMore():Boolean
        {
            return m_src.bytesAvailable > 0;
        }

        public function readMapPoint():MapPoint
        {
            readRecordHeader();
            const x:Number = m_src.readDouble();
            const y:Number = m_src.readDouble();
            return new MapPoint(x, y);
        }

        public function fillMapPoint(mapPoint:MapPoint):MapPoint
        {
            readRecordHeader();
            mapPoint.x = m_src.readDouble();
            mapPoint.y = m_src.readDouble();
            return mapPoint;
        }

        protected function readParts():void
        {
            readRecordHeader();
            
            const position:int = m_src.position;

            m_xmin = m_src.readDouble();
            m_ymin = m_src.readDouble();
            m_xmax = m_src.readDouble();
            m_ymax = m_src.readDouble();
            
            const partCount:int = m_src.readInt();
            const pointCount:int = m_src.readInt();

            const partOffsets:Array = [];
            while (partCount--)
            {
                partOffsets.push(m_src.readInt());
            }
            const points:Array = [];
            while (pointCount--)
            {
                   points.push(m_src.readDouble());
                   points.push(m_src.readDouble());
            }
            m_parts = [];
            var removed:int = partOffsets.shift();
            while (partOffsets.length)
            {
                var split:int = partOffsets.shift() * 2;
                m_parts.push(points.splice(0, split - removed));
                removed = split;
            }
            m_parts.push(points);
            
            m_src.position = position + contentLengthBytes;
        }
		
		protected function readPoints():void
        {
            readRecordHeader();
            
            const position:int = m_src.position;

            m_xmax = m_src.readDouble();
            m_ymax = m_src.readDouble();
            
            m_src.position = position + contentLengthBytes;
        }
		
		public function readShpPoint():ShpPoint
        {
            readPoints();
            return new ShpPoint(m_xmax, m_ymax);
        }
		
		public function readShpLine():ShpLine
        {
            readParts();
            return new ShpLine(new Extent(m_xmin, m_ymin, m_xmax, m_ymax), m_parts);
        }
		
        public function readShpPolygon():ShpPolygon
        {
            readParts();
            return new ShpPolygon(new Extent(m_xmin, m_ymin, m_xmax, m_ymax), m_parts);
        }
        
        public function readShpType():int
        {
            return m_hdr.shpType;
        }
    }
}
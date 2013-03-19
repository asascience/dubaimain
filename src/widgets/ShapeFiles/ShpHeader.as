package widgets.ShapeFiles
{
    import com.esri.ags.geometry.Extent;
    
    import flash.errors.EOFError;
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    public final class ShpHeader
    {
        public var fileLength:int;
        public var version:int;
        public var shapeType:int;
        public var xmin:Number;
        public var ymin:Number;
        public var xmax:Number;
        public var ymax:Number;
        public var zmin:Number;
        public var zmax:Number;
        public var mmin:Number;
        public var mmax:Number;

        public function ShpHeader(src:ByteArray)
        {
            src.endian = Endian.BIG_ENDIAN;
			
			const signature:int = src.readInt();
            
			if (signature != 9994)
            {
                throw new Error("Not a valid signature. Expected 9994");
            }

            src.position += 5 * 4;

			fileLength = src.readInt();
            src.endian = Endian.LITTLE_ENDIAN;

            version = src.readInt();

            shapeType = src.readInt();

            xmin = src.readDouble();
            ymin = src.readDouble();
            xmax = src.readDouble();
            ymax = src.readDouble();
            zmin = src.readDouble();
            zmax = src.readDouble();
            mmin = src.readDouble();
            mmax = src.readDouble();
            // trace( "shapeType", shapeType );
        }

        public function get extent():Extent
        {
            return new Extent(xmin, ymin, xmax, ymax);
        }
        
        public function get shpType():int
        {
            return shapeType;
        }
    }
}
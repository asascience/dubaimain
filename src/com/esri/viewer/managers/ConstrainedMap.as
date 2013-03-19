package com.esri.viewer.managers
{

	import com.esri.ags.Map;
	import com.esri.ags.Units;
	import com.esri.ags.esri_internal;
	import com.esri.ags.events.ExtentEvent;
	import com.esri.ags.events.MapEvent;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.utils.ProjUtils;
	
	use namespace esri_internal;
	
	public class ConstrainedMap extends Map
	{
	    private var m_initialScale : Number = Number.POSITIVE_INFINITY;
	    private var m_initialExtent : Extent = new Extent(
	        Number.NEGATIVE_INFINITY, Number.NEGATIVE_INFINITY,
	        Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY);
	     
	    public function ConstrainedMap(constrainedExtent:Extent)
	    {
	        this.openHandCursorVisible = true;
	        this.extent = constrainedExtent;
	        this.addEventListener(MapEvent.LOAD, loadHandler );
	    }
	    
	    override public function set extent(value:Extent):void
	    {
	        const newScale : Number = ProjUtils.convertExtentToScale( value, width, height, Units.esri_internal::UNITS_DECIMAL_DEGREES);
	        // trace( newScale.toFixed(0), m_initialScale.toFixed(0));
	        // Make sure we do not go over the initial extent.
	        if( newScale > m_initialScale )
	        {
	            super.extent = m_initialExtent.esri_internal::duplicate();
	        }
	        else
	        {
	            super.extent = value;
	        }            
	    }
	    
	    private function loadHandler( event : MapEvent ) : void
	    {
	        this.removeEventListener( MapEvent.LOAD, loadHandler );
	        // Note the low priority listener.    
	        this.addEventListener( ExtentEvent.EXTENT_CHANGE, extentChangeHandlerOnce, false, -99 );
	        this.addEventListener( ExtentEvent.EXTENT_CHANGE, extentChangeHandler );
	    }
	    
	    /**
	     * Handler used _once_ to get the initial map scale and extent.
	     */
	    private function extentChangeHandlerOnce( event : ExtentEvent ) : void
	    {
	        this.removeEventListener( ExtentEvent.EXTENT_CHANGE, extentChangeHandlerOnce);
	        m_initialScale = scale;
	        m_initialExtent = extent;
	    }
	
	    private function extentChangeHandler( event : ExtentEvent ) : void
	    {
	        // trace( "extentChangeHandler", event.extent );
	        if( extent.containsExtent( m_initialExtent ))
	        {
	            return;
	        }
	        var dx : Number, dy : Number;
	        if( m_initialExtent.xmax < extent.xmax )
	        {
	            dx = extent.xmax - m_initialExtent.xmax;                         
	        }
	        else if( m_initialExtent.xmin > extent.xmin )
	        {
	            dx = extent.xmin - m_initialExtent.xmin;
	        }
	        else
	        {
	            dx = 0.0;
	        }
	        if( m_initialExtent.ymax < extent.ymax )
	        {
	            dy = extent.ymax - m_initialExtent.ymax;
	        }
	        else if( m_initialExtent.ymin > extent.ymin )
	        {
	            dy = extent.ymin - m_initialExtent.ymin;
	        }
	        else
	        {
	            dy = 0;
	        }
	        // trace( dx.toFixed(0), dy.toFixed(0));
	        if( dx !== 0.0 || dy !== 0.0 )
	        {
	            // Make sure the extent is set on the next display cycle.
	            callLater( callLaterHandler, [dx,dy] );
	        }
	    }
	    
	    private function callLaterHandler( dx : Number, dy : Number ) : void
	    {
	        extent = new Extent( extent.xmin - dx, extent.ymin - dy, extent.xmax - dx, extent.ymax - dy );
	    }
	            
	}

}
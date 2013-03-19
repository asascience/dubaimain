/*
 * Copyright 2009 ESRI
 *
 * All rights reserved under the copyright laws of the United States
 * and applicable international laws, treaties, and conventions.
 *
 * You may freely redistribute and use this sample code, with or
 * without modification, provided you include the original copyright
 * notice and use restrictions.
 *
 * See use restrictions at http://resources.esri.com/help/9.3/usagerestrictions.htm.
 */
package com.esri.maplib.controls
{
import mx.skins.halo.CheckBoxIcon;

/**
 * CheckBox skin that supports a tri-state check. In addition to selected and
 * unselected, the CheckBox can be in an indeterminate state.
 */
public class CheckBoxIndeterminateIcon extends CheckBoxIcon
{
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function updateDisplayList( w:Number, h:Number ):void
	{
		super.updateDisplayList(w, h);
		
		var indet:Boolean = getStyle("indeterminate");
		
		if (indet)
		{
			var cornerRadius:Number = 2;
			
			var boxFillColors:Array = [ 0xAAAACC, 0x666666 ];
			var boxFillAlphas:Array = [ 1.0, 1.0 ];
			
			drawRoundRect(
				3, 3, w - 6, h - 6, cornerRadius,
				boxFillColors, boxFillAlphas,
				verticalGradientMatrix(1, 1, w - 2, h - 2));
		}
	}
}

}

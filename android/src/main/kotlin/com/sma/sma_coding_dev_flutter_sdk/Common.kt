package com.sma.sma_coding_dev_flutter_sdk

import java.text.DecimalFormat
import java.text.DecimalFormatSymbols
import java.util.Locale

fun keepTwoDecimal(value: Float): String {
    return  if(!value.isFinite()){
        "0.00"
    }else {
        DecimalFormat("#.##", DecimalFormatSymbols.getInstance(Locale.ENGLISH))
            .format(value.toBigDecimal())
    }
}
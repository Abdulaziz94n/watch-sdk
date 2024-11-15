package com.sma.sma_coding_dev_flutter_sdk

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import com.blankj.utilcode.util.FileIOUtils
import com.blankj.utilcode.util.ImageUtils
import com.blankj.utilcode.util.LogUtils
import com.blankj.utilcode.util.PathUtils
import com.jieli.bmp_convert.BmpConvert
import com.szabh.smable3.watchface.Element
import com.szabh.smable3.watchface.WatchFaceBuilder
import org.json.JSONObject
import java.io.File
import java.nio.ByteBuffer

object WatchFaceUtils {
    /**
     * 对齐节字数
     */
    val SIZE_4 = 4

    fun getImageBuffers(
        hasAlpha: Int,
        ignoreBlack: Int,
        type: Int,
        w: Int,
        h: Int,
        imagePaths: List<String>
    ): Array<ByteArray> {
        val isAlpha = hasAlpha == 1
        return when (type) {
            //预览图和背景
            WatchFaceBuilder.ELEMENT_PREVIEW,
            WatchFaceBuilder.ELEMENT_BACKGROUND -> {
                if (ignoreBlack == 4) {
                    arrayOf(convertPng(File(imagePaths[0]), isAlpha))
                } else {
                    arrayOf(
                        bitmap2Bytes(
                            "bmp",
                            getFinalBgBitmap(ImageUtils.getBitmap(imagePaths[0]))
                        )
                    )
                }
            }
            //指针统一使用8565
            WatchFaceBuilder.ELEMENT_NEEDLE_HOUR,
            WatchFaceBuilder.ELEMENT_NEEDLE_MIN,
            WatchFaceBuilder.ELEMENT_NEEDLE_SEC -> {
                arrayOf(
                    defaultConversion(
                        "png",
                        FileIOUtils.readFile2BytesByChannel(imagePaths[0]),
                        w,
                        isTo8565 = true,
                        h = h
                    )
                )
            }
            else -> if (imagePaths.size > 1) {
                if (ignoreBlack == 4) {
                    getNumberBuffers2(w, h, imagePaths).toTypedArray()
                } else {
                    getNumberBuffers(w, h, imagePaths).toTypedArray()
                }
            } else arrayOf()
        }
    }

    fun getNumberBuffers(w: Int, h: Int, imagePaths: List<String>): ArrayList<ByteArray> {
        val bytes = ArrayList<ByteArray>()
        for (path in imagePaths) {
            bytes.add(
                defaultConversion(
                    "png",
                    FileIOUtils.readFile2BytesByChannel(path),
                    w,
                    isTo8565 = true,
                    h = h
                )
            )
        }
        return bytes
    }

    fun getNumberBuffers2(w: Int, h: Int, imagePaths: List<String>): ArrayList<ByteArray> {
        val bytes = ArrayList<ByteArray>()
        for (path in imagePaths) {
            bytes.add(
                convertPng(File(path))
            )
        }
        return bytes
    }

    fun genWatchFaceBin(param: JSONObject): ByteArray {
        val elements = ArrayList<Element>()
        val jsonElements = param.getJSONArray("elementList")
        for (i in 0 until jsonElements.length()) {
            val jsonElement = jsonElements.getJSONObject(i)
            val type = jsonElement.getInt("type")
            val hasAlpha = jsonElement.getInt("hasAlpha")
            val w = jsonElement.getInt("w")
            val h =  jsonElement.getInt("h")
            val ignoreBlack = jsonElement.getInt("ignoreBlack")
            val imagePathsElements = jsonElement.getJSONArray("imagePaths");
            val imagePaths = mutableListOf<String>()
            for (i in 0 until imagePathsElements.length()) {
                imagePaths.add(imagePathsElements.getString(i))
            }
            val element = Element(
                type = type,
                hasAlpha = hasAlpha,
                w = w,
                h = h,
                gravity = jsonElement.getInt("gravity"),
                x = jsonElement.getInt("x"),
                y = jsonElement.getInt("y"),
                bottomOffset = jsonElement.getInt("bottomOffset"),
                leftOffset = jsonElement.getInt("leftOffset"),
                ignoreBlack = ignoreBlack,
                imageBuffers = getImageBuffers(hasAlpha, ignoreBlack, type, w, h, imagePaths)
            )
            elements.add(element)
        }

        for (element in elements) {
            LogUtils.d("customize watchface length: ${element.imageBuffers.first().size}")
        }
        val bytes = WatchFaceBuilder.build(
            elements.toTypedArray(),
            param.getInt("imageFormat")
        )
        FileIOUtils.writeFileFromBytesByStream(File(PathUtils.getExternalAppDataPath(), "watchface.bin"), bytes)
        LogUtils.d("customize watchface bytes size  ${bytes.size}")
        return bytes
    }

    private fun bitmap2Bytes(fileFormat: String, finalBgBitMap: Bitmap): ByteArray {
        val allocate = ByteBuffer.allocate(finalBgBitMap.byteCount)
        finalBgBitMap.copyPixelsToBuffer(allocate)
        val array = allocate.array()
        return defaultConversion(fileFormat, array, finalBgBitMap.width, 16, 0, false)
    }

    fun getFinalBgBitmap(bgBitMap: Bitmap): Bitmap {
        val finalBitmap = Bitmap.createBitmap(
            bgBitMap.width,
            bgBitMap.height,
            Bitmap.Config.RGB_565
        )
        val canvas = Canvas(finalBitmap)
        val paint = Paint()
        paint.color = Color.BLACK
        canvas.drawBitmap(bgBitMap, 0f, 0f, paint)
        return finalBitmap
    }

    /**
     * 转换png图片
     */
    private fun convertPng(
        pngFile: File,
        isAlpha: Boolean = true,
    ): ByteArray {
        val outFilePath = pngFile.path + ".bin"
        val type = if (isAlpha) {
            BmpConvert.TYPE_BR_28_ALPHA_RAW
        } else {
            BmpConvert.TYPE_BR_28_RAW
        }
        LogUtils.d("convertPng type=$type, pngFile=$pngFile, outFilePath=$outFilePath")
        //目前是用杰里的库转换
        val ret = BmpConvert().bitmapConvertBlock(type, pngFile.path, outFilePath)
        if (ret <= 0) {
            LogUtils.d("convertPng error = $ret")
            return byteArrayOf()
        }
        val outFileBytes = FileIOUtils.readFile2BytesByChannel(outFilePath)
        val bytesSize = (outFileBytes.size + SIZE_4 - 1) / SIZE_4 * SIZE_4
        val bytes = ByteArray(bytesSize)
        System.arraycopy(outFileBytes, 0, bytes, 0, outFileBytes.size)
        LogUtils.d("convertPng outFileBytes=${outFileBytes.size}, bytes=${bytes.size}")
        return bytes
    }

    fun argb8888To8565(argb: Int): Int {
        val b = argb and 255
        val g = argb shr 8 and 255
        val r = argb shr 16 and 255
        val a = argb shr 24 and 255
        return (a shl 16) + (r shr 3 shl 11) + (g shr 2 shl 5) + (b shr 3)
    }

    fun defaultConversion(
        fileFormat: String,
        data: ByteArray,
        w: Int,                      //图片宽度
        bitCount: Int = 16,          //位深度，可为8，16，24，32
        headerInfoSize: Int = 70,   //头部信息长度，默认70
        isReverseRows: Boolean = true,   //是否反转行数据，就是将第一行置换为最后一行
        isTo8565: Boolean = false, // 一般都是png文件转8565格式
        h: Int = 0                //图片高度
    ): ByteArray {
        if (fileFormat == "bmp") {

            //标准bmp文件可以从第十个字节读取到头长度，如果那些设备有问题可以先检查这里
            val headerInfoSize2 = if (headerInfoSize == 0) 0 else data[10]
            LogUtils.d("headerInfoSize $headerInfoSize2")

            val data1 = data.takeLast(data.size - headerInfoSize2)
            //分别获取每一行的数据
            //计算每行多少字节
            val rowSize: Int = (bitCount * w + 31) / 32 * 4
            val data2 = java.util.ArrayList<ByteArray>()
            //判断单、双数，单数要减去无用字节
            val offset = if (w % 2 == 0) 0 else 2
            for (index in 0 until (data1.size / rowSize)) {
                val tmpData = ByteArray(rowSize - offset)
                for (rowIndex in 0 until (rowSize - offset)) {
                    tmpData[rowIndex] = data1[index * rowSize + rowIndex]
                }
                data2.add(tmpData)
            }

            //将获得的行数据反转
            val data3 = if (isReverseRows) {
                data2.reversed()
            } else {
                data2
            }
            //将每行数据中，依据 16bit（此处定义，如果是不同的位深度，则需要跟随调整） 即 2 字节的内容从小端序修改为大端序
            val test3 = java.util.ArrayList<Byte>()
            for (index in data3.indices) {
                var j = 0
                while (j < data3[index].size) {
                    test3.add(data3[index][j + 1])
                    test3.add(data3[index][j])
                    j += 2
                }
            }
            //取得最终元素
            val finalData = ByteArray(test3.size)
            for (index in finalData.indices) {
                finalData[index] = test3[index]
            }
            return finalData
        } else {
            return if (isTo8565) {
                pngTo8565(data, w, h)
            } else {
                data
            }
        }

    }

    fun pngTo8565(bytes: ByteArray, w: Int, h: Int): ByteArray {
        val tmpBitmap =
            ImageUtils.getBitmap(bytes, 0)
        val pixels = IntArray(tmpBitmap.height * tmpBitmap.width)
        tmpBitmap.getPixels(pixels, 0, tmpBitmap.width, 0, 0, tmpBitmap.width, tmpBitmap.height)

        val rowSize = (w * 3 + SIZE_4 - 1) / SIZE_4 * SIZE_4//4字节对齐
        val data = ByteArray(rowSize * h)
        for (y in 0 until h) {
            val rawBytes = ByteArray(rowSize)
            for (x in 0 until w) {
                val index = y * w + x
                val a565 = argb8888To8565(pixels[index])
                val offset = x * 3
                rawBytes[offset + 2] = (a565 and 255).toByte()//2
                rawBytes[offset + 1] = (a565 shr 8 and 255).toByte()//1.
                rawBytes[offset + 0] = (a565 shr 16 and 255).toByte()//0.alpha
            }
            System.arraycopy(rawBytes, 0, data, y * rowSize, rowSize)
        }
        LogUtils.d("pngTo8565 -> w=$w, h=$h, rowSize=$rowSize, data=${data.size}")
        return data
    }
}
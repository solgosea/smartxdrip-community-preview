package com.metaguru.smartxdrip.glance

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.DashPathEffect
import android.graphics.Paint
import android.graphics.Path
import kotlin.math.max

class GlanceWidgetChartRenderer {
    fun render(
        values: List<Float>,
        targetLowMmol: Float,
        targetHighMmol: Float,
        color: Int,
        dashboard: Boolean
    ): Bitmap {
        val width = if (dashboard) 760 else 560
        val height = if (dashboard) 136 else 140
        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        val cleanValues = values.filter { !it.isNaN() && !it.isInfinite() }
        val low = minOf(targetLowMmol, targetHighMmol)
        val high = maxOf(targetLowMmol, targetHighMmol)
        val allValues = cleanValues + listOf(low, high)
        val rawMin = allValues.minOrNull() ?: low
        val rawMax = allValues.maxOrNull() ?: high
        val rawSpan = max(.1f, rawMax - rawMin)
        val padding = max(.6f, rawSpan * .08f)
        val minValue = rawMin - padding
        val maxValue = rawMax + padding
        val span = max(.1f, maxValue - minValue)
        fun yFor(value: Float): Float {
            val normalized = ((value - minValue) / span).coerceIn(0f, 1f)
            return height - normalized * height
        }
        val topBand = yFor(high)
        val bottomBand = yFor(low)

        val bandPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.FILL
            this.color = Color.argb(25, 110, 232, 158)
        }
        canvas.drawRect(0f, topBand, width.toFloat(), bottomBand, bandPaint)

        val guidePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.STROKE
            strokeWidth = 1.6f
            this.color = Color.argb(70, 110, 232, 158)
            pathEffect = DashPathEffect(floatArrayOf(9f, 8f), 0f)
        }
        canvas.drawLine(0f, topBand, width.toFloat(), topBand, guidePaint)
        canvas.drawLine(0f, bottomBand, width.toFloat(), bottomBand, guidePaint)

        if (cleanValues.size < 2) return bitmap

        val path = Path()
        cleanValues.forEachIndexed { index, value ->
            val x = width * index.toFloat() / (cleanValues.size - 1).toFloat()
            val y = yFor(value)
            if (index == 0) path.moveTo(x, y) else path.lineTo(x, y)
        }

        if (dashboard) {
            val fillPath = Path(path).apply {
                lineTo(width.toFloat(), height.toFloat())
                lineTo(0f, height.toFloat())
                close()
            }
            canvas.drawPath(
                fillPath,
                Paint(Paint.ANTI_ALIAS_FLAG).apply {
                    style = Paint.Style.FILL
                    this.color = withAlpha(color, 28)
                }
            )
        }

        val haloPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.STROKE
            strokeWidth = if (dashboard) 5.2f else 4.4f
            strokeCap = Paint.Cap.ROUND
            strokeJoin = Paint.Join.ROUND
            this.color = Color.argb(60, 4, 16, 10)
        }
        canvas.drawPath(path, haloPaint)

        val linePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.STROKE
            strokeWidth = if (dashboard) 2.8f else 2.4f
            strokeCap = Paint.Cap.ROUND
            strokeJoin = Paint.Join.ROUND
            this.color = color
        }
        canvas.drawPath(path, linePaint)

        val lastValue = cleanValues.last()
        val x = width.toFloat()
        val y = yFor(lastValue)
        canvas.drawCircle(
            x - 4f,
            y,
            if (dashboard) 6f else 5f,
            Paint(Paint.ANTI_ALIAS_FLAG).apply { this.color = color }
        )
        return bitmap
    }

    private fun withAlpha(color: Int, alpha: Int): Int {
        return Color.argb(
            alpha.coerceIn(0, 255),
            Color.red(color),
            Color.green(color),
            Color.blue(color)
        )
    }
}

package com.metaguru.smartxdrip.floating

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.text.TextUtils
import android.view.Gravity
import android.view.View
import android.widget.LinearLayout
import android.widget.TextView
import org.json.JSONArray
import org.json.JSONObject
import kotlin.math.max
import kotlin.math.min

class FloatingSurfaceViewFactory(private val context: Context) {
    fun create(snapshot: FloatingSurfaceSnapshot): View {
        val glance = snapshot.singleGlanceSegment()
        if (glance != null) {
            return if (snapshot.overlayState == "expanded") {
                glanceExpanded(glance)
            } else {
                glanceCompact(glance)
            }
        }
        return stackedSurface(snapshot)
    }

    private fun glanceCompact(segment: FloatingSurfaceSegmentSnapshot): View {
        val color = levelColor(segment.level)
        return LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            setPadding(12.dp, 10.dp, 12.dp, 10.dp)
            background = roundedBackground(
                radius = 999.dp,
                color = "#EE17211D",
                strokeColor = color
            )
            addView(label("::", color, 14, true))
            addHorizontalGap(this, 8)
            addView(
                label(segment.primaryText, color, 15, true),
                LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
            )
            addHorizontalGap(this, 8)
            val tir = segment.secondaryText.orEmpty()
            if (tir.isNotBlank()) {
                addView(label(tir, Color.parseColor("#C8D8D0"), 10, true))
                addHorizontalGap(this, 6)
            }
            addView(label(segment.metaText ?: "", Color.parseColor("#82958D"), 9, false))
        }
    }

    private fun glanceExpanded(segment: FloatingSurfaceSegmentSnapshot): View {
        val color = levelColor(segment.level)
        return LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(15.dp, 14.dp, 15.dp, 13.dp)
            background = roundedBackground(
                radius = 18.dp,
                color = "#F017211D",
                strokeColor = color
            )
            addView(expandedHeader(segment, color))
            addVerticalGap(this, 11)
            addView(
                SparklineView(
                    context = context,
                    points = segment.data.sparklinePoints(),
                    low = segment.data.optDouble("targetLowMmol", 3.9),
                    high = segment.data.optDouble("targetHighMmol", 10.0),
                    lineColor = color
                ),
                LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 62.dp)
            )
            addVerticalGap(this, 10)
            addView(expandedMetrics(segment))
            addView(sourceRow(segment))
        }
    }

    private fun expandedHeader(segment: FloatingSurfaceSegmentSnapshot, color: Int): View {
        return LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.TOP
            addView(label("::", color, 14, true))
            addHorizontalGap(this, 10)
            val main = LinearLayout(context).apply {
                orientation = LinearLayout.VERTICAL
                val valueRow = LinearLayout(context).apply {
                    orientation = LinearLayout.HORIZONTAL
                    gravity = Gravity.BOTTOM
                    addView(label(segment.data.string("valueLabel", "--"), color, 31, true))
                    addHorizontalGap(this, 7)
                    addView(label(segment.data.string("unitLabel"), Color.parseColor("#8FA198"), 10, true))
                }
                addView(valueRow)
                addVerticalGap(this, 5)
                addView(statusLine(segment.metaText ?: ""))
            }
            addView(main, LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f))
            val right = LinearLayout(context).apply {
                orientation = LinearLayout.VERTICAL
                gravity = Gravity.RIGHT
                val deltaRow = LinearLayout(context).apply {
                    orientation = LinearLayout.HORIZONTAL
                    gravity = Gravity.CENTER_VERTICAL
                    addView(label(segment.data.string("trendArrow"), color, 15, true))
                    addHorizontalGap(this, 5)
                    addView(label(segment.data.string("deltaLabel"), color, 13, true))
                }
                addView(deltaRow)
                addVerticalGap(this, 5)
                addView(label("TREND", Color.parseColor("#8FA198"), 8, true))
            }
            addView(right)
        }
    }

    private fun statusLine(text: String): View {
        return LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            addView(dot(levelColor("healthy")))
            addHorizontalGap(this, 5)
            addView(label("Updated $text", Color.parseColor("#82958D"), 9, true))
        }
    }

    private fun expandedMetrics(segment: FloatingSurfaceSegmentSnapshot): View {
        return LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            val tirLabel = segment.data.string("tir24hCompactLabel", "--")
                .removePrefix("TIR ")
                .ifBlank { "--" }
            addView(
                metricBox("TIR 24H", tirLabel, true),
                LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
            )
            addHorizontalGap(this, 8)
            addView(
                metricBox("Window", "24H", false),
                LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
            )
        }
    }

    private fun sourceRow(segment: FloatingSurfaceSegmentSnapshot): View {
        return LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            setPadding(0, 9.dp, 0, 0)
            addView(label("SOURCE", Color.parseColor("#4D7264"), 8, true))
            addHorizontalGap(this, 7)
            addView(dot(levelColor("healthy")))
            addHorizontalGap(this, 6)
            val source = segment.data.string("sourceLabel", "Solgo Insight")
            addView(
                label("$source - updated ${segment.metaText ?: "--"}", Color.parseColor("#8FA198"), 10, true),
                LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
            )
        }
    }

    private fun metricBox(label: String, value: String, highlight: Boolean): View {
        return LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(8.dp, 8.dp, 8.dp, 8.dp)
            background = roundedBackground(
                radius = 11.dp,
                color = "#101F1818",
                strokeColor = Color.parseColor("#2272E79F")
            )
            addView(label(label, Color.parseColor("#4D7264"), 8, true))
            addVerticalGap(this, 4)
            addView(label(value, if (highlight) Color.parseColor("#6EE89F") else Color.parseColor("#D6EDE3"), 12, true))
        }
    }

    private fun stackedSurface(snapshot: FloatingSurfaceSnapshot): View {
        val root = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_VERTICAL
            setPadding(14.dp, 10.dp, 14.dp, 10.dp)
            minimumWidth = surfaceWidth(snapshot)
            background = roundedBackground(
                radius = 18.dp,
                color = "#F017211D",
                strokeColor = borderColor(snapshot.segments)
            )
        }
        snapshot.segments.forEachIndexed { index, segment ->
            if (index > 0) addVerticalGap(root, 5)
            root.addView(segmentRow(segment))
        }
        return root
    }

    private fun segmentRow(segment: FloatingSurfaceSegmentSnapshot): View {
        val row = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                if (segment.kind == "glucose") 22.dp else LinearLayout.LayoutParams.WRAP_CONTENT
            )
        }
        if (segment.kind == "glucose") {
            row.addView(
                label(segment.primaryText, levelColor(segment.level), 15, true),
                LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
            )
            addHorizontalGap(row, 8)
            segment.secondaryText?.let {
                row.addView(label(it, Color.parseColor("#CFE0D7"), 12, true))
                addHorizontalGap(row, 8)
            }
            segment.metaText?.let {
                row.addView(label(it, Color.parseColor("#8FA198"), 11, false))
            }
        } else {
            if (segment.components.isEmpty()) {
                row.addView(
                    label(segment.primaryText, levelColor(segment.level), 12, true),
                    LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
                )
            } else {
                val componentsRow = if (segment.components.size > 3) {
                    componentGrid(segment.components)
                } else {
                    componentRow(segment.components)
                }
                row.addView(
                    componentsRow,
                    LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
                )
            }
            if (segment.components.size <= 3) {
                segment.metaText?.let {
                    addHorizontalGap(row, 8)
                    row.addView(label(it, Color.parseColor("#7E9088"), 10, false))
                }
            }
        }
        return row
    }

    private fun componentRow(components: List<FloatingSurfaceComponentSnapshot>): View {
        return LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            components.forEachIndexed { index, component ->
                if (index > 0) addHorizontalGap(this, 10)
                addView(componentChip(component))
            }
        }
    }

    private fun componentGrid(components: List<FloatingSurfaceComponentSnapshot>): View {
        val grid = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
        }
        var index = 0
        while (index < components.size) {
            if (index > 0) addVerticalGap(grid, 5)
            val row = LinearLayout(context).apply {
                orientation = LinearLayout.HORIZONTAL
                gravity = Gravity.CENTER_VERTICAL
            }
            row.addView(componentChip(components[index]), LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f))
            if (index + 1 < components.size) {
                addHorizontalGap(row, 8)
                row.addView(componentChip(components[index + 1]), LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f))
            } else {
                addHorizontalGap(row, 8)
                row.addView(View(context), LinearLayout.LayoutParams(0, 1, 1f))
            }
            grid.addView(row, LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
            index += 2
        }
        return grid
    }

    private fun componentChip(component: FloatingSurfaceComponentSnapshot): View {
        return LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            val color = levelColor(component.level)
            addView(label(component.glyph, color, 11, true))
            addHorizontalGap(this, 4)
            addView(label("${component.label} ${component.scoreLabel}", color, 12, true))
        }
    }

    private fun label(text: String, color: Int, sp: Int, bold: Boolean): TextView {
        return TextView(context).apply {
            this.text = text
            setTextColor(color)
            textSize = sp.toFloat()
            includeFontPadding = false
            maxLines = 1
            ellipsize = TextUtils.TruncateAt.END
            if (bold) typeface = Typeface.DEFAULT_BOLD
        }
    }

    private fun dot(color: Int): View {
        return View(context).apply {
            background = GradientDrawable().apply {
                shape = GradientDrawable.OVAL
                setColor(color)
            }
            layoutParams = LinearLayout.LayoutParams(6.dp, 6.dp)
        }
    }

    private fun roundedBackground(radius: Int, color: String, strokeColor: Int): GradientDrawable {
        return GradientDrawable().apply {
            shape = GradientDrawable.RECTANGLE
            cornerRadius = radius.toFloat()
            setColor(Color.parseColor(color))
            setStroke(1.dp, strokeColor)
        }
    }

    private fun addHorizontalGap(root: LinearLayout, width: Int) {
        root.addView(View(context), LinearLayout.LayoutParams(width.dp, 1))
    }

    private fun addVerticalGap(root: LinearLayout, height: Int) {
        root.addView(View(context), LinearLayout.LayoutParams(1, height.dp))
    }

    private fun borderColor(segments: List<FloatingSurfaceSegmentSnapshot>): Int {
        if (segments.any { it.level == "issue" }) return levelColor("issue")
        if (segments.any { it.level == "watch" }) return levelColor("watch")
        if (segments.any { it.level == "healthy" }) return levelColor("healthy")
        return levelColor("unknown")
    }

    private fun levelColor(level: String): Int {
        return when (level) {
            "healthy" -> Color.parseColor("#6EE89F")
            "watch" -> Color.parseColor("#F2C66D")
            "issue" -> Color.parseColor("#FF7E93")
            else -> Color.parseColor("#82958D")
        }
    }

    private fun surfaceWidth(snapshot: FloatingSurfaceSnapshot): Int {
        val screenWidth = context.resources.displayMetrics.widthPixels
        val hasDenseStatus = snapshot.segments.any { it.kind != "glucose" && it.components.size > 3 }
        val desired = when {
            hasDenseStatus -> 292.dp
            snapshot.segments.size > 1 -> 286.dp
            else -> 232.dp
        }
        return desired.coerceAtMost(screenWidth - 32.dp)
    }

    private fun FloatingSurfaceSnapshot.singleGlanceSegment(): FloatingSurfaceSegmentSnapshot? {
        if (segments.size != 1) return null
        return segments.firstOrNull { it.id == "glance" && it.kind == "glucose" }
    }

    private fun JSONObject.string(name: String, fallback: String = ""): String {
        if (!has(name) || isNull(name)) return fallback
        return optString(name, fallback)
    }

    private fun JSONObject.sparklinePoints(): List<Float> {
        val array = optJSONArray("sparklinePoints") ?: return emptyList()
        val values = mutableListOf<Float>()
        for (index in 0 until array.length()) {
            val point = array.optJSONObject(index) ?: continue
            if (!point.has("valueMmol")) continue
            values.add(point.optDouble("valueMmol").toFloat())
        }
        return values
    }

    private val Int.dp: Int
        get() = (this * context.resources.displayMetrics.density).toInt()
}

private class SparklineView(
    context: Context,
    private val points: List<Float>,
    private val low: Double,
    private val high: Double,
    private val lineColor: Int
) : View(context) {
    private val bandPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = Color.parseColor("#1A72E79F")
        style = Paint.Style.FILL
    }
    private val guidePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = Color.parseColor("#3372E79F")
        style = Paint.Style.STROKE
        strokeWidth = 1f
    }
    private val linePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = lineColor
        style = Paint.Style.STROKE
        strokeWidth = 2.4f * resources.displayMetrics.density
        strokeCap = Paint.Cap.ROUND
        strokeJoin = Paint.Join.ROUND
    }
    private val dotPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = lineColor
        style = Paint.Style.FILL
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        val width = width.toFloat()
        val height = height.toFloat()
        if (width <= 0f || height <= 0f) return
        val minValue = min(points.minOrNull() ?: low.toFloat(), low.toFloat()).toDouble()
        val maxValue = max(points.maxOrNull() ?: high.toFloat(), high.toFloat()).toDouble()
        val span = (maxValue - minValue).takeIf { it > 0.1 } ?: 1.0
        fun y(value: Double): Float {
            return (height - ((value - minValue) / span * height)).toFloat().coerceIn(0f, height)
        }
        val highY = y(high)
        val lowY = y(low)
        canvas.drawRoundRect(0f, highY, width, lowY, 10f, 10f, bandPaint)
        canvas.drawLine(0f, highY, width, highY, guidePaint)
        canvas.drawLine(0f, lowY, width, lowY, guidePaint)
        if (points.size < 2) return
        val path = Path()
        points.forEachIndexed { index, value ->
            val x = if (points.size == 1) width else width * index / (points.size - 1)
            val pointY = y(value.toDouble())
            if (index == 0) path.moveTo(x, pointY) else path.lineTo(x, pointY)
        }
        canvas.drawPath(path, linePaint)
        canvas.drawCircle(width, y(points.last().toDouble()), 4f * resources.displayMetrics.density, dotPaint)
    }
}

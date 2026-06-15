package com.mausam.mausam

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class MausamWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                // Get data from SharedPreferences saved by Flutter
                val location = widgetData.getString("location", "Location")
                val temp = widgetData.getString("temp", "--°C")
                val rain = widgetData.getString("rain", "Rain: --%")

                // Update the Views
                setTextViewText(R.id.widget_location, location)
                setTextViewText(R.id.widget_temp, temp)
                setTextViewText(R.id.widget_rain, rain)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

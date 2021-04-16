package com.example.flutter.locating_app

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin
import io.flutter.view.FlutterMain
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin
import rekab.app.background_locator.IsolateHolderService

class Application : FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingService.setPluginRegistrant(this);
        IsolateHolderService.setPluginRegistrant(this)
        FlutterMain.startInitialization(this)
    }

    override fun registerWith(registry: PluginRegistry?) {
        if (!registry!!.hasPlugin("io.flutter.plugins.sharedpreferences")) {
            SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences"))
            if (!registry!!.hasPlugin("io.flutter.plugins.firebasemessaging")) {
                FirebaseMessagingPlugin.registerWith(registry!!.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
            }
        }
    }
}
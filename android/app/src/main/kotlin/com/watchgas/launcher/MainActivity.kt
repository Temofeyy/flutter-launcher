package com.watchgas.launcher

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugins.GeneratedPluginRegistrant



class MainActivity: FlutterActivity() {
    private val eventChannelName: String = "LockerEvents"
    private val intentAction: String = "com.example.android.UNLOCK_LAUNCHER"

    private val passwordReceiver: PasswordBroadcastReceiver = PasswordBroadcastReceiver()
    private val sendToFlutterStream: LauncherEventHandler = LauncherEventHandler()




    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        val eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannelName)
        eventChannel.setStreamHandler(sendToFlutterStream)
        passwordReceiver.addFlutterPort(sendToFlutterStream)

        val filter = IntentFilter(intentAction)
        registerReceiver(passwordReceiver, filter, Context.RECEIVER_EXPORTED)
    }

    override fun onDestroy() {
        unregisterReceiver(passwordReceiver)
        super.onDestroy()
    }

    override fun onBackPressed() {

    }
}

class PasswordBroadcastReceiver: BroadcastReceiver() {
    private val PASSWORD = "12345"
    private var flutterPort: LauncherEventHandler? = null

    override fun onReceive(context: Context, intent: Intent) {
        Log.d("Kotlin", "Receive an intent")
        val pass = intent.getStringExtra("pass")
        if(pass == PASSWORD){
            Log.d("Kotlin", "Password correct")
            if(flutterPort == null) {
                Log.d("Kotlin", "LauncherEventHandler wasn't passed to PasswordReceiver in MainActivity")
                return
            }
            flutterPort!!.add(LauncherEvents.Unlock)
        } else {
            Log.d("Kotlin", "Password uncorrected")
            flutterPort!!.add(LauncherEvents.InvalidPassword)
        }
    }
    fun addFlutterPort(port: LauncherEventHandler){
        if(this.flutterPort != null) return
        this.flutterPort = port;
    }
}

class LauncherEventHandler : EventChannel.StreamHandler {
    private var stream: EventChannel.EventSink? = null

    override fun onListen(args: Any?, sink: EventChannel.EventSink) {
        Log.d("Kotlin", "Added listener to LauncherEventHandler")
        this.stream = sink
    }

    override fun onCancel(args: Any?) {
        this.stream = null
    }

    fun add(event: LauncherEvents){
        if(stream == null) return;
        Log.d("Kotlin", "Added event ${event.name} to flutter stream")
        stream!!.success(event.name)
    }
}

enum class LauncherEvents{
    Unlock,
    InvalidPassword
}
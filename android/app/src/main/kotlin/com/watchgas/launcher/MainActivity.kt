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
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    private val receiver: BroadcastReceiver = LockReceiver()

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        GeneratedPluginRegistrant.registerWith(flutterEngine)

        val filter = IntentFilter("com.example.android.UNLOCK_LAUNCHER")
        registerReceiver(receiver, filter, Context.RECEIVER_EXPORTED)
    }

    override fun onDestroy() {
        unregisterReceiver(receiver)
        super.onDestroy()
    }
}

class LockReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        Log.d("Kotlin", "Receive an intent")

        val PASSWORD = "12345"
        val flutterEngine = FlutterEngine(context)
        flutterEngine
                .dartExecutor
                .executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "LockerEvents")

        val pass = intent.getStringExtra("pass")

        if(pass == PASSWORD){
            Log.d("Kotlin", "Password correct")
            channel.invokeMethod("Unlock",null)
        } else {
            Log.d("Kotlin", "Password uncorrected")
            channel.invokeMethod("InvalidPassword",null )
        }

    }
}
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider
# Keep uni_links package
-keep class io.flutter.plugins.** { *; }
-keep class com.tentwenty.bookandgo.** { *; }


# Keep components with intent filters declared in the manifest
-keep class * {
 public void onReceive(android.content.Context, android.content.Intent);
}


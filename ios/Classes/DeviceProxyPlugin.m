#import "DeviceProxyPlugin.h"

@implementation DeviceProxyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
        methodChannelWithName:@"com.intechlab/device_proxy"
              binaryMessenger:[registrar messenger]];
    DeviceProxyPlugin* instance = [[DeviceProxyPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getProxySetting" isEqualToString:call.method]) {
    result([self getProxyUrl]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}
- (NSString *)getProxyUrl{
    NSDictionary *proxySettings = (__bridge NSDictionary *)CFNetworkCopySystemProxySettings();
    NSArray *proxies = (__bridge NSArray *)CFNetworkCopyProxiesForURL((__bridge CFURLRef)[NSURL URLWithString:@"http://www.baidu.com"], (__bridge CFDictionaryRef)proxySettings);
    NSDictionary *settings = [proxies objectAtIndex:0];
    NSString * hostName = [settings objectForKey:(NSString *)kCFProxyHostNameKey];
    NSString * protNumber = [settings objectForKey:(NSString *)kCFProxyPortNumberKey];
    NSString * proxyType = [settings objectForKey:(NSString *)kCFProxyTypeKey];
    NSLog(@"host=%@", hostName);
    NSLog(@"port=%@", protNumber);
    NSLog(@"type=%@", proxyType);
    return [NSString stringWithFormat:@"%@:%@", hostName?hostName:@"", protNumber?protNumber:@""];

}
@end

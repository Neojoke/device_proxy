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
    if ([proxySettings isKindOfClass:[NSDictionary class]]) {
        NSArray *proxies = (__bridge NSArray *)CFNetworkCopyProxiesForURL((__bridge CFURLRef)[NSURL URLWithString:@"http://www.baidu.com"], (__bridge CFDictionaryRef)proxySettings);
        if (proxies != nil && [proxies isKindOfClass:[NSArray class]]) {
            NSDictionary *settings = [proxies objectAtIndex:0];
            if (settings != nil && [settings isKindOfClass:[NSDictionary class]]) {
                NSString * hostName = [settings objectForKey:(NSString *)kCFProxyHostNameKey];
                NSString * protNumber = [settings objectForKey:(NSString *)kCFProxyPortNumberKey];
                NSString * proxyType = [settings objectForKey:(NSString *)kCFProxyTypeKey];
                if (hostName && protNumber && hostName.length) {
                    NSLog(@"host=%@", hostName);
                    NSLog(@"port=%@", protNumber);
                    NSLog(@"type=%@", proxyType);
                    return [NSString stringWithFormat:@"%@:%@", hostName?hostName:@"", protNumber?protNumber:@""];
                }
                else{
                    return @"";
                }
            }
            else{
                return @"";
            }
            
        }
        else{
            return @"";
        }
        
    }
    else{
        return @"";
    }
    

}
@end

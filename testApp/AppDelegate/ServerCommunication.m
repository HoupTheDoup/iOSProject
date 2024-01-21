//
//  ServerCommunication.m
//  testApp
//
//  Created by I462548730 on 20.01.24.
//

#import "ServerCommunication.h"

@implementation ServerCommunication

+ (id)sharedInstance {
    static ServerCommunication *serverCommunication = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serverCommunication = [[self alloc] init];
    });
    return serverCommunication;
}

//https://api.thecatapi.com/v1/images/search?limit=10&has_breeds=1&api_key=live_21Z7BSjztH1imeQQfBJyolNT2XJssrOflBzGpIjS1iTIqPvMYcSBeyji5YOnT0mz

- (void)hitAPI:(void (^)(NSArray * _Nullable result, NSError * _Nullable error))completionHandler {
    [self callAPI:@"https://api.thecatapi.com/v1/images/search?limit=10&has_breeds=1&api_key=live_21Z7BSjztH1imeQQfBJyolNT2XJssrOflBzGpIjS1iTIqPvMYcSBeyji5YOnT0mz" res:^(NSArray * _Nullable json, NSError * _Nullable error) {
        NSLog(@"res %@, err %@", json, error);
        completionHandler(json, error);
    }];
}

- (void)callAPI:(NSString*)url res:(void (^)(NSArray * _Nullable json, NSError * _Nullable error))completionHandler {
    [self callAPI:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completionHandler(nil, error);
            return;
        }
        NSError* error1;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error1];
        NSArray *array = @[json];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(array, error1);
        });
    }];
}
    
- (void)callAPI:(NSString*)url completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[defaultSession dataTaskWithRequest:urlRequest
                       completionHandler:completionHandler] resume];
}


+ (void)call:(NSString*_Nonnull)strURL
      method:(NSString*_Nullable)method
     headers:(NSDictionary*_Nullable)headers
   andParams:(NSDictionary*_Nullable)params
         res:(void (^_Nonnull)(NSDictionary * _Nullable json, NSError * _Nullable error))completionHandler {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    for (NSString *key in headers) {
        [request addValue:headers[key] forHTTPHeaderField:key];
    }
    method = method ?: @"GET";
    [request setHTTPMethod:method.uppercaseString];
    if (params) {
        NSError *error;
        NSData *body = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
        [request setHTTPBody:body];
    }
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (error) {
                        completionHandler(nil, error);
                        return;
                    }
                    NSError* error1;
                    id json = [NSJSONSerialization JSONObjectWithData:data
                                                              options:kNilOptions
                                                                error:&error1];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler(json, error1);
                    });
                }] resume];
}

@end

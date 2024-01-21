//
//  ServerCommunication.h
//  testApp
//
//  Created by I462548730 on 20.01.24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServerCommunication : NSObject

+ (id)sharedInstance;
- (void)hitAPI:(void (^)(NSArray * _Nullable result, NSError * _Nullable error))completionHandler;


@end

NS_ASSUME_NONNULL_END

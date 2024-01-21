//
//  CatsViewController.h
//  testApp
//
//  Created by I462548730 on 20.01.24.
//

#import <UIKit/UIKit.h>
#import "CatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CatsViewController : UIViewController

@property NSArray<CatModel *> *cats;
@property NSArray<NSString *> *urls;

@end

NS_ASSUME_NONNULL_END

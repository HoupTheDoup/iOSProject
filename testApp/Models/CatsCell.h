//
//  CatsCell.h
//  testApp
//
//  Created by I462548730 on 20.01.24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CatsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *catImage;
@property (weak, nonatomic) IBOutlet UILabel *catBreedLabel;
@property (weak, nonatomic) IBOutlet UILabel *catBreedValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *catNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *catNameValueLabel;

@end

NS_ASSUME_NONNULL_END

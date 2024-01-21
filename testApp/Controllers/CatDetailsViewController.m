//
//  CatDetailsViewController.m
//  testApp
//
//  Created by I462548730 on 21.01.24.
//

#import "CatDetailsViewController.h"

@interface CatDetailsViewController ()
@property NSDictionary *catInfo;

@property (weak, nonatomic) IBOutlet UIImageView *catImage;
@property (weak, nonatomic) IBOutlet UILabel *catInfoLabel;

@property (weak, nonatomic) IBOutlet UILabel *lifeSpanLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *breedLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperamentLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToFavoritesButton;

- (IBAction)addToFavoritesButtonTapped:(id)sender;
- (IBAction)catImageButtonTapped:(id)sender;


@end

@implementation CatDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *catDetailsArray = [self.details valueForKey:@"breeds"];
    self.catInfo = catDetailsArray[0];
    [self setValueLabels];
}

#pragma mark - Actions

- (IBAction)catImageButtonTapped:(id)sender 
{
    [self addImageViewWithImage:self.catImage.image];
}

- (IBAction)addToFavoritesButtonTapped:(id)sender 
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [self.catInfo valueForKey:@"wikipedia_url"]]];
}

#pragma mark - Other methods

- (void)setValueLabels 
{
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [self.details valueForKey:@"url"]]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            self.catImage.image = [UIImage imageWithData: data];
        });
    });
    self.catInfoLabel.text = [self.catInfo valueForKey:@"description"];
    self.lifeSpanLabel.text = [NSString stringWithFormat:@"%@ years", [self.catInfo valueForKey:@"life_span"]];
    NSDictionary *weight = [self.catInfo valueForKey:@"weight"];
    self.weightLabel.text = [NSString stringWithFormat:@"%@ kg", [weight valueForKey:@"metric"]];
    self.breedLabel.text = [self.catInfo valueForKey:@"name"];
    self.temperamentLabel.text = [self.catInfo valueForKey:@"temperament"];
}

-(void)addImageViewWithImage:(UIImage*)image {

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.backgroundColor = [UIColor whiteColor];
    imgView.image = image;
    imgView.tag = 1000;
    UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce:)];

    tapOnce.numberOfTapsRequired = 1;
    [imgView addGestureRecognizer:tapOnce];

    [imgView setUserInteractionEnabled:YES];
    [self.view addSubview:imgView];
}

- (void)tapOnce:(UIGestureRecognizer *)gesture
{
    UIImageView *imgView = (UIImageView*)[self.view viewWithTag:1000];
    [imgView removeFromSuperview];
}

@end

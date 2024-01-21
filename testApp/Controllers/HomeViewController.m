//
//  HomeViewController.m
//  testApp
//
//  Created by I462548730 on 20.01.24.
//

#import "HomeViewController.h"
#import "CatsViewController.h"
#import "ServerCommunication.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *catsButton;
- (IBAction)catsButtonTapped:(id)sender;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tileableImage"]];
//    [[ServerCommunication sharedInstance] hitAPI];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"CatsSegue"]) {
        [segue.destinationViewController setUrls:sender];
    }
}

- (IBAction)catsButtonTapped:(id)sender 
{
    __block NSArray *url;
    [[ServerCommunication sharedInstance] hitAPI:^(NSArray * _Nullable result, NSError * _Nullable error) {
        NSArray *array = result[0];
        url = array;
        [self performSegueWithIdentifier:@"CatsSegue" sender:url];
    }];
}


@end

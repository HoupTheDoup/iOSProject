//
//  CatsViewController.m
//  testApp
//
//  Created by I462548730 on 20.01.24.
//

#import "CatsViewController.h"
#import "CatDetailsViewController.h"
#import "catsCell.h"
#import "ServerCommunication.h"

@interface CatsViewController () <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property UIRefreshControl *refreshControl;

@end

@implementation CatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
        [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

        if (@available(iOS 10.0, *)) {
            self.tableView.refreshControl = self.refreshControl;
        } else {
            [self.tableView addSubview:self.refreshControl];
        }
    
    NSMutableArray *cats = [@[] mutableCopy];
    for (int i = 0; i < 10; i ++) {
        CatModel *cat = [CatModel new];
        
        [cats addObject:cat];
    }
    self.cats = cats;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"CatDetailsSegue"]) {
        [segue.destinationViewController setDetails:sender];
    }
}


#pragma mark - UITableViewDataSource UITableViewDelegate


- (nonnull CatsCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CatsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CatsCell"];
    __block NSString *dict = @"";
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        dict = self.urls[indexPath.row];
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [dict valueForKey:@"url"]]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.catImage.image = [UIImage imageWithData: data];
            NSArray *catDetailsArray = [dict valueForKey:@"breeds"];
            NSDictionary *catDetails = catDetailsArray[0];
            cell.catBreedValueLabel.text = [catDetails valueForKey:@"name"];
        });
    });
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return self.cats.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"CatDetailsSegue" sender:self.urls[indexPath.row]];
}

#pragma mark - Other methods

- (void)refreshTable {
    [self.refreshControl endRefreshing];
    [[ServerCommunication sharedInstance] hitAPI:^(NSArray * _Nullable result, NSError * _Nullable error) {
        
        NSArray *array = result[0];
        self.urls = array;
        [self.tableView reloadData];
    }];
    
}

@end

//
//  DSOHomeViewController.m
//  RBReviewer
//
//  Created by Aaron Schachter on 12/23/14.
//  Copyright (c) 2014 DoSomething.org. All rights reserved.
//

#import "DSOInboxViewController.h"
#import "DSODoSomethingAPIClient.h"
#import "DSODetailViewController.h"

@interface DSOInboxViewController ()

@property (strong, nonatomic) NSMutableArray *terms;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

- (IBAction)logoutTapped:(id)sender;
- (IBAction)refreshTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DSOInboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.terms = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    DSODoSomethingAPIClient *client = [DSODoSomethingAPIClient sharedClient];
    self.emailLabel.text = client.user[@"mail"];
    
    [client getTermsWithCompletionHandler:^(NSMutableArray *response){
        self.terms = response;
        [self.tableView reloadData];
    }];
    
    // @todo: Set this view as the initial vc, and then check if we're logged in
//    [client checkStatusWithCompletionHandler:^(NSDictionary *response){
//        NSLog(@"%@", response);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.terms count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    NSMutableDictionary *term = (NSMutableDictionary *)[self.terms objectAtIndex:indexPath.row];

    cell.textLabel.text = term[@"name"];
    NSString *total = (NSString *)term[@"inbox"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", total];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;

    if ([total intValue] == 0) {
        cell.textLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    NSMutableDictionary *term = (NSMutableDictionary *)[self.terms objectAtIndex:path.row];
    NSString *total = (NSString *)term[@"inbox"];
    
    if ([total intValue] > 0){
        return path;
    }
    
    return nil;
}

- (IBAction)logoutTapped:(id)sender {
    DSODoSomethingAPIClient *client = [DSODoSomethingAPIClient sharedClient];
    [client logoutUserWithCompletionHandler:^(NSDictionary *response){
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        [self.navigationController presentViewController:vc animated:YES completion:NULL];
    }];
}

- (IBAction)refreshTapped:(id)sender {
    [self viewDidLoad];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if (sender == self.logoutButton) {
        return;
    }
    UINavigationController *initialVC = (UINavigationController *) [segue destinationViewController];
    DSODetailViewController *destVC = (DSODetailViewController *)initialVC.topViewController;
    UITableViewCell *cell = (UITableViewCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *term = (NSMutableDictionary *)[self.terms objectAtIndex:indexPath.row];
    [destVC setTaxonomyTerm:term];
}
@end

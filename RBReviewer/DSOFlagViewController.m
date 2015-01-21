//
//  DSOFlagViewController.m
//  RBReviewer
//
//  Created by Aaron Schachter on 1/21/15.
//  Copyright (c) 2015 DoSomething.org. All rights reserved.
//

#import "DSOFlagViewController.h"

@interface DSOFlagViewController ()
@property (strong, nonatomic) NSMutableArray *options;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DSOFlagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.options = [[NSMutableArray alloc] init];
    [self.options addObject:@"Irrelevant"];
    [self.options addObject:@"Inappropriate"];
    [self.options addObject:@"Unrealistic"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.options count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.options objectAtIndex:indexPath.row];
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

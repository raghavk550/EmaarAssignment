//
//  ViewController.m
//  EmaarTestRaghav
//
//  Created by apple on 26/08/23.
//

#import "ViewController.h"
#import "UsersInformation.h"
#import "UsersListTableViewCell.h"
#import <SDWebImage/SDWebImage.h>
#import "EmaarTestRaghav-Swift.h"
#import "ViewModel.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set title
    self.title = @"Users List";
    
    // Initialize View Model
    self.viewModel = [[ViewModel alloc] init];
    
    // Fetch data from Core Data
    [_viewModel fetchUsersData:^(NSMutableArray * _Nonnull array) {
        [self->_tableView reloadData];
    }];
    
    // Call Api if internet connected
    if (self.viewModel.connected) {
        // Call Api
        [_viewModel callUserListApi:100 completion:^{
            [self->_tableView reloadData];
        }];
    }
}

#pragma mark - Table view Datasource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.userArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UsersListTableViewCell";
    UsersListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UsersListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString: [self.viewModel.userArray[indexPath.row] pictureMedium]]
                          placeholderImage:[UIImage systemImageNamed:@"person"]];
    cell.nameLabel.text = [self.viewModel.userArray[indexPath.row] fullName];
    cell.emailLabel.text = [self.viewModel.userArray[indexPath.row] email];
    cell.countryLabel.text = [NSString stringWithFormat:@"Country | %@", [self.viewModel.userArray[indexPath.row] country]];
    cell.registeredDateLabel.text = [self.viewModel.userArray[indexPath.row] registeredDate];
    return cell;
}

#pragma mark - Table view Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"UserDetailViewController"];
    controller.usersInfo = self.viewModel.userArray[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

@end

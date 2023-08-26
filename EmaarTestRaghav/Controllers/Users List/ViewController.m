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

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Variables

NSMutableArray *usersArray;

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set title
    self.title = @"Users List";
    
    // Call Api
    [self callUserListApi];
}

#pragma mark - API Call

- (void)callUserListApi {
    NSString *userData = [NSString stringWithFormat:@"https://randomuser.me/api?results=%d", 100];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString: userData]];
    
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            
            NSArray *userResultArray = responseDictionary[@"results"];
            usersArray = [[NSMutableArray alloc] init];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSDate *nowDate = [[NSDate alloc] init];
            
            for (NSDictionary *userData in userResultArray) {
                UsersInformation *user = [[UsersInformation alloc] init];
                user.gender = userData[@"gender"];
                user.email = userData[@"email"];
                
                NSString *fullName = [NSString stringWithFormat:@"%@ %@", userData[@"name"][@"first"], userData[@"name"][@"last"]];
                
                user.fullName = fullName;
                user.city = userData[@"location"][@"city"];
                user.state = userData[@"location"][@"state"];
                if ([userData[@"location"][@"postcode"] isKindOfClass:[NSString class]]) {
                    user.postCode = userData[@"location"][@"postcode"];
                }
                else {
                    NSNumber *postCode = userData[@"location"][@"postcode"];
                    user.postCode = [postCode stringValue];
                }
                
                user.country = userData[@"location"][@"country"];
                
                NSString *dobDate = userData[@"dob"][@"date"];
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                
                NSDate *dateFromDobString = [[NSDate alloc] init];
                dateFromDobString = [dateFormatter dateFromString:dobDate];
                [dateFormatter setDateFormat:@"dd MMM yyyy"];
                user.dobDate = [dateFormatter stringFromDate:dateFromDobString];
                
                user.dobAge = userData[@"dob"][@"age"];
                
                NSString *registeredDate = userData[@"registered"][@"date"];
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                
                NSDate *dateFromRegisteredString = [[NSDate alloc] init];
                dateFromRegisteredString = [dateFormatter dateFromString:registeredDate];
                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:dateFromRegisteredString toDate:nowDate options:0];
                
                if ([components day] == 0) {
                    [dateFormatter setDateFormat:@"hh:mm a"];
                    NSString *convertedString = [NSString stringWithFormat:@"Today, %@", [dateFormatter stringFromDate:dateFromRegisteredString]];
                    user.registeredDate = convertedString;
                }
                else if ([components day] == 1) {
                    [dateFormatter setDateFormat:@"hh:mm a"];
                    NSString *convertedString = [NSString stringWithFormat:@"Yesterday, %@", [dateFormatter stringFromDate:dateFromRegisteredString]];
                    user.registeredDate = convertedString;
                }
                else if ([components day] >= 2 && [components day] <= 10) {
                    user.registeredDate = [NSString stringWithFormat:@"%ld days ago", (long)[components day]];
                }
                else {
                    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
                    user.registeredDate = [dateFormatter stringFromDate:dateFromRegisteredString];
                }
                
                user.pictureLarge = userData[@"picture"][@"large"];
                user.pictureMedium = userData[@"picture"][@"medium"];
                
                [usersArray addObject:user];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_tableView reloadData];
            });
        }
        else
        {
            NSLog(@"Error");
        }
    }];
    [dataTask resume];
}

#pragma mark - Table view Datasource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UsersListTableViewCell";
    UsersListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UsersListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString: [usersArray[indexPath.row] pictureMedium]]
                          placeholderImage:[UIImage systemImageNamed:@"person"]];
    cell.nameLabel.text = [usersArray[indexPath.row] fullName];
    cell.emailLabel.text = [usersArray[indexPath.row] email];
    cell.countryLabel.text = [NSString stringWithFormat:@"Country | %@", [usersArray[indexPath.row] country]];
    cell.registeredDateLabel.text = [usersArray[indexPath.row] registeredDate];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return usersArray.count;
}

#pragma mark - Table view Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"UserDetailViewController"];
    controller.usersInfo = usersArray[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

@end

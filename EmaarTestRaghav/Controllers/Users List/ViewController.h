//
//  ViewController.h
//  EmaarTestRaghav
//
//  Created by apple on 26/08/23.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (strong, nonatomic) AppDelegate *delegate;
@property (strong) NSManagedObject *usersDb;

- (void)callUserListApi: (int) count;

- (BOOL)connected;

@end


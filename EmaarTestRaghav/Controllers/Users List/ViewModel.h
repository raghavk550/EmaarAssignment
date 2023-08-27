//
//  ViewModel.h
//  EmaarTestRaghav
//
//  Created by apple on 27/08/23.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *userArray;

@property (strong, nonatomic) AppDelegate *delegate;

- (void)fetchUsersData: (void (^)(NSMutableArray *array)) callback;

- (void)callUserListApi: (int) count completion:(void (^)(void)) callback;

- (BOOL)connected;

@end

NS_ASSUME_NONNULL_END

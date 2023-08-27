//
//  ViewModel.m
//  EmaarTestRaghav
//
//  Created by apple on 27/08/23.
//

#import "ViewModel.h"
#import "UsersInformation.h"

@implementation ViewModel

#pragma mark - Getting Managed Object Context

- (NSManagedObjectContext *) managedObjectContext {
    NSManagedObjectContext *context = nil;
    _delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([_delegate respondsToSelector:@selector(persistentContainer)]) {
        context = _delegate.persistentContainer.viewContext;
    }
    return context;
}

#pragma mark - Check Internet Connectivity

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
//    Reachability* reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

#pragma mark - Fetch Users data

- (void)fetchUsersData: (void (^)(NSMutableArray *array)) callback {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    self.userArray = [[NSMutableArray alloc] init];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Users"];
    self.userArray = [[context executeFetchRequest:request error:nil] mutableCopy];
    
    callback(self.userArray);
}

#pragma mark - API Call

- (void)callUserListApi: (int) count completion:(void (^)(void)) callback {
    NSString *userData = [NSString stringWithFormat:@"https://randomuser.me/api?results=%d", count];
    
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
            
            NSArray *userResultsArray = responseDictionary[@"results"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self deleteUserData:userResultsArray completion:^(NSMutableArray *array) {
                    self.userArray = array;
                    callback();
                }];
            });
        }
        else
        {
            NSLog(@"Error");
        }
    }];
    [dataTask resume];
}

#pragma mark - Delete All data

- (void)deleteUserData: (NSArray *) userResultArray completion:(void (^)(NSMutableArray *array)) callback {
    NSManagedObjectContext *context = [self managedObjectContext];

    // Fetch all objects of the entity
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Users"];
    NSError *fetchError = nil;
    NSArray *users = [context executeFetchRequest:fetchRequest error:&fetchError];

    if (fetchError) {
        NSLog(@"Error fetching objects: %@", fetchError);
    } else {
        // Delete each fetched object
        for (NSManagedObject *user in users) {
            [context deleteObject:user];
        }

        // Save the context to commit the changes
        NSError *saveError = nil;
        if (![context save:&saveError]) {
            NSLog(@"Error saving context: %@", saveError);
        }
        else {
            // Save new data to Core Data
            self.userArray = [[NSMutableArray alloc] init];
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
                
                user.dobAge = [userData[@"dob"][@"age"] stringValue];
                
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
                
                [self.userArray addObject:user];
                
                NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:context];
                
                [newUser setValue:fullName forKey:@"fullName"];
                [newUser setValue:user.city forKey:@"city"];
                [newUser setValue:user.state forKey:@"state"];
                [newUser setValue:user.email forKey:@"email"];
                [newUser setValue:user.gender forKey:@"gender"];
                [newUser setValue:user.country forKey:@"country"];
                [newUser setValue:user.postCode forKey:@"postCode"];
                [newUser setValue:user.dobAge forKey:@"dobAge"];
                [newUser setValue:user.dobDate forKey:@"dobDate"];
                [newUser setValue:user.registeredDate forKey:@"registeredDate"];
                [newUser setValue:user.pictureLarge forKey:@"pictureLarge"];
                [newUser setValue:user.pictureMedium forKey:@"pictureMedium"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = nil;
                if (![context save:&error]) {
                    NSLog(@"%@ %@", error, [error localizedDescription]);
                }
                else {
                    NSLog(@"Data Saved");
                    
                    // Fetch Data from Core data
                    [self fetchUsersData:^(NSMutableArray * _Nonnull array) {
                        self.userArray = array;
                        callback(array);
                    }];
                }
            });
        }
    }
}

@end

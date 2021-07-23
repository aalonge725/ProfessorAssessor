#import <Parse/Parse.h>
#import "School.h"
#import "Professor.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser <PFSubclassing>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) School *school;
@property (nonatomic, strong) NSMutableArray<Professor *> *professors;

@end

NS_ASSUME_NONNULL_END

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FacebookUser : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;

+ (FacebookUser *)createUserWithFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email;

@end

NS_ASSUME_NONNULL_END

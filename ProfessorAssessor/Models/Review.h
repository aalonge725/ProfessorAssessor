#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Review : PFObject /*<PFSubclassing>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) PFUser *reviewer;
// TODO: add course property once Course class is set up
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSString *content;
// TODO: add professor property once Professor class is set up

// TODO: make postReview method*/

@end

NS_ASSUME_NONNULL_END

@import HCSStarRatingView;
#import <UIKit/UIKit.h>
#import "Professor.h"

NS_ASSUME_NONNULL_BEGIN

@interface SortedProfessorsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *professorName;
@property (strong, nonatomic) IBOutlet UILabel *departmentName;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *averageRating;

- (void)setProfessor:(Professor *)professor;

@end

NS_ASSUME_NONNULL_END

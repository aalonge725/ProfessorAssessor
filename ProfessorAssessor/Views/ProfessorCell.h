@import HCSStarRatingView;
#import <UIKit/UIKit.h>
#import "Professor.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfessorCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *professorName;
@property (strong, nonatomic) IBOutlet UILabel *departmentName;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *averageRating;
@property (strong, nonatomic) IBOutlet UIView *background;

- (void)setProfessor:(Professor *)professor;
- (void)configureBackground;

@end

NS_ASSUME_NONNULL_END

@import HCSStarRatingView;
#import <UIKit/UIKit.h>
#import "Professor.h"

NS_ASSUME_NONNULL_BEGIN

@interface FilteredProfessorsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *professorName;
@property (nonatomic, strong) IBOutlet UILabel *departmentName;
@property (nonatomic, strong) IBOutlet HCSStarRatingView *averageRating;
@property (strong, nonatomic) IBOutlet UIView *background;

- (void)setProfessor:(Professor *)professor;
- (void)configureBackground;

@end

NS_ASSUME_NONNULL_END

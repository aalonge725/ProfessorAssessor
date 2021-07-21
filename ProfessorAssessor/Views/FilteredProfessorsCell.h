@import HCSStarRatingView;
#import <UIKit/UIKit.h>
#import "Professor.h"

NS_ASSUME_NONNULL_BEGIN

@interface FilteredProfessorsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *professorName;
@property (nonatomic, strong) IBOutlet UILabel *departmentName;
@property (nonatomic, strong) IBOutlet HCSStarRatingView *averageRating;

- (void)setProfessor:(Professor *)professor;

@end

NS_ASSUME_NONNULL_END

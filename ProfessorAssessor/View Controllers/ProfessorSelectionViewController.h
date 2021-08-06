#import <UIKit/UIKit.h>
#import "Professor.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ProfessorSelectionViewControllerDelegate

- (void)didSelectProfessor:(Professor *)professor;

@end

@interface ProfessorSelectionViewController : UIViewController

@property (nonatomic, weak) id<ProfessorSelectionViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

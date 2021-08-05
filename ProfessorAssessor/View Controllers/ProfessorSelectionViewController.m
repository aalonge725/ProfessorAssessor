@import DGActivityIndicatorView;
#import "ProfessorSelectionViewController.h"
#import "ProfessorCell.h"
#import "Networker.h"
#import "School.h"

@interface ProfessorSelectionViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray<Professor *> *professors;
@property (nonatomic, strong) NSArray<Professor *> *filteredProfessors;
@property (nonatomic, strong) DGActivityIndicatorView *activityIndicator;

@end

@implementation ProfessorSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfessorCell" bundle:nil] forCellReuseIdentifier:@"ProfessorCell"];

    [self setUpActivityIndicator];
    [self setUpRefreshControl];

    [self fetchProfessors];
}

- (void)fetchProfessors {
    [self.activityIndicator startAnimating];

    __weak typeof(self) weakSelf = self;

    [Networker
     fetchSchoolAndProfessorsWithCompletion:^(
                                              PFObject *_Nullable object,
                                              NSError *_Nonnull error) {
        if (object) {
            __strong __typeof(self) strongSelf = weakSelf;

            School *school = [School schoolFromPFObject:object];

            NSArray<Professor *> *professors = school.professors;
            strongSelf.professors = [professors
                                   sortedArrayUsingComparator:
                                   ^NSComparisonResult(Professor *_Nonnull professor1,
                                                       Professor *_Nonnull professor2) {
                return [professor1.name compare:professor2.name];
            }];
            strongSelf.filteredProfessors = strongSelf.professors;

            [strongSelf.tableView reloadData];
            [strongSelf.tableView.refreshControl endRefreshing];
            [strongSelf.activityIndicator stopAnimating];
        }
    }];

}

- (void)setUpRefreshControl {
    self.tableView.refreshControl = [[UIRefreshControl alloc] init];

    [self.tableView.refreshControl addTarget:self
                                      action:@selector(fetchProfessors)
                            forControlEvents:UIControlEventValueChanged];

    [self.tableView insertSubview:self.tableView.refreshControl atIndex:0];
}

- (void)setUpActivityIndicator {
    CGFloat width = self.view.bounds.size.width / 5.0f;
    self.activityIndicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallClipRotateMultiple tintColor:[UIColor systemTealColor] size:width];

    self.activityIndicator.frame = CGRectMake(self.view.center.x - width / 2, self.view.center.y - width / 2, width, width);

    [self.view addSubview:self.activityIndicator];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredProfessors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfessorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfessorCell" forIndexPath:indexPath];

    Professor *professor = self.filteredProfessors[indexPath.row];
    [cell setProfessor:professor];
    [cell configureBackground];

    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate
                                  predicateWithBlock:^
                                BOOL(id _Nullable evaluatedObject,
                                       NSDictionary<NSString *,id>
                                       *_Nullable bindings) {
            return [((Professor *)evaluatedObject).name containsString:searchText];
        }];
        self.filteredProfessors = [self.professors filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredProfessors = self.professors;
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Professor *professor = self.filteredProfessors[indexPath.row];

    [self.delegate didSelectProfessor:professor];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}

- (IBAction)close:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

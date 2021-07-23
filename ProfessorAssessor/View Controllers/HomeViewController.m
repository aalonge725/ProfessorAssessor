@import FBSDKLoginKit;
@import HCSStarRatingView;
#import "HomeViewController.h"
#import "AuthenticationViewController.h"
#import "ProfessorViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "Networker.h"
#import "FilteredProfessorsCell.h"
#import "SortedProfessorsCell.h"
#import "Professor.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UITableView *filteredTableView;
@property (nonatomic, strong) IBOutlet UITableView *sortedTableView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UILabel *schoolName;
@property (nonatomic, strong) NSArray<Professor *> *professors;
@property (nonatomic, strong) NSArray<Professor *> *filteredProfessors;
@property (nonatomic, strong) NSArray<Professor *> *sortedProfessors;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self fetchSchoolAndProfessors];

    [self setUpRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self deselectTableViewRow];
}

- (void)fetchSchoolAndProfessors {
    __weak typeof(self) weakSelf = self;

    [Networker
     fetchSchoolAndProfessorsWithCompletion:^(
                                              PFObject *_Nullable object,
                                              NSError *_Nonnull error) {
        if (object) {
            weakSelf.school = [School schoolFromPFObject:object];
            weakSelf.schoolName.text = weakSelf.school.name;
            
            NSArray<Professor *> *professors = weakSelf.school.professors;
            weakSelf.professors = [professors
                                   sortedArrayUsingComparator:
                                   ^NSComparisonResult(School *_Nonnull school1,
                                                       School *_Nonnull school2) {
                return [school1.name compare:school2.name];
            }];
            weakSelf.filteredProfessors = weakSelf.professors;
            weakSelf.sortedProfessors = weakSelf.professors;

            [weakSelf.filteredTableView reloadData];
            [weakSelf.sortedTableView reloadData];
            [weakSelf.sortedTableView.refreshControl endRefreshing];
        }
    }];
}

- (void)setUpRefreshControl {
    self.sortedTableView.refreshControl = [[UIRefreshControl alloc] init];

    [self.sortedTableView.refreshControl addTarget:self action:@selector(fetchSchoolAndProfessors) forControlEvents:UIControlEventValueChanged];

    [self.sortedTableView insertSubview:self.sortedTableView.refreshControl atIndex:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView == self.filteredTableView ? self.filteredProfessors.count : self.sortedProfessors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.filteredTableView) {
        FilteredProfessorsCell *cell = [tableView
                                        dequeueReusableCellWithIdentifier:@"FilteredProfessorsCell"
                                        forIndexPath:indexPath];

        Professor *professor = self.filteredProfessors[indexPath.row];
        [cell setProfessor:professor];

        return cell;
    } else if (tableView == self.sortedTableView) {
        SortedProfessorsCell *cell = [
                                      tableView
                                      dequeueReusableCellWithIdentifier:@"SortedProfessorsCell"
                                      forIndexPath:indexPath];

        Professor *professor = self.sortedProfessors[indexPath.row];
        [cell setProfessor:professor];

        return cell;
    }
    return [UITableViewCell new];
}

- (void)deselectTableViewRow {
    NSIndexPath *selectedFromFiltered = self.filteredTableView.indexPathForSelectedRow;
    NSIndexPath *selectedFromSorted = self.sortedTableView.indexPathForSelectedRow;

    if (selectedFromFiltered) {
        [self.filteredTableView deselectRowAtIndexPath:selectedFromFiltered animated:YES];
    }

    if (selectedFromSorted) {
        [self.sortedTableView deselectRowAtIndexPath:selectedFromSorted animated:YES];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate
                                  predicateWithBlock:
                                  ^BOOL(id _Nullable evaluatedObject,
                                        NSDictionary<NSString *,id> *_Nullable bindings) {
            return [((Professor *)evaluatedObject).name containsString:searchText];
        }];
        self.filteredProfessors = [self.professors filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredProfessors = self.professors;
    }
    [self.filteredTableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;

    // TODO: adjust constraints to show filteredTableView
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar endEditing:YES];
    self.searchBar.showsCancelButton = NO;

    // TODO: adjust constraints to hide filteredTableView
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self endEditingForScrollOrSearch];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self endEditingForScrollOrSearch];
}

- (void)endEditingForScrollOrSearch {
    [self.searchBar endEditing:YES];

    if (self.searchBar.text.length == 0) {
        self.searchBar.showsCancelButton = NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *tappedCell = sender;

    if ([segue.identifier isEqual:@"filteredSegue"]) {
        NSIndexPath *indexPath = [self.filteredTableView indexPathForCell:tappedCell];
        Professor *professor = self.filteredProfessors[indexPath.row];

        ProfessorViewController *viewController = [segue destinationViewController];
        viewController.professor = professor;
    } else if ([segue.identifier isEqual:@"sortedSegue"]) {
        NSIndexPath *indexPath = [self.sortedTableView indexPathForCell:tappedCell];
        Professor *professor = self.sortedProfessors[indexPath.row];

        ProfessorViewController *viewController = [segue destinationViewController];
        viewController.professor = professor;
    }
}

@end

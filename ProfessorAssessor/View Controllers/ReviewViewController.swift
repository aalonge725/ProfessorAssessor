import UIKit
import HCSStarRatingView

@objc public class ReviewViewController: UIViewController {
    static var dateFormatter: DateFormatter?

    @IBOutlet var professorName: UILabel!
    @IBOutlet var courseName: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var content: UILabel!
    @IBOutlet var rating: HCSStarRatingView!

    @objc var review: Review!

    public override func viewDidLoad() {
        super.viewDidLoad()

        displayReview()
    }

    func displayReview() {
        professorName.text = review.professor?.name
        courseName.text = review.course?.name
        content.text = review.content
        rating.value = CGFloat(review.rating.doubleValue)

        if ReviewViewController.dateFormatter != nil {
            ReviewViewController.dateFormatter = DateFormatter()
            ReviewViewController.dateFormatter?.dateStyle = .medium
            ReviewViewController.dateFormatter?.timeStyle = .none
        }

        date.text = ReviewViewController.dateFormatter?.string(from: review.createdAt)
    }

}

/// Represents something that is expandable.
public protocol Expandable {
    /// Gets or sets the whether or not the object
    /// should expand to the available space (greedy).
    var expand: Bool { get set }
}

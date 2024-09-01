/// Represents something that is paddable.
public protocol Paddable: AnyObject {
    /// Gets or sets the padding.
    var padding: Padding? { get set }
}

extension Paddable where Self: AnyObject {
    public func padLeft(_ value: Int) -> Self {
        return padding(
            Padding(
                left: value,
                top: self.padding.getSafeTopPadding(),
                right: self.padding.getSafeRightPadding(),
                bottom: self.padding.getSafeBottomPadding()
            ))
    }

    public func padTop(_ value: Int) -> Self {
        return padding(
            Padding(
                left: self.padding.getSafeTopPadding(),
                top: value,
                right: self.padding.getSafeRightPadding(),
                bottom: self.padding.getSafeBottomPadding()
            ))
    }

    public func padRight(_ value: Int) -> Self {
        return padding(
            Padding(
                left: self.padding.getSafeTopPadding(),
                top: self.padding.getSafeTopPadding(),
                right: value,
                bottom: self.padding.getSafeBottomPadding()
            ))
    }

    public func padBottom(_ value: Int) -> Self {
        return padding(
            Padding(
                left: self.padding.getSafeTopPadding(),
                top: self.padding.getSafeTopPadding(),
                right: self.padding.getSafeRightPadding(),
                bottom: value
            ))
    }

    public func padding(left: Int, top: Int, right: Int, bottom: Int) -> Self {
        return padding(
            Padding(
                left: left,
                top: top,
                right: right,
                bottom: bottom
            ))
    }

    public func padding(_ padding: Padding) -> Self {
        self.padding = padding
        return self
    }
}

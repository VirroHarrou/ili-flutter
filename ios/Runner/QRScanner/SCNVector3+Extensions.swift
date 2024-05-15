import SceneKit

private func * (lhs: SCNVector3, rhs: Float) -> SCNVector3 {
    return SCNVector3(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs)
}

internal extension SCNVector3 {
    func length() -> Float {
        return sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
    }
    func setLength(_ mag: Float) -> SCNVector3 {
        return self * (mag / self.length())
    }
}

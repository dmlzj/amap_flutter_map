/// 地图覆盖物基类
class BaseOverlay {
  /// overlay id
  String _id;

  String get id => _id;

  BaseOverlay() {
    this._id = this.hashCode.toString();
  }

  void setIdForCopy(String copyId) => _id = copyId;

  BaseOverlay clone() {
    throw UnimplementedError(
        'BaseOverlay subClass should implement this methed.');
  }

  Map<String, dynamic> toMap() {
    throw UnimplementedError(
        'BaseOverlay subClass should implement this methed.');
  }
}

List<Map<String, dynamic>> serializeOverlaySet(Set<BaseOverlay> overlays) {
  if (overlays == null) {
    return null;
  }
  return overlays
      .map<Map<String, dynamic>>((BaseOverlay overlay) => overlay.toMap())
      .toList();
}

/// All / Cloud / Downloaded switcher on the Voices screen.
enum VoicesSegment { all, cloud, downloaded }

extension VoicesSegmentLabel on VoicesSegment {
  String get label {
    switch (this) {
      case VoicesSegment.all:
        return 'All';
      case VoicesSegment.cloud:
        return 'Cloud';
      case VoicesSegment.downloaded:
        return 'Downloaded';
    }
  }
}

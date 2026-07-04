class UserPermissions {
  final bool isGuest;
  final bool isAdmin;
  final Set<int> accessibleTeamIds;

  const UserPermissions({
    this.isGuest = false,
    this.isAdmin = false,
    this.accessibleTeamIds = const {}, // Tomt sæt som standard
  });

  bool canReportResults(int teamId) {
    if (isGuest) return false; // En gæst kan aldrig redigere
    if (isAdmin) return true;
    return accessibleTeamIds.contains(teamId);
  }
}

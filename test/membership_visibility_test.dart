import 'package:flutter_test/flutter_test.dart';
import 'package:hop/models/active_memberships.dart';
import 'package:hop/models/user_membership.dart';

/// GZ#1508 — a customer who holds TWO active memberships of the same type
/// (same membership_id) — one freshly topped up with uses, one already at 0 —
/// saw only ONE of them in the app, and it was the depleted (0-use) pass. The
/// new pass was invisible even though the backend returned BOTH rows in
/// `activeMembership`.
///
/// Root cause: `UserActiveMembership.activeMemberships(id)` used `lastWhere`,
/// collapsing every active row sharing a membership_id down to a single one —
/// the LAST in the list, which happened to be the depleted pass. The membership
/// tab iterated the catalog and looked up exactly one active row per
/// membership_id, so the second pass could never render.
///
/// Fix: `activeMembershipsFor(id)` exposes ALL active rows for a membership_id
/// so the tab renders one card per active membership.
void main() {
  // The pass with uses remaining (id 15645) first, the depleted 0-use pass
  // (id 12615) last — exactly the order that made `lastWhere` pick the wrong
  // one.
  UserActiveMembership member() => UserActiveMembership(
        membershipModel: [],
        membershipCategories: [],
        activeMembership: [
          ActiveMemberships(
            id: 15645,
            membershipId: 421,
            membershipName: 'Pass',
            usesLeft: 8, // uses remaining
            finishDate: '2026-09-03T23:59:59.999Z',
          ),
          ActiveMemberships(
            id: 12615,
            membershipId: 421,
            membershipName: 'Pass',
            usesLeft: 0, // depleted
            finishDate: '2026-07-24T23:59:59.999Z',
          ),
        ],
      );

  group('GZ#1508 multiple active memberships of the same type', () {
    test('activeMembershipsFor returns EVERY active row for a membership_id',
        () {
      final visible = member().activeMembershipsFor(421);
      expect(visible.length, 2,
          reason: 'both active Pass rows must be visible');
    });

    test('the topped-up (uses-remaining) pass is among the visible rows', () {
      final visible = member().activeMembershipsFor(421);
      final hasUses =
          visible.any((m) => (m.usesLeft ?? 0) > 0 && m.id == 15645);
      expect(hasUses, isTrue,
          reason: 'the pass with uses (id 15645) must not be hidden by the 0-use pass');
    });

    test('ignores placeholder rows with a null id', () {
      final um = UserActiveMembership(
        membershipModel: [],
        membershipCategories: [],
        activeMembership: [ActiveMemberships(membershipId: 421)],
      );
      expect(um.activeMembershipsFor(421), isEmpty);
    });

    test('returns empty when the customer has no active row for that id', () {
      expect(member().activeMembershipsFor(999), isEmpty);
    });
  });
}

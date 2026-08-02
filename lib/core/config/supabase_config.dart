/// Supabase project this app authenticates against directly — see
/// docs/adr/0006-mobile-supabase-auth.md and the backend repo's
/// docs/adr/0004-supabase-jwks-verification.md (which verifies the
/// session tokens this produces).
///
/// [publishableKey] is safe to ship in the client: it's a public key
/// by design (same as it being visible in Supabase's own dashboard),
/// unlike a service-role key or JWT signing secret, neither of which
/// belongs on a device.
library;

abstract final class SupabaseConfig {
  static const String url = 'https://rkbxifztyvmtnpwctsiu.supabase.co';
  static const String publishableKey =
      'sb_publishable_aXfbL6cR8yAgQir4fOYbYQ_xTPiQbiF';
}

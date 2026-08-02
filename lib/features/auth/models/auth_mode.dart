/// Which of the two auth flows [AuthScreen] is rendering — the copy,
/// the cross-link at the bottom, and which Supabase call the
/// email/password form submits to (`signInWithPassword` vs `signUp`)
/// all differ; the Apple/Google buttons behave identically either way
/// (both are not-set-up-yet placeholders regardless of mode).
enum AuthMode { signIn, signUp }

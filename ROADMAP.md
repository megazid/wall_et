# wall_et — Build Roadmap

A simple money tracker, built in **3 versions**. Each version is a full rebuild of the
same app at a higher level of architecture. The goal is to *feel* the difference between
approaches by shipping the same product three times.

Each version lives on its own long-lived branch (`v1`, `v2`, `v3`). Do feature work on
short branches off the current version branch, then merge in. Tag a release when a version
is done.

| Version | Architecture | State | Storage | Screens | Headline feature |
|--------|--------------|-------|---------|---------|------------------|
| **v1** | MVC | `setState` | `shared_preferences` | 1 (Home) | Add + persist expenses |
| **v2** | MVVM | `provider` (ChangeNotifier) | `hive` | Multi-screen | Filter system |
| **v3** | Clean Architecture | `bloc` / `cubit` | Firebase (Firestore) | Multi-screen | Custom UI identity + animations |

---

## Git / branch workflow

Use this same flow for all three versions.

- Long-lived branches: `v1`, `v2`, `v3`. Never commit straight to them once real.
- Feature branches off the version branch: `feat/v1-add-expense`, `fix/v1-invoice-color`, etc.
- Merge feature branch → version branch via PR (even solo — it's good practice and gives you a history).
- When a version is complete and working, tag it: `git tag v1.0.0 && git push --tags`.
- Keep `main` pointing at the latest *finished* version (merge `v1` → `main` when v1 ships).

Suggested lifecycle per feature:

```
git checkout v1
git checkout -b feat/v1-add-expense
# ... work, commit small ...
git push -u origin feat/v1-add-expense
# open PR -> merge into v1
```

---

## Version 1 — MVC + setState + shared_preferences

**Goal:** finish the current app so it actually works end-to-end. One screen, real data
you can add and that survives an app restart. No packages beyond `shared_preferences`.

**Scope:** single Home screen showing expenses grouped by day, a running total, an add-expense
flow, and local persistence. This is about getting the *product* working, not the architecture.

### Tasks

**1.1 — Fix the current model & clean up mock data**
- Fix the `Invoice.color` getter bug (`Color get color => color(colorValue)` infinitely recurses; should be `Color(colorValue)`).
- Add `Invoice.icon` / `Invoice.color` mapping that actually compiles.
- Give `Invoice` an `amount` as a real `double` (not a `String`), plus a `DateTime date`.
- Delete `mock_data.dart`'s raw `Map` structure; replace with `List<Invoice>` (mock is fine for now).
- ✅ **Done when:** the app builds with no analyzer errors and Home renders from `List<Invoice>`, not `Map`s.

**1.2 — Introduce a real controller**
- Move all expense logic into `HomeController` (add, delete, group-by-day, day total, grand total).
- Controller holds the in-memory `List<Invoice>` and exposes methods the view calls.
- Keep parsing/formatting helpers here (currency formatting, date formatting).
- ✅ **Done when:** `HomeScreen` contains no business logic — only layout + calls into `HomeController`.

**1.3 — Add-expense flow**
- Wire the FAB to open an add-expense form (bottom sheet or a pushed simple form is fine).
- Fields: title, amount, category/icon, date (default today).
- On submit: create an `Invoice`, add via controller, `setState` to refresh Home.
- ✅ **Done when:** adding an expense makes it appear on Home immediately, in the right day group, and totals update.

**1.4 — Delete / edit an expense**
- Swipe-to-delete (or long-press) on an expense row.
- (Optional) tap a row to edit.
- ✅ **Done when:** removing an expense updates the list and totals without a restart.

**1.5 — Persist with shared_preferences**
- Add `shared_preferences`. Serialize `List<Invoice>` to JSON (add `toJson`/`fromJson` to `Invoice`).
- Save on every mutation (add/edit/delete). Load on app start.
- ✅ **Done when:** you add expenses, kill the app, reopen it, and they're all still there.

**1.6 — Polish & totals correctness**
- Grand total = sum of all amounts; day totals correct; format money consistently (e.g. `-$1,000`).
- Handle empty state (no expenses yet).
- ✅ **Done when:** totals are always correct and the empty state looks intentional.

**1.7 — Ship v1**
- Basic widget test still passes (`flutter test`).
- Tag `v1.0.0`, merge `v1` → `main`.
- ✅ **Done when:** tagged, pushed, and `main` runs the finished v1.

---

## Version 2 — MVVM + Provider + Hive + multi-screen

**Goal:** re-architect for growth. Reactive state via `provider`, a real local DB via `hive`,
proper separation into ViewModels, and more than one screen. Add the filtering system.

**Scope:** everything v1 does, plus categories as first-class data, multiple screens
(Home, Add/Edit, Details, Filter/Search), and a filter system (by date range, category, amount).

### Tasks

**2.1 — Project restructure (MVVM)**
- New folders: `models/`, `viewmodels/`, `views/`, `services/` (or `repositories/`), `widgets/`.
- A ViewModel per screen (e.g. `HomeViewModel`, `AddExpenseViewModel`) extending `ChangeNotifier`.
- ✅ **Done when:** each screen has a ViewModel and views never touch storage directly.

**2.2 — Hive setup & models**
- Add `hive`, `hive_flutter`, `hive_generator`, `build_runner`.
- Convert `Invoice` to a Hive `@HiveType` with `@HiveField`s; run codegen.
- Add a `Category` model (name, icon, color) as its own Hive type.
- ✅ **Done when:** `flutter pub run build_runner build` succeeds and boxes open on startup.

**2.3 — Repository layer**
- `ExpenseRepository` wraps the Hive box: `getAll`, `add`, `update`, `delete`, `watch` (stream/listenable).
- ViewModels depend on the repository, not on Hive directly.
- ✅ **Done when:** swapping storage later would only touch the repository.

**2.4 — Provider wiring**
- Add `provider`. Register repositories + ViewModels at the app root (`MultiProvider`).
- Views use `context.watch` / `Consumer` to rebuild reactively — remove all `setState` for data.
- ✅ **Done when:** UI updates come from `notifyListeners()`, no manual `setState` for data changes.

**2.5 — Multi-screen navigation**
- Screens: Home (list + totals), Add/Edit Expense, Expense Details, Filter/Search.
- Set up named routes or a simple router.
- ✅ **Done when:** you can navigate between all screens and back cleanly.

**2.6 — Categories management**
- Screen or sheet to create/edit categories; pick a category when adding an expense.
- Seed a few default categories on first run.
- ✅ **Done when:** expenses reference real categories and you can manage them.

**2.7 — Filter system (headline feature)**
- Filter by: date range, category (multi-select), amount range, and free-text search on title.
- Filtering happens in the ViewModel; Home reflects the active filter with a clear "filters active" indicator + reset.
- ✅ **Done when:** applying any combination of filters correctly narrows the list and totals recompute for the filtered set.

**2.8 — Summary / stats (optional stretch)**
- Simple totals per category or per month on Home or a stats tab.
- ✅ **Done when:** numbers match the filtered/overall data.

**2.9 — Ship v2**
- Migrate/ignore v1 data (fresh Hive box is fine for a learning project).
- Tag `v2.0.0`, merge `v2` → `main`.
- ✅ **Done when:** tagged, pushed, v2 is the app on `main`.

---

## Version 3 — Clean Architecture + Bloc/Cubit + Firebase + custom UI

**Goal:** production-shaped. Layered clean architecture, `bloc`/`cubit` for state, Firestore
(NoSQL) as the backend so data syncs across devices, and a distinct visual identity with
motion.

**Scope:** everything v2 does, plus cloud sync, auth (optional but natural), a designed UI
system, and animations. This is the showcase version.

### Tasks

**3.1 — Clean architecture skeleton**
- Layers: `presentation/` (bloc + widgets), `domain/` (entities, repository interfaces, use cases), `data/` (models, datasources, repository impls).
- Define `Expense` and `Category` as pure domain entities (no Firebase/Hive types leaking up).
- ✅ **Done when:** `domain` has zero imports from Flutter/Firebase; dependencies point inward.

**3.2 — Firebase project & Firestore**
- Create a Firebase project, add the app (Android/iOS), wire `firebase_core` + `cloud_firestore`.
- Firestore structure: `users/{uid}/expenses/{id}`, `users/{uid}/categories/{id}`.
- ✅ **Done when:** the app reads/writes a document in Firestore from a real device/emulator.

**3.3 — Auth (recommended)**
- `firebase_auth` — anonymous or email/Google sign-in.
- Scope all data under the signed-in user's `uid`.
- ✅ **Done when:** two accounts see separate data.

**3.4 — Data layer over Firestore**
- `FirestoreExpenseDataSource` + `ExpenseModel` (with `toMap`/`fromDoc`).
- Repository implementation returns domain entities and exposes streams (`snapshots()`).
- ✅ **Done when:** the domain repository interface is satisfied purely by Firestore, live-updating.

**3.5 — Use cases**
- `AddExpense`, `DeleteExpense`, `UpdateExpense`, `GetExpenses`, `FilterExpenses`, `GetStats`.
- ✅ **Done when:** blocs call use cases only, never repositories/datasources directly.

**3.6 — Bloc / Cubit state**
- A cubit/bloc per feature (e.g. `ExpenseListCubit`, `ExpenseFormBloc`, `FilterCubit`, `AuthBloc`).
- Model loading / loaded / error states explicitly.
- ✅ **Done when:** every screen renders purely from bloc state, with visible loading + error handling.

**3.7 — Custom UI identity**
- Define a design system: color palette, typography scale, spacing tokens, a custom `ThemeData`.
- Redesign Home / cards / add flow to a distinct look (not default Material).
- Light + dark theme.
- ✅ **Done when:** the app has a recognizable identity and both themes look intentional.

**3.8 — Animations & motion**
- Add: list item enter/exit animations, hero transition into details, animated total counter, a polished FAB/add-sheet transition.
- ✅ **Done when:** core interactions have smooth, purposeful motion (no jank on a mid device).

**3.9 — Sync & offline**
- Enable Firestore offline persistence; confirm the app works offline and reconciles on reconnect.
- ✅ **Done when:** you can add offline, go online, and it syncs.

**3.10 — Ship v3**
- Tag `v3.0.0`, merge `v3` → `main`.
- ✅ **Done when:** tagged, pushed, v3 is the finished showcase app.

---

## Suggested learning focus per version

- **v1:** the product + persistence basics. Don't over-engineer — the point is a working app.
- **v2:** separation of concerns, reactive state, a real local DB, and query/filter logic.
- **v3:** layering, testability, remote data, and craft (design + motion).

Keep the *feature set* roughly the same across versions so the architecture is the variable
you're actually studying.

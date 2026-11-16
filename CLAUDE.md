# FastPay Business Onboarding (Flutter)

## Project overview
A mobile app (Flutter, iOS + Android) where merchants apply to be onboarded to FastPay.
The **backend is already built and working**. This repo is the client only.
Do not invent endpoints: read `docs/api/` (or ask me) before writing any API code.

## Working rules for Claude
- Ask me before making architecture changes or adding dependencies not listed here.
- Work in small steps: one feature or screen per task, then stop and summarize.
- Never log or print personal data (IDs, bank names, documents, tokens). Use `safeLog` with fixed messages only.
- Run `flutter analyze` and `flutter test` after each change and fix issues.
- Keep UI strings in ARB files (no hardcoded text).
- Prefer simple, readable code over clever abstractions.

## Tech stack
- Flutter (latest stable), Dart null safety
- State management: `flutter_bloc` (swap for Riverpod only if I say so)
- Navigation: `go_router`
- HTTP: `dio` (with interceptors for auth token + error mapping)
- Forms: `flutter_form_builder` + `form_builder_validators`
- Phone numbers: `phone_numbers_parser` (validation; country picker is our own widget)
- Files: `image_picker`, `file_picker`, `flutter_image_compress`, `permission_handler`
- Local storage: `hive_ce` for drafts (encrypted box, stored as JSON), `flutter_secure_storage` for tokens and the box key
- Models: `freezed` + `json_serializable`
- Localization: `flutter_localizations` + `intl` (ARB)
- Tests: `bloc_test`, `mocktail`

## Decisions so far
- **The backend is the source of truth.** Where this file and the API differ, follow the API (`docs/api/README.md`) and update this file.
- Step 1 matches the backend's `initial-business-details`: owner first/last name, business address (line 1 + city required, sublease toggle = `subtenant`), optional time at residence, home landlord when the home is leased, and the EIN or SSN (SSN only for the single-member SSN designation; stored as digits).
- Single flavor, one entry point (`lib/main.dart`). API base URL via `--dart-define=API_BASE_URL=...`.
- App ID `com.fastpay.business` (Android and iOS).
- Android backup is disabled (drafts contain personal data).
- `bloc_test` caps the analyzer version, which holds `json_serializable` at 6.11 / `json_annotation` at 4.9.
- `permission_handler` is pinned to 12.x: 13.x needs AGP 9 / Kotlin 2.3 and breaks the Android build. It is only used for `openAppSettings()`.
- Documents: `features/documents/` holds the reusable upload card. Uploads go through `DocumentRepository` (mock until the API is known). Images are compressed to JPEG with EXIF stripped; temporary copies are deleted after upload.
- Step forms use `SingleChildScrollView` + `Column`, not `ListView`: `FormBuilder` only validates fields that are built.
- Required uploads use `DocumentFormField` (card inside a `FormBuilderField`). Dynamic/conditional cards are keyed by field name so each keeps its own upload state.
- Step 2: partners are a list with local ids (first partner can't be removed). Bill dates are entered by the user and checked by `BillWindow` (60 days / 3 calendar months). Hidden conditional data (home bill, sublease agreement) stays in the draft; leave it out of the submission.
- Step 2 extras agreed: each partner has a full legal name; the DBA toggle asks for the trade name; the optional 4th photo is untagged ("Additional photo"); changing the license type keeps the uploaded file. (Being re-aligned with the backend: names are first/last, 4th photo is `PHOTO_INTERIOR_ADDITIONAL`, DBA has its own `DBA_DOCUMENTATION` upload.)
- The sublease agreement card in Step 2 follows Step 1's `subtenant` toggle.
- Partner 1 is the owner. Step 3 "Same as owner" (default on) refers to them. At least one transaction processor is required.

## Commands
- Code generation: `dart run build_runner build --delete-conflicting-outputs`
- Localization: `flutter gen-l10n` (also runs on build)

## Folder structure
```
lib/
  core/        api client, theme, router, config, storage, utils, errors
  features/
    auth/
    onboarding/
      data/ logic/ ui/    wizard-wide model, cubit, shell
      step1_business/
      step2_documents/
      step3_compliance/
      review/
      status/
  shared/      reusable widgets, models
```
Each feature: `data/` (models, repositories), `logic/` (blocs), `ui/` (screens, widgets).

## App flow
Welcome/Login -> Step 1 -> Step 2 -> Step 3 -> Review -> Status.
Wizard with progress indicator, Back/Next, and auto-saved drafts so users can resume.

## Step 1: Initial business details
| Field | Input |
|---|---|
| Days and hours of operation | Day chips (Mon-Sun) + open/close time pickers |
| Time at current location | Years + months |
| Property status (business location) | Dropdown: Lease / Own |
| Property status (residential home) | Dropdown: Lease / Own |
| Landlord name + phone | Text fields, **only if business location is leased** |
| Personal bank name | Text / searchable dropdown |
| Business tax designation | Radio, one of the four below |

Tax designation options (show the short explanation under each):
1. LLC (Sole Proprietorship / Single-Member LLC - EIN): files under its own EIN
2. LLC (Sole Proprietorship / Single-Member LLC - SSN): disregarded entity, owner reports on personal return using SSN
3. LLC (C-Corporation Election): taxed as C-Corp (IRS Form 8832)
4. LLC (S-Corporation Election): taxed as S-Corp (IRS Form 2553)

## Step 2: Required documents
Each item is an upload card with a status: Not uploaded / Uploading / Uploaded / Rejected (with reason).

1. **Personal ID** for every business partner ("Add partner" action): government ID, driver's license, or passport.
   - If passport, or the ID lists a P.O. Box: also require a home utility bill dated within the last 60 days.
2. **Business registration**: Articles of Organization (LLC) or Articles of Incorporation (Corp). Must be in good standing with the Secretary of State.
3. **IRS registration**: EIN form / IRS SS-4 letter, or a recent tax return.
4. **Business license or permit**: only ONE document; user picks the type first:
   - General business license or sales tax permit
   - Industry-specific permit (food, liquor, tobacco, lottery, health department, etc.)
   - Property/safety (certificate of occupancy, fire inspection, food inspection)
   - Transportation (DOT registration, commercial auto insurance, commercial vehicle registration)
5. **Business utility bill** dated within the last 3 months.
6. **Business photos** (3-4 total), tagged by type:
   - Exterior: entrance, business name, and numeric address clearly visible
   - Interior: full store layout
   - Interior: transaction/checkout area
7. **DBA and sublease** (conditional):
   - Toggle "My business uses a trade name (DBA)". DBA is verified using the submitted photos.
   - Toggle "I sublease from another location": require the sublease agreement.

## Step 3: Operations and compliance
- **Transaction processors**: dynamic list of full names (add/remove). Used for system user setup, passwords, compliance training.
- **Compliance Officer**: "Same as owner" toggle, otherwise a full-name field.

## Validation rules
- All required fields checked before "Next".
- Phone numbers: valid format, country picker.
- EIN format: `XX-XXXXXXX`.
- Dates for utility bills: enforce the 60-day / 3-month windows using the bill date the user enters (or API response if the backend extracts it).
- File limits: types (jpg, png, pdf), max size from the API; compress images before upload.

## UX requirements
- Autosave draft after each field change (debounced) and on step change.
- Upload progress, retry on failure, ability to replace a file.
- Camera overlay hints for the exterior photo ("Show entrance, business name, street number").
- Review screen with an "Edit" shortcut per section before final submit.
- Status screen shows rejected items and lets the user re-upload only those.
- Handle offline gracefully: keep drafts locally, queue uploads.
- Accessibility: large tap targets, labels for screen readers, supports dynamic text size.

## Security
- HTTPS only; tokens in secure storage; clear on logout.
- No sensitive data in logs, analytics, or crash reports.
- Auto-lock or session timeout on inactivity.
- Consider blocking screenshots on document screens (confirm with me first).

## Backend contract
Full details: `docs/api/README.md`.
- Base URL: local `http://localhost:9033`, test `https://gateway.fastpayet.com/bo`, prod TBD.
- Auth: email + password (`POST /api/v1/auth/login`), JWT access + refresh tokens (`/auth/refresh`, `/auth/logout`). Self-registration at `/auth/partner/register`.
- Endpoints: POST upsert per step (`.../onboarding/initial-business-details`, `.../onboarding/operations-compliance`), owners CRUD, one `GET /api/v1/partner/applications/{id}` read model, and `POST .../submit` for both submit and resubmit. Reference catalogs come from `GET /api/v1/partner/onboarding/reference`.
- Uploads: presigned S3 (initiate, then PUT to `frontUploadUrl`, then verify). `maxFileSizeBytes` comes back from initiate. Use `.../replace` to replace a file.
- Application status: `DRAFT, IN_PROGRESS, ACTION_REQUIRED, SUBMITTED, RESUBMITTED, APPROVED, REJECTED`. Step progress: `COMPLETED, IN_PROGRESS, NOT_STARTED`.
- Errors: `{ message, error, validationErrors: { "dotted.field": "text" } }`. Success: `{ data }`.

Repositories stay behind interfaces. The mock and real implementations are swapped in one place.

## Build order
1. ~~Project setup: theme, router, localization, Dio client~~
2. ~~Wizard shell: progress indicator, step navigation, draft persistence~~
3. ~~Step 1 form with conditional landlord fields and validation~~
4. ~~Reusable document upload card + file/camera picking + compression~~
5. ~~Step 2 screens with all conditional logic (passport/P.O. Box, DBA, sublease)~~
6. ~~Step 3 dynamic lists~~
7. Review and submit
8. Status screen and re-upload flow
9. Wire real API, error handling, offline behavior
10. Tests (unit for validators and blocs, widget tests for each step) and polish

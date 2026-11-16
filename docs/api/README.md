# FastPay Partner API: contract notes

Sources:
- Postman collection `fastpay-onboarding-partner.postman_collection.json` (partner side)
- Postman environment `fastpay-onboarding-test.postman_environment.json` (test env)
- The partner onboarding console at `{baseUrl}/internal/tools/onboarding-console`, a reference web client.
  Response field names below that the collection doesn't show come from this console's `partner-app.js`.

Admin review endpoints are in a separate internal collection. The app does not use them.

> Do not commit the Postman environment with its `secret` values. It holds seeded test passwords.

## Environments

| Env | Base URL |
|---|---|
| Local backend | `http://localhost:9033` |
| Test | `https://gateway.fastpayet.com/bo` |
| Prod | TBD |

All paths below are relative to the base URL. Set `API_BASE_URL` in `.env` and run `dart run build_runner build`; a plain `flutter run` then uses it.

## Envelope and errors

Confirmed against the test backend on 2026-11-16.

- Success: `{ "status", "message", "data": ... }`. Creates return **201**, upserts return **201** on first save and **200** after that.
- Validation error (400):
  ```json
  { "errorCode": "VALIDATION_ERROR", "message": "Request validation failed", "method": "POST", "path": "...",
    "status": 400, "timestamp": "...", "traceId": null,
    "validationErrors": { "businessLocationAddress.city": "must not be blank" } }
  ```
  `validationErrors` keys are dotted field paths, with list indexes, e.g. `staff[0].firstName`.
- Malformed body (400): `errorCode: "BAD_REQUEST"`, `validationErrors: null`. The message contains Java class names, so never show it to users.
  This happens when a primitive is null, e.g. a missing `intervalIndex` or `closedAllDay` in an operating interval: always send both.
- Some errors use a shorter shape: `{ "success": false, "message": "..." }`.
- Lists: `?page=0&size=20` returns `data: { items: [...], pagination: { page, size, totalElements, totalPages, hasNext, hasPrevious } }`.

## Headers

- `Authorization: Bearer <accessToken>` on everything except login, register, and refresh.
- `X-Onboarding-Application-Id: <applicationId>` on **every** application-scoped call. `GET /applications/{id}` without it returns 400 "Missing X-Onboarding-Application-Id header."

## Auth

Email + password. JWT access and refresh tokens.

| Method | Path | Body | Response `data` |
|---|---|---|---|
| POST | `/api/v1/auth/partner/register` | `firstName, lastName, email, phoneNumber, password, confirmPassword, organizationName` | `userId, email, applicationId` (201) |
| POST | `/api/v1/auth/login` | `loginIdentifier` (email), `password` | `accessToken, refreshToken, sessionId, expiresIn` (seconds, console assumes 900 if absent) |
| POST | `/api/v1/auth/refresh` | `refreshToken` | `accessToken, refreshToken` |
| POST | `/api/v1/auth/logout` | none | |

On 401, refresh once and retry. If the refresh fails, log in again.

Registration returns an `applicationId`, so a newly registered partner already has an application.

## Reference data

`GET /api/v1/partner/onboarding/reference` returns all catalogs in one response:

Every catalog entry is `{ code, label, description }`.

- `step1`: `daysOfWeek`, `locationTenures`, `residentialTenures`, `taxClassifications`, `taxIdentifierKinds` (`EIN`, `SSN`, `OTHER`), `entityForms` (`LLC`, `CORPORATION`, `SOLE_PROPRIETORSHIP`, `PARTNERSHIP`, `OTHER`), `ownerTypes` (`INDIVIDUAL`, `ENTITY`), `governmentIdentifierTypes` (`GOVERNMENT_ID`, `DRIVERS_LICENSE`, `PASSPORT`, `SSN`, `OTHER`)
- `step2`: per section, e.g. `personalIdentification.identificationDocumentTypes`, `personalIdentification.ownerUtilityDocumentTypes`, `businessLicensesAndPermits.documentTypes` + `.note`, `dbaAndSublease.dbaDocumentTypes`, `dbaAndSublease.subleaseDocumentTypes`. Each type has `code`, a label, and a `description`.
- `step3`: `staffRoleCodes[] {code, label}`, `transactionProcessorsInstructions`, `complianceOfficerInstructions`

Known codes:
- Tax classification: `LLC_SINGLE_MEMBER_EIN`, `LLC_SINGLE_MEMBER_SSN`, `LLC_C_CORP_ELECTION`, `LLC_S_CORP_ELECTION`
- Tax identifier kind: `EIN`, `SSN` (the app sends SSN for `LLC_SINGLE_MEMBER_SSN`, EIN otherwise)
- Tenure: `LEASED`, `OWNED`
- Owner type: `INDIVIDUAL`
- Days: `MONDAY` ... `SUNDAY`
- Staff roles: `TRANSACTION_PROCESSOR`, `COMPLIANCE_OFFICER`

## Applications

| Method | Path | Notes |
|---|---|---|
| POST | `/api/v1/partner/applications` | `{ businessName }`, unique per partner (case-insensitive). Returns `data.id`. |
| GET | `/api/v1/partner/applications?page=&size=` | Optional filters: `status, createdFrom, createdTo, submittedFrom, submittedTo` |
| GET | `/api/v1/partner/applications/{id}` | **Single read model** (below) |
| POST | `/api/v1/partner/applications/{id}/submit` | First submit: body optional. Resubmit (status `ACTION_REQUIRED`): `{ "addressedCorrectionItemIds": [...] }` with every open correction id. Returns the new `status`. |

### Application status

`DRAFT`, `IN_PROGRESS`, `ACTION_REQUIRED`, `SUBMITTED`, `RESUBMITTED`, `APPROVED`, `REJECTED`.

**Watch out:** GET detail returns the code in `status` and a display string in `statusLabel` (`"DRAFT"` / `"Draft"`). The **list** endpoint returns the display string in `status` (`"Draft"`). Normalize: uppercase, spaces become `_`.

List item fields: `id, applicationNumber, businessName, legalName, status, hasOpenCorrections, createdAt, submittedAt, updatedAt`.
The app can edit only in `DRAFT` / `IN_PROGRESS`, and in `ACTION_REQUIRED` for corrections. `hasOpenCorrections: true` also means action required.

### GET application: fields

- `id, applicationNumber, businessName, status, createdAt, hasOpenCorrections`
- `initialBusinessDetails`: Step 1 in the same shape as the POST body, plus `locationId`, `ownerId`. `businessTaxDesignation` comes back with `code` and `identifierOnFile`, and may not return the raw identifier.
- `owners[] {id, ...}`: `owners[0]` is the primary owner from Step 1.
- `locations[]`, `tradeNames[] {tradeName}`, `staff[] {id, firstName, lastName, email, phone, roles[]}`, `businessProfile {id}`
- `requiredDocuments`: Step 2 checklist (below)
- `operationsAndCompliance`: `transactionProcessors[]`, `complianceOfficer`, instructions, `stepComplete`
- `onboardingCompletion`:
  - `stepProgress { INITIAL_BUSINESS_DETAILS | REQUIRED_DOCUMENTS | OPERATIONS_AND_COMPLIANCE : COMPLETED | IN_PROGRESS | NOT_STARTED }`
  - `missingByStep { <step key>: [...] }`
- `openCorrections[]`: `correctionItemId, wizardStep, wizardStepLabel, targetType, targetKey, targetTypeLabel, targetKeyLabel, displayLabel, fieldKeys[], reason, summaryMessage, instructions, remediated, ownerId, ownerDisplayName`

## Step 1: initial business details

`POST /api/v1/partner/applications/{id}/onboarding/initial-business-details` (upsert)

```json
{
  "operatingHours": { "intervals": [
    { "dayOfWeek": "MONDAY", "intervalIndex": 0, "opensAt": "09:00:00", "closesAt": "18:00:00", "closedAllDay": false },
    { "dayOfWeek": "SUNDAY", "intervalIndex": 0, "closedAllDay": true }
  ]},
  "monthsAtLocation": 24,
  "propertyStatus": { "businessLocationTenure": "LEASED", "residentialHomeTenure": "OWNED", "monthsAtResidence": 36 },
  "businessLandlordDetails": { "name": "...", "phone": "+15551239999" },
  "residentialLandlordDetails": { "name": "...", "phone": "..." },
  "personalBankName": "First National",
  "businessTaxDesignation": { "taxClassificationCode": "LLC_SINGLE_MEMBER_EIN", "identifierKind": "EIN", "identifierValue": "123456789" },
  "businessLocationAddress": { "subtenant": false, "line1": "100 Market St", "city": "Austin", "region": "TX", "postalCode": "78701", "countryCode": "US" },
  "primaryOwner": { "ownerType": "INDIVIDUAL", "firstName": "Jane", "lastName": "Owner" }
}
```

Required by request validation (probed): `operatingHours` (each interval needs `dayOfWeek`, `intervalIndex`, `closedAllDay`), `propertyStatus`, `personalBankName`, `businessTaxDesignation.{taxClassificationCode, identifierKind, identifierValue}` (value 4-32 chars), `businessLocationAddress.{line1, city, countryCode}`, `primaryOwner.ownerType`.
Optional: `monthsAtLocation`, `monthsAtResidence`, address `line2`, `region`, `postalCode`.

Enforced later or by the console, not by request validation: owner first/last name, and the landlord details:
- `businessLandlordDetails` is required when the business location is `LEASED`. `residentialLandlordDetails` is required when the home is `LEASED`.
- `primaryOwner` is required on the first save.

`onboardingCompletion.missingByStep` lists what is still missing as readable sentences.
- Phone numbers are sent in E.164 format. The identifier value is sent without the dash, e.g. `123456789`.
- Response `data` echoes the step and includes `locationId`, `ownerId`. That `ownerId` is the `businessOwnerId` used in Steps 2 and 3.

## Owners (business partners)

| Method | Path |
|---|---|
| POST | `/api/v1/partner/applications/{id}/owners` |
| PUT | `/api/v1/partner/applications/{id}/owners/{ownerId}` |
| DELETE | `/api/v1/partner/applications/{id}/owners/{ownerId}`: fails on the last owner |

Body (example has every field; which are required is **unconfirmed**):
`ownerType, firstName, lastName, email, phone, dateOfBirth (YYYY-MM-DD), ownershipPercent, residentialTenure, monthsAtResidence, residentialAddress {addressType: RESIDENTIAL, line1, city, region, postalCode, countryCode, poBox}, governmentIdentifier {identifierType: SSN, identifierValue, issuingCountry}`. Response `data.ownerId`.

## Step 2: documents (presigned S3 upload)

1. **Initiate**: `POST /api/v1/partner/applications/{id}/onboarding/documents/uploads/initiate`
   ```json
   {
     "documentTypeCode": "GOVERNMENT_ID",
     "frontContentType": "application/pdf",
     "frontFileSizeBytes": 2048,
     "originalFilename": "id.pdf",
     "businessOwnerId": "...",
     "identificationListsPoBox": false,
     "documentDate": "YYYY-MM-DD"
   }
   ```
   - `businessOwnerId` is required for `GOVERNMENT_ID`, `DRIVERS_LICENSE`, `PASSPORT`, `RESIDENTIAL_UTILITY_BILL`.
   - `identificationListsPoBox` applies to owner ID types only.
   - `documentDate` is the statement date, sent for `RESIDENTIAL_UTILITY_BILL` (60 days) and `BUSINESS_UTILITY_BILL` (3 months). The backend enforces the window. An old date still uploads but leaves the slot unsatisfied.
   - Response (201): `documentPublicId, frontUploadUrl, maxFileSizeBytes`. The Postman scripts default the max to 20 MB.
2. **PUT** the raw file bytes to `frontUploadUrl` with `Content-Type` equal to `frontContentType`. No auth header. Expect 200.
3. **Verify**: `POST .../documents/uploads/{documentPublicId}/verify` (no body).

**Replace** (for corrections): `POST .../documents/uploads/{submissionId}/replace` with `{frontContentType, frontFileSizeBytes, originalFilename}`. It returns a new `documentPublicId` + `frontUploadUrl`. Then PUT and verify as above.

**Download URL**: `GET .../onboarding/documents/{documentId}/download-url`

### Document type codes

| Section (`requiredDocuments` key) | Codes |
|---|---|
| `personalIdentification` (array, one per owner, with `ownerId`) | `GOVERNMENT_ID`, `DRIVERS_LICENSE`, `PASSPORT`; `RESIDENTIAL_UTILITY_BILL` when passport / P.O. Box |
| `businessRegistration` | `ARTICLES_OF_ORGANIZATION`, `ARTICLES_OF_INCORPORATION` |
| `irsRegistration` (one) | `EIN_FORM`, `IRS_SS4_LETTER`, `RECENT_TAX_RETURN` |
| `businessLicensesAndPermits` (pick one) | `GENERAL_BUSINESS_LICENSE`, `SALES_TAX_PERMIT`, `FOOD_LICENSE`, `LIQUOR_LICENSE`, `TOBACCO_LICENSE`, `LOTTERY_LICENSE`, `HEALTH_DEPT_PERMIT`, `CERTIFICATE_OF_OCCUPANCY`, `FIRE_INSPECTION`, `FOOD_INSPECTION`, `DOT_REGISTRATION`, `COMMERCIAL_AUTO_INSURANCE`, `COMMERCIAL_VEHICLE_REGISTRATION` |
| `utilityBill` | `BUSINESS_UTILITY_BILL` |
| `businessPhotos` (3-4) | `PHOTO_EXTERIOR_ENTRANCE`, `PHOTO_INTERIOR_LAYOUT`, `PHOTO_CHECKOUT_AREA`, optional `PHOTO_INTERIOR_ADDITIONAL` |
| `dbaAndSublease` | `DBA_DOCUMENTATION`, `SUBLEASE_AGREEMENT` |

The reference endpoint is the source of truth for the full list and labels.

### Section shape in `requiredDocuments`

Each section has: `instructions`, `note`, `acceptableDocumentTypeCodes[]`, `requiresCorrection`, `submissions[]`, `slots[]`.
- `slots[]`: `documentTypeCode, documentTypeLabel, description/instructions, required, satisfied, submittedCount, requirementKey, requirementGroupCode`
- `submissions[]`: `id, documentTypeCode, originalFilename, requiresCorrection, correctionReasons[]`
- `dbaAndSublease` also has `dbaApplicable`, `subleaseApplicable`.

## Step 3: operations and compliance

`POST /api/v1/partner/applications/{id}/onboarding/operations-compliance`. This upsert **replaces the whole staff list**.

```json
{ "staff": [
  { "firstName": "Sam", "lastName": "Processor", "email": "sam@acme.test", "phone": "+15551112222", "roleCode": "TRANSACTION_PROCESSOR" },
  { "firstName": "Jane", "lastName": "Owner", "email": "owner@acme.test", "roleCode": "COMPLIANCE_OFFICER", "businessOwnerId": "<ownerId>" }
]}
```

- If the compliance officer is the owner, set `businessOwnerId`.
- Only `firstName` and `lastName` are required (probed). Email and phone are optional.
- Response `data`: `stepComplete`, `complianceOfficer`, ...

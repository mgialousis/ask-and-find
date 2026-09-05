# Submission API contract

Ask & Find does not connect to Google Sheets or another privileged data store
from the mobile client. A separately deployed HTTPS service owns all storage
credentials and exposes one narrow endpoint to the app.

## Request

The URL is supplied at build time:

```bash
flutter build apk \
  --dart-define=SUBMISSIONS_ENDPOINT_URL=https://example.com/api/submissions
```

The client sends `POST` with `Content-Type: application/json`:

```json
{
  "schemaVersion": 1,
  "submission": {
    "id": "client-generated-uuid",
    "type": "newCard",
    "submittedAt": "2026-09-05T12:00:00.000Z",
    "promptEn": "Name ten European capitals",
    "answersEn": ["..."],
    "difficulty": "medium",
    "locale": "en"
  }
}
```

`type` is either `newCard` or `correction`; optional fields vary by type. The
backend should return any `2xx` response only after accepting the submission.
Other responses remain in the app's local retry queue.

## Backend requirements

- Require HTTPS in production.
- Validate the schema, field lengths, submission type, and UUID.
- Apply IP/device rate limits and request-body size limits.
- Treat names, email addresses, and submission text as untrusted input.
- Keep Google service-account, database, and signing credentials exclusively in
  the backend's secret store.
- Grant the backend identity access only to the target sheet/table.
- Use idempotent writes keyed by the client-generated submission ID.
- Configure logging retention so optional submitter details are not retained
  longer than necessary.

The endpoint URL is public configuration, not an authentication secret. Abuse
protection and authorization decisions must therefore be enforced server-side.

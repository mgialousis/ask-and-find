# Implementation Plan: User Card Submissions Feature

## Overview

Enable users to:
1. **Propose new cards** - Submit trivia cards with questions and answers
2. **Report corrections** - Suggest edits to existing cards

All submissions are sent to **Google Sheets** as a lightweight backend (no Firebase or database server needed).
                                                                                                                                                                                                                                                                                                                        
---                                                                                                                                                                                                                                                                                                                   

## UI/UX Flow

### Entry Points

| Location | Feature | Use Case |                                                                                                                                                                                                                                                                                     
  |----------|---------|----------|                                                                                                                                                                                                                                                                                     
| **Settings Screen** | "Community" section | Primary access to submit cards or report issues |                                                                                                                                                                                                                       
| **Round Result Dialog** | "Report Issue" icon | Quick correction for the card just played |                                                                                                                                                                                                                         

### Navigation Flow

  ```                                                                                                                                                                                                                                                                                                                   
  Settings → Community Section                                                                                                                                                                                                                                                                                          
  ├── "Submit New Card" → CardSubmissionScreen (new card mode)                                                                                                                                                                                                                                                          
  └── "Report Issue" → CardSubmissionScreen (correction mode)                                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                                                                                                        
  Round Result Dialog → "Report Issue" icon → CardSubmissionScreen (card pre-selected)                                                                                                                                                                                                                                  
  ```                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                        
---                                                                                                                                                                                                                                                                                                                   

## New Files to Create

  ```                                                                                                                                                                                                                                                                                                                   
  lib/                                                                                                                                                                                                                                                                                                                  
  ├── domain/entities/                                                                                                                                                                                                                                                                                                  
  │   └── card_submission.dart           # Submission entity & enums                                                                                                                                                                                                                                                    
  │                                                                                                                                                                                                                                                                                                                     
  ├── data/                                                                                                                                                                                                                                                                                                             
  │   ├── repositories/                                                                                                                                                                                                                                                                                                 
  │   │   └── submissions_repository.dart    # Repository interface & impl                                                                                                                                                                                                                                              
  │   └── sources/                                                                                                                                                                                                                                                                                                      
  │       ├── google_sheets_service.dart     # Google Sheets API service                                                                                                                                                                                                                                                
  │       └── offline_submissions_storage.dart # Offline queue storage                                                                                                                                                                                                                                                  
  │                                                                                                                                                                                                                                                                                                                     
  ├── presentation/                                                                                                                                                                                                                                                                                                     
  │   ├── screens/submission/                                                                                                                                                                                                                                                                                           
  │   │   ├── card_submission_screen.dart    # Main submission screen                                                                                                                                                                                                                                                   
  │   │   ├── submission_success_screen.dart # Success confirmation                                                                                                                                                                                                                                                     
  │   │   └── widgets/                                                                                                                                                                                                                                                                                                  
  │   │       ├── submission_form.dart       # Form widget                                                                                                                                                                                                                                                              
  │   │       ├── answer_list_editor.dart    # Dynamic answer list                                                                                                                                                                                                                                                      
  │   │       ├── card_preview_widget.dart   # Preview card display                                                                                                                                                                                                                                                     
  │   │       ├── issue_type_selector.dart   # Issue type radio buttons                                                                                                                                                                                                                                                 
  │   │       └── card_selector_dialog.dart  # Select card for correction                                                                                                                                                                                                                                               
  │   │                                                                                                                                                                                                                                                                                                                 
  │   └── state/                                                                                                                                                                                                                                                                                                        
  │       ├── submission_provider.dart       # Submission state management                                                                                                                                                                                                                                              
  │       └── submission_form_provider.dart  # Form state management                                                                                                                                                                                                                                                    
  │                                                                                                                                                                                                                                                                                                                     
  └── core/config/                                                                                                                                                                                                                                                                                                      
  └── sheets_config.dart             # Google Sheets configuration                                                                                                                                                                                                                                                      
  ```                                                                                                                                                                                                                                                                                                                   

## Files to Modify

| File | Change |                                                                                                                                                                                                                                                                                                     
  |------|--------|                                                                                                                                                                                                                                                                                                     
| `pubspec.yaml` | Add `gsheets: ^0.5.0` and `connectivity_plus: ^5.0.0` |                                                                                                                                                                                                                                            
| `lib/core/routing/app_router.dart` | Add routes for submission screens |                                                                                                                                                                                                                                            
| `lib/presentation/screens/settings/settings_screen.dart` | Add "Community" section |                                                                                                                                                                                                                                
| `lib/presentation/screens/game/widgets/round_result_dialog.dart` | Add "Report Issue" button |                                                                                                                                                                                                                      
| `lib/l10n/app_en.arb` | Add ~30 new localization strings |                                                                                                                                                                                                                                                          
| `lib/l10n/app_es.arb` | Add Spanish translations |                                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                        
---                                                                                                                                                                                                                                                                                                                   

## Data Models

### CardSubmission Entity

  ```dart                                                                                                                                                                                                                                                                                                               
  enum SubmissionType { newCard, correction }                                                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                                                                                                        
  enum IssueType {                                                                                                                                                                                                                                                                                                      
  wrongAnswer,                                                                                                                                                                                                                                                                                                          
  outdatedInfo,                                                                                                                                                                                                                                                                                                         
  spellingGrammar,                                                                                                                                                                                                                                                                                                      
  unclearQuestion,                                                                                                                                                                                                                                                                                                      
  other,                                                                                                                                                                                                                                                                                                                
  }                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                        
  class CardSubmission extends Equatable {                                                                                                                                                                                                                                                                              
  final String id;                                                                                                                                                                                                                                                                                                      
  final SubmissionType type;                                                                                                                                                                                                                                                                                            
  final DateTime submittedAt;                                                                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                                                                                                        
  // For new cards                                                                                                                                                                                                                                                                                                      
  final String? promptEn;                                                                                                                                                                                                                                                                                               
  final List<String>? answersEn;                                                                                                                                                                                                                                                                                        
  final Difficulty? difficulty;                                                                                                                                                                                                                                                                                         
  final String? source;                                                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                        
  // For corrections                                                                                                                                                                                                                                                                                                    
  final String? existingCardId;                                                                                                                                                                                                                                                                                         
  final String? existingCardPrompt;                                                                                                                                                                                                                                                                                     
  final IssueType? issueType;                                                                                                                                                                                                                                                                                           
  final String? issueDescription;                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                        
  // Submitter info (optional)                                                                                                                                                                                                                                                                                          
  final String? submitterName;                                                                                                                                                                                                                                                                                          
  final String? submitterEmail;                                                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                                        
  // Metadata                                                                                                                                                                                                                                                                                                           
  final String? appVersion;                                                                                                                                                                                                                                                                                             
  final String? locale;                                                                                                                                                                                                                                                                                                 
  }                                                                                                                                                                                                                                                                                                                     
  ```                                                                                                                                                                                                                                                                                                                   

### Google Sheets Structure

**Sheet 1: "New Card Submissions"**                                                                                                                                                                                                                                                                                   
| submission_id | submitted_at | status | prompt_en | answers_en (JSON) | difficulty | source | submitter_name | submitter_email | app_version | locale |

**Sheet 2: "Card Corrections"**                                                                                                                                                                                                                                                                                       
| submission_id | submitted_at | status | existing_card_id | existing_card_prompt | issue_type | issue_description | submitter_email | app_version | locale |
                                                                                                                                                                                                                                                                                                                        
---                                                                                                                                                                                                                                                                                                                   

## Form Validation Rules

### New Card
- **Question**: Required, 10-200 characters
- **Answers**: Required, 10-15 unique answers, each 1-100 characters
- **Difficulty**: Required
- **Source**: Optional, max 200 characters
- **Email**: Optional, valid format if provided

### Correction
- **Card**: Required (pre-selected)
- **Issue Type**: Required
- **Description**: Required, 20-1000 characters
- **Email**: Optional, valid format if provided

  ---                                                                                                                                                                                                                                                                                                                   

## Implementation Phases

### Phase 1: Foundation (1-2 days)
1. Add dependencies to `pubspec.yaml`
2. Create `CardSubmission` entity and enums
3. Set up Google Cloud project and service account
4. Create Google Sheets spreadsheet with proper structure
5. Implement `GoogleSheetsService` basic connectivity
6. Add localization strings to ARB files

### Phase 2: Core Submission Flow (2-3 days)
1. Implement `SubmissionsRepository`
2. Create Riverpod providers (`submission_provider.dart`, `submission_form_provider.dart`)
3. Build `CardSubmissionScreen` UI (new card mode)
4. Build `AnswerListEditor` widget for dynamic answer input
5. Implement form validation
6. Add routes to `AppRouter`
7. Add "Community" section to Settings screen

### Phase 3: Correction Flow (1-2 days)
1. Add correction mode to `CardSubmissionScreen`
2. Build `CardSelectorDialog` for choosing cards to report
3. Build `IssueTypeSelector` widget
4. Add "Report Issue" button to `RoundResultDialog`

### Phase 4: Offline Support & Polish (1-2 days)
1. Implement `OfflineSubmissionsStorage` using SharedPreferences
2. Add connectivity checking before submission
3. Queue submissions when offline, retry when online
4. Add `CardPreviewWidget` for previewing submissions
5. Add success/error feedback with SnackBars
6. Add pending submissions indicator

  ---                                                                                                                                                                                                                                                                                                                   

## Google Cloud Setup

1. Create Google Cloud project
2. Enable Google Sheets API
3. Create service account with Editor access
4. Download JSON credentials
5. Create spreadsheet with two sheets (structure above)
6. Share spreadsheet with service account email
7. Store spreadsheet ID in app config

**Security Note**: Service account credentials should be obfuscated or stored securely. For production, consider a server-side proxy.

## Project Setup Checklist (Required for Submissions to Work)

1. **Create the Google Sheet**
   - Create a spreadsheet with two tabs:
     - `New Card Submissions`
     - `Card Corrections`
   - Add the exact headers listed in **Google Sheets Structure** above.

2. **Create/Configure the Service Account**
   - In Google Cloud, create a service account with Editor permissions.
   - Download the JSON key.

3. **Share the Spreadsheet**
   - Share the Google Sheet with the service account email.
   - Give it Editor access.

4. **Add Credentials to the App**
   - Open `lib/core/config/sheets_config.dart`.
   - Paste the service account JSON into `SheetsConfig.credentials`.
   - Paste the spreadsheet ID into `SheetsConfig.spreadsheetId`.

5. **Verify Submissions**
   - Run the app, open **Settings → Community → Submit New Card**.
   - Submit a card and confirm a new row appears in the sheet.
   - Test **Report Issue** and confirm a row appears in the corrections sheet.
   - (Optional) Go offline, submit, then go online and confirm the queued submission syncs.
                                                                                                                                                                                                                                                                                                                        
---                                                                                                                                                                                                                                                                                                                   

## Key Localization Strings to Add

  ```                                                                                                                                                                                                                                                                                                                   
  community, submitNewCard, reportIssue, submitCardTitle, reportIssueTitle,                                                                                                                                                                                                                                             
  questionLabel, questionHint, answersLabel, addAnswer, removeAnswer,                                                                                                                                                                                                                                                   
  sourceLabel, yourNameLabel, yourEmailLabel, previewCard, submitCard,                                                                                                                                                                                                                                                  
  submitReport, cardBeingCorrected, issueTypeLabel, issueTypeWrongAnswer,                                                                                                                                                                                                                                               
  issueTypeOutdated, issueTypeSpelling, issueTypeUnclear, issueTypeOther,                                                                                                                                                                                                                                               
  describeIssue, submissionSuccess, submissionSuccessMessage, submissionError,                                                                                                                                                                                                                                          
  offlineSubmissionSaved, pendingSubmissions, retrySubmissions,                                                                                                                                                                                                                                                         
  validationQuestionRequired, validationAnswersCount, validationDifficultyRequired,                                                                                                                                                                                                                                     
  validationIssueTypeRequired, validationDescriptionRequired                                                                                                                                                                                                                                                            
  ```                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                        
---                                                                                                                                                                                                                                                                                                                   

## Verification & Testing

### Manual Testing
1. Submit a new card while online → verify it appears in Google Sheet
2. Submit a correction while online → verify it appears in Google Sheet
3. Submit while offline → verify saved locally and synced when online
4. Navigate from Settings → Submit New Card → complete form → submit
5. Navigate from Round Result → Report Issue → complete form → submit
6. Test form validation (empty fields, invalid email, too few answers)

### Automated Tests
- Unit tests: Form validation logic, entity serialization
- Widget tests: Form interactions, add/remove answers, submit button states
- Integration tests: Full submission flow with mocked API

  ---                                                                                                                                                                                                                                                                                                                   

## Critical Files (Priority Order)

1. `lib/domain/entities/card_submission.dart` - Data model
2. `lib/data/sources/google_sheets_service.dart` - API integration
3. `lib/presentation/screens/submission/card_submission_screen.dart` - Main UI
4. `lib/presentation/screens/submission/widgets/answer_list_editor.dart` - Core widget
5. `lib/presentation/screens/settings/settings_screen.dart` - Entry point modification


If you need specific details from before exiting plan mode (like exact code snippets, error messages, or content you generated), read the full transcript at: /Users/miltos/.claude/projects/-Users-miltos-IdeaProjects-pes-vres/7a157f0c-30a8-4206-b2a2-bd842e555c0e.jsonl

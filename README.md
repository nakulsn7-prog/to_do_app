# to_do_app

# Product Requirement Document (PRD): Smart Task & Productivity App (Offline-First Edition)

## 1. Product Overview & Architectural Strategy
The Smart Task & Productivity App is a local-first, low-latency task management and analytics application. To deliver an instantaneous user experience ($0\text{ms}$ local interface response time) and completely resilient offline operations, the application implements an **Offline-First Architectural Pattern** leveraging **PowerSync** as the client sync layer and **Supabase** as the cloud database ecosystem.

### 🔄 The Offline-First Data Strategy
1. **The Presentation and State Layers (`lib/`)** read and write modifications exclusively against local database storage interfaces. They remain completely agnostic to network connectivity shifts.
2. **The Client Infrastructure Layer (`packages/database_client`)** encapsulates third-party SDK dependencies (`supabase_flutter` and `powersync`), executing statements directly against the local cache for immediate $0\text{ms}$ turnaround.
3. **The Synchronization Engine Middleware** runs asynchronous background workers to automatically mirror local cache mutations back to Supabase Cloud tables and stream downstream remote mutations back to the device.

[Offline-First Dependency Flow]
UI (lib/) ──> BLoC/Cubit ──> TaskRepository ──> PowerSync/Local DB Interface ──> Supabase Cloud

## 2. Core Feature & Architectural Specifications

### 🟩 Feature 1: Core Task Management & Categories
* **User Experience:** Users can create, edit, delete, and group tasks into custom categories (e.g., Work, Personal, Health) using localized icons.
* **Overdue Warning System:** Tasks past their due date automatically transition into an "Overdue" visual state. This uses a high-contrast, strict UI color code (e.g., Warning Amber or Alert Red tokens) to create urgency.
* **Architectural Mapping:**
  * `packages/task_repository`: Owns the data contracts, local database cache joins, and task validation logic.
  * `lib/task/`: Feature folder housing sub-features `task_list/` and `task_detail/`.

### 🟨 Feature 2: Time-Constrained Priority Assigner
* **User Experience:** An automated or manual toggle system that calculates and assigns task priorities (Low, Medium, High, Urgent) based on upcoming deadlines and available time constraints.
* **Architectural Mapping:**
  * Priority calculation algorithm resides completely inside `packages/task_repository` or a pure utility in `packages/shared`. The UI simply reads the calculated immutable output field.

### 🟦 Feature 3: Productivity Dashboard & Analytics
* **User Experience:** A dedicated visualization screen displaying aggregated metrics through clean analytical charts.
  * **Data Metrics:** Total Tasks, Completed Tasks, and Pending Tasks.
  * **Visual Element:** Interactive charts plotting task completion velocities over days, weeks, or months.
* **Architectural Mapping:**
  * `lib/dashboard/`: Isolated presentation domain.
  * The `DashboardBloc` calls data aggregation functions from the task repository to generate a single `DashboardPopulated` state.

### 🟪 Feature 4: Streak System & Rewards
* **User Experience:** To gamify consistency, a visible streak counter increases every consecutive day the user completes all their daily high-priority tasks. Breaking the loop resets the streak. Reaching milestones unlocks digital "Reward" badges or animations.
* **Architectural Mapping:**
  * Streak tracking calculations and timestamp comparisons belong in the repository layer.
  * `packages/app_ui` owns the generic presentation reward pop-up configurations.

### 🟧 Feature 5: Context-Aware Dynamic Experience
* **Smart Greetings:** The home interface greets users based on their local device time (e.g., *"Good Morning, Alex"* vs. *"Good Evening, Alex"*).
* **Calendar View:** A continuous calendar ribbon or month-view matrix allowing users to tap specific dates to instantly filter tasks.
* **Theme Engine (Dark & Light Modes):** Seamless toggling between light and high-contrast dark themes.
* **Architectural Mapping:**
  * Time logic sits directly inside a specific home screen view or helper cubit.
  * Calendar rendering components leverage primitive layout structures within `packages/app_ui`.
  * Theme properties are mapped entirely using tokens inside `packages/app_ui`.

---

## 3. Product Backlog: Epics and User Stories

### 🛠️ Epic 1: Task Domain Data Engine (`packages/`)
**Goal:** Build the background data modeling layer, persistence schemas, and mathematical calculations for tasks, analytics, priorities, and streaks.

#### Story 1.1: Database Schemas & Tasks Client
* **As a** Developer  
* **I want to** establish localized database schemas for task items, categories, and streak logs  
* **So that** user data persists accurately across sessions.
* **Acceptance Criteria:**
  * Built entirely inside `packages/database_client/`.
  * Zero references to UI layout files or BLoC state types.

#### Story 1.2: Business Repositories (Tasks, Analytics, Streaks)
* **As a** Developer  
* **I want to** write clean repository layers that compute time-constrained priorities, evaluate streak rules, and aggregate chart numbers  
* **So that** the presentation layer can ingest ready-to-render domain models.
* **Acceptance Criteria:**
  * Built inside `packages/task_repository/`.
  * Converts raw database rows into immutable Dart entities using `Equatable`.

---

### 🎨 Epic 2: Theme & Component Design System (`packages/app_ui`)
**Goal:** Establish a beautiful design system that supports Dark/Light mode switching, calendar visual patterns, and specific color-coded status wrappers.

#### Story 2.1: Semantic Color Tokens & Theme Configuration
* **As a** Designer/Developer  
* **I want to** declare strict light/dark semantic color tokens—including specific color alerts for overdue warnings  
* **So that** the application's appearance stays cohesive.
* **Acceptance Criteria:**
  * Modifying a value in `packages/app_ui/` updates colors app-wide.
  * Hardcoded hex parameters in feature layouts will fail CI pipelines.

#### Story 2.2: Calendar & Dashboard Graph Layout Primitives
* **As a** UI Engineer  
* **I want to** create structural atomic components for the calendar view grids and graph outlines  
* **So that** feature screens can import them cleanly without bloating business feature folders.
* **Acceptance Criteria:**
  * Widgets remain perfectly stateless and completely independent of any app BLoC or business repository layer.

---

### 📱 Epic 3: Core Presentation Architecture (`lib/`)
**Goal:** Assemble the features into user-facing screens using the vertical feature-first structure.

#### 📂 Feature Module: `lib/dashboard/`
##### Story 3.1: Productivity Metrics and Graph Screen
* **As a** User  
* **I want to** view a centralized analytics dashboard with clear charts tracking total, pending, and completed items  
* **So that** I can evaluate my productivity.
* **Acceptance Criteria:**
  * Uses an explicit status engine pattern ($initial \rightarrow loading \rightarrow success/failure$).
  * Renders UI graph primitives imported from `packages/app_ui`.

#### 📂 Feature Module: `lib/home/`
##### Story 3.2: Smart Greeting Home Wrapper
* **As a** User  
* **I want to** open my app and receive a smart, contextual greeting alongside an organized look at my daily streak counter  
* **So that** the application experience feels personal and motivating.
* **Acceptance Criteria:**
  * Root feature uses a public barrel file (`lib/home/home.dart`).
  * Extracts temporal components natively to format strings at run time.

#### 📂 Feature Module: `lib/task/` (Domain-Grouped)
##### Story 3.3: Master Task Orchestrator & Calendar View
* **As a** User  
* **I want to** see a calendar overview at the top of my primary list view  
* **So that** i can seamlessly select dates and view tasks structured under specific categories.
* **Acceptance Criteria:**
  * Implements `lib/task/view/task_page.dart` and `lib/task/cubit/task_cubit.dart` to manage date selections, passing variables downward to child widgets.

##### Story 3.4: Sub-Feature Phase 1: Task Management List (`task_list`)
* **As a** User  
* **I want to** view categorized tasks sorted by priority  
* **So that** I can identify what requires urgent execution.
* **Acceptance Criteria:**
  * Isolated under `lib/task/task_list/`.
  * **Sibling Boundary Protection:** Emits actions upward to the parent `TaskCubit` whenever configurations or context changes occur.

##### Story 3.5: Sub-Feature Phase 2: Overdue Warning Detail Screen (`task_detail`)
* **As a** User  
* **I want to** inspect individual task details and see striking, color-coded warning headers if a task is overdue  
* **So that** I never lose track of missed milestones.
* **Acceptance Criteria:**
  * Isolated under `lib/task/task_detail/`.
  * Pulls the exact color design tokens explicitly from `packages/app_ui`.
  * No sibling imports allowed between `task_list/` and `task_detail/`.

---

## 4. The Product Manager Review Checklist

Before signing off on any engineering branch, the PM and QA teams will verify these strict guardrails:

| Rule Verification | Expected Result | Pass / Fail Condition |
| :--- | :--- | :--- |
| **Sibling Boundary Check** | `lib/task/task_list/` contains zero imports connecting to `lib/task/task_detail/`. | **FAIL** if horizontal file cross-references exist. |
| **Design System Token Leakage** | Colors for Light, Dark, and Overdue states use semantic paths (e.g., `AppColors.warningRed`). | **FAIL** if custom hex strings or non-token spacing are found in `lib/`. |
| **No Third-Party SDK Leakage** | `lib/` handles local time, priority values, and categories as pure Dart parameters. | **FAIL** if raw database clients or SDK analytical frameworks are imported outside of `packages/`. |

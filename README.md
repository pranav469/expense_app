# Proactive Expense Manager

A production-style offline-first expense management application built with Flutter using BLoC architecture, SQLite relational persistence, and manual cloud synchronization.

---

# Features

## Authentication & Onboarding
- 3-screen onboarding flow
- Phone number + OTP authentication
- Existing/New user handling
- Local session persistence using SharedPreferences

---

## Expense Management
- Add income and expense transactions
- Create and manage categories
- View recent transactions
- Track total income and expenses
- SQL JOIN-based relational transaction display

---

## Offline-First Architecture
- Local SQLite database as the primary source of truth
- UUID-based local identity generation
- Instant UI updates using optimistic state management
- Soft delete support for reliable synchronization

---

## Synchronization Engine
- Manual sync workflow
- Batch upload of categories and transactions
- Batch deletion synchronization
- Sync state tracking using `is_synced`
- Relational sync ordering support

---

## Notifications
- Local expense limit alerts
- Instant notification when monthly spending exceeds threshold

---

# Tech Stack

| Category | Technology |
|---|---|
| Framework | Flutter |
| State Management | flutter_bloc + equatable |
| Local Database | sqflite |
| Networking | dio |
| Local Storage | shared_preferences |
| Notifications | flutter_local_notifications |
| UUID Generation | uuid |
| Architecture | Feature-first layered architecture |

---

# Architecture Overview

The application follows an offline-first architecture where the local SQLite database acts as the primary source of truth.

```txt
UI
 ↓
BLoC
 ↓
Repository
 ↓
Local SQLite Database
 ↓
Remote API (Sync Layer)
# Expensit

An iOS app to track expenses and browse them by year, month or day. Expenses can be filtered by category, shown in pie and line charts, and entered in different currencies with conversion to a base currency.

I started it in 2013 in Objective-C and have kept it as a long-running playground, moving it to Swift, SwiftUI, Combine and Swift Concurrency over the years.

## Architecture

Clean Architecture, split into local Swift packages:

- **CoreExpenses**: domain models, interactors (use cases) and presenters. It doesn't depend on Core Data; storage is accessed through protocols.
- **CoreDataPersistence**: Core Data implementation of those protocols, including model migrations.
- **Currencies**: currency selection and conversion rates.

The app target holds the SwiftUI views and navigation coordinators.

## Tests

- Unit tests for the currency conversion interactors, using mocks for persistence and rates.
- Tests for the daily, monthly and yearly summaries, run against a fresh Core Data test store with generated data.

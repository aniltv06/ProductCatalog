# ProductCatalog - SOLID Swift/SwiftUI App

A clean architecture iOS/macOS app demonstrating SOLID principles with SwiftUI and MVVM.

Summary

This app demonstrates: 
- Clean SOLID architecture
- MVVM with SwiftUI
- Protocol-oriented design
- Constructor injection (no singletons)
- Service layer pattern
- Strategy pattern for sorting
- Comprehensive unit tests
- Thread-safe repository
- Proper error handling with Result types
- Modern Swift concurrency (async/await)

<img width="1136" height="912" alt="Home" src="https://github.com/user-attachments/assets/8962049e-3825-4836-b22e-b4424d001e17" />

<img width="1136" height="912" alt="Details" src="https://github.com/user-attachments/assets/a46dd216-3dc9-4a45-8b27-f291958a0d4e" />

**Architecture Overview**
```
┌─────────────────────────────────────────────────────────────┐
│                         SwiftUI Views                        │
│                  (ProductListView, DetailView)               │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                      ViewModel Layer                         │
│                   (ProductListViewModel)                     │
│                 Depends on Protocol Abstractions             │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                   Use Case / Service Layer                   │
│                      (CatalogService)                        │
│              Business Logic & Orchestration                  │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                     Repository Layer                         │
│               (InMemoryProductRepository)                    │
│                      Data Source                             │
└─────────────────────────────────────────────────────────────┘
```

**SOLID Principles Applied**

1. Single Responsibility Principle (SRP)
- Each class has one reason to change
- Views handle UI only
- ViewModel manages presentation logic
- Service handles business rules
- Repository manages data access

2. Open/Closed Principle (OCP)
- Sort strategies can be added without modifying core logic
- New repositories can be added (network, CoreData) without changing service
- Protocol-based design allows extension

3. Liskov Substitution Principle (LSP)
- Any ProductRepositoryProtocol implementation can replace another
- Any ProductSortStrategy can be swapped

4. Interface Segregation Principle (ISP)
- Small, focused protocols
- Repository protocol only exposes what's needed
- No fat interfaces

5. Dependency Inversion Principle (DIP)
- High-level modules (ViewModel) depend on abstractions (protocols)
- Low-level modules (Repository) implement abstractions
- Constructor injection throughout

**Features**

- Product listing with name, category, and price
- Case-insensitive search by name
- Mark/unmark favorites with UI reflection
- Navigation to detail view
- Sorting strategies (by name, by price - extensible)
- MVVM architecture
- Service layer between ViewModel and Repository
- Protocol-based design (DIP)
- In-memory repository with seed data
- Error handling with Result types
- Unit tests included
- No singletons - constructor injection only

File Structure
```
ProductCatalog/
├── App/
│   └── ProductCatalogApp.swift          # App entry point with DI setup
├── Domain/
│   ├── Models/
│   │   └── Product.swift                 # Domain model
│   ├── Protocols/
│   │   ├── ProductRepositoryProtocol.swift
│   │   └── ProductSortStrategy.swift     # Strategy pattern
│   └── Services/
│       └── CatalogService.swift          # Use case layer
├── Data/
│   └── Repositories/
│       └── InMemoryProductRepository.swift
├── Presentation/
│   ├── ViewModels/
│   │   └── ProductListViewModel.swift
│   └── Views/
│       ├── ProductListView.swift
│       └── ProductDetailView.swift
└── Tests/
    └── CatalogServiceTests.swift
```

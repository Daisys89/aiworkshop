# AI Workshop - OpenEdge ABL Project

This repository contains the OpenEdge ABL (Advanced Business Language) project for the AI Workshop, demonstrating modern ABL development patterns including:

- Business Entity Architecture
- Factory Pattern for Singleton Management
- Dataset-based Data Access
- UI Separation from Business Logic

## Project Structure

- `src/business/` - Business entity classes (CustomerEntity, ItemEntity, EntityFactory)
- `src/` - UI window files (CustomerWin.w, ItemWin.w)
- `.windsurf/rules/` - Windsurf IDE coding rules
- `.windsurf/workflows/` - Windsurf workflow definitions
- `doc/` - Documentation including Business Entity Pattern guide

## Database

Uses the Sports2000 demo database (`sports2000.df` schema).

## Getting Started

1. Open in OpenEdge Development environment
2. Connect to the Sports2000 database
3. Compile and run CustomerWin.w or ItemWin.w

## Architecture

This project follows the **Business Entity Pattern** documented in `doc/business-entity-pattern.md`.

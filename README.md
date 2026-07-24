# Flow 

## The Problem
Early-stage app brainstorming is fragmented, forcing creators to switch between loose handwriting tools for sketching ideas and complex vector software to test interactive screen flows.
## Vision
A mobile-first wireframing and prototyping app that allows designers, founders, and developers to sketch app ideas on an iPhone and create interactive navigation flows in minutes.

## Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| Frontend | SwiftUI | Building the modern, declarative user interface and layout controls. |
| Canvas Engine | PencilKit | Handling low-latency finger/Apple Pencil drawing input and path storage. |
| Local Cache | SwiftData | Managing local data schemas, folder hierarchies, and offline persistence. |
| Backend DB | Supabase (PostgreSQL) | Storing global project data, user profiles, and cross-device relational tables. |
| File Storage | Supabase Storage | Hosting the raw, heavy PencilKit binary canvas files (.store) efficiently. |
| Network Core | Codable / JSON | Bridging local database models securely with remote backend APIs. |



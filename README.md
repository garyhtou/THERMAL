# THERMAL 🧾

A searchable collection of your receipts.

## Deploy

In Production, the following environment variables are required:

- `RAILS_MASTER_KEY`: production rails master key
- `HOST_URL`: Location where the app is hosted (e.g. `thermal.guide`)
- Database URLS

  I recommend omitting the database name portion of the connection string so that Rails uses the database name defined
  in `database.yml` for each database. This means that if you're hosting all of these databases on the same server,
  these four strings may be identical!
  - `DATABASE_URL`: Primary database's connection string
  - `CACHE_DATABASE_URL`: connection string for the Solid Cache database
  - `QUEUE_DATABASE_URL`: connection string for the Solid Queue database
  - `CABLE_DATABASE_URL`: connection string for the Solid Cable database
- `PORT`: depending on your proxy/Nginx config, you may need to set this to configure Rails to run on a specific port.

The following dependencies need to be installed on the machine:

- ActiveStorage requirement
    - libvips for image analysis and transformations
    - poppler for PDF previews
- Tesseract for OCR


# TODO

- hash id
  - make dom_id use it (override `to_key` or `to_param`?)
- pundit
- google drive folder source by sharing folder with thermal@example.com (to omit oauth scope)
- context from provenance's file
  - image metadata (location, date, etc)
- as a user, i want to manual upload receipts so that i don't need to access google drive
  - may want to manually upload a receipt via web (instead of google drive)
  - although it creates an Importer::Upload::File, endpoint should be located at POST /receipt
  - how do we handle sourceable for Importer::Upload::Source? (dummy record?)
- handle deletion of sources
- handle deletion of receipts
- importables are non-deletable (unless user is deleted)
  - it prevents re-creating a deleted receipt
- searchability
  - full text search
  - keywords
  - date (purchased, provenance external created at (externally_created_at))
  - amount (total)
  - natural language search
- as a user, i want to organizer my receipts so they're easier to find and filter
  idea: user provides info (tags, categories, etc) to make searching even better
  - tags
  - edit/correct extracted data

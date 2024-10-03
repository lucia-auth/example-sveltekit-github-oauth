# GitHub OAuth example in SvelteKit

Uses SQLite. Rate limiting is implemented using JavaScript `Map`.

## Initialize project

Create a GitHub OAuth app with the redirect URI pointed to `/login/github/callback`.

```
http://localhost:5173/login/github/callback
```

Paste the client ID and secret to a `.env` file.

```bash
GITHUB_CLIENT_ID=""
GITHUB_CLIENT_SECRET="
```

Create `sqlite.db` and run `setup.sql`.

```
sqlite3 sqlite.db
```

Run the application:

```
pnpm dev
```

## Notes

- TODO: Update redirect URI

# GitHub OAuth example in SvelteKit

1. [Original Repo](https://lucia-auth.com/tutorials/github-oauth/sveltekit) used SQLite.
2. We will be using Azure SQL Server with [Prisma ORM](https://www.prisma.io/docs/getting-started/setup-prisma/start-from-scratch/relational-databases-typescript-postgresql).
3. Rate limiting is implemented using JavaScript `Map`.

## Initialize project

1. Created WonderTax Labs a GitHub OAuth app named [WonderTax Labs OAuth](https://github.com/organizations/WonderTaxLabs/settings/applications/2768870) with the redirect URI pointed to `http://localhost:5173/login/github/callback`.

```bash
http://localhost:5173/login/github/callback
```

Pasted the client ID and secret into our `.env` file.

```bash
GITHUB_CLIENT_ID=""
GITHUB_CLIENT_SECRET="
```

2. Install from naked cloned repo

```bash
npm npm install
```

3. see if it runs?

```bash
npm run dev
```

4. Server started on port 5174.

- updated GitHub OAuth app [WonderTax Labs OAuth](https://github.com/organizations/WonderTaxLabs/settings/applications/2768870) redirect to updated port 5174
- launch complained baout missing favicon. Created [static/favicon.png](static/favicon.png)
- Server presented a page with a Signin in via GitHub link
- followed link and was presented with an OAuth permission requet from GitHub!
- Holy S**t it worked out of the box!
- Server/terminal error "SqliteError: no such table: user" which makes sense - we're not using SQLite.

5. Repo instructions said to "Create `sqlite.db` and run `setup.sql`." We'll be skipping this because we are going to use Azure SQL

6. Setup new Azure SQL Database `msbuxley.database.windows.net`

![Miss Buxley](miss-buxley.png "Miss Buxley")

7. Created [T-SQL setup file](./setup-t-sql.sql)

8. Repo instructions want us to run: `sqlite3 sqlite.db` but we are not using SQLite. Now begins the implemention of [Prisma ORM](https://www.prisma.io/docs/getting-started/setup-prisma/start-from-scratch/relational-databases-typescript-postgresql) to connect to Azure SQL database `msbuxley.database.windows.net` :alien:

9. Quick deview of package.json seems to indicate this project is using `svelte ^4.2.7`

10. running `npx sv migrate svelte-5` now

- sadly, after upgrate to Svelte 5, app is now broken

    ```txt
    Internal server error: C:/Users/DavidCampbell/Documents/GitHub/example-sveltekit-github-oauth/src/routes/+layout.svelte:10:1 Unexpected character '@'
    Plugin: vite-plugin-svelte
    File: C:/Users/DavidCampbell/Documents/GitHub/example-sveltekit-github-oauth/src/routes/+layout.svelte:10:1
        8 |  </svelte:head>
        9 |
    10 |  {@render children?.()}
            ^ (x6)
    ```

- Reviewing [breaking changes documentation](https://svelte-5-preview.vercel.app/docs/breaking-changes) now. :disappointed: 

- Apparently efter upgrading to svelte 5 via CLI, previous Svelte 4 libraries are still cached. Delete `node modules` and `.sveltekit` directories, then re-install via `npm install` if dependencies fail, run `npm-install --force` to upgrade dependencies. So we're running again! :satisfied: Now back to Prisma ORM :alien: 

- Trying to install minimal prisma:

```bash
/* npm init -y
npm install prisma typescript tsx @types/node --save-dev */
npm install prisma --save-dev
npm install @types/node --save-dev
```

- invoke the Prisma CLI by prefixing it with npx:
```bash
npx prisma
npx prisma init
```

added `DATABASE_URL` to `.env`

- Reviewing [prisma connections strings documentation](https://pris.ly/d/connection-strings)

- after some tinkering with the JDBC connection string syntax for a while was finally able to connect and generate [local schema](prisma/schema.prisma) from `Azure SQL Database msbuxley` !!!

- Install and generate Prisma Client [This document is important!](https://www.prisma.io/docs/getting-started/setup-prisma/start-from-scratch/relational-databases/install-prisma-client-typescript-postgresql). Whenever we update our Prisma schema, we will have to update our database schema using either `prisma migrate dev` or `prisma db push`. This will keep our database schema in sync with our Prisma schema. The commands will also regenerate the **Prisma Client** to match current schema.

```bash
npm install @prisma/client
```

- Now starting to implement a `.svelte.server.ts` file to query our database...

- Lucia docs recommend [Oslo](https://oslojs.dev/) for encoding and crypto utils.

```bash
npm install @oslojs/encoding @oslojs/crypto
```

- ported `/lib/server/user.ts` and `/lib/server/session.ts` to use prisma.
- Used some bad *any* types to get compile to succeed at
```ts
type SessionValidationResult = { session: any ; user: any };
```

- Got Sever-side debugging well in hand now, but hate the laptop's muti-use function keys - can't easily use F10 (Step Over) & F11 (Step into) :angry:

- let me know if you wanna try it out - I'll securely email the `.env` file, or relay values via slack huddle :smirk:

## Notes

- TODO: Update redirect URI
- To load environment variables, run 
```bash 
  npx prisma generate
  ``` 

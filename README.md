# Prayer Request — Free Website Deployment

This version is prepared for a genuinely free static hosting + database setup:

- **Cloudflare Pages** hosts the website for free.
- **Supabase Free** provides the persistent PostgreSQL database.
- The uploaded MN logo is included as `logo.png`.
- No Node.js server is required for deployment.

## 1. Create the free database

1. Create a free Supabase account at https://supabase.com/.
2. Create a new project.
3. Open **SQL Editor**.
4. Open `schema.sql` from this ZIP and run the entire script.
5. Go to **Project Settings -> API**.
6. Copy the **Project URL** and the public **anon/publishable key**.

Do not put a Supabase `service_role` key in this website.

## 2. Configure the website

Open `supabase-config.js` and replace:

- `YOUR_SUPABASE_PROJECT_URL`
- `YOUR_SUPABASE_ANON_KEY`

with the values from Supabase.

## 3. Test locally

You can simply serve this folder with any static server. For example, if Python is installed:

```bash
python -m http.server 8080
```

Then open http://localhost:8080.

## 4. Deploy free with Cloudflare Pages

1. Create a GitHub repository.
2. Upload all files in this folder to the repository.
3. Open Cloudflare and go to **Workers & Pages**.
4. Choose **Create application -> Pages -> Import an existing Git repository**.
5. Select your GitHub repository.
6. Build command: `exit 0`
7. Build output directory: `/`
8. Deploy.

Cloudflare will give you a free `*.pages.dev` address.

## Important

The browser-side Supabase anon/publishable key is intended to be public. The database is protected by Row Level Security policies in `schema.sql`.

For a public prayer website, you should eventually add moderation, spam/rate limiting, reporting, and an admin dashboard before using it at large scale.

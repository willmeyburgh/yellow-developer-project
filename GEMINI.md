--- Context from: ../../.gemini/GEMINI.md ---
## Gemini Added Memories
- The user prefers that I do not run the linter automatically after making changes.
- The user prefers that I do not ask to build the application automatically after making changes.

1. Please always use `shadcn-vue` components
2. This is a `nuxt` project, so please use compatible libibries
4. Please use tailwindcss where needed
5. Dont use `#supabase` imports, supabase imports are always available by default (if expliclty imported import from '#imports')
6. When you need to deploy a edge function use `pnpm dlx supabase functions deploy` rather than the mcp tool (it is broken)
7. Don't run or install this or ask to
10. don't do git commands without expliclity being told
11. in production this site is a statically server ssr generated site (with no running server (just supabase backend))
import tailwindcss from '@tailwindcss/vite'

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },
  css: ['~/assets/css/tailwind.css'],

  vite: {
    plugins: [
      tailwindcss(),
    ],
  },

  modules: ['shadcn-nuxt','@nuxtjs/supabase'],
  supabase: {
    url: process.env.SUPABASE_URL, // Placeholder: Replace with your Supabase URL or environment variable
    key: process.env.SUPABASE_KEY, // Placeholder: Replace with your Supabase Key or environment variable
    redirect: false,
    cookieOptions: {
      maxAge: 0
    }
  },
  shadcn: {
    /**
     * Prefix for all the imported component
     */
    prefix: '',
    /**
     * Directory that the component lives in.
     * @default "./components/ui"
     */
    componentDir: './components/ui'
  },
})
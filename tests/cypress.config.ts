import { defineConfig } from 'cypress'

export default defineConfig({
  e2e: {
    baseUrl: process.env.BASE_URL
  },
  defaultCommandTimeout: 10000,
})

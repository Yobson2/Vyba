import { setupServer } from 'msw/node'

/**
 * The dashboard's single test seam (ticket 13 / spec 17): page-level RTL
 * tests hit this mocked server instead of a real backend. No default
 * handlers — each test registers exactly the requests it expects via
 * `server.use(...)`, so an unexpected request fails loudly instead of
 * silently matching a stale fixture.
 */
export const server = setupServer()

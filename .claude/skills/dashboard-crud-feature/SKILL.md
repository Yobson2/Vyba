---
name: dashboard-crud-feature
description: >-
  Scaffold a new resource feature in Vyba-dashboard-admin (src/features/<name>/)
  following the codebase's CRUD + TanStack Table pattern: a Zod schema, mock data
  file, a data-table (columns, table wrapper, toolbar, faceted filters,
  pagination, row actions, view options), CRUD dialogs (action/add-edit + delete)
  driven by a React context (useDialogState + currentRow), a primary-buttons bar,
  an index.tsx page shell (Header/Search/ThemeSwitch/Main), and the file-based
  route. Use when asked to "add an admin page/section", "create a <X> management
  screen", "add a table for <X>", or to add a column / filter / dialog to an
  existing feature. Also covers registering the route and sidebar nav entry.
---

# Dashboard CRUD feature (Vyba-dashboard-admin)

Stack: React 19 + TS strict + Vite + TanStack Router (file-based) + TanStack
Table + Zod + React Hook Form + shadcn/ui + Zustand + TanStack Query. Path alias
`@/` -> `./src/`. Prettier: single quotes, trailing commas, 80 cols. ESLint bans
`console.log`. Respect `docs/design-system.md` and `docs/security.md`. See
`docs/dashboard.md` for the full architecture reference.

> Note: the existing `data-table-*` components use `rounded-md border`, which
> violates the "no-line rule". Prefer tonal surfaces (`bg-muted`, `bg-card`) over
> `border`; if you must copy the legacy files, flag it rather than spreading it.

## When to use

- New admin resource (venues, users, tasks, bookings, promotions, reviews,
  admins…) → full scaffold.
- Add/modify a column, faceted filter, bulk action, or CRUD dialog on an existing
  feature → edit just those files.

Do **not** use for the landing page, auth flows, settings sub-pages that are
plain forms, or copy/style tweaks.

## First: reuse, don't copy

`src/components/ui/data-table/` already holds shared `table-pagination.tsx`,
`table-toolbar.tsx`, `index.tsx`. The six per-feature `data-table-*.tsx` files
(column-header, faceted-filter, pagination, row-actions, toolbar, view-options)
are **byte-identical across 6 features**. When scaffolding:

1. Prefer importing the shared components from `@/components/ui/data-table`.
2. If a needed piece isn't shared yet, lift it there once and import it
   everywhere, rather than pasting a 7th copy.
3. Only `*-columns.tsx`, `*-table.tsx`, `*-row-actions.tsx` (calls `use<Name>()`),
   and the dialogs are genuinely per-feature.

## File layout (mirror `src/features/users/` or `src/features/venues/`)

```
src/features/<name>/
  data/
    schema.ts        # zod: <item>Schema, <item>ListSchema, exported TS types
    <name>.ts        # mock array (typed to the schema)
    data.ts          # statusTypes Map<Status,string(badge classes)>, roleTypes[] etc.
  context/
    <name>-context.tsx   # createContext + Provider(useDialogState + currentRow) + use<Name>() hook
  components/
    <name>-columns.tsx        # ColumnDef<Item>[] : select checkbox, fields, actions
    <name>-table.tsx          # useReactTable wiring, <DataTableToolbar/> + <DataTablePagination/>
    <name>-dialogs.tsx        # renders action/delete dialogs off context `open`
    <name>-action-dialog.tsx  # RHF + Zod add/edit form in a <Dialog>
    <name>-delete-dialog.tsx  # confirm <Dialog>
    <name>-primary-buttons.tsx # "Add <Name>" etc. -> setOpen('add')
    data-table-row-actions.tsx # dropdown -> setOpen('edit'|'delete') + setCurrentRow
  index.tsx          # page shell
```

Route: `src/routes/_authenticated/<name>/index.tsx`. Nav: add an entry to
`src/components/layout/data/sidebar-data.ts`.

## Templates

### `data/schema.ts`
```ts
import { z } from 'zod'

const <name>StatusSchema = z.union([
  z.literal('active'),
  z.literal('inactive'),
])
export type <Name>Status = z.infer<typeof <name>StatusSchema>

const <name>Schema = z.object({
  id: z.string(),
  name: z.string(),
  status: <name>StatusSchema,
  createdAt: z.coerce.date(),
  updatedAt: z.coerce.date(),
})
export type <Name> = z.infer<typeof <name>Schema>

export const <name>ListSchema = z.array(<name>Schema)
```

### `context/<name>-context.tsx`
```tsx
import React, { useState } from 'react'
import useDialogState from '@/hooks/use-dialog-state'
import { <Name> } from '../data/schema'

type <Name>DialogType = 'add' | 'edit' | 'delete'

interface <Name>ContextType {
  open: <Name>DialogType | null
  setOpen: (str: <Name>DialogType | null) => void
  currentRow: <Name> | null
  setCurrentRow: React.Dispatch<React.SetStateAction<<Name> | null>>
}

const <Name>Context = React.createContext<<Name>ContextType | null>(null)

export default function <Name>Provider({ children }: { children: React.ReactNode }) {
  const [open, setOpen] = useDialogState<<Name>DialogType>(null)
  const [currentRow, setCurrentRow] = useState<<Name> | null>(null)
  return (
    <<Name>Context value={{ open, setOpen, currentRow, setCurrentRow }}>
      {children}
    </<Name>Context>
  )
}

// eslint-disable-next-line react-refresh/only-export-components
export const use<Name> = () => {
  const ctx = React.useContext(<Name>Context)
  if (!ctx) throw new Error('use<Name> has to be used within <<Name>Context>')
  return ctx
}
```

### `index.tsx`
```tsx
import { Header } from '@/components/layout/header'
import { Main } from '@/components/layout/main'
import { ProfileDropdown } from '@/components/profile-dropdown'
import { Search } from '@/components/search'
import { ThemeSwitch } from '@/components/theme-switch'
import { columns } from './components/<name>-columns'
import { <Name>Dialogs } from './components/<name>-dialogs'
import { <Name>PrimaryButtons } from './components/<name>-primary-buttons'
import { <Name>Table } from './components/<name>-table'
import <Name>Provider from './context/<name>-context'
import { <name>ListSchema } from './data/schema'
import { <name>s } from './data/<name>'

export default function <Name>s() {
  const list = <name>ListSchema.parse(<name>s)
  return (
    <<Name>Provider>
      <Header fixed>
        <Search />
        <div className='ml-auto flex items-center space-x-4'>
          <ThemeSwitch />
          <ProfileDropdown />
        </div>
      </Header>
      <Main>
        <div className='mb-2 flex flex-wrap items-center justify-between space-y-2'>
          <div>
            <h2 className='text-2xl font-bold tracking-tight'><Name>s</h2>
            <p className='text-muted-foreground'>Manage <name>s.</p>
          </div>
          <<Name>PrimaryButtons />
        </div>
        <div className='-mx-4 flex-1 overflow-auto px-4 py-1 lg:flex-row lg:space-y-0 lg:space-x-12'>
          <<Name>Table data={list} columns={columns} />
        </div>
      </Main>
      <<Name>Dialogs />
    </<Name>Provider>
  )
}
```

### Route — `src/routes/_authenticated/<name>/index.tsx`
```tsx
import { createFileRoute } from '@tanstack/react-router'
import <Name>s from '@/features/<name>'

export const Route = createFileRoute('/_authenticated/<name>/')({
  component: <Name>s,
})
```
The route tree (`routeTree.gen.ts`) is auto-generated by the Vite plugin on
`pnpm dev` / `pnpm build` — don't edit it by hand.

### `components/<name>-table.tsx`
Copy `users-table.tsx`: `useReactTable` with row selection, faceted row model,
faceted unique values, sorting, filtering, pagination models; renders
`<DataTableToolbar table={table} />`, the `<Table>`, then
`<DataTablePagination table={table} />`. Keep the
`declare module '@tanstack/react-table'` `ColumnMeta` augmentation.

### `components/<name>-columns.tsx`
`ColumnDef<<Name>>[]`: leading `select` checkbox column (sticky, `enableSorting:
false`), one entry per visible field using `<DataTableColumnHeader column title />`,
badge cells reading class strings from `data/data.ts` `statusTypes`,
`filterFn: (row, id, value) => value.includes(row.getValue(id))` for faceted
columns, trailing `{ id: 'actions', cell: DataTableRowActions }`.

### `components/<name>-dialogs.tsx`
Mirror `users-dialogs.tsx`: always-mounted add dialog; `currentRow &&` guarded
edit + delete dialogs keyed by `currentRow.id`; on close call `setOpen(type)` then
`setTimeout(() => setCurrentRow(null), 500)`.

### `components/<name>-action-dialog.tsx`
shadcn `<Dialog>` + `useForm` with `zodResolver(<name>Schema.omit({ id: true, ... }))`,
fields via `<Form>` / `<FormField>`, submit -> (later) TanStack Query mutation,
`toast` via Sonner on success, `handleServerError(error)` on failure.

## Data / API layer

- Endpoint constants: `src/api/endpoints.ts`. Axios instance: `src/api/axios-instance.ts`
  (Bearer token request interceptor, 401 -> logout response interceptor).
- Types: `ApiResponse<T>`, `PaginatedResponse<T>`, `ApiError` in `src/api/types.ts`.
- Server state: TanStack Query hooks (`useQuery` / `useMutation`), 10s stale time,
  no retry on 401/403. Until a real endpoint exists, `index.tsx` parses the mock
  file through the Zod schema (current pattern).

## Finish

1. `pnpm lint` — zero warnings (no `console.log`, no unused non-`_` vars).
2. `pnpm format` (Prettier + import + Tailwind class sorting).
3. `pnpm build` — `tsc` must pass under strict mode.
4. `pnpm knip` — no new unused exports/deps.
5. Verify the route renders and the sidebar entry links to it.

import { Table } from '@tanstack/react-table'
import {
  DataTableFacetedFilter,
  DataTableToolbar,
} from '@/components/ui/data-table'
import { acquisitionSourceTypes, roleTypes } from '../data/data'

interface UsersTableToolbarProps<TData> {
  table: Table<TData>
}

export function UsersTableToolbar<TData>({
  table,
}: UsersTableToolbarProps<TData>) {
  return (
    <DataTableToolbar
      table={table}
      searchColumn='name'
      searchPlaceholder='Search by name...'
    >
      {table.getColumn('status') && (
        <DataTableFacetedFilter
          column={table.getColumn('status')}
          title='Status'
          options={[
            { label: 'Active', value: 'active' },
            { label: 'Inactive', value: 'inactive' },
            { label: 'Suspended', value: 'suspended' },
            { label: 'Banned', value: 'banned' },
          ]}
        />
      )}
      {table.getColumn('role') && (
        <DataTableFacetedFilter
          column={table.getColumn('role')}
          title='Role'
          options={roleTypes.map((t) => ({ ...t }))}
        />
      )}
      {table.getColumn('acquisitionSource') && (
        <DataTableFacetedFilter
          column={table.getColumn('acquisitionSource')}
          title='Acquisition'
          options={acquisitionSourceTypes}
        />
      )}
    </DataTableToolbar>
  )
}

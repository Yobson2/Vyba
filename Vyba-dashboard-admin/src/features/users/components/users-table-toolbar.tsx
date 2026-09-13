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
      searchColumn='phone'
      searchPlaceholder='Search by phone...'
    >
      {table.getColumn('isActive') && (
        <DataTableFacetedFilter
          column={table.getColumn('isActive')}
          title='Status'
          options={[
            { label: 'Active', value: 'true' },
            { label: 'Inactive', value: 'false' },
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

import { Table } from '@tanstack/react-table'
import {
  DataTableFacetedFilter,
  DataTableToolbar,
} from '@/components/ui/data-table'
import { statusOptions, venueTypes } from '../data/data'

interface VenuesTableToolbarProps<TData> {
  table: Table<TData>
}

export function VenuesTableToolbar<TData>({
  table,
}: VenuesTableToolbarProps<TData>) {
  return (
    <DataTableToolbar
      table={table}
      searchColumn='name'
      searchPlaceholder='Search by name...'
    >
      {table.getColumn('validationStatus') && (
        <DataTableFacetedFilter
          column={table.getColumn('validationStatus')}
          title='Status'
          options={statusOptions}
        />
      )}
      {table.getColumn('venueType') && (
        <DataTableFacetedFilter
          column={table.getColumn('venueType')}
          title='Type'
          options={venueTypes}
        />
      )}
    </DataTableToolbar>
  )
}

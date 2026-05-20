import { Cross2Icon } from '@radix-ui/react-icons'
import { Table } from '@tanstack/react-table'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { DataTableFacetedFilter } from './data-table-faceted-filter'
import { DataTableViewOptions } from './data-table-view-options'

interface DataTableToolbarProps<TData> {
  table: Table<TData>
}

export function DataTableToolbar<TData>({
  table,
}: DataTableToolbarProps<TData>) {
  const isFiltered = table.getState().columnFilters.length > 0

  return (
    <div className='flex items-center justify-between'>
      <div className='flex flex-1 flex-col-reverse items-start gap-y-2 sm:flex-row sm:items-center sm:space-x-2'>
        <Input
          placeholder='Search users...'
          value={
            (table.getColumn('userName')?.getFilterValue() as string) ?? ''
          }
          onChange={(event) =>
            table.getColumn('userName')?.setFilterValue(event.target.value)
          }
          className='h-8 w-[150px] lg:w-[250px]'
        />
        <div className='flex gap-x-2'>
          {table.getColumn('isFlagged') && (
            <DataTableFacetedFilter
              column={table.getColumn('isFlagged')}
              title='Flagged'
              options={[
                { label: 'Flagged', value: 'true' },
                { label: 'Not Flagged', value: 'false' },
              ]}
            />
          )}
          {table.getColumn('rating') && (
            <DataTableFacetedFilter
              column={table.getColumn('rating')}
              title='Rating'
              options={[
                { label: '5.0', value: '5' },
                { label: '4.5', value: '4.5' },
                { label: '4.0', value: '4' },
                { label: '3.5', value: '3.5' },
                { label: '3.0', value: '3' },
                { label: '2.5', value: '2.5' },
                { label: '2.0', value: '2' },
                { label: '1.5', value: '1.5' },
                { label: '1.0', value: '1' },
              ]}
            />
          )}
        </div>
        {isFiltered && (
          <Button
            variant='ghost'
            onClick={() => table.resetColumnFilters()}
            className='h-8 px-2 lg:px-3'
          >
            Reset
            <Cross2Icon className='ml-2 h-4 w-4' />
          </Button>
        )}
      </div>
      <DataTableViewOptions table={table} />
    </div>
  )
}

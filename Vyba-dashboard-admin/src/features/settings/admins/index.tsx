import {
  flexRender,
  getCoreRowModel,
  getFilteredRowModel,
  useReactTable,
} from '@tanstack/react-table'
import { IconPlus } from '@tabler/icons-react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table'
import ContentSection from '../components/content-section'
import { adminsColumns } from './components/admins-columns'
import { AdminsDialogs } from './components/admins-dialogs'
import AdminsProvider, { useAdmins } from './context/admins-context'
import { adminListSchema } from './data/schema'
import { mockAdmins } from './data/mock-admins'

function AdminsContent() {
  const { setOpen } = useAdmins()
  const adminList = adminListSchema.parse(mockAdmins)

  const table = useReactTable({
    data: adminList,
    columns: adminsColumns,
    getCoreRowModel: getCoreRowModel(),
    getFilteredRowModel: getFilteredRowModel(),
  })

  return (
    <ContentSection
      title='Admin Users'
      desc='Manage team members with dashboard access.'
      actions={
        <Button size='sm' onClick={() => setOpen('invite')}>
          <IconPlus size={16} className='mr-1' />
          Invite
        </Button>
      }
    >
      <div className='space-y-4'>
        <Input
          placeholder='Search by name or email...'
          value={
            (table.getColumn('name')?.getFilterValue() as string) ?? ''
          }
          onChange={(e) =>
            table.getColumn('name')?.setFilterValue(e.target.value)
          }
          className='max-w-sm'
        />
        <div className='rounded-xl bg-muted/20 overflow-hidden'>
          <Table>
            <TableHeader>
              {table.getHeaderGroups().map((headerGroup) => (
                <TableRow key={headerGroup.id}>
                  {headerGroup.headers.map((header) => (
                    <TableHead key={header.id}>
                      {header.isPlaceholder
                        ? null
                        : flexRender(
                            header.column.columnDef.header,
                            header.getContext()
                          )}
                    </TableHead>
                  ))}
                </TableRow>
              ))}
            </TableHeader>
            <TableBody>
              {table.getRowModel().rows?.length ? (
                table.getRowModel().rows.map((row) => (
                  <TableRow key={row.id}>
                    {row.getVisibleCells().map((cell) => (
                      <TableCell key={cell.id}>
                        {flexRender(
                          cell.column.columnDef.cell,
                          cell.getContext()
                        )}
                      </TableCell>
                    ))}
                  </TableRow>
                ))
              ) : (
                <TableRow>
                  <TableCell
                    colSpan={adminsColumns.length}
                    className='h-24 text-center'
                  >
                    No admin users found.
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </div>
      </div>
    </ContentSection>
  )
}

export default function SettingsAdmins() {
  return (
    <AdminsProvider>
      <AdminsContent />
      <AdminsDialogs />
    </AdminsProvider>
  )
}

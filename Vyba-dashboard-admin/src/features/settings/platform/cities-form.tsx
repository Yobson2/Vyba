import { useState } from 'react'
import { IconPlus, IconTrash } from '@tabler/icons-react'
import { toast } from 'sonner'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Switch } from '@/components/ui/switch'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog'
import { Label } from '@/components/ui/label'
import { SettingsCard } from '../components/settings-card'

interface City {
  id: string
  name: string
  country: string
  active: boolean
}

const initialCities: City[] = [
  { id: '1', name: 'Abidjan', country: 'Nigeria', active: true },
]

export function CitiesForm() {
  const [cities, setCities] = useState<City[]>(initialCities)
  const [newCity, setNewCity] = useState({ name: '', country: '' })
  const [dialogOpen, setDialogOpen] = useState(false)

  const toggleCity = (id: string) => {
    setCities((prev) =>
      prev.map((c) => (c.id === id ? { ...c, active: !c.active } : c))
    )
    toast.success('City status updated.')
  }

  const removeCity = (id: string) => {
    setCities((prev) => prev.filter((c) => c.id !== id))
    toast.success('City removed.')
  }

  const addCity = () => {
    if (!newCity.name.trim() || !newCity.country.trim()) return
    setCities((prev) => [
      ...prev,
      {
        id: crypto.randomUUID(),
        name: newCity.name.trim(),
        country: newCity.country.trim(),
        active: true,
      },
    ])
    setNewCity({ name: '', country: '' })
    setDialogOpen(false)
    toast.success('City added.')
  }

  return (
    <SettingsCard
      title='Cities'
      description='Manage cities where Vyba is available.'
      actions={
        <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
          <DialogTrigger asChild>
            <Button variant='outline' size='sm'>
              <IconPlus size={16} className='mr-1' />
              Add city
            </Button>
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Add City</DialogTitle>
              <DialogDescription>
                Add a new city to the Vyba platform.
              </DialogDescription>
            </DialogHeader>
            <div className='space-y-4 py-4'>
              <div className='space-y-2'>
                <Label htmlFor='city-name'>City name</Label>
                <Input
                  id='city-name'
                  placeholder='e.g. Abuja'
                  value={newCity.name}
                  onChange={(e) =>
                    setNewCity((prev) => ({ ...prev, name: e.target.value }))
                  }
                />
              </div>
              <div className='space-y-2'>
                <Label htmlFor='city-country'>Country</Label>
                <Input
                  id='city-country'
                  placeholder='e.g. Nigeria'
                  value={newCity.country}
                  onChange={(e) =>
                    setNewCity((prev) => ({ ...prev, country: e.target.value }))
                  }
                />
              </div>
            </div>
            <DialogFooter>
              <Button
                variant='ghost'
                onClick={() => setDialogOpen(false)}
              >
                Cancel
              </Button>
              <Button
                onClick={addCity}
                disabled={!newCity.name.trim() || !newCity.country.trim()}
              >
                Add city
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      }
    >
      <div className='space-y-3'>
        {cities.map((city) => (
          <div
            key={city.id}
            className='flex items-center justify-between rounded-xl bg-muted/30 p-4'
          >
            <div>
              <p className='text-sm font-medium'>{city.name}</p>
              <p className='text-muted-foreground text-xs'>{city.country}</p>
            </div>
            <div className='flex items-center gap-3'>
              <Switch
                checked={city.active}
                onCheckedChange={() => toggleCity(city.id)}
              />
              <Button
                variant='ghost'
                size='icon'
                className='text-muted-foreground hover:text-destructive h-8 w-8'
                onClick={() => removeCity(city.id)}
              >
                <IconTrash size={14} />
              </Button>
            </div>
          </div>
        ))}
        {cities.length === 0 && (
          <p className='text-muted-foreground py-4 text-center text-sm'>
            No cities configured. Add your first city to get started.
          </p>
        )}
      </div>
    </SettingsCard>
  )
}

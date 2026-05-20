import { createFileRoute } from '@tanstack/react-router'
import SettingsPlatform from '@/features/settings/platform'

export const Route = createFileRoute('/_authenticated/settings/platform')({
  component: SettingsPlatform,
})

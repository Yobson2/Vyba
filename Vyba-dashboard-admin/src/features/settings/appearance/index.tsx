import ContentSection from '../components/content-section'
import { AppearanceForm } from './appearance-form'

export default function SettingsAppearance() {
  return (
    <ContentSection
      title='Appearance'
      desc='Customize how the dashboard looks and feels.'
    >
      <AppearanceForm />
    </ContentSection>
  )
}

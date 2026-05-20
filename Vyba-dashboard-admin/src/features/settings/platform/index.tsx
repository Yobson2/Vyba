import ContentSection from '../components/content-section'
import { CitiesForm } from './cities-form'
import { RegionalForm } from './regional-form'

export default function SettingsPlatform() {
  return (
    <ContentSection
      title='Platform'
      desc='Configure global platform settings.'
    >
      <div className='space-y-6'>
        <CitiesForm />
        <RegionalForm />
      </div>
    </ContentSection>
  )
}

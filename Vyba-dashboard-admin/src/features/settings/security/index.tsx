import ContentSection from '../components/content-section'
import { PasswordForm } from './password-form'
import { TwoFactorCard } from './two-factor-card'
import { SessionsCard } from './sessions-card'

export default function SettingsSecurity() {
  return (
    <ContentSection
      title='Security'
      desc='Manage your password and account security.'
    >
      <div className='space-y-6'>
        <PasswordForm />
        <TwoFactorCard />
        <SessionsCard />
      </div>
    </ContentSection>
  )
}

import ContentSection from '../components/content-section'
import { ChangePasswordForm } from './change-password-form'

export default function SettingsSecurity() {
  return (
    <ContentSection
      title='Security'
      desc='Manage the password for your admin account.'
    >
      <ChangePasswordForm />
    </ContentSection>
  )
}

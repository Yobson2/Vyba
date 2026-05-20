import ContentSection from '../components/content-section'
import { NotificationsForm } from './notifications-form'

export default function SettingsNotifications() {
  return (
    <ContentSection
      title='Notifications'
      desc='Choose which notifications you receive as an admin.'
    >
      <NotificationsForm />
    </ContentSection>
  )
}

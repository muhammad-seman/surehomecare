import { getToken } from "../_actions/auth"
import DashboardCard from "../_components/dashboard_card"
import MainLayout from "../_components/main_layout/main_layout"
import DashboardData from "../_models/dahboard_data"
import { getAdminBaseUrl } from "../_utils/constants"
import { v4 } from "uuid"

async function DashboardBidan() {
  const dashboardData = await getDashboardBidanData()
  
  return (
    <MainLayout title="Dashboard Bidan">
      <div className="w-full flex flex-wrap space-x-8">
        {dashboardData.map((data) => {
          const key = v4()
          return <DashboardCard key={key} {...data} />
        })}
      </div>
    </MainLayout>
  )
}

async function getDashboardBidanData() {
  const token = await getToken()

  const endpoint = `${getAdminBaseUrl()}/dashboard_bidan`
  const response = await fetch(endpoint, {
    headers: {"Authorization": `Bearer ${token}`}
  })

  const jsonData = await response.json()
  const data: DashboardData[] = jsonData["data"]
  return data
}

export default DashboardBidan
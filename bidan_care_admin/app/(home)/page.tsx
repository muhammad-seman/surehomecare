import { getToken } from "../_actions/auth"
import MainLayout from "../_components/main_layout/main_layout"
import { getAdminBaseUrl } from "../_utils/constants"
import DashboardCard from "../_components/dashboard_card"
import DashboardData from "../_models/dahboard_data"
import { v4 } from "uuid"

async function Home() {
  const dashboardData = await getDashboardData()

  return (
    <MainLayout title="Dashboard">
      <div className="w-full flex flex-wrap space-x-8">
        {dashboardData.map((data) => {
          const key = v4()
          return <DashboardCard key={key} {...data} />
        })}
      </div>
    </MainLayout>
  )
}

async function getDashboardData(): Promise<DashboardData[]> {
  const token = await getToken()

  const endpoint = `${getAdminBaseUrl()}/dashboard`
  const response = await fetch(endpoint, {
    headers: {"Authorization": `Bearer ${token}`}
  })
  const data: DashboardData[] = (await response.json())["data"]
  return data
}

export default Home

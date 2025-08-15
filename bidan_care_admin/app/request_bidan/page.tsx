import { getToken } from "../_actions/auth"
import DataTable from "../_components/data_table"
import ElevatedLinkButton from "../_components/elevated_link_button"
import MainLayout from "../_components/main_layout/main_layout"
import { getAdminBaseUrl } from "../_utils/constants"
import { v4 } from "uuid"

async function RequestBidanPage() {
  const listRequests = await getDaftarRequests()
  const columns = ["#", "Nama", "Email", "Kecamatan", "Aksi"]
  
  return (
    <MainLayout title="Pengajuan Pendaftaran Bidan">
      <DataTable columns={columns}>
        {listRequests.length === 0 && (
          <tr><td colSpan={5}>Tidak ada pengajuan pendaftaran bidan</td></tr>
        )}
        {listRequests.map((requestBidan, index) => {
          const key = v4()
          return (
            <tr key={key}>
              <td>{index + 1}</td>
              <td>{requestBidan.nama}</td>
              <td>{requestBidan.email}</td>
              <td>{requestBidan.kecamatan}</td>
              <td className="w-32 !py-4">
                <ElevatedLinkButton href={`/request_bidan/${requestBidan.id}`}>
                  Details
                </ElevatedLinkButton>
              </td>
            </tr>
          )
        })}
      </DataTable>
    </MainLayout>
  )
}

interface RequestBidan {
  id: string
  nama: string
  email: string
  kecamatan: string
}
async function getDaftarRequests() {
  const endpoint = `${getAdminBaseUrl()}/requests`
  const token = await getToken()
  const response = await fetch(endpoint, {
    headers: {"Authorization": `Bearer ${token}`}
  })
  const data: RequestBidan[] = (await response.json()).data
  return data
}

export default RequestBidanPage
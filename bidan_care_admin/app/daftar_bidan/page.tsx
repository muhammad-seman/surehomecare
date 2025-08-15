import { getToken } from "../_actions/auth"
import DataTable from "../_components/data_table"
import MainLayout from "../_components/main_layout/main_layout"
import ProfilePicture from "../_components/profile_picture"
import { getAdminBaseUrl } from "../_utils/constants"
import { v4 } from "uuid"

async function DaftarBidan() {
  const listBidan = await getAllBidan()
  const columns = ["#", "Gambar", "Nama", "Email", "Kecamatan", "Bersedia"]
  
  return (
    <MainLayout title="Bidan Terdaftar">
      <DataTable columns={columns}>
        {listBidan.length === 0 && (
          <tr>
            <td colSpan={columns.length}>Tidak ada bidan yang terdaftar</td>
          </tr>
        )}
        {listBidan.map((bidan, index) => {
          const key = v4()
          return (
            <tr key={key}>
              <td>{index + 1}</td>
              <td><ProfilePicture gambar={bidan.gambar} /></td>
              <td>{bidan.nama}</td>
              <td>{bidan.email}</td>
              <td>{bidan.kecamatan}</td>
              <td className={bidan.bersedia ? "text-green-600" : "text-neutral-400"}>
                {bidan.bersedia ? "Bersedia" : "Tidak Bersedia"}
              </td>
            </tr>
          )
        })}
      </DataTable>
    </MainLayout>
  )
}

interface Bidan {
  id: string
  gambar?: string
  nama: string
  email: string
  kecamatan: string
  bersedia: boolean
}

async function getAllBidan(): Promise<Bidan[]> {
  const endpoint = `${getAdminBaseUrl()}/all_bidan`
  const token = await getToken()
  const response = await fetch(endpoint, {
    headers: {"Authorization": `Bearer ${token}`}
  })
  const data: Bidan[] = (await response.json()).data
  return data
}

export default DaftarBidan
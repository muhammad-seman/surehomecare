import { getToken } from "../_actions/auth"
import DataTable from "../_components/data_table"
import MainLayout from "../_components/main_layout/main_layout"
import ProfilePicture from "../_components/profile_picture"
import { getAdminBaseUrl } from "../_utils/constants"
import { v4 } from "uuid"

async function DaftarUser() {
  const listUser = await getAllUser()
  const columns = ["#", "Gambar", "Nama", "Email", "Kecamatan"]
  
  return (
    <MainLayout title="User Terdaftar">
      <DataTable columns={columns}>
        {listUser.length === 0 && (
          <tr>
            <td colSpan={columns.length}>Tidak ada user yang terdaftar</td>
          </tr>
        )}
        {listUser.map((user, index) => {
          const key = v4()
          return (
            <tr key={key}>
              <td>{index + 1}</td>
              <td><ProfilePicture gambar={user.gambar} /></td>
              <td>{user.nama}</td>
              <td>{user.email}</td>
              <td>{user.kecamatan}</td>
            </tr>
          )
        })}
      </DataTable>
    </MainLayout>
  )
}

interface User {
  id: string
  gambar?: string
  nama: string
  email: string
  kecamatan: string
}

async function getAllUser(): Promise<User[]> {
  const endpoint = `${getAdminBaseUrl()}/all_user`
  const token = await getToken()
  const response = await fetch(endpoint, {
    headers: {"Authorization": `Bearer ${token}`}
  })
  const data: User[] = (await response.json()).data
  return data
}

export default DaftarUser
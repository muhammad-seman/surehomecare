import { format } from "date-fns"
import MainLayout from "../_components/main_layout/main_layout"
import DataTable from "../_components/data_table"
import { getAdminBaseUrl } from "../_utils/constants"
import { getToken } from "../_actions/auth"
import Order from "../_models/order"
import { v4 } from "uuid"

async function Transaksi() {
  const orders = await getAllOrder()
  const columns = [
    "#",
    "Nama User",
    "Nama Bidan",
    "Layanan",
    "Status",
    "Tanggal",
  ]

  return (
    <MainLayout title="Transaksi">
      <DataTable columns={columns}>
        {orders.length === 0 && (
          <tr><td colSpan={6}>Tidak ada data transaksi</td></tr>
        )}
        {orders.map((order, index) => {
          const key = v4()
          const layanan = order.layanan.reduce((v, e) => `${v}, ${e}`)
          const tanggal = format(order.tanggal, "dd/MM/yyyy")
          
          return (
            <tr key={key}>
              <td>{index + 1}</td>
              <td>{order.user}</td>
              <td>{order.bidan}</td>
              <td className="max-w-64 over truncate">{layanan}</td>
              <td>{order.status}</td>
              <td>{tanggal}</td>
            </tr>
          )
        })}
      </DataTable>
    </MainLayout>
  )
}

async function getAllOrder() {
  const endpoint = `${getAdminBaseUrl()}/all_orders`
  const token = await getToken()
  const response = await fetch(endpoint, {
    headers: {"Authorization": `Bearer ${token}`}
  })
  const raw: any[] = (await response.json())["data"]

  const statusMessage: Record<string, string> = {
    "diajukan": "Diajukan",
    "ongoing": "Ongoing",
    "ditolak": "Ditolak",
    "dibatal": "Dibatalkan",
    "selesai": "Selesai",
  }

  const data: Order[] = raw.map((order) => {
    order.tanggal = new Date(order.tanggal)
    order.status = statusMessage[(order.status)]
    return order
  })
  return data
}

export default Transaksi

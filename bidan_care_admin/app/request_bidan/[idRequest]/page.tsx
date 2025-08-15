import { getToken } from "@/app/_actions/auth"
import MainLayout from "@/app/_components/main_layout/main_layout"
import { getAdminBaseUrl } from "@/app/_utils/constants"
import { format } from "date-fns"
import DetailActions from "./detail_actions"

interface DetailRequestBidanPageProps {
  params: Promise<{idRequest: string}>
}
async function DetailRequestBidanPage({ params }: DetailRequestBidanPageProps) {
  const { idRequest } = await params
  const detailRequest = await getDetailRequest(idRequest)
  
  return (
    <MainLayout title="Detail Pengajuan Pendaftaran Bidan">
      <div className="bg-white p-6 shadow-lg">
        <h1 className="font-semibold text-2xl">{detailRequest.nama}</h1>
        <p>{detailRequest.email}</p>
        <p className="text-neutral-400 pt-3">
          {detailRequest.kecamatan} | {format(detailRequest.tanggal, "dd MMMM yyyy")}
        </p>
        <p className="pt-7">{detailRequest.keterangan}</p>
        <DetailActions id={idRequest} />
      </div>
    </MainLayout>
  )
}

interface DetailRequest {
  id: string
  nama: string
  email: string
  noHp: string
  kecamatan: string
  alamat: string
  keterangan: string
  tanggal: Date
}
async function getDetailRequest(id: string) {
  const endpoint = `${getAdminBaseUrl()}/requests/${id}`
  const token = await getToken()
  const response = await fetch(endpoint, {
    headers: {"Authorization": `Bearer ${token}`}
  })
  const raw = (await response.json()).data
  const tanggal = new Date(raw.createdAt)
  const data: DetailRequest = { ...raw, tanggal }
  return data
}

export default DetailRequestBidanPage